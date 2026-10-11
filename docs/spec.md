# Spec app Flutter quản lý thu chi & tiết kiệm cá nhân

Oct 11, 2026 · @Phuc Pham Pro

## 1. Tổng quan

App giúp ghi thu chi trong dưới 10 giây, so sánh dự tính với thực tế, và biến mục tiêu tiết kiệm thành tiến độ nhìn thấy được mỗi ngày để giữ động lực.

**Giả định mặc định** (sửa nếu không đúng): một người dùng, tiền VND, tiếng Việt, Android + iOS, ưu tiên offline, múi giờ Asia/Ho\_Chi\_Minh.

**Vấn đề app giải quyết**

- Ghi chép thu chi hay bị bỏ dở vì nhập quá nhiều bước.
- Biết đã chi bao nhiêu nhưng không biết so với kế hoạch là đúng hay lệch.
- Mục tiêu tiết kiệm nằm trong đầu, không có tiến độ nên dễ bỏ giữa chừng.

**Nguyên tắc sản phẩm**

- Nhập nhanh trước, chi tiết sau: số tiền + danh mục là đủ để lưu.
- Dự tính và thực tế luôn đặt cạnh nhau, ở mọi màn hình có số tiền.
- Tiến độ phải nhìn thấy: vòng tiến độ, cột mốc, số ngày còn lại.
- Ngôn ngữ trung tính. Vượt ngân sách là thông tin để điều chỉnh, không phải lỗi.

**Phạm vi MVP**

| Có trong MVP | Để sau (v1.1 trở đi) |
| --- | --- |
| Đăng nhập, ví, danh mục | Giao dịch định kỳ |
| Ghi thu / chi / chuyển ví | Xuất CSV, sao lưu |
| Ngân sách dự tính theo tháng, so sánh thực tế | Đa tiền tệ |
| Mục tiêu tiết kiệm, tiến độ, cột mốc, streak | Chia sẻ ví với người thân |
| Báo cáo tháng cơ bản | Dark mode, widget màn hình chính |
| Nhắc ghi chép hằng ngày | Quét hóa đơn, đọc SMS ngân hàng |

## 2. Design system (Mastercard)

Mọi màu, font, bo góc, khoảng cách phải lấy từ file `DESIGN.md` của getdesign, không tự chọn. Chạy ở thư mục gốc project Flutter:

```bash
npx getdesign@latest add mastercard
```

Lệnh này ghi `./DESIGN.md` ở thư mục gốc (thêm `--out ./docs/design.md` để đổi chỗ, `--force` để ghi đè). Theo mô tả của getdesign, đây là phân tích độc lập các mẫu thiết kế công khai của Mastercard, không phải design system chính thức: nền kem ấm, bo góc pill rất lớn, ảnh tròn, các cung quỹ đạo màu cam. Dùng làm cảm hứng thị giác, không dùng logo hay tài sản thương hiệu của Mastercard trong app.

**Quy tắc cho người code (hoặc coding agent)**

- Đọc `DESIGN.md` trước khi viết bất kỳ UI nào.
- Chuyển token thành một file duy nhất `lib/core/theme/app_tokens.dart` + `app_theme.dart`. Widget không được ghi cứng mã màu hay số bo góc.
- Nếu cần màu ngoài `DESIGN.md` (ví dụ xanh cho khoản thu), thêm token semantic riêng và ghi chú là bổ sung.

**Map ý tưởng Mastercard sang Flutter**

| Đặc trưng trong DESIGN.md | Dùng trong app | Flutter |
| --- | --- | --- |
| Nền kem ấm | Nền mọi màn hình | `scaffoldBackgroundColor`, `ColorScheme.surface` |
| Màu cam nhấn | Nút chính, vòng tiến độ, mục đang chọn | `ColorScheme.primary` |
| Bo góc pill rất lớn | Nút, chip lọc, ô nhập, thanh chọn Chi/Thu | `StadiumBorder` hoặc `BorderRadius.circular(999)` |
| Hình tròn | Icon danh mục, avatar, nút `+` | `CircleAvatar`, `Container(shape: BoxShape.circle)` |
| Cung quỹ đạo cam | Vòng tiến độ mục tiêu tiết kiệm | widget tự vẽ `OrbitProgressRing` (`CustomPainter`) |
| Ít đổ bóng, nhiều khoảng trắng | Card phẳng, phân tách bằng khoảng trống | `elevation: 0`, padding lớn |

**Component dùng chung** (đặt trong `core/widgets`)

- `PillButton`: primary (cam), secondary (viền), text.
- `PillChip`: lọc và chọn danh mục.
- `CategoryAvatar`: icon trong vòng tròn, màu theo danh mục.
- `AmountText`: hiển thị tiền VND, số tabular để các hàng thẳng cột, thu / chi khác màu và có dấu +/−.
- `OrbitProgressRing`: vòng nền mờ + cung cam chạy theo phần trăm, đầu cung có chấm tròn như một hành tinh trên quỹ đạo. Animation 600 ms khi mở màn hình và khi giá trị đổi.
- `BudgetBar`: thanh dự tính vs thực tế, 3 trạng thái màu (bình thường, từ 80%, vượt 100%).

**Cần kiểm tra khi nhận `DESIGN.md`**

- Font có hỗ trợ dấu tiếng Việt đầy đủ không. Nếu không, chọn font fallback gần nhất và ghi lại.
- Độ tương phản chữ cam trên nền kem. Nếu dưới 4.5:1 thì chỉ dùng cam cho nút, vòng, icon, còn chữ nhỏ dùng màu mực.
- File chỉ có light theme thì MVP chỉ làm light, dark mode để sau.

## 3. UI và màn hình

**Điều hướng:** thanh dưới 4 mục (Tổng quan, Giao dịch, Ngân sách, Tiết kiệm) với nút `+` tròn cam nằm giữa để ghi nhanh từ bất kỳ đâu. Báo cáo mở từ Tổng quan, Cài đặt mở bằng avatar góc trên. Dùng `go_router` với `StatefulShellRoute` để mỗi tab giữ trạng thái riêng.

| Màn hình | Thành phần chính | Hành vi |
| --- | --- | --- |
| Onboarding | 3 slide giới thiệu, đăng nhập (Google / Apple / email), tạo ví đầu tiên + số dư ban đầu, chọn ngày bắt đầu tháng (ngày nhận lương) | Bỏ qua được slide, bắt buộc có 1 ví để vào app |
| Tổng quan | Lời chào + avatar; thẻ lớn "Còn có thể chi" của tháng kèm số tiền chi được mỗi ngày; hàng Thu / Chi / Dư thực tế; khối dự tính vs thực tế (2 thanh); thẻ mục tiêu nổi bật với `OrbitProgressRing`; streak; 5 giao dịch gần nhất; câu động lực theo tình trạng | Chạm thẻ nào mở màn hình tương ứng; kéo xuống để làm mới; đổi tháng bằng mũi tên ở đầu trang |
| Thêm giao dịch | Thanh chọn pill Chi / Thu / Chuyển ví / Gửi tiết kiệm; số tiền cỡ lớn + bàn phím số tự vẽ (có nút 000); lưới danh mục tròn; chọn ví; ngày (mặc định hôm nay); ghi chú | Lưu = `Lưu` hoặc `Lưu và thêm tiếp`; nhớ danh mục + ví dùng gần nhất; chọn "Gửi tiết kiệm" thì hiện chọn mục tiêu |
| Danh sách giao dịch | Chip lọc (tháng, loại, danh mục, ví), ô tìm theo ghi chú, nhóm theo ngày kèm tổng ngày | Vuốt trái xóa, vuốt phải sửa; xóa có snackbar Hoàn tác 5 giây; tải thêm 30 dòng mỗi lần cuộn |
| Ngân sách | Chọn tháng; 2 tab Dự tính thu / Dự tính chi; mỗi danh mục một hàng: dự tính, thực tế, còn lại + `BudgetBar`; tổng kết Dư dự tính vs Dư thực tế | Chạm số dự tính để sửa tại chỗ; nút `Sao chép từ tháng trước`; chạm hàng mở danh sách giao dịch của danh mục |
| Tiết kiệm (danh sách) | Thẻ mỗi mục tiêu: tên, `OrbitProgressRing`, đã gom / mục tiêu, số ngày còn lại, nhãn Đúng tiến độ / Chậm | Nút `Tạo mục tiêu`; mục tiêu đã hoàn thành xếp ở nhóm riêng bên dưới |
| Chi tiết mục tiêu | Vòng tiến độ lớn; số cần gom mỗi tháng; 4 cột mốc 25 / 50 / 75 / 100%; lịch sử các lần gửi | Nút `Gửi thêm`; đạt cột mốc thì có animation chúc mừng + lưu lại ngày đạt |
| Tạo / sửa mục tiêu | Tên, số tiền mục tiêu, hạn (ngày), số đã có sẵn, icon + màu | Hiện ngay bản xem trước "cần gom X mỗi tháng" khi nhập |
| Báo cáo | Chọn tháng / quý / năm; donut chi theo danh mục; đường thu chi 6 hoặc 12 tháng; cột dự tính vs thực tế; top 5 khoản chi lớn nhất | Chạm lát donut lọc danh sách giao dịch tương ứng |
| Cài đặt | Ví, danh mục (thêm, sửa, ẩn, sắp xếp), ngày bắt đầu tháng, giờ nhắc, khóa sinh trắc học, xuất dữ liệu, đăng xuất, xóa tài khoản | Xóa tài khoản phải xác nhận 2 bước |

**Trạng thái dùng chung cho mọi màn hình**

- Đang tải: skeleton cùng hình dạng nội dung, không dùng spinner toàn trang.
- Trống: minh họa nhỏ + một câu + nút hành động (ví dụ "Chưa có giao dịch tháng này, thêm khoản đầu tiên").
- Lỗi: thông báo ngắn + nút Thử lại.
- Offline: dải nhỏ "Đang offline, dữ liệu sẽ đồng bộ khi có mạng"; mọi thao tác ghi vẫn chạy bình thường.
- Tiền vượt ngân sách dùng màu cảnh báo nhẹ và câu trung tính ("Đã dùng 112% ngân sách Ăn uống").

## 4. Chức năng chi tiết

MVP gồm 18 chức năng (4 chức năng còn lại để v1.1), mỗi cái có tiêu chí chấp nhận để test được. Ba loại giao dịch dùng chung một collection: `income`, `expense`, `transfer`, và `saving` (gửi vào mục tiêu).

| Mã | Chức năng | Ưu tiên | Tiêu chí chấp nhận |
| --- | --- | --- | --- |
| AUTH-1 | Đăng nhập Google, Apple (iOS), email + mật khẩu | MVP | Đăng nhập xong vào thẳng Tổng quan; lần mở sau không phải đăng nhập lại |
| WAL-1 | Quản lý ví (tiền mặt, ngân hàng, ví điện tử) | MVP | Mỗi ví có số dư; số dư đổi đúng khi thêm, sửa, xóa giao dịch |
| CAT-1 | Danh mục mặc định + tự tạo | MVP | Có sẵn bộ danh mục chi và thu khi tạo tài khoản; danh mục đã có giao dịch chỉ được ẩn, không xóa cứng |
| TXN-1 | Thêm thu / chi | MVP | Lưu được trong tối đa 4 thao tác (số tiền, danh mục, Lưu); số tiền là số nguyên lớn hơn 0 |
| TXN-2 | Sửa, xóa giao dịch | MVP | Sửa số tiền hoặc ví thì số dư ví, tổng tháng, ngân sách, mục tiêu cập nhật đúng; xóa có Hoàn tác |
| TXN-3 | Chuyển giữa ví | MVP | Không tính vào thu hay chi; tổng số dư các ví không đổi |
| TXN-4 | Tìm, lọc, phân trang | MVP | Lọc kết hợp được nhiều điều kiện; cuộn mượt với 5.000 giao dịch |
| TXN-5 | Giao dịch định kỳ (lương, tiền nhà, gói thuê bao) | v1.1 | Tự sinh giao dịch đúng ngày khi mở app, không sinh trùng |
| BUD-1 | Dự tính chi theo danh mục từng tháng | MVP | Đặt, sửa được; có `Sao chép từ tháng trước` |
| BUD-2 | Dự tính thu từng tháng (lương, thu nhập thêm) | MVP | Có dự tính thu tổng và theo nguồn thu |
| BUD-3 | So sánh dự tính vs thực tế | MVP | Hiện dự tính, thực tế, chênh lệch, phần trăm; cập nhật ngay khi có giao dịch mới |
| BUD-4 | Cảnh báo ngân sách | MVP | Thông báo khi một danh mục chạm 80% và 100%, mỗi mức chỉ báo một lần mỗi tháng |
| SAV-1 | Tạo, sửa, lưu trữ mục tiêu tiết kiệm | MVP | Có tên, số tiền, hạn, icon; hạn phải sau hôm nay |
| SAV-2 | Gửi thêm / rút bớt vào mục tiêu | MVP | Gửi tạo giao dịch `saving` trừ ví; rút tạo giao dịch ngược lại; đã gom không âm |
| SAV-3 | Gợi ý mức gom mỗi tháng và trạng thái tiến độ | MVP | Công thức ở mục 5; đổi ngay khi sửa hạn hoặc số tiền |
| SAV-4 | Cột mốc và chúc mừng | MVP | Đạt 25 / 50 / 75 / 100% hiện animation đúng một lần mỗi cột mốc |
| SAV-5 | Tự gom phần dư cuối tháng vào mục tiêu | v1.1 | Chỉ gợi ý, người dùng bấm xác nhận mới tạo giao dịch |
| MOT-1 | Streak ghi chép + "ngày không chi" | MVP | Streak tăng khi có ghi chép hoặc bấm "hôm nay không chi"; hoạt động cả khi offline |
| RPT-1 | Báo cáo tháng | MVP | Donut, đường thu chi, cột dự tính vs thực tế khớp với danh sách giao dịch |
| NOT-1 | Nhắc ghi chép hằng ngày | MVP | Thông báo cục bộ, giờ mặc định 21:00, tắt hoặc đổi giờ trong Cài đặt |
| SEC-1 | Khóa app bằng vân tay / Face ID | v1.1 | Mở lại app sau nền hơn 1 phút thì hỏi xác thực |
| DATA-1 | Xuất CSV, xóa tài khoản | v1.1 | Xuất đủ giao dịch của khoảng thời gian chọn; xóa tài khoản xóa hết dữ liệu trên Firestore |

## 5. Logic nghiệp vụ

Toàn bộ công thức viết thành hàm thuần trong `domain/` (không phụ thuộc Flutter hay Firestore) để unit test dễ.

**Quy ước dữ liệu**

- Tiền là số nguyên VND, không dùng số thực. Số tiền luôn dương, chiều thu hay chi do `type` quyết định.
- Tháng tính theo ngày bắt đầu tháng của người dùng (`monthStartDay`, 1 đến 28). Mỗi giao dịch lưu sẵn `monthKey` dạng `2026-10` tính theo quy tắc này.
- Giờ lưu UTC, hiển thị theo Asia/Ho\_Chi\_Minh.

**Giao dịch ảnh hưởng thế nào**

| Loại | Số dư ví | Tính vào Thu | Tính vào Chi | Tính vào Đã tiết kiệm |
| --- | --- | --- | --- | --- |
| income | cộng | có | không | không |
| expense | trừ | không | có | không |
| transfer | trừ ví nguồn, cộng ví đích | không | không | không |
| saving (gửi) | trừ | không | không | có, cộng vào mục tiêu |

Tiền đã gửi tiết kiệm không bị coi là "chi tiêu", nếu không người dùng sẽ thấy mình "chi nhiều" đúng lúc đang làm điều tốt. Rút từ mục tiêu về ví thì ngược lại.

**Công thức tháng**

```latex
\text{Dư thực tế} = \sum \text{Thu} - \sum \text{Chi}
\text{Dư dự tính} = \sum \text{Dự tính thu} - \sum \text{Dự tính chi}
\text{Chênh lệch} = \text{Dư thực tế} - \text{Dư dự tính}
\text{Mức dùng ngân sách} = \frac{\text{Chi thực tế của danh mục}}{\text{Dự tính chi của danh mục}}
\text{Chi được mỗi ngày} = \frac{\text{Dự tính chi tổng} - \text{Đã chi}}{\text{Số ngày còn lại trong tháng}}
```

Thẻ "Còn có thể chi" ở Tổng quan = Dự tính chi tổng − Đã chi. Nếu chưa đặt dự tính chi thì dùng Dự tính thu − Đã chi − phần cần gom tiết kiệm của tháng.

**Công thức mục tiêu tiết kiệm**

```latex
\text{Tiến độ} = \frac{\text{Đã gom}}{\text{Mục tiêu}}
\text{Cần gom mỗi tháng} = \left\lceil \frac{\text{Mục tiêu} - \text{Đã gom}}{\text{Số tháng còn lại}} \right\rceil
```

- Số tháng còn lại = số ngày đến hạn chia 30, làm tròn lên, tối thiểu 1.
- Làm tròn "cần gom mỗi tháng" lên bội số 1.000 đồng cho dễ nhớ.
- Trạng thái: **Đúng tiến độ** nếu Tiến độ ≥ tỷ lệ thời gian đã trôi qua (từ ngày tạo đến hạn), ngược lại **Chậm**. Quá hạn mà chưa đủ thì hiện **Quá hạn** và gợi ý dời hạn.
- Đã gom ≥ Mục tiêu thì chuyển trạng thái `completed`, lưu `completedAt`.

**Động lực**

- Streak: số ngày liên tiếp có ít nhất một ghi chép hoặc bấm "hôm nay không chi". Bỏ lỡ một ngày thì về 0, nhưng luôn hiện kỷ lục dài nhất để không gây nản.
- Cột mốc 25 / 50 / 75 / 100% mỗi mục tiêu, kèm câu nói theo tình trạng ("Còn 3 tháng, bạn đã đi được hơn nửa chặng").
- Tổng kết cuối tháng: dư thực tế so với dự tính, mục tiêu nào tiến thêm bao nhiêu phần trăm, một gợi ý cho tháng sau.
- Không dùng cơ chế gây áp lực hay xấu hổ khi vượt ngân sách.

## 6. Thiết kế Firestore

Mọi dữ liệu nằm dưới `users/{uid}` để rule đơn giản (mỗi người chỉ đọc ghi vùng của mình) và dễ xóa sạch khi xóa tài khoản. Giao dịch là nguồn sự thật duy nhất; số dư ví, tổng tháng, tiền đã gom của mục tiêu là số tổng hợp được cập nhật cùng lúc để Tổng quan chỉ cần đọc vài document.

```text
users/{uid}                         hồ sơ + cài đặt
  ├─ wallets/{walletId}             ví, có balance
  ├─ categories/{categoryId}        danh mục thu / chi
  ├─ transactions/{txId}            thu, chi, chuyển ví, gửi tiết kiệm
  ├─ budgets/{monthKey_categoryId}  dự tính của một danh mục trong một tháng
  ├─ monthSummaries/{monthKey}      tổng hợp tháng (thu, chi, tiết kiệm, theo danh mục)
  ├─ goals/{goalId}                 mục tiêu tiết kiệm
  ├─ recurring/{recurringId}        giao dịch định kỳ (v1.1)
  └─ stats/streak                   streak ghi chép
```

**Các collection**

| Collection | Trường chính | Ghi chú |
| --- | --- | --- |
| `users/{uid}` | `displayName`, `currency` (`VND`), `monthStartDay`, `reminderTime`, `createdAt`, `schemaVersion` | `schemaVersion` để migrate sau này |
| `wallets` | `name`, `type` (`cash` / `bank` / `ewallet`), `balance`, `initialBalance`, `archived`, `order` | `balance` đổi bằng `FieldValue.increment` |
| `categories` | `name`, `type` (`income` / `expense`), `icon`, `colorToken`, `order`, `archived` | Có giao dịch rồi thì chỉ `archived: true` |
| `transactions` | `type`, `amount`, `walletId`, `toWalletId?`, `categoryId?`, `goalId?`, `note`, `date`, `monthKey`, `recurringId?`, `createdAt`, `updatedAt` | `amount` luôn là số nguyên dương |
| `budgets` | `monthKey`, `categoryId`, `type`, `plannedAmount` | Doc id `2026-10_{categoryId}` nên sửa là ghi đè, không tạo trùng |
| `monthSummaries` | `totalIncome`, `totalExpense`, `totalSaved`, `byCategory` (map `categoryId` → số tiền), `loggedDays` (mảng ngày có ghi chép), `updatedAt` | Doc id = `monthKey` |
| `goals` | `name`, `targetAmount`, `savedAmount`, `startDate`, `targetDate`, `icon`, `colorToken`, `status` (`active` / `completed` / `archived`), `milestonesReached` (mảng 25, 50...), `completedAt?` | `savedAmount` là số tổng hợp từ giao dịch `saving` |
| `stats/streak` | `currentStreak`, `longestStreak`, `lastLogDate` | Chỉ để cache, tính lại được từ `loggedDays` |

**Ví dụ document giao dịch gửi tiết kiệm**

```json
{
  "type": "saving",
  "amount": 2000000,
  "walletId": "w_bank_vcb",
  "goalId": "g_laptop",
  "note": "Gom tháng 10",
  "date": "2026-10-11T03:20:00Z",
  "monthKey": "2026-10",
  "createdAt": "2026-10-11T03:20:05Z",
  "updatedAt": "2026-10-11T03:20:05Z"
}
```

**Ghi một giao dịch = một `WriteBatch` duy nhất** gồm: doc giao dịch, `wallets.balance` (`increment` ±), `monthSummaries` (`totalExpense` / `totalIncome` / `totalSaved` và `byCategory.{id}` bằng `increment`, `loggedDays` bằng `arrayUnion`), và `goals.savedAmount` nếu có `goalId`.

- Dùng `WriteBatch` chứ không dùng `runTransaction`, vì batch vẫn xếp hàng ghi được khi offline, còn transaction cần có mạng.
- `increment` cộng được từ nhiều thiết bị mà không ghi đè nhau.
- Sửa giao dịch = trừ ngược tác động của bản cũ + cộng tác động của bản mới trong cùng batch. Xóa = chỉ trừ ngược.
- Streak tính phía client từ `loggedDays` của tháng này và tháng trước. Xóa giao dịch không gỡ ngày khỏi `loggedDays` (chấp nhận được).
- Cột mốc: sau khi ghi, client so `savedAmount / targetAmount` với `milestonesReached`; nếu có mốc mới thì `arrayUnion` mốc đó và hiện chúc mừng.
- Mỗi batch tối đa khoảng 6 thao tác, xa mức giới hạn 500.

Firestore có truy vấn tổng hợp `sum()`, nhưng Tổng quan mở rất thường xuyên nên đọc một doc `monthSummaries` rẻ và nhanh hơn nhiều so với cộng hàng trăm giao dịch mỗi lần mở.

**Chỉ mục (index) composite cần tạo**

| Collection | Trường | Dùng cho |
| --- | --- | --- |
| `transactions` | `monthKey` ↑, `date` ↓ | Danh sách giao dịch của tháng |
| `transactions` | `monthKey` ↑, `type` ↑, `date` ↓ | Lọc theo loại |
| `transactions` | `categoryId` ↑, `date` ↓ | Giao dịch của một danh mục |
| `transactions` | `walletId` ↑, `date` ↓ | Giao dịch của một ví |
| `transactions` | `goalId` ↑, `date` ↓ | Lịch sử gửi của một mục tiêu |
| `budgets` | `monthKey` ↑, `type` ↑ | Danh sách dự tính của tháng |

Phân trang bằng `limit(30)` + `startAfterDocument`. Tìm theo ghi chú: MVP lọc phía client trên tháng đang xem, vì Firestore không có tìm kiếm toàn văn.

## 7. Bảo mật, Auth và offline

**Auth:** Firebase Authentication với Google, Apple (iOS thường bắt buộc nếu app đã có đăng nhập mạng xã hội khác) và email + mật khẩu. Tùy chọn v1.1: cho dùng thử bằng tài khoản ẩn danh rồi liên kết sang tài khoản thật để giảm rào cản lúc đầu.

**Security Rules** (khởi điểm, siết thêm khi có schema chốt). Lưu ý các `match` chồng nhau được cộng theo kiểu OR, nên `transactions` phải nằm ngoài danh sách dùng chung để rule kiểm tra dữ liệu không bị vượt qua:

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isOwner(uid) {
      return request.auth != null && request.auth.uid == uid;
    }

    match /users/{uid} {
      allow read, write: if isOwner(uid);

      match /transactions/{txId} {
        allow read, delete: if isOwner(uid);
        allow create, update: if isOwner(uid)
          && request.resource.data.amount is int
          && request.resource.data.amount > 0
          && request.resource.data.type in ['income', 'expense', 'transfer', 'saving']
          && request.resource.data.monthKey is string;
      }

      match /{sub}/{docId} {
        allow read, write: if isOwner(uid)
          && sub in ['wallets', 'categories', 'budgets', 'monthSummaries',
                     'goals', 'recurring', 'stats'];
      }
    }
  }
}
```

- Số tổng hợp (`balance`, `monthSummaries`, `savedAmount`) do client ghi, nên người dùng có thể tự sửa số của chính mình. Với app cá nhân điều này chấp nhận được. Nếu sau này cần tin cậy hơn thì chuyển phần tổng hợp sang Cloud Functions (yêu cầu gói Blaze).
- Kiểm thử rule bằng Firebase Emulator Suite: người lạ không đọc được dữ liệu người khác, `amount` âm hoặc là số thực bị từ chối.
- Bật **App Check** (Play Integrity cho Android, App Attest cho iOS) để chặn client giả mạo gọi thẳng vào Firestore.
- Dùng hai Firebase project tách biệt `dev` và `prod`, cấu hình bằng `flutterfire configure`.

**Offline**

- Cache offline của Firestore bật sẵn trên Android và iOS. Mọi thao tác ghi được xếp hàng và tự đồng bộ khi có mạng.
- Dùng `snapshots(includeMetadataChanges: true)` để biết giao dịch nào đang chờ đồng bộ (`hasPendingWrites`) và hiện icon đám mây nhỏ cạnh dòng đó.
- Xung đột: ghi cuối thắng ở cấp field. Các số tổng hợp dùng `increment` nên cộng đúng dù nhiều thiết bị cùng ghi.
- Khi ghi `byCategory` lần đầu trong tháng, doc `monthSummaries` chưa tồn tại: dùng `set` với `merge: true` thay vì `update`.

**Quyền riêng tư và an toàn dữ liệu**

- Không lưu số tài khoản hay thẻ ngân hàng. Ví chỉ có tên và số dư người dùng tự nhập.
- Khóa app bằng sinh trắc học qua `local_auth` (v1.1).
- Xóa tài khoản: xóa các collection con theo từng đợt `WriteBatch` rồi xóa user Firebase Auth. Cần đăng nhập lại gần đây (re-auth) trước khi xóa.
- Nhắc ghi chép chạy bằng thông báo cục bộ, không cần gửi dữ liệu lên server.

## 8. Kiến trúc Flutter

Chia theo tính năng (feature-first), mỗi tính năng ba lớp: giao diện, logic ứng dụng (Riverpod), domain thuần. Widget không bao giờ gọi Firestore trực tiếp, chỉ đi qua repository.

```text
lib/
  main.dart
  app.dart                      MaterialApp.router + theme
  core/
    theme/                      app_tokens.dart, app_theme.dart (từ DESIGN.md)
    router/                     app_router.dart (go_router)
    utils/                      money_format.dart, month_key.dart, date_utils.dart
    widgets/                    pill_button, pill_chip, category_avatar,
                                amount_text, orbit_progress_ring, budget_bar
  data/
    firestore_paths.dart        tên collection/doc ở một chỗ
    models/                     freezed + json_serializable
    repositories/               transaction_repo, wallet_repo, budget_repo,
                                goal_repo, summary_repo (interface + impl Firestore)
  features/
    auth/        presentation/ application/ domain/
    home/
    transactions/
    budgets/
    savings/
    reports/
    settings/
```

**Package đề xuất** (chốt phiên bản bằng `flutter pub add` lúc khởi tạo)

| Nhóm | Package | Dùng cho |
| --- | --- | --- |
| Firebase | `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_app_check` | Nền tảng, đăng nhập, dữ liệu, chống lạm dụng |
| Đăng nhập | `google_sign_in`, `sign_in_with_apple` | Social login |
| State | `flutter_riverpod` | Provider, stream từ Firestore, tiêm repository |
| Điều hướng | `go_router` | Route + tab giữ trạng thái |
| Model | `freezed`, `json_serializable`, `build_runner` | Model bất biến + chuyển JSON |
| Định dạng | `intl` | Tiền VND, ngày giờ `vi_VN` |
| Biểu đồ | `fl_chart` | Donut, đường, cột |
| Thông báo | `flutter_local_notifications` | Nhắc ghi chép, cảnh báo ngân sách |
| Bảo mật | `local_auth` | Vân tay, Face ID |
| Test | `fake_cloud_firestore`, `mocktail` | Test repository và logic |

**Luồng dữ liệu:** UI → `Notifier` / `StreamProvider` → repository → Firestore. Tổng quan nghe `snapshots()` của `monthSummaries/{monthKey}`, danh sách ví và 5 giao dịch gần nhất, tổng cộng khoảng 4 listener.

**Kiểm thử**

- Unit test cho mọi hàm công thức ở mục 5 (ca biên: hạn là hôm nay, đã gom vượt mục tiêu, dự tính bằng 0 thì không chia cho 0).
- Test repository bằng `fake_cloud_firestore`: thêm, sửa, xóa giao dịch thì số dư ví và `monthSummaries` khớp với tổng tính tay.
- Test Security Rules bằng Firebase Emulator.
- Golden test cho `OrbitProgressRing` ở 0%, 25%, 100% và `BudgetBar` ở 3 trạng thái.
- Widget test luồng quan trọng nhất: mở app → thêm khoản chi → thấy số liệu Tổng quan đổi.

## 9. Roadmap và câu hỏi cần chốt

Làm theo thứ tự dưới đây, mỗi giai đoạn dùng được ngay rồi mới sang giai đoạn sau.

1. **Nền tảng:** tạo project Flutter, chạy `npx getdesign@latest add mastercard`, dựng `app_tokens.dart` + theme, các widget dùng chung (`PillButton`, `CategoryAvatar`, `OrbitProgressRing`), Firebase `dev`, đăng nhập. Xong khi: đăng nhập được và thấy màn hình mẫu đúng phong cách DESIGN.md.
2. **Lõi thu chi:** ví, danh mục, thêm / sửa / xóa giao dịch bằng `WriteBatch`, danh sách giao dịch, Security Rules + test emulator. Xong khi: số dư ví và `monthSummaries` luôn khớp tổng tính tay.
3. **Dự tính vs thực tế:** màn Ngân sách, `BudgetBar`, thẻ so sánh ở Tổng quan, cảnh báo 80% / 100%. Xong khi: đổi một khoản chi thì thanh ngân sách đổi ngay.
4. **Tiết kiệm và động lực:** mục tiêu, gửi / rút, tiến độ, cột mốc, streak, nhắc hằng ngày. Xong khi: tạo mục tiêu, gửi tiền, thấy vòng tiến độ chạy và nhận chúc mừng ở mốc đầu tiên.
5. **Báo cáo và hoàn thiện:** báo cáo tháng, trạng thái trống / lỗi / offline, App Check, kiểm tra tương phản và cỡ chữ lớn, thử trên máy thật Android và iOS. Xong khi: dùng thật một tháng không lệch số.
6. **v1.1:** giao dịch định kỳ, tự gom phần dư, khóa sinh trắc học, xuất CSV, xóa tài khoản đầy đủ.
7. **v2 (nếu cần):** đa tiền tệ, chia sẻ ví, dark mode, widget màn hình chính.

**Cần bạn chốt trước khi code**

- [ ] Tên app (để đặt tên package, bundle id và màn onboarding).
- [ ] Chạy cả Android và iOS hay chỉ Android trước (ảnh hưởng đăng nhập Apple và App Check).
- [ ] Ngày bắt đầu tháng mặc định là 1 hay ngày nhận lương.
- [ ] "Gửi tiết kiệm" có trừ khỏi số dư ví hay chỉ là ghi nhận trên mục tiêu (tiền thật nằm ở tài khoản tiết kiệm riêng). Spec này đang chọn cách trừ khỏi ví.
- [ ] Có cần chia sẻ ví với vợ/chồng hoặc người thân không (nếu có, schema `users/{uid}` phải đổi sang ví dùng chung).
- [ ] Dark mode có nằm trong kế hoạch gần không.
- [ ] Font trong `DESIGN.md` có hỗ trợ tiếng Việt không (xem sau khi chạy lệnh cài).
