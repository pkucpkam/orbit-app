# Kiến trúc Hệ thống Ứng dụng Quỹ Đạo

Tài liệu mô tả kiến trúc phân lớp, luồng dữ liệu, quy ước lập trình và cách khởi chạy ứng dụng Quỹ Đạo.

---

## 1. Kiến trúc Tổng thể (Feature-First Architecture)

Dự án áp dụng kiến trúc theo tính năng (**Feature-First**) kết hợp phân tách 4 lớp trách nhiệm chặt chẽ:

```text
┌────────────────────────────────────────────────────────┐
│               Lớp Trình diễn (Presentation)            │
│       (Widgets, Pages, Controls, Formatters)           │
└───────────────────────────▲────────────────────────────┘
                            │ Watch / Listen state
┌───────────────────────────┴────────────────────────────┐
│              Lớp Ứng dụng (Application / State)         │
│     (Riverpod Notifiers, StateProviders, Controllers)  │
└─────────────▲────────────────────────────▲─────────────┘
              │ Calls                      │ Transforms
┌─────────────┴─────────────┐ ┌────────────┴─────────────┐
│  Lớp Dữ liệu (Repository) │ │    Lớp Nghiệp vụ thuần   │
│ (Interfaces & FirebaseImpl│ │         (Domain)         │
└─────────────▲─────────────┘ │ (Pure functions, models, │
              │ I/O ops       │      math formulas)      │
┌─────────────┴─────────────┐ └──────────────────────────┘
│      Cloud Firestore      │
│  (Offline cache & Remote) │
└───────────────────────────┘
```

### Nguyên tắc cốt lõi:
1. **Widget không bao giờ gọi trực tiếp Cloud Firestore hay Firebase Auth.** Mọi tương tác dữ liệu phải thông qua Repository được tiêm bởi Riverpod.
2. **Logic nghiệp vụ và công thức tính toán là hàm thuần (Pure Functions) trong `domain/`**: Không phụ thuộc vào SDK Flutter, UI hay Firestore, đảm bảo 100% kiểm thử bằng Unit Test nhanh chóng và độc lập.
3. **Mỗi thay đổi giao dịch là một `WriteBatch` duy nhất**: Không dùng `runTransaction` cho ghi chép thu chi để hỗ trợ ghi ngoại tuyến (Offline first) và xử lý đồng thời qua `FieldValue.increment`.

---

## 2. Cấu trúc Thư mục

```text
lib/
  main.dart                    // Điểm vào mặc định (chuyển tiếp tới main_dev.dart)
  main_dev.dart                // Điểm vào môi trường dev
  main_prod.dart               // Điểm vào môi trường prod
  bootstrap.dart               // Khởi tạo nền tảng, Firebase & runApp
  app.dart                     // Widget gốc MaterialApp.router + Theme
  firebase/                    // File cấu hình Firebase sinh bởi FlutterFire
    firebase_options_dev.dart
    firebase_options_prod.dart
  core/                        // Nền tảng dùng chung toàn app
    theme/                     // app_tokens.dart, app_theme.dart (Mastercard theme)
    router/                    // app_router.dart (GoRouter, StatefulShellRoute)
    strings/                   // app_strings.dart (Toàn bộ text UI tiếng Việt)
    utils/                     // money_format.dart, month_key.dart
    widgets/                   // PillButton, OrbitProgressRing, BudgetBar, ...
  data/                        // Tầng dữ liệu chung
    firestore_paths.dart       // Hằng số path collection & document
    models/                    // Model dùng chung
    repositories/              // Interface & Implementation repository
  features/                    // Tách biệt theo từng tính năng
    auth/
    home/
    transactions/
    budgets/
    savings/
    reports/
    settings/
      presentation/            // Giao diện (Screens, Widgets riêng)
      application/             // State management (Riverpod Providers/Notifiers)
      domain/                  // Model nghiệp vụ, logic thuần, validation
```

---

## 3. Danh sách Package & Phiên bản Thực tế

Dưới đây là danh sách toàn bộ thư viện được cài đặt thực tế trong dự án (xác thực từ `pubspec.lock`):

### 3.1. Dependencies (Runtime)

| Tên Package | Phiên bản | Mục đích sử dụng |
| :--- | :--- | :--- |
| **`firebase_core`** | `^4.15.0` (4.15.0) | Khởi tạo kết nối Firebase đa nền tảng |
| **`firebase_auth`** | `^6.7.0` (6.7.0) | Quản lý phiên đăng nhập và định danh người dùng |
| **`cloud_firestore`** | `^6.10.0` (6.10.0) | Cơ sở dữ liệu tài liệu NoSQL chính, hỗ trợ offline cache |
| **`firebase_app_check`** | `^0.4.8` (0.4.8) | Chống lạm dụng API qua Play Integrity (Android) và App Attest (iOS) |
| **`google_sign_in`** | `^7.2.0` (7.2.0) | Xác thực tài khoản Google |
| **`sign_in_with_apple`** | `^8.1.0` (8.1.0) | Xác thực tài khoản Apple ID trên iOS |
| **`flutter_riverpod`** | `^3.3.2` (3.3.2) | Quản lý trạng thái phân tán, Dependency Injection |
| **`go_router`** | `^17.5.0` (17.5.0) | Điều hướng ứng dụng, hỗ trợ StatefulShellRoute 4 tab |
| **`freezed_annotation`** | `^3.1.0` (3.1.0) | Annotation sinh model bất biến |
| **`json_annotation`** | `^4.12.0` (4.12.0) | Annotation chuyển đổi tuần tự hóa JSON |
| **`intl`** | `^0.20.3` (0.20.3) | Định dạng tiền VND và thời gian theo chuẩn locale vi_VN |
| **`fl_chart`** | `^1.2.0` (1.2.0) | Vẽ biểu đồ donut danh mục, xu hướng thu chi và cột ngân sách |
| **`flutter_local_notifications`** | `^22.3.1` (22.3.1) | Thông báo nhắc nhở ghi chép hằng ngày trên thiết bị |
| **`local_auth`** | `^3.0.2` (3.0.2) | Khóa ứng dụng bảo mật bằng vân tay và Face ID (v1.1) |
| **`cupertino_icons`** | `^1.0.8` (1.0.9) | Bộ icon phong cách iOS |

### 3.2. Dev Dependencies (Phát triển & Kiểm thử)

| Tên Package | Phiên bản | Mục đích sử dụng |
| :--- | :--- | :--- |
| **`flutter_lints`** | `^6.0.0` (6.0.0) | Bộ quy tắc phân tích tĩnh cho mã Flutter |
| **`build_runner`** | `^2.15.1` (2.15.1) | Công cụ thực thi sinh mã nguồn tự động |
| **`freezed`** | `^3.2.5` (3.2.5) | Trình sinh mã model bất biến, copyWith, unions |
| **`json_serializable`** | `^6.14.1` (6.14.1) | Trình sinh mã `fromJson` / `toJson` |
| **`fake_cloud_firestore`** | `^4.3.0` (4.3.0) | Giả lập Cloud Firestore trong bộ nhớ để unit test repository |
| **`mocktail`** | `^1.0.5` (1.0.5) | Thư viện mock đối tượng và hành vi cho Dart |

---

## 4. Quy ước Đặt tên (Naming Conventions)

### 4.1. File & Thư mục
- Đặt tên theo `snake_case`.
- Ví dụ: `transaction_repository.dart`, `orbit_progress_ring.dart`, `month_key_test.dart`.

### 4.2. Class & Types
- Đặt tên theo `PascalCase`.
- Model: `Transaction`, `Wallet`, `Category`, `MonthSummary`.
- Repository Interface: `TransactionRepository`.
- Repository Firestore Impl: `FirestoreTransactionRepository`.
- Presentation: `OverviewScreen`, `AddTransactionScreen`, `PillButton`.

### 4.3. Riverpod Providers
- Đặt tên theo `camelCase` có hậu tố `Provider`.
- Ví dụ:
  - Repository: `transactionRepositoryProvider`
  - Stream dữ liệu: `transactionsStreamProvider`, `monthSummaryProvider(monthKey)`
  - State Notifier: `addTransactionControllerProvider`

---

## 5. Hướng dẫn Chạy Ứng dụng

### 5.1. Môi trường Phát triển (Development)
```bash
# Lấy dependencies
flutter pub get

# Sinh code Freezed / JSON Serializable nếu có chỉnh sửa model
dart run build_runner build --delete-conflicting-outputs

# Chạy ứng dụng môi trường Dev
flutter run -t lib/main_dev.dart
```

### 5.2. Môi trường Sản phẩm (Production)
```bash
# Chạy ứng dụng môi trường Prod
flutter run -t lib/main_prod.dart
```

### 5.3. Kiểm tra Chất lượng Mã nguồn
```bash
# Định dạng chuẩn toàn bộ code
dart format .

# Phân tích tĩnh (phải đạt 0 issues)
flutter analyze

# Chạy toàn bộ test
flutter test
```
