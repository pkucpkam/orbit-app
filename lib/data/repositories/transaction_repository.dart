/// Repository giao dịch (Transaction) — trung tâm của toàn bộ nghiệp vụ.
///
/// Tuân thủ Quy tắc #4 (spec.md):
/// Mỗi thao tác thêm/sửa/xóa giao dịch là MỘT WriteBatch duy nhất
/// cập nhật đồng thời: doc giao dịch + wallets.balance + monthSummaries
/// + goals.savedAmount (nếu có goalId).
///
/// Dùng WriteBatch (không dùng runTransaction) để hỗ trợ offline.
library;

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quy_dao/data/firestore_paths.dart';
import 'package:quy_dao/data/models/transaction.dart';
import 'package:quy_dao/data/repositories/app_providers.dart';

// ---------------------------------------------------------------------------
// Interface
// ---------------------------------------------------------------------------

abstract interface class TransactionRepository {
  /// Stream giao dịch của một tháng, sắp xếp theo ngày giảm dần.
  Stream<List<Transaction>> watchByMonth(String uid, String monthKey);

  /// Stream giao dịch theo loại trong một tháng.
  Stream<List<Transaction>> watchByMonthAndType(
    String uid,
    String monthKey,
    String type,
  );

  /// Stream giao dịch của một danh mục, phân trang (limit + startAfter).
  Stream<List<Transaction>> watchByCategory(
    String uid,
    String categoryId, {
    DocumentSnapshot? startAfter,
    int limit = 30,
  });

  /// Stream giao dịch của một mục tiêu tiết kiệm.
  Stream<List<Transaction>> watchByGoal(
    String uid,
    String goalId, {
    DocumentSnapshot? startAfter,
    int limit = 30,
  });

  /// Thêm giao dịch mới (1 WriteBatch: tx + balance + monthSummary + goalAmount).
  Future<String> addTransaction(String uid, Transaction tx);

  /// Sửa giao dịch (1 WriteBatch: trừ ngược cũ + cộng mới).
  Future<void> updateTransaction(
    String uid,
    Transaction oldTx,
    Transaction newTx,
  );

  /// Xóa giao dịch (1 WriteBatch: trừ ngược tác động cũ).
  Future<void> deleteTransaction(String uid, Transaction tx);

  /// Lấy 5 giao dịch gần nhất (dùng cho màn Tổng quan).
  Future<List<Transaction>> getRecent(String uid, {int limit = 5});
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Transaction _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  // Firestore trả về Timestamp → chuyển sang DateTime
  final json = <String, dynamic>{...data, 'id': doc.id};
  for (final key in ['date', 'createdAt', 'updatedAt']) {
    if (json[key] is Timestamp) {
      json[key] = (json[key] as Timestamp).toDate().toIso8601String();
    }
  }
  return Transaction.fromJson(json);
}

Map<String, dynamic> _toFirestore(Transaction tx) => {
  'type': tx.type,
  'amount': tx.amount,
  'walletId': tx.walletId,
  if (tx.toWalletId != null) 'toWalletId': tx.toWalletId,
  if (tx.categoryId != null) 'categoryId': tx.categoryId,
  if (tx.goalId != null) 'goalId': tx.goalId,
  'note': tx.note,
  'date': Timestamp.fromDate(tx.date),
  'monthKey': tx.monthKey,
  if (tx.recurringId != null) 'recurringId': tx.recurringId,
  'createdAt': tx.createdAt != null
      ? Timestamp.fromDate(tx.createdAt!)
      : FieldValue.serverTimestamp(),
  'updatedAt': FieldValue.serverTimestamp(),
};

// ---------------------------------------------------------------------------
// WriteBatch helper: áp dụng tác động của 1 giao dịch lên batch
// ---------------------------------------------------------------------------

/// Thêm các thao tác INCREMENT vào batch cho giao dịch [tx].
/// [sign] = +1 khi thêm/sửa mới, -1 khi xóa/đảo ngược.
void _applyTxEffect(
  WriteBatch batch,
  FirebaseFirestore firestore,
  String uid,
  Transaction tx,
  int sign,
) {
  final walletRef = firestore
      .collection(FirestorePaths.walletsCollection(uid))
      .doc(tx.walletId);
  final summaryRef = firestore
      .collection(FirestorePaths.monthSummariesCollection(uid))
      .doc(tx.monthKey);
  final dateStr = tx.date.toIso8601String().substring(0, 10); // "2026-10-11"

  if (tx.type == 'income') {
    // Cộng vào balance ví
    batch.update(walletRef, {
      'balance': FieldValue.increment(sign * tx.amount),
    });
    // Cập nhật monthSummaries
    batch.set(summaryRef, {
      'totalIncome': FieldValue.increment(sign * tx.amount),
      if (tx.categoryId != null)
        'byCategory.${tx.categoryId}': FieldValue.increment(sign * tx.amount),
      'loggedDays': FieldValue.arrayUnion([dateStr]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  } else if (tx.type == 'expense') {
    // Trừ balance ví
    batch.update(walletRef, {
      'balance': FieldValue.increment(-sign * tx.amount),
    });
    // Cập nhật monthSummaries
    batch.set(summaryRef, {
      'totalExpense': FieldValue.increment(sign * tx.amount),
      if (tx.categoryId != null)
        'byCategory.${tx.categoryId}': FieldValue.increment(sign * tx.amount),
      'loggedDays': FieldValue.arrayUnion([dateStr]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  } else if (tx.type == 'transfer') {
    // Trừ ví nguồn, cộng ví đích — không tính vào thu/chi
    batch.update(walletRef, {
      'balance': FieldValue.increment(-sign * tx.amount),
    });
    if (tx.toWalletId != null) {
      final toWalletRef = firestore
          .collection(FirestorePaths.walletsCollection(uid))
          .doc(tx.toWalletId);
      batch.update(toWalletRef, {
        'balance': FieldValue.increment(sign * tx.amount),
      });
    }
    // Vẫn ghi loggedDays để tính streak
    batch.set(summaryRef, {
      'loggedDays': FieldValue.arrayUnion([dateStr]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  } else if (tx.type == 'saving') {
    // Trừ ví — tính vào totalSaved, không tính vào chi tiêu
    batch.update(walletRef, {
      'balance': FieldValue.increment(-sign * tx.amount),
    });
    batch.set(summaryRef, {
      'totalSaved': FieldValue.increment(sign * tx.amount),
      'loggedDays': FieldValue.arrayUnion([dateStr]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    // Cập nhật goals.savedAmount
    if (tx.goalId != null) {
      final goalRef = firestore
          .collection(FirestorePaths.goalsCollection(uid))
          .doc(tx.goalId);
      batch.update(goalRef, {
        'savedAmount': FieldValue.increment(sign * tx.amount),
      });
    }
  } // end else-if saving
}

// ---------------------------------------------------------------------------
// Implementation Firestore
// ---------------------------------------------------------------------------

class FirestoreTransactionRepository implements TransactionRepository {
  FirestoreTransactionRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection(FirestorePaths.transactionsCollection(uid));

  @override
  Stream<List<Transaction>> watchByMonth(String uid, String monthKey) =>
      _col(uid)
          .where('monthKey', isEqualTo: monthKey)
          .orderBy('date', descending: true)
          .snapshots()
          .map((s) => s.docs.map(_fromDoc).toList());

  @override
  Stream<List<Transaction>> watchByMonthAndType(
    String uid,
    String monthKey,
    String type,
  ) => _col(uid)
      .where('monthKey', isEqualTo: monthKey)
      .where('type', isEqualTo: type)
      .orderBy('date', descending: true)
      .snapshots()
      .map((s) => s.docs.map(_fromDoc).toList());

  @override
  Stream<List<Transaction>> watchByCategory(
    String uid,
    String categoryId, {
    DocumentSnapshot? startAfter,
    int limit = 30,
  }) {
    Query<Map<String, dynamic>> q = _col(uid)
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('date', descending: true)
        .limit(limit);
    if (startAfter != null) q = q.startAfterDocument(startAfter);
    return q.snapshots().map((s) => s.docs.map(_fromDoc).toList());
  }

  @override
  Stream<List<Transaction>> watchByGoal(
    String uid,
    String goalId, {
    DocumentSnapshot? startAfter,
    int limit = 30,
  }) {
    Query<Map<String, dynamic>> q = _col(uid)
        .where('goalId', isEqualTo: goalId)
        .orderBy('date', descending: true)
        .limit(limit);
    if (startAfter != null) q = q.startAfterDocument(startAfter);
    return q.snapshots().map((s) => s.docs.map(_fromDoc).toList());
  }

  @override
  Future<String> addTransaction(String uid, Transaction tx) async {
    final batch = _firestore.batch();
    final txRef = _col(uid).doc();

    // 1. Ghi doc giao dịch
    batch.set(txRef, _toFirestore(tx));

    // 2–6. Cập nhật balance, monthSummaries, goals
    _applyTxEffect(batch, _firestore, uid, tx, 1);

    await batch.commit();
    return txRef.id;
  }

  @override
  Future<void> updateTransaction(
    String uid,
    Transaction oldTx,
    Transaction newTx,
  ) async {
    final batch = _firestore.batch();
    final txRef = _col(uid).doc(oldTx.id);

    // 1. Đảo ngược tác động cũ
    _applyTxEffect(batch, _firestore, uid, oldTx, -1);

    // 2. Ghi doc giao dịch mới
    batch.set(txRef, _toFirestore(newTx));

    // 3. Áp dụng tác động mới
    _applyTxEffect(batch, _firestore, uid, newTx, 1);

    await batch.commit();
  }

  @override
  Future<void> deleteTransaction(String uid, Transaction tx) async {
    final batch = _firestore.batch();
    final txRef = _col(uid).doc(tx.id);

    // 1. Xóa doc giao dịch
    batch.delete(txRef);

    // 2. Đảo ngược tác động
    _applyTxEffect(batch, _firestore, uid, tx, -1);

    await batch.commit();
  }

  @override
  Future<List<Transaction>> getRecent(String uid, {int limit = 5}) async {
    final snap = await _col(
      uid,
    ).orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map(_fromDoc).toList();
  }
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => FirestoreTransactionRepository(ref.watch(firestoreProvider)),
  name: 'transactionRepositoryProvider',
);

/// Stream giao dịch tháng hiện tại.
final transactionsStreamProvider = StreamProvider.autoDispose
    .family<List<Transaction>, String>((ref, monthKey) {
      final uid = ref.watch(currentUidProvider);
      if (uid == null) return Stream.value(const []);
      return ref
          .watch(transactionRepositoryProvider)
          .watchByMonth(uid, monthKey);
    }, name: 'transactionsStreamProvider');
