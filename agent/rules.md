# 11 Quy tắc Bắt buộc cho Coding Agent

1. **Đọc `DESIGN.md` trước khi viết hoặc sửa UI:** Không ghi cứng mã màu, tên phông, bán kính bo góc hay khoảng cách; luôn dùng `AppTokens` hoặc `Theme.of(context)` để giữ đúng phong cách Mastercard.
2. **Tiền tệ luôn là số nguyên (`int`) VND dương:** Chiều thu hay chi do trường `type` quyết định; tuyệt đối không dùng số thực `double` để tránh lỗi sai số dấu phẩy động.
3. **Widget không bao giờ gọi Firestore trực tiếp:** Mọi truy vấn phải đi qua repository được tiêm bởi Riverpod; mọi logic và công thức nghiệp vụ phải viết thành hàm thuần trong `domain/` kèm unit test độc lập.
4. **Mỗi thao tác giao dịch (thêm / sửa / xóa) là MỘT `WriteBatch` duy nhất:** Batch phải cập nhật đồng thời: doc giao dịch, `wallets.balance`, `monthSummaries` và `goals.savedAmount` (nếu có `goalId`). Dùng `FieldValue.increment`; `monthSummaries` ghi bằng `set` kèm `merge: true`; không dùng `runTransaction` để đảm bảo hoạt động khi offline.
5. **Thay đổi schema Firestore phải đồng bộ toàn diện:** Khi đổi cấu trúc dữ liệu, phải cập nhật cùng lúc: Model Freezed, `firestore.rules`, `firestore.indexes.json`, `docs/spec.md` mục 6, và tăng `schemaVersion` nếu cần migrate dữ liệu cũ.
6. **Mọi chuỗi hiển thị UI phải nằm trong `app_strings.dart`:** Tuyệt đối không hardcode text tiếng Việt trong Widget; giữ ngôn ngữ trung tính, không phán xét khi thông báo vượt ngân sách.
7. **Không tự ý thêm package mới vào `pubspec.yaml`:** Nếu thực sự cần thiết, phải giải trình lý do rõ ràng và cập nhật vào `docs/architecture.md` trước khi cài đặt.
8. **Quy trình kiểm tra bắt buộc trước khi báo hoàn thành:** Phải chạy thành công chuỗi lệnh: `dart format .`, `flutter analyze` (0 lỗi), `flutter test` (100% test pass). Nếu có chỉnh sửa model Freezed, phải chạy `dart run build_runner build --delete-conflicting-outputs`.
9. **Bảo mật tuyệt đối thông tin và môi trường thật:** Không commit bất kỳ secret, API key hay file service-account nào; không tự ý chạy lệnh `firebase deploy`, login hoặc ghi dữ liệu lên project Firebase thật khi chưa có yêu cầu trực tiếp từ người dùng.
10. **Tôn trọng Nguồn sự thật (`docs/spec.md`):** Mọi điểm chưa rõ hoặc mâu thuẫn với `docs/spec.md` phải dừng lại và hỏi người dùng, không được tự suy đoán hoặc tự quyết định.
11. **Duy trì tài liệu dự án:** Luôn cập nhật tiến độ tương ứng trong `docs/progress.md` khi hoàn thành một mục; nếu có quyết định kiến trúc mới, phải tạo thêm ADR trong `docs/decisions/`.
