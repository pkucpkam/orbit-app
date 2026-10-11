# Checklist Tự Rà soát Mã nguồn (PR Review Checklist)

Checklist tự kiểm tra nhanh trước khi gửi Pull Request hoặc commit:

---

## 1. Kiến trúc & Thiết kế Phân tầng
- [ ] Widget có gọi trực tiếp Firestore hoặc FirebaseAuth không? (Nếu có -> CẦN SỬA, phải chuyển qua Repository).
- [ ] Logic tính toán tài chính có được tách thành hàm thuần trong `domain/` không?
- [ ] Thao tác thay đổi giao dịch có dùng đúng một `WriteBatch` duy nhất không?
- [ ] Có thao tác nào dùng `runTransaction` cho việc thêm/sửa/xóa giao dịch không? (Cấm dùng).

## 2. Tiền tệ & Kiểu Dữ liệu
- [ ] Toàn bộ số tiền có phải kiểu `int` VND không?
- [ ] Có xuất hiện kiểu `double` cho số tiền không? (Nếu có -> CẦN SỬA).
- [ ] Số tiền lưu trữ có luôn luôn là số dương $> 0$ không?

## 3. Giao diện & Design System
- [ ] Có màu mã Hex nào bị hardcode trực tiếp trong Widget không? (Nếu có -> chuyển vào `AppTokens`).
- [ ] Nút bấm, Chip và TextField có tuân thủ bo góc pill (`StadiumBorder`) không?
- [ ] Độ tương phản chữ đã kiểm tra đạt chuẩn chưa? (Chữ nhỏ trên nền kem phải dùng Ink Black `#141413`).

## 4. Chuỗi hiển thị (Strings)
- [ ] Có text tiếng Việt nào bị viết cứng trong Widget không? (Nếu có -> chuyển vào `AppStrings`).
- [ ] Câu từ cảnh báo ngân sách có trung tính, tôn trọng người dùng không?

## 5. Kiểm thử & Phân tích Tĩnh
- [ ] Đã chạy `dart format .` chưa?
- [ ] Đã chạy `flutter analyze` và đạt 0 issues chưa?
- [ ] Đã chạy `flutter test` và tất cả các test cases đều passed chưa?
