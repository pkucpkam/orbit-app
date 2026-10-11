# ADR-0001: Sử dụng WriteBatch kết hợp FieldValue.increment thay vì runTransaction

- **Trạng thái:** Chấp thuận
- **Ngày:** 2026-10-11
- **Tác giả:** Team Quỹ Đạo

---

## 1. Bối cảnh (Context)
Khi người dùng thêm, sửa hoặc xóa một giao dịch tài chính, ứng dụng cần cập nhật đồng bộ nhiều document Firestore liên quan:
1. Document giao dịch trong `transactions/{txId}`.
2. Số dư của ví trong `wallets/{walletId}`.
3. Số liệu tổng kết tháng trong `monthSummaries/{monthKey}` (bao gồm `totalIncome`, `totalExpense`, `totalSaved`, và map theo từng danh mục `byCategory`).
4. Số tiền đã tích lũy trong `goals/{goalId}` (nếu là giao dịch gửi tiết kiệm).

Theo chuẩn Firestore, có hai cơ chế cập nhật nguyên tử (Atomic updates):
- **`runTransaction`:** Đọc dữ liệu mới nhất từ server, thực hiện tính toán tại client rồi ghi lại.
- **`WriteBatch`:** Gom các thao tác ghi (set/update/delete) thành một gói gửi lên server mà không bắt buộc phải đọc trước.

## 2. Quyết định (Decision)
Dự án quyết định **toàn bộ luồng ghi nhận giao dịch sử dụng `WriteBatch` kết hợp `FieldValue.increment`** (và `FieldValue.arrayUnion`), tuyệt đối **KHÔNG sử dụng `runTransaction`**.

Quy tắc chi tiết:
- Cập nhật số dư ví: `wallets.balance = FieldValue.increment(±amount)`.
- Cập nhật tổng kết tháng: `monthSummaries` được ghi bằng phương thức `set` với tham số `merge: true` (để tự tạo document nếu chưa tồn tại vào đầu tháng), sử dụng `FieldValue.increment(±amount)` cho `totalExpense`, `totalIncome`, `totalSaved` và `byCategory.{categoryId}`.
- Cập nhật danh sách ngày có ghi chép: `monthSummaries.loggedDays = FieldValue.arrayUnion([dateString])`.
- Khi sửa giao dịch: Tính độ chênh lệch hoặc trừ tác động của bản ghi cũ rồi cộng tác động mới trong cùng một batch duy nhất.
- Khi xóa giao dịch: Trừ ngược lại tác động của giao dịch trong một batch.

## 3. Hệ quả (Consequences)

### Tích cực:
1. **Hỗ trợ ghi Offline tuyệt đối (Offline-First):** `runTransaction` bắt buộc phải có kết nối mạng để đọc dữ liệu từ server, nếu mất mạng transaction sẽ thất bại ngay lập tức. Ngược lại, `WriteBatch` được Firestore SDK xếp hàng lưu trong bộ nhớ đệm cục bộ (local cache) và tự động đồng bộ lên cloud khi có mạng trở lại.
2. **Tránh xung đột ghi đè từ nhiều thiết bị (Concurrent Updates):** Toán tử `FieldValue.increment` được server Firestore xử lý trực tiếp dưới dạng atomic delta, giúp người dùng ghi chép trên nhiều thiết bị (hoặc nhiều tab) cùng lúc mà không ghi đè mất dữ liệu của nhau.
3. **Tiết kiệm chi phí và tăng tốc độ:** Không tốn chi phí và độ trễ đọc (Read operations) trước khi ghi.

### Đánh đổi & Giải pháp giảm thiểu:
- **Đánh đổi:** Client ghi nhận số tổng hợp thay vì Cloud Functions, do đó nếu có lỗi logic client thì số liệu tổng hợp có thể bị lệch.
- **Giải pháp:** Viết unit test kỹ lưỡng bằng `fake_cloud_firestore` để đảm bảo 100% logic batch tính toán chính xác; cung cấp tính năng "Tính toán lại số dư" (Recalculate balances) trong phần Cài đặt nếu cần tái đồng bộ từ lịch sử giao dịch.
