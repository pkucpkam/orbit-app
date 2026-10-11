# Tiêu chuẩn Hoàn thành (Definition of Done - DoD)

Một nhiệm vụ hoặc tính năng trong ứng dụng Quỹ Đạo CHỈ được coi là hoàn thành khi đáp ứng ĐẦY ĐỦ các tiêu chí sau:

---

- [ ] **1. Chất lượng mã nguồn:**
  - `dart format .` đã được chạy và toàn bộ file tuân thủ formatting chuẩn.
  - `flutter analyze` báo cáo `No issues found!` (0 lỗi, 0 cảnh báo, 0 lint info).
  - Không còn `TODO` chưa được giải quyết hoặc comment debug, `print()`.

- [ ] **2. Kiểm thử tự động (Testing):**
  - `flutter test` chạy thành công 100% test cases.
  - Mọi hàm thuần / công thức tính toán mới trong `domain/` đều có unit test tương ứng (bao gồm các ca biên).
  - Các thao tác ghi repository có test sử dụng `fake_cloud_firestore`.

- [ ] **3. Trải nghiệm người dùng & Xử lý Trạng thái (UI States):**
  - Màn hình đã xử lý đủ 4 trạng thái cốt lõi:
    - **Loading:** Hiển thị skeleton đúng hình dáng nội dung, không dùng spinner chắn toàn trang.
    - **Empty:** Có hình minh họa nhỏ, dòng thông báo thân thiện và nút kêu gọi hành động (Call To Action).
    - **Error:** Thông báo ngắn gọn và có nút "Thử lại".
    - **Offline:** Hiển thị dải banner offline, dữ liệu được ghi vào cache cục bộ mà không báo lỗi.

- [ ] **4. Tuân thủ Design System (Mastercard):**
  - Không hardcode màu sắc, phông chữ, bán kính bo góc hay khoảng cách.
  - 100% sử dụng token từ [lib/core/theme/app_tokens.dart](file:///f:/Project/orbit-app/lib/core/theme/app_tokens.dart) hoặc `Theme.of(context)`.
  - Nút bấm, ô nhập, chip sử dụng `StadiumBorder` (pill); Card phẳng `elevation: 0`.

- [ ] **5. Bản địa hóa & Chuỗi ký tự (Localization):**
  - Không hardcode bất kỳ chuỗi text tiếng Việt nào trong Widget.
  - 100% chuỗi hiển thị được khai báo trong [lib/core/strings/app_strings.dart](file:///f:/Project/orbit-app/lib/core/strings/app_strings.dart).
  - Ngôn ngữ giữ thái độ trung tính khi thông báo tình trạng vượt ngân sách.

- [ ] **6. Dữ liệu & Tài liệu:**
  - Nếu có thay đổi cấu trúc dữ liệu, đã cập nhật model Freezed, `firestore.rules`, `firestore.indexes.json` và `docs/spec.md`.
  - Đã đánh dấu hoàn thành mục tương ứng trong [docs/progress.md](file:///f:/Project/orbit-app/docs/progress.md).
