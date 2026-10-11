# Quy trình Ghi Giao dịch Chuẩn với WriteBatch

Tài liệu hướng dẫn bắt buộc cho mọi thao tác thêm, sửa, xóa giao dịch trong ứng dụng Quỹ Đạo.

---

## 1. Nguyên tắc Bất biến

1. **Một thao tác giao dịch = MỘT `WriteBatch` duy nhất.** Tuyệt đối không tách thành nhiều lệnh ghi rời rạc.
2. **Không dùng `runTransaction`** vì không hoạt động khi offline. Dùng `WriteBatch` kết hợp `FieldValue.increment` để đảm bảo hỗ trợ offline và không bị xung đột khi nhiều thiết bị cùng ghi.
3. **`monthSummaries` luôn dùng `set` với `SetOptions(merge: true)`** để tự động tạo mới document tổng kết nếu người dùng ghi giao dịch đầu tiên của tháng.

---

## 2. Đoạn Mã Mẫu Chuẩn: Thêm Khoản Chi Tiêu (`expense`)

Dưới đây là đoạn mã Dart chuẩn mực cần tuân thủ trong `TransactionRepository`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quy_dao/data/firestore_paths.dart';

Future<void> addExpenseTransaction({
  required FirebaseFirestore firestore,
  required String uid,
  required int amount, // Số nguyên VND dương
  required String walletId,
  required String categoryId,
  required String monthKey, // Dạng "YYYY-MM" sinh từ monthKeyFor
  required DateTime date,
  String? note,
}) async {
  assert(amount > 0, 'Số tiền chi phải là số nguyên dương');

  final batch = firestore.batch();
  final now = DateTime.now().toUtc();

  // 1. Tạo document giao dịch mới
  final txRef = firestore.collection(FirestorePaths.transactionsCollection(uid)).doc();
  batch.set(txRef, {
    'type': 'expense',
    'amount': amount,
    'walletId': walletId,
    'categoryId': categoryId,
    'note': note ?? '',
    'date': date.toUtc().toIso8601String(),
    'monthKey': monthKey,
    'createdAt': now.toIso8601String(),
    'updatedAt': now.toIso8601String(),
  });

  // 2. Trừ số dư ví bằng FieldValue.increment
  final walletRef = firestore.doc(FirestorePaths.walletDoc(uid, walletId));
  batch.update(walletRef, {
    'balance': FieldValue.increment(-amount),
  });

  // 3. Cập nhật monthSummaries bằng set(merge: true)
  final summaryRef = firestore.doc(FirestorePaths.monthSummaryDoc(uid, monthKey));
  final dayString = date.toIso8601String().substring(0, 10); // "YYYY-MM-DD"

  batch.set(
    summaryRef,
    {
      'totalExpense': FieldValue.increment(amount),
      'byCategory': {
        categoryId: FieldValue.increment(amount),
      },
      'loggedDays': FieldValue.arrayUnion([dayString]),
      'updatedAt': now.toIso8601String(),
    },
    SetOptions(merge: true),
  );

  // 4. Thực thi batch nguyên tử
  await batch.commit();
}
```

---

## 3. Quy trình khi Sửa hoặc Xóa Giao dịch

### Sửa Giao dịch (Edit):
Trong cùng một `WriteBatch`:
1. Trừ ngược tác động của bản ghi cũ: `balance = FieldValue.increment(oldAmount)`, `totalExpense = FieldValue.increment(-oldAmount)`, `byCategory.{oldCat} = FieldValue.increment(-oldAmount)`.
2. Cộng tác động của bản ghi mới: `balance = FieldValue.increment(-newAmount)`, `totalExpense = FieldValue.increment(newAmount)`, `byCategory.{newCat} = FieldValue.increment(newAmount)`.
3. Cập nhật document giao dịch `txRef.update(...)`.

### Xóa Giao dịch (Delete):
Trong cùng một `WriteBatch`:
1. Xóa doc giao dịch `batch.delete(txRef)`.
2. Trừ ngược số dư và tổng hợp tháng: hoàn lại tiền vào ví, trừ khỏi `totalExpense` và `byCategory`.
3. **Không cần** gỡ ngày khỏi `loggedDays` (đã quy định chấp nhận được tại spec mục 6).
