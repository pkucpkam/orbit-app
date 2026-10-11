# Quỹ Đạo (orbit-app) — Hướng dẫn Agent

Ứng dụng Flutter quản lý thu chi cá nhân và tích lũy tiết kiệm theo tiến độ quỹ đạo trực quan. Giao diện xây dựng theo Design System Mastercard (nền kem putty `#F3F0EE`, bo góc pill/stadium, vòng quỹ đạo cam). Backend Cloud Firestore và Firebase Authentication.

## Tech Stack
- **Framework:** Flutter 3.x (Dart 3.x) — Android & iOS
- **State Management:** Flutter Riverpod (`flutter_riverpod`)
- **Điều hướng:** GoRouter (`go_router`) với `StatefulShellRoute` 4 tab
- **Backend:** Firebase Core, Auth, Cloud Firestore, App Check
- **Model:** Freezed (`freezed`, `freezed_annotation`, `json_serializable`)
- **Định dạng & Biểu đồ:** `intl` (locale `vi_VN`), `fl_chart`
- **Kiểm thử:** `flutter_test`, `fake_cloud_firestore`, `mocktail`

## Các lệnh thường dùng
- Cài đặt dependencies: `flutter pub get`
- Sinh mã model Freezed: `dart run build_runner build --delete-conflicting-outputs`
- Định dạng mã nguồn: `dart format .`
- Phân tích tĩnh (bắt buộc 0 lỗi): `flutter analyze`
- Chạy toàn bộ test: `flutter test`
- Chạy app môi trường Dev: `flutter run -t lib/main_dev.dart`
- Chạy app môi trường Prod: `flutter run -t lib/main_prod.dart`

## Tài liệu bắt buộc phải đọc trước khi code
1. [agent/rules.md](file:///f:/Project/orbit-app/agent/rules.md) — 11 quy tắc bắt buộc của dự án (tiền là `int`, không gọi Firestore từ Widget, 1 batch cho giao dịch...).
2. [agent/README.md](file:///f:/Project/orbit-app/agent/README.md) — Tổng quan tài liệu dành cho agent và các workflows.
3. [DESIGN.md](file:///f:/Project/orbit-app/DESIGN.md) — Quy chuẩn màu sắc, phông chữ, bán kính bo góc và độ sâu Mastercard.
4. [docs/spec.md](file:///f:/Project/orbit-app/docs/spec.md) — Nguồn sự thật (Source of Truth) về mô hình dữ liệu, 18 tính năng và nghiệp vụ.
5. [docs/architecture.md](file:///f:/Project/orbit-app/docs/architecture.md) — Kiến trúc phân tầng Feature-First và quy ước đặt tên.
