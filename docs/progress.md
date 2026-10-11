# Bảng Theo dõi Tiến độ Dự án Quỹ Đạo

Tiến độ phát triển được chia theo 5 giai đoạn roadmap chính quy định tại Mục 9 của `docs/spec.md`.

---

## Giai đoạn 1: Nền tảng & Cấu trúc (Foundation)
> **Mục tiêu:** Xây dựng khung kiến trúc vững chắc, theme chuẩn Mastercard, các tiện ích lõi và kiểm thử khói. Xong khi đăng nhập được và hiển thị màn hình mẫu đúng phong cách DESIGN.md.

- [x] **1.1. Khởi tạo dự án & Kiểm tra môi trường**
  - *Xong khi:* Flutter, Dart, Node, Git đã xác thực; project `quy_dao` khởi tạo thành công; `.gitignore` bảo vệ file nhạy cảm và commit `chore: init flutter project`.
- [x] **1.2. Tích hợp Design System Mastercard**
  - *Xong khi:* Kéo `DESIGN.md` từ getdesign; xây dựng `lib/core/theme/app_tokens.dart` và `lib/core/theme/app_theme.dart` (Material 3, StadiumBorder, Card elevation 0); tài liệu hóa trong `docs/design-notes.md`.
- [x] **1.3. Cài đặt Thư viện & Cấu hình Phân tích tĩnh**
  - *Xong khi:* Cài đặt đủ 20 dependencies/dev_dependencies theo spec; cấu hình `analysis_options.yaml` nghiêm ngặt; `flutter analyze` đạt 0 issues.
- [x] **1.4. Thiết lập Cấu trúc Thư mục Feature-First**
  - *Xong khi:* Tạo đủ cây thư mục `lib/features/...` (presentation, application, domain), `core/`, `data/`, các file bootstrap, main_dev, main_prod.
- [x] **1.5. Bộ Hằng số Chuỗi UI & Đường dẫn Firestore**
  - *Xong khi:* Tạo `app_strings.dart` (toàn bộ text tiếng Việt, ngôn ngữ trung tính) và `firestore_paths.dart` theo spec mục 6.
- [x] **1.6. Tiện ích Lõi & Unit Tests**
  - *Xong khi:* Viết `money_format.dart` và `month_key.dart` (hàm thuần) kèm unit test đầy đủ các ca biên (ngày 1, 25, cuối năm), toàn bộ test passed.
- [x] **1.7. Điều hướng Shell Router & Smoke Test**
  - *Xong khi:* `app_router.dart` cấu hình `StatefulShellRoute` với 4 tab (Tổng quan, Giao dịch, Ngân sách, Tiết kiệm); smoke test `test/smoke_test.dart` pump thành công `App` với `ProviderScope`.
- [x] **1.8. Cấu hình Firebase trong Repo**
  - *Xong khi:* Tạo `firebase.json`, `firestore.rules` (kiểm tra `isOwner`, `amount is int && amount > 0`), `firestore.indexes.json` (6 composite indexes).
- [ ] **1.9. Các Widget Dùng chung (Core Widgets)**
  - *Xong khi:* Tạo xong `PillButton`, `PillChip`, `CategoryAvatar`, `AmountText`, `OrbitProgressRing` (CustomPainter 600ms), `BudgetBar`.
- [ ] **1.10. Cấu hình Kết nối Firebase Thật (Dev & Prod)**
  - *Xong khi:* Người dùng chạy `flutterfire configure` sinh `firebase_options_dev.dart` và `firebase_options_prod.dart`.
- [ ] **1.11. Onboarding & Xác thực (Auth)**
  - *Xong khi:* Hoàn thiện 3 slide giới thiệu, đăng nhập Google, Apple, Email; tạo ví đầu tiên và chọn `monthStartDay`.

---

## Giai đoạn 2: Lõi Thu Chi & Quản lý Ví (Core Transactions)
> **Mục tiêu:** Vận hành trơn tru luồng tiền tệ với độ tin cậy tuyệt đối về dữ liệu. Xong khi số dư ví và `monthSummaries` luôn khớp tổng tính tay.

- [ ] **2.1. Quản lý Ví (Wallets)**
  - *Xong khi:* Thêm, sửa, ẩn ví (tiền mặt, ngân hàng, ví điện tử) kèm số dư ban đầu.
- [ ] **2.2. Danh mục Giao dịch (Categories)**
  - *Xong khi:* Bộ danh mục thu/chi mặc định được tự động sinh; hỗ trợ thêm danh mục; danh mục có giao dịch chỉ được `archived: true`, không xóa cứng.
- [ ] **2.3. Thêm Thu / Chi / Chuyển ví / Gửi tiết kiệm**
  - *Xong khi:* Ghi nhận giao dịch dưới 10 giây; nhập số tiền nguyên VND; lưu bằng 1 `WriteBatch` cập nhật đồng thời ví, `monthSummaries`, `goals`.
- [ ] **2.4. Sửa & Xóa Giao dịch với Hoàn tác (Undo)**
  - *Xong khi:* Xóa có Snackbar Hoàn tác 5s; sửa đổi tự động đảo ngược tác động cũ và áp dụng tác động mới trong cùng 1 batch.
- [ ] **2.5. Danh sách Giao dịch & Bộ lọc**
  - *Xong khi:* Lọc theo tháng, loại, danh mục, ví; tìm kiếm theo ghi chú; phân trang 30 dòng/lần cuộn mượt.
- [ ] **2.6. Kiểm thử Security Rules trên Emulator**
  - *Xong khi:* Bộ test rule chạy qua Firebase Emulator chặn thành công truy cập trái phép và dữ liệu không hợp lệ.

---

## Giai đoạn 3: Ngân sách & Dự tính vs Thực tế (Budgets)
> **Mục tiêu:** Giúp người dùng nắm bắt kế hoạch tài chính từng tháng. Xong khi đổi một khoản chi thì thanh ngân sách đổi ngay lập tức.

- [ ] **3.1. Thiết lập Ngân sách Tháng**
  - *Xong khi:* Đặt và chỉnh sửa dự tính chi / dự tính thu theo từng danh mục cho từng `monthKey`.
- [ ] **3.2. Tính năng "Sao chép từ tháng trước"**
  - *Xong khi:* Tự động sao chép toàn bộ hạn mức từ tháng liền kề chỉ với 1 chạm.
- [ ] **3.3. Thanh hiển thị Ngân sách `BudgetBar`**
  - *Xong khi:* Hiển thị trực quan 3 trạng thái: bình thường, cảnh báo nhẹ ($\ge 80\%$), vượt ngân sách ($> 100\%$) với tông màu trung tính.
- [ ] **3.4. Thẻ "Còn có thể chi" & Dư dự tính vs Dư thực tế**
  - *Xong khi:* Hiển thị rõ số tiền còn được chi trong tháng và hạn mức chi trung bình mỗi ngày.
- [ ] **3.5. Cảnh báo Ngân sách Thông minh**
  - *Xong khi:* Bắn thông báo cục bộ khi một danh mục chạm mốc 80% và 100% (chỉ kích hoạt 1 lần mỗi tháng cho mỗi mốc).

---

## Giai đoạn 4: Mục tiêu Tiết kiệm & Động lực (Savings & Motivation)
> **Mục tiêu:** Biến mục tiêu tiết kiệm thành tiến độ trực quan mỗi ngày. Xong khi gửi tiền thấy vòng tiến độ chạy và nhận chúc mừng ở mốc đầu tiên.

- [ ] **4.1. Tạo & Quản lý Mục tiêu Tiết kiệm**
  - *Xong khi:* Nhập tên, số tiền đích, ngày hạn; tính tự động công thức "cần gom mỗi tháng" làm tròn bội số 1.000đ.
- [ ] **4.2. Giao dịch Gửi thêm / Rút bớt (Saving Txn)**
  - *Xong khi:* Gửi tiền tạo transaction `saving`, trừ tiền ví nhưng KHÔNG tính vào tổng Chi tiêu; tăng `savedAmount`.
- [ ] **4.3. Vòng tiến độ Quỹ đạo `OrbitProgressRing`**
  - *Xong khi:* Vòng vẽ CustomPainter cam chạy mượt 600ms; hiển thị trạng thái Đúng tiến độ / Chậm / Quá hạn.
- [ ] **4.4. Cột mốc (25%, 50%, 75%, 100%) & Chúc mừng**
  - *Xong khi:* Kích hoạt hiệu ứng chúc mừng đúng một lần khi chạm mốc; lưu mốc vào `milestonesReached`.
- [ ] **4.5. Streak Ghi chép & Nút "Hôm nay không chi"**
  - *Xong khi:* Tính streak chính xác từ `loggedDays`, hỗ trợ bấm offline; duy trì kỷ lục dài nhất.
- [ ] **4.6. Nhắc nhở Ghi chép Hằng ngày**
  - *Xong khi:* Thông báo cục bộ hiển thị đúng 21:00 mỗi tối; cho phép tùy chỉnh giờ trong Cài đặt.

---

## Giai đoạn 5: Báo cáo, Hoàn thiện & Đóng gói (Reports & Polish)
> **Mục tiêu:** Báo cáo toàn diện, tối ưu trải nghiệm và đưa lên thiết bị thật. Xong khi dùng thử 1 tháng không lệch số liệu.

- [ ] **5.1. Màn hình Báo cáo Chi tiết**
  - *Xong khi:* Donut chart phân bổ danh mục, biểu đồ đường thu chi 6/12 tháng, cột so sánh kế hoạch vs thực tế.
- [ ] **5.2. Hoàn thiện 4 Trạng thái Chung**
  - *Xong khi:* Toàn bộ màn hình xử lý triệt để: Skeleton loading, Empty state có hành động, Error có nút Thử lại, Banner Offline sync.
- [ ] **5.3. Kích hoạt Firebase App Check**
  - *Xong khi:* Bảo vệ an toàn backend với Play Integrity và App Attest.
- [ ] **5.4. Kiểm thử Khả năng Truy cập & Thiết bị Thật**
  - *Xong khi:* Kiểm tra độ tương phản màu sắc, cỡ chữ lớn, kiểm thử trên cả Android và iOS thật.
