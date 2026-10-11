# Quỹ Đạo (orbit-app) 🪐

Ứng dụng Flutter quản lý thu chi cá nhân và tích lũy tiết kiệm theo tiến độ quỹ đạo trực quan. Giao diện được thiết kế chuẩn mực theo ngôn ngữ thiết kế **Mastercard** (nền kem ấm `#F3F0EE`, bo góc viên thuốc `StadiumBorder`, vòng quỹ đạo cam `#CF4500`). Backend xây dựng trên **Cloud Firestore** và **Firebase Authentication** với kiến trúc **Offline-First**.

---

## 🌟 Tính Năng Nổi Bật

### 1. Quản lý Thu Chi & Đa Ví (Core Transactions)
- **Nhập nhanh dưới 10 giây:** Hỗ trợ 4 nghiệp vụ: *Chi tiêu*, *Thu nhập*, *Chuyển ví*, và *Gửi tiết kiệm*.
- **Toàn vẹn dữ liệu tuyệt đối:** Sử dụng 1 `WriteBatch` duy nhất cập nhật đồng thời số dư ví, tổng kết tháng (`monthSummaries`), và số tiền gom của mục tiêu (`goals`).
- **Thao tác vuốt trực quan:** Vuốt để xóa giao dịch kèm SnackBar Hoàn tác (Undo) trong 5 giây.
- **Quản lý nhiều ví & danh mục:** Hỗ trợ ví tiền mặt, ngân hàng, ví điện tử; bộ 12 danh mục thu/chi mặc định kèm icon và màu sắc nhận diện.

### 2. Ngân sách & Dự tính vs Thực tế (Budgets)
- **Kế hoạch tài chính từng tháng:** Đặt và theo dõi ngân sách chi / dự tính thu theo từng danh mục.
- **Sao chép từ tháng trước:** Tái sử dụng kế hoạch tháng cũ chỉ với 1 chạm.
- **Thanh đo ngân sách `BudgetBar`:** Hiển thị 3 trạng thái (Bình thường, Chạm ngưỡng $\ge 80\%$, Vượt ngân sách $> 100\%$) bằng màu sắc và ngôn ngữ trung tính, không phán xét.
- **Thẻ "Còn có thể chi":** Tính toán tức thì số tiền còn được chi và hạn mức chi trung bình mỗi ngày còn lại trong tháng.
- **Cảnh báo ngân sách thông minh:** Tự động kích hoạt thông báo cục bộ khi chi tiêu chạm ngưỡng 80% và 100%.

### 3. Mục tiêu Tiết kiệm & Động lực Quỹ đạo (Savings & Motivation)
- **Vòng tiến độ Quỹ đạo `OrbitProgressRing`:** Hiệu ứng CustomPainter cung cam chạy 600ms với hành tinh quay quanh quỹ đạo.
- **Cột mốc tích lũy (25%, 50%, 75%, 100%):** Hộp thoại chúc mừng `MilestoneCelebrationDialog` rực rỡ kèm lời nhắn động lực theo thời gian còn lại.
- **Streak ghi chép & Nút "Hôm nay không chi":** Duy trì thói quen tài chính tích cực mỗi ngày mà không gây áp lực.
- **Nhắc nhở hằng ngày 21:00:** Lên lịch thông báo cục bộ định kỳ theo múi giờ `Asia/Ho_Chi_Minh`.

### 4. Báo cáo Chi tiết & Trực quan hóa (Reports)
- **Biểu đồ Donut Chart:** Phân bổ chi tiêu theo danh mục với bảng màu Mastercard sang trọng (`fl_chart`), chạm lát cắt để phóng to xem chi tiết.
- **So sánh Thu & Chi:** Đối chiếu trực quan dòng tiền theo chu kỳ Tháng, Quý, Năm.
- **Top 5 khoản chi lớn nhất:** Tự động phát hiện các khoản chi tiêu lớn nhất trong kỳ.

### 5. Hoàn thiện 4 Trạng thái Chung
- **Skeleton Loading:** Hiệu ứng xung nhịp Shimmer kem ấm đồng dạng nội dung (`SkeletonBox`), loại bỏ hoàn toàn spinner toàn trang.
- **Empty State:** Trạng thái rỗng có icon minh họa và nút hành động nhanh (`EmptyStateView`).
- **Error State:** Thông báo lỗi ngắn gọn kèm nút Thử lại (`ErrorStateView`).
- **Offline Banner:** Dải thông báo offline nhẹ nhàng, đồng bộ mượt mà khi có mạng trở lại (`OfflineBanner`).

---

## 🛠️ Công Nghệ Sử Dụng

- **Framework:** Flutter 3.x (Dart 3.x) — Hỗ trợ Android & iOS
- **State Management:** Flutter Riverpod (`flutter_riverpod`)
- **Điều hướng:** GoRouter (`go_router`) với `StatefulShellRoute` 4 tab độc lập
- **Backend & Cloud:** Firebase Core, Firebase Auth (Google, Email/Password, Khách), Cloud Firestore (Offline Persistence)
- **Bảo mật:** Firebase App Check (`PlayIntegrityProvider` trên Android, `AppAttestProvider` trên iOS)
- **Thông báo Cục bộ:** `flutter_local_notifications` & `timezone`
- **Biểu đồ:** `fl_chart`
- **Model sinh mã:** `freezed`, `json_serializable`, `build_runner`
- **Kiểm thử:** `flutter_test`, `fake_cloud_firestore`, `mocktail` (100% Pass)

---

## 📂 Cấu Trúc Thư Mục Feature-First

```text
lib/
├── bootstrap.dart                  # Khởi tạo App Check, Notifications, Firebase
├── app.dart                        # MaterialApp theme & router
├── core/                           # Tiện ích dùng chung toàn ứng dụng
│   ├── routing/                    # Cấu hình GoRouter (4 tabs shell + root routes)
│   ├── services/                   # NotificationService (local notifications)
│   ├── strings/                    # Toàn bộ hằng số chuỗi UI tiếng Việt (AppStrings)
│   ├── theme/                      # AppTokens (màu sắc, typography, border radius)
│   ├── utils/                      # money_format, month_key (hàm thuần)
│   └── widgets/                    # Core widgets (PillButton, BudgetBar, OrbitRing...)
├── data/                           # Lớp dữ liệu trung tâm & Firestore Repositories
│   ├── firestore_paths.dart        # Quy ước đường dẫn Firestore
│   ├── models/                     # Data models (Freezed)
│   ├── providers/                  # Real-time state providers
│   └── repositories/               # Auth, User, Wallet, Category, Tx, Budget, Goal
└── features/                       # Các tính năng theo mô hình Feature-First
    ├── auth/                       # Đăng nhập Google, Email, Khách
    ├── home/                       # Tab Tổng quan (Overview), Streak, Quick Actions
    ├── transactions/               # Tab Giao dịch & AddTransactionSheet
    ├── budgets/                    # Tab Ngân sách & SetBudgetSheet
    ├── savings/                    # Tab Tiết kiệm, AddGoalSheet & Milestone Celebration
    └── reports/                    # Màn hình Báo cáo Chi tiết & Donut Chart
```

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Ứng Dụng

### 1. Cài đặt Dependencies
```bash
flutter pub get
```

### 2. Sinh mã Model (nếu có cập nhật Freezed)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Chạy Ứng dụng
- **Môi trường Phát triển (Dev):**
  ```bash
  flutter run -t lib/main_dev.dart
  ```
- **Môi trường Sản phẩm (Prod):**
  ```bash
  flutter run -t lib/main_prod.dart
  ```

---

## 🧪 Kiểm Thử & Kiểm Tra Chất Lượng Mã Nguồn

Dự án áp dụng quy chuẩn phân tích tĩnh nghiêm ngặt và kiểm thử toàn diện:

- **Định dạng mã nguồn:**
  ```bash
  dart format .
  ```
- **Phân tích tĩnh (bắt buộc 0 lỗi):**
  ```bash
  flutter analyze
  ```
- **Chạy toàn bộ 32 Unit & Widget Tests:**
  ```bash
  flutter test
  ```

---

## 🔒 Quy Chuẩn Bảo Mật & Tệp Nhạy Cảm

Các tệp cấu hình và khóa bí mật sau đã được cấu hình trong `.gitignore` để tránh rò rỉ:
- `google-services.json` (Android credentials)
- `GoogleService-Info.plist` (iOS credentials)
- `lib/firebase_options.dart`
- `*.keystore`, `*.jks`, `*.p8`, `*.p12`, `key.properties`, `local.properties`
- `.env*` và `service-account*.json`
- `.agents/` và `skills-lock.json`

---

## 📖 Tài Liệu Dự Án

- [docs/spec.md](file:///f:/Project/orbit-app/docs/spec.md): Nguồn sự thật (Source of Truth) về 18 chức năng và công thức tài chính.
- [docs/progress.md](file:///f:/Project/orbit-app/docs/progress.md): Bảng theo dõi tiến độ chi tiết 5 giai đoạn roadmap.
- [docs/architecture.md](file:///f:/Project/orbit-app/docs/architecture.md): Quy ước kiến trúc và đặt tên layers.
- [DESIGN.md](file:///f:/Project/orbit-app/DESIGN.md): Đặc tả màu sắc, typography và phong cách thiết kế Mastercard.
- [agent/rules.md](file:///f:/Project/orbit-app/agent/rules.md): 11 quy tắc bất di bất dịch của dự án.
