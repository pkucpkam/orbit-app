# Mẫu Prompt Giao việc: Xây dựng Màn hình mới

Dưới đây là mẫu prompt chuẩn để giao nhiệm vụ cho coding agent triển khai một màn hình mới trong ứng dụng Quỹ Đạo. Thay thế các phần `{{...}}` bằng thông tin thực tế:

---

```markdown
# NHIỆM VỤ: Xây dựng màn hình {{TÊN_MÀN_HÌNH}}

## Mã chức năng trong docs/spec.md
- Mã tính năng: {{MÃ_TÍNH_NĂNG}} (Ví dụ: TXN-1, BUD-1, SAV-1, RPT-1)
- Vị trí trên cây thư mục: `lib/features/{{TÊN_FEATURE}}/presentation/{{TÊN_FILE_SCREEN}}.dart`

## Tiêu chí chấp nhận (Acceptance Criteria)
{{LIỆT_KÊ_TIÊU_CHÍ_CHẤP_NHẬN_TỪ_SPEC}}

## Yêu cầu Kỹ thuật & Design
1. Tuân thủ triệt để `DESIGN.md` và `lib/core/theme/app_tokens.dart`. Nền kem putty (`#F3F0EE`), nút dạng pill (`StadiumBorder`), card phẳng `elevation: 0`.
2. Toàn bộ chuỗi UI tiếng Việt phải khai báo trong `lib/core/strings/app_strings.dart`.
3. Số tiền phải định dạng qua `formatMoneyVnd` từ `lib/core/utils/money_format.dart`.
4. Xử lý đủ 4 trạng thái: Loading (Skeleton), Empty, Error (thử lại), Offline.
5. Kết nối dữ liệu thông qua Riverpod Notifier/Provider trong `application/`, không gọi trực tiếp Firestore từ Widget.
6. Sau khi hoàn thành: Chạy `dart format .`, `flutter analyze`, `flutter test` và cập nhật `docs/progress.md`.
```
