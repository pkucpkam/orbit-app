# Quy trình Kiểm tra Trước khi Phát hành (Release Checklist)

Quy trình 8 bước bắt buộc trước khi đóng gói hoặc phát hành phiên bản ứng dụng Quỹ Đạo:

---

1. **Kiểm tra Secret & File nhạy cảm:**
   Chạy `git status` và xác nhận không có file nhạy cảm lọt vào staging:
   - Không có `.env`, `*.keystore`, `key.properties`, `service-account*.json`.
   - File `.gitignore` đã có hiệu lực đúng chuẩn.

2. **Cập nhật số phiên bản (Version & Build Number):**
   Mở [pubspec.yaml](file:///f:/Project/orbit-app/pubspec.yaml), tăng `version: x.y.z+build` theo chuẩn Semantic Versioning:
   - Android: `build-name` là `versionName`, `build-number` là `versionCode`.
   - iOS: `CFBundleShortVersionString` và `CFBundleVersion`.

3. **Sinh mã nguồn tự động đồng bộ:**
   Đảm bảo không còn sai lệch mã sinh tự động:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Định dạng và phân tích tĩnh nghiêm ngặt:**
   ```bash
   dart format --set-exit-if-changed .
   flutter analyze
   ```
   Yêu cầu bắt buộc: `No issues found!`.

5. **Chạy toàn bộ bộ kiểm thử tự động (Unit, Widget, Golden):**
   ```bash
   flutter test --coverage
   ```
   100% test cases phải passed.

6. **Kiểm tra Firebase Security Rules & Indexes:**
   Xác nhận [firestore.rules](file:///f:/Project/orbit-app/firestore.rules) và [firestore.indexes.json](file:///f:/Project/orbit-app/firestore.indexes.json) đã được đồng bộ và deploy lên Firebase Console của project `prod`.

7. **Kiểm tra Cấu hình Nền tảng (Platform Readiness):**
   - **Android:** File `android/app/build.gradle.kts` đã cấu hình `signingConfigs` với keystore phát hành; SHA-1 và SHA-256 đã đăng ký trên Firebase console; App Check Play Integrity đã kích hoạt.
   - **iOS:** Bundle Identifier khớp với Apple Developer portal; Capabilities có "Sign in with Apple"; App Check App Attest đã kích hoạt.

8. **Build thử nghiệm bản phát hành (Release Build):**
   - Android APK / AAB:
     ```bash
     flutter build appbundle -t lib/main_prod.dart
     ```
   - iOS Archive:
     ```bash
     flutter build ipa -t lib/main_prod.dart
     ```
   - Cập nhật ghi chú phát hành vào [docs/progress.md](file:///f:/Project/orbit-app/docs/progress.md).
