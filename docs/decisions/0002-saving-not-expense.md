# ADR-0002: Tách biệt Giao dịch Tiết kiệm (saving) khỏi Chi tiêu (expense)

- **Trạng thái:** Chấp thuận
- **Ngày:** 2026-10-11
- **Tác giả:** Team Quỹ Đạo

---

## 1. Bối cảnh (Context)
Trong các ứng dụng quản lý tài chính truyền thống, khi người dùng chuyển tiền từ tài khoản thanh toán / ví tiền mặt vào quỹ tiết kiệm hay tài khoản tích lũy, giao dịch này thường bị phân loại là một khoản "Chi tiêu" (Expense).
Hệ quả tâm lý phát sinh:
- Người dùng cảm thấy mình đang "chi tiêu quá mức" đúng vào lúc họ đang tích lũy tài sản lành mạnh.
- Báo cáo ngân sách chi tiêu trong tháng bị méo mó, đội lên một con số chi ảo lớn khiến họ dễ chán nản hoặc bỏ thói quen ghi chép.
- Ngược lại, nếu coi việc gửi tiết kiệm là "Chuyển ví" (Transfer) đơn thuần, người dùng lại không cảm nhận được thành tựu và tiến độ tiến gần đến mục tiêu dự định.

## 2. Quyết định (Decision)
Dự án quyết định **thiết lập loại giao dịch `saving` (Gửi tiết kiệm) là một loại giao dịch độc lập**, phân tách rõ ràng với `expense`, `income`, và `transfer`.

Quy tắc xử lý của loại giao dịch `saving`:
1. **Số dư ví nguồn:** Bị trừ đúng số tiền gửi (tiền thực tế đã chuyển khỏi ví chi tiêu hàng ngày).
2. **Tổng Chi tiêu (`totalExpense`):** **KHÔNG tính vào Chi tiêu**.
3. **Tổng Thu nhập (`totalIncome`):** **KHÔNG tính vào Thu nhập**.
4. **Tổng Tiết kiệm (`totalSaved` & `goals.savedAmount`):** **CỘNG vào tổng tiết kiệm** của tháng và cộng dồn vào mục tiêu tiết kiệm tương ứng (`goalId`).
5. Khi người dùng rút tiền từ mục tiêu về lại ví: Số dư ví tăng lên, số tiền tích lũy của mục tiêu giảm đi, và hoàn toàn không bị coi là khoản thu nhập mới.

## 3. Hệ quả (Consequences)

### Tích cực:
1. **Bảo toàn tâm lý tích cực:** Người dùng không bị cảm giác tội lỗi "chi tiêu lạm phát" khi thực hiện các khoản tích lũy lớn.
2. **Minh bạch hóa dòng tiền:** Báo cáo tài chính phân định rạch ròi ba dòng chảy: Thu về, Chi thực sự ra ngoài, và Tích lũy cho tương lai.
3. **Thúc đẩy động lực hoàn thành mục tiêu:** Mỗi giao dịch `saving` trực tiếp kích hoạt hiệu ứng tiến trình trên vòng quỹ đạo `OrbitProgressRing` và các cột mốc ăn mừng (25%, 50%, 75%, 100%).

### Đánh đổi & Giải pháp:
- **Đánh đổi:** Công thức tính "Số tiền còn có thể chi" ở màn hình Tổng quan cần được hiệu chỉnh: Nếu chưa đặt ngân sách chi tổng, hạn mức chi sẽ bằng: `Dự tính thu - Đã chi - Phần cần gom tiết kiệm của tháng`.
- **Giải pháp:** Đóng gói công thức này thành hàm thuần trong `domain/` với unit test đầy đủ, đảm bảo tính toán nhất quán trên toàn hệ thống.
