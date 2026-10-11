# Quỹ Đạo (Orbit App)

Ứng dụng Flutter quản lý thu chi cá nhân và tích lũy tiết kiệm theo tiến độ quỹ đạo trực quan.

- **Phong cách Thiết kế:** Lấy cảm hứng từ ngôn ngữ thiết kế của Mastercard (`DESIGN.md`) với nền kem ấm (`#F3F0EE`), bo góc viên thuốc (`StadiumBorder`), card phẳng không đổ bóng gắt và cung quỹ đạo cam.
- **Backend:** Firebase Authentication và Cloud Firestore (thiết kế Offline-First).
- **Kiến trúc:** Feature-First, phân tầng UI -> Application (Riverpod) -> Repository -> Domain thuần.

---

## 1. Yêu cầu Hệ thống & Cài đặt

Yêu cầu máy phát triển đã cài đặt:
- Flutter SDK (>= 3.24)
- Dart SDK (>= 3.5)
- Node.js (>= 18)
- Firebase CLI & FlutterFire CLI (`dart pub global activate flutterfire_cli`)

Cài đặt dependencies:
```bash
flutter pub get
```

---

## 2. Cách Khởi chạy Ứng dụng

### 2.1. Môi trường Phát triển (Development)
```bash
flutter run -t lib/main_dev.dart
```

### 2.2. Môi trường Sản phẩm (Production)
```bash
flutter run -t lib/main_prod.dart
```

### 2.3. Kiểm tra Mã nguồn & Kiểm thử
```bash
dart format .
flutter analyze
flutter test
```

---

## 3. Hướng dẫn Cấu hình Firebase (Bắt buộc cho Developer)

Trước khi ứng dụng có thể kết nối với Firebase thật, bạn cần thực hiện các bước sau:

1. **Tạo 2 Firebase Project trên Firebase Console:**
   - Project Dev: ví dụ `quy-dao-dev`
   - Project Prod: ví dụ `quy-dao-prod`

2. **Kích hoạt các dịch vụ Firebase:**
   - **Authentication:** Bật Google Sign-in, Sign in with Apple (cho iOS), và Email/Password.
   - **Cloud Firestore:** Tạo cơ sở dữ liệu ở chế độ Native mode (vùng `asia-southeast1` hoặc gần nhất).

3. **Sinh cấu hình Firebase bằng FlutterFire CLI:**
   - Đối với môi trường Dev:
     ```bash
     flutterfire configure --project=quy-dao-dev --out=lib/firebase/firebase_options_dev.dart
     ```
   - Đối với môi trường Prod:
     ```bash
     flutterfire configure --project=quy-dao-prod --out=lib/firebase/firebase_options_prod.dart
     ```

4. **Đăng ký Khóa SHA cho Android:**
   - Lấy mã băm SHA-1 và SHA-256 từ keystore máy phát triển và thêm vào mục cấu hình Android App trên Firebase Console (bắt buộc cho Google Sign-in).

5. **Cấu hình Sign in with Apple cho iOS:**
   - Bật Capability "Sign in with Apple" trong Xcode và cấu hình Services ID trên Apple Developer Console.

6. **Triển khai Security Rules và Composite Indexes:**
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes
   ```

7. **Kích hoạt Firebase App Check:**
   - Bật Play Integrity cho Android và App Attest / DeviceCheck cho iOS trên Firebase Console.

---

## 4. Tài liệu Tham khảo

- [docs/spec.md](file:///f:/Project/orbit-app/docs/spec.md): Đặc tả chi tiết sản phẩm, logic tài chính & schema Firestore.
- [docs/architecture.md](file:///f:/Project/orbit-app/docs/architecture.md): Tài liệu kiến trúc phân lớp & danh sách thư viện.
- [docs/progress.md](file:///f:/Project/orbit-app/docs/progress.md): Bảng theo dõi tiến độ phát triển 5 giai đoạn.
- [docs/design-notes.md](file:///f:/Project/orbit-app/docs/design-notes.md): Bảng phân tích token thiết kế & độ tương phản.
- [AGENTS.md](file:///f:/Project/orbit-app/AGENTS.md): Hướng dẫn nhanh dành cho Coding AI Agent.
