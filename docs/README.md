# Tài liệu Dự án Quỹ Đạo

Thư mục chứa toàn bộ đặc tả kỹ thuật, tài liệu kiến trúc, ghi chú thiết kế và các quyết định kiến trúc (ADR) của dự án.

## Mục lục Tài liệu

- [spec.md](file:///f:/Project/orbit-app/docs/spec.md): Đặc tả yêu cầu sản phẩm, giao diện, luồng người dùng, mô hình dữ liệu Firestore và nghiệp vụ (Nguồn sự thật - Source of Truth, không tự ý sửa đổi).
- [architecture.md](file:///f:/Project/orbit-app/docs/architecture.md): Tài liệu kiến trúc hệ thống, phân lớp (UI -> Application -> Repository -> Firestore), danh sách package thực tế và quy ước code.
- [progress.md](file:///f:/Project/orbit-app/docs/progress.md): Bảng theo dõi tiến độ dự án qua 5 giai đoạn roadmap với tiêu chí hoàn thành chi tiết.
- [design-notes.md](file:///f:/Project/orbit-app/docs/design-notes.md): Tổng hợp token thiết kế từ Mastercard (`DESIGN.md`), kết quả đo độ tương phản và các quyết định cần người dùng chốt.
- [decisions/](file:///f:/Project/orbit-app/docs/decisions): Thư mục lưu trữ các Architecture Decision Records (ADR).
  - [0001-firestore-writebatch.md](file:///f:/Project/orbit-app/docs/decisions/0001-firestore-writebatch.md): Quyết định sử dụng `WriteBatch` kết hợp `FieldValue.increment` thay vì `runTransaction`.
  - [0002-saving-not-expense.md](file:///f:/Project/orbit-app/docs/decisions/0002-saving-not-expense.md): Quyết định tách riêng loại giao dịch `saving` (gửi tiết kiệm) khỏi Chi tiêu thông thường.
  - [_template.md](file:///f:/Project/orbit-app/docs/decisions/_template.md): Mẫu tài liệu ADR chuẩn để tạo quyết định kiến trúc mới.
