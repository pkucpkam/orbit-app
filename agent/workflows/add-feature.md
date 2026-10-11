# Quy trình Thêm một Tính năng mới (Add Feature Workflow)

Quy trình chuẩn 8 bước cụ thể để hiện thực một tính năng mới trong ứng dụng Quỹ Đạo:

---

1. **Đọc Spec và xác định mã tính năng:**
   Mở file [docs/spec.md](file:///f:/Project/orbit-app/docs/spec.md) mục 4 (ví dụ: `TXN-1`, `BUD-1`, `SAV-2`). Đọc kỹ mô tả chức năng, tiêu chí chấp nhận và các bảng dữ liệu liên quan ở mục 5 và mục 6.

2. **Khai báo chuỗi UI tiếng Việt:**
   Mở [lib/core/strings/app_strings.dart](file:///f:/Project/orbit-app/lib/core/strings/app_strings.dart), thêm các hằng số chuỗi cho tính năng mới. Đảm bảo ngôn ngữ trung tính, tôn trọng trải nghiệm người dùng.

3. **Hiện thực tầng Domain & Unit Test:**
   - Tạo/cập nhật model bất biến trong `lib/features/<feature>/domain/` (hoặc `lib/data/models/`).
   - Nếu có công thức tính toán (ví dụ: tỷ lệ ngân sách, số tiền gom mỗi tháng), viết thành hàm thuần tại đây.
   - Viết unit test cho toàn bộ hàm công thức tại `test/<feature>/..._test.dart`. Chạy `flutter test` để xác nhận test pass.

4. **Hiện thực tầng Repository & Test với Fake Firestore:**
   - Định nghĩa repository interface trong `lib/data/repositories/` hoặc `lib/features/<feature>/domain/`.
   - Viết implementation kết nối Firestore trong `lib/data/repositories/`. Sử dụng đúng hằng số đường dẫn từ [lib/data/firestore_paths.dart](file:///f:/Project/orbit-app/lib/data/firestore_paths.dart).
   - Viết unit test cho repository sử dụng package `fake_cloud_firestore` và `mocktail`.

5. **Hiện thực tầng Application (Riverpod):**
   - Tạo Controller/Notifier hoặc StreamProvider trong `lib/features/<feature>/application/`.
   - Kết nối với Repository Provider và quản lý các trạng thái: `AsyncLoading`, `AsyncData`, `AsyncError`.

6. **Hiện thực tầng Presentation (UI):**
   - Đọc lại [DESIGN.md](file:///f:/Project/orbit-app/DESIGN.md) và import [lib/core/theme/app_tokens.dart](file:///f:/Project/orbit-app/lib/core/theme/app_tokens.dart).
   - Tạo Widget/Screen trong `lib/features/<feature>/presentation/`. Dùng `StadiumBorder`, card phẳng `elevation: 0`, màu từ `AppTokens`.
   - Xử lý đủ 4 trạng thái: Loading (Skeleton), Empty, Error (thông báo + nút Thử lại), Offline.

7. **Đăng ký điều hướng (Routing):**
   - Mở [lib/core/router/app_router.dart](file:///f:/Project/orbit-app/lib/core/router/app_router.dart), cấu hình `GoRoute` dẫn đến màn hình mới.
   - Thêm widget test hoặc cập nhật smoke test.

8. **Kiểm thử chất lượng & Cập nhật tiến độ:**
   - Chạy lệnh sinh code nếu có sửa model:
     ```bash
     dart run build_runner build --delete-conflicting-outputs
     ```
   - Chạy kiểm tra định dạng và phân tích tĩnh:
     ```bash
     dart format .
     flutter analyze
     flutter test
     ```
   - Cập nhật checklist trong [docs/progress.md](file:///f:/Project/orbit-app/docs/progress.md).
