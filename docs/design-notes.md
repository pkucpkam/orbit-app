# Ghi chú Thiết kế & Design System (Mastercard Theme)

Tài liệu ghi lại việc triển khai Design System từ `DESIGN.md` sang Flutter (`app_tokens.dart` và `app_theme.dart`), cùng các điểm phân tích kỹ thuật cần quyết định.

---

## 1. Tóm tắt Token đã triển khai

### 1.1. Bảng màu (Color Palette)

| Tên Token | Mã Hex | Vai trò trong DESIGN.md | Triển khai Flutter |
| :--- | :--- | :--- | :--- |
| **Canvas Cream** | `#F3F0EE` | Nền canvas trang, ấm, tông putty (thay thế trắng) | `AppTokens.canvasCream`, `scaffoldBackgroundColor` |
| **Lifted Cream** | `#FCFBFA` | Nền nâng một bậc, cho card lồng nhau | `AppTokens.liftedCream`, `cardColor` |
| **White** | `#FFFFFF` | Nền nav pill nổi, modal, ô nhập, satellite CTA | `AppTokens.white` |
| **Soft Bone** | `#F4F4F4` | Nền xám lạnh phụ | `AppTokens.softBone` |
| **Ink Black** | `#141413` | Đen ấm cho nút chính (CTA), tiêu đề, thân bài, footer | `AppTokens.inkBlack`, `colorScheme.primary` |
| **Charcoal** | `#262627` | Đen mềm cho văn bản thay thế | `AppTokens.charcoal` |
| **Slate Gray** | `#696969` | Xám mờ cho nhãn phụ, trạng thái disabled | `AppTokens.slateGray` |
| **Granite / Graphite** | `#555555` / `#565656` | Xám đậm cho điểm nhấn trong dòng | `AppTokens.granite`, `AppTokens.graphite` |
| **Dust Taupe** | `#D1CDC7` | Xám kem mờ cho placeholder, đường viền nhẹ | `AppTokens.dustTaupe` |
| **Signal Orange** | `#CF4500` | Cam cháy cho hành động xác nhận, điểm nhấn, vòng quỹ đạo | `AppTokens.signalOrange`, `colorScheme.secondary` |
| **Light Signal Orange** | `#F37338` | Cam cà rốt cho cung quỹ đạo trang trí, trạng thái active | `AppTokens.lightSignalOrange`, `colorScheme.tertiary` |
| **Clay Brown** | `#9A3A0A` | Nâu gỉ cho nút phụ kiểu link | `AppTokens.clayBrown` |
| **Link Blue** | `#3860BE` | Xanh bụi cho link và thông tin | `AppTokens.linkBlue` |
| **Mastercard Red / Yellow** | `#EB001B` / `#F79E1B` | Nhận diện thương hiệu (chỉ dùng cho logo, không dùng cho UI) | `AppTokens.brandRed`, `AppTokens.brandYellow` |

#### Token màu bổ sung (Semantic - không có trong DESIGN.md):
- **`semanticIncome`** (`#1B8755`): Màu xanh lục cho các khoản thu nhập (+).
- **`semanticBudgetWarning`** (`#D97706`): Màu hổ phách/cam vàng cho cảnh báo nhẹ khi chi tiêu chạm ngưỡng 80% ngân sách.
- **`semanticBudgetExceeded`** (`#C53030`): Màu đỏ cảnh báo trung tính khi chi tiêu vượt quá 100% ngân sách.

### 1.2. Kiểu dáng & Bo góc (Border Radii)

- `radiusMicro` (4.0px) & `radiusSmall` (6.0px): Chi tiết nhỏ.
- `radiusButton` (20.0px): Nút bấm chính chữ nhật bo tròn đặc trưng.
- `radiusConsentButton` (24.0px): Nút cam cảnh báo / xác nhận.
- `radiusStadium` (40.0px): Khung media hero, thẻ section lớn.
- `radiusPill` (999.0px): Nút dạng viên thuốc tròn hoàn toàn (`StadiumBorder`), thanh điều hướng nổi, ô nhập dữ liệu, chip.

### 1.3. Khoảng cách (Spacing)

Hệ thống cơ sở lũy thừa 8px: `4, 8, 16, 24, 32, 48, 64, 96, 128` (px).

### 1.4. Đổ bóng & Nổi khối (Elevation & Shadows)

- Mặc định toàn bộ Card và Scaffold là phẳng (`elevation: 0`).
- Không dùng bóng đổ gắt. Chỉ dùng bóng mờ mở rộng (`blurRadius: 24-48px`, độ mờ chỉ 4% - 8%) cho thanh điều hướng nổi và hero container.

---

## 2. Các điểm cần Bạn quyết định

### (a) Phông chữ & Hỗ trợ tiếng Việt đầy đủ

- **Hiện trạng:**
  - `DESIGN.md` chỉ định phông chính là **`MarkForMC`** (phông hình học độc quyền của Mastercard, có bản quyền thương mại và không có sẵn).
  - Phông fallback được chỉ định trong fallback stack là **`Sofia Sans`** (Google Fonts), `Arial`, `sans-serif`.
- **Đánh giá dấu tiếng Việt:**
  - Phông hệ thống mặc định (`Roboto` trên Android, `San Francisco` trên iOS) hỗ trợ tiếng Việt hoàn hảo nhưng không mang đúng chất hình học đặc trưng của Mastercard.
  - Phông **`Sofia Sans`** có bộ ký tự Latin Extended hỗ trợ đầy đủ 100% tiếng Việt có dấu.
  - Một phương án khác rất phổ biến cho tiếng Việt với phong cách hình học tương tự là **`Be Vietnam Pro`** hoặc **`Inter`**.
- **Cần quyết định:**
  - Phương án 1 (Khuyên dùng): Tải font ttf `Sofia Sans` đưa vào assets dự án để giữ đúng bộ nhận diện fallback từ DESIGN.md.
  - Phương án 2: Sử dụng font hệ thống (`sans-serif`) không cần thêm asset để dung lượng app nhẹ nhất.

---

### (b) Đo lường độ tương phản: Chữ màu Cam trên nền Kem Canvas

Theo tiêu chuẩn WCAG 2.1:
- Văn bản thông thường (dưới 18pt hoặc dưới 14pt in đậm): Yêu cầu tỷ lệ tương phản tối thiểu **4.5 : 1** (AA) hoặc **7.0 : 1** (AAA).
- Văn bản lớn (từ 18pt trở lên hoặc từ 14pt in đậm) & thành phần giao diện (UI components): Yêu cầu tối thiểu **3.0 : 1** (AA).

#### Kết quả đo đạc thực tế:
1. **Nền Canvas Cream (`#F3F0EE`) vs Signal Orange (`#CF4500`):**
   - Độ chói tương đối (Relative Luminance) Canvas Cream: **0.8754**
   - Độ chói tương đối Signal Orange: **0.1756**
   - **Tỷ lệ tương phản thực tế:** $(0.8754 + 0.05) / (0.1756 + 0.05) = 0.9254 / 0.2256 =$ **`4.10 : 1`**
   - **Đánh giá:**
     - **ĐẠT** cho thành phần UI (nút, viền, icon) và chữ cỡ lớn (tiêu đề in đậm $\ge 14pt$ hoặc chữ $\ge 18pt$).
     - **KHÔNG ĐẠT** chuẩn 4.5:1 cho chữ nhỏ / văn bản thân (body text).
2. **Nền Canvas Cream (`#F3F0EE`) vs Light Signal Orange (`#F37338`):**
   - Độ chói tương đối Light Signal Orange: **0.3181**
   - **Tỷ lệ tương phản thực tế:** $(0.8754 + 0.05) / (0.3181 + 0.05) = 0.9254 / 0.3681 =$ **`2.51 : 1`**
   - **Đánh giá:**
     - **KHÔNG ĐẠT** chuẩn WCAG AA cho cả văn bản thường lẫn thành phần giao diện. Chỉ dùng cho đường cong trang trí quỹ đạo mờ (`Orbit line`) và chỉ báo không chứa thông tin quan trọng.
3. **Nền Canvas Cream (`#F3F0EE`) vs Ink Black (`#141413`):**
   - **Tỷ lệ tương phản thực tế:** **`16.5 : 1`** (Vượt chuẩn AAA tuyệt đối).

- **Cần quyết định:**
  - Giữ nguyên quy tắc từ spec: Chữ nhỏ trên nền kem luôn dùng `Ink Black` (`#141413`). Màu cam `Signal Orange` chỉ dùng làm nền nút (chữ trên nút là trắng hoặc kem), icon, vòng tiến độ `OrbitProgressRing`.
  - Nếu bắt buộc dùng chữ cam nhỏ trên nền kem, sẽ đổi thành màu rust sẫm (`#B83A00`, tương phản 5.2:1).

---

### (c) Về Dark Theme trong DESIGN.md

- **Hiện trạng:**
  - File `DESIGN.md` hoàn toàn **KHÔNG có Dark Theme**. Toàn bộ triết lý thiết kế dựa trên trang bìa tạp chí in trên giấy kem ấm (`Canvas Cream #F3F0EE`), thẻ pill trắng và đen mực `Ink Black`.
  - Chỉ có khu vực duy nhất mang màu tối là footer (`#141413`).
- **Khuyến nghị & Cần quyết định:**
  - Trong giai đoạn MVP, bám sát `docs/spec.md`: **Chỉ triển khai Light Theme**.
  - Đưa việc nghiên cứu và phối bảng màu Dark Theme (ví dụ: nền Ink Black `#141413`, card `#262627`, chữ Canvas Cream `#F3F0EE`) sang phiên bản v1.1 hoặc v2.
