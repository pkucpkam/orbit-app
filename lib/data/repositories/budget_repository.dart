/// Repository ngân sách (Budget) và tổng kết tháng (MonthSummary).
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quy_dao/data/firestore_paths.dart';
import 'package:quy_dao/data/models/budget.dart';
import 'package:quy_dao/data/models/month_summary.dart';
import 'package:quy_dao/data/repositories/app_providers.dart';

// ---------------------------------------------------------------------------
// Budget Repository
// ---------------------------------------------------------------------------

abstract interface class BudgetRepository {
  /// Stream danh sách dự tính của một tháng.
  Stream<List<Budget>> watchByMonth(String uid, String monthKey);

  /// Stream dự tính theo loại (income/expense) trong tháng.
  Stream<List<Budget>> watchByMonthAndType(
    String uid,
    String monthKey,
    String type,
  );

  /// Lưu (tạo hoặc ghi đè) một dự tính. Doc id = {monthKey}_{categoryId}.
  Future<void> saveBudget(String uid, Budget budget);

  /// Sao chép toàn bộ dự tính từ tháng trước sang tháng mới.
  Future<void> copyFromPreviousMonth(
    String uid, {
    required String fromMonthKey,
    required String toMonthKey,
  });

  /// Lấy một dự tính theo khóa ghép {monthKey}_{categoryId}.
  Future<Budget?> getBudget(
    String uid, {
    required String monthKey,
    required String categoryId,
  });

  /// Xóa một dự tính theo khóa ghép {monthKey}_{categoryId}.
  Future<void> deleteBudget(
    String uid, {
    required String monthKey,
    required String categoryId,
  });
}

extension _BudgetJson on Budget {
  Map<String, dynamic> toFirestore() => {
    'monthKey': monthKey,
    'categoryId': categoryId,
    'type': type,
    'plannedAmount': plannedAmount,
  };
}

Budget _budgetFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
    Budget.fromJson(doc.data()!);

class FirestoreBudgetRepository implements BudgetRepository {
  FirestoreBudgetRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection(FirestorePaths.budgetsCollection(uid));

  @override
  Stream<List<Budget>> watchByMonth(String uid, String monthKey) => _col(uid)
      .where('monthKey', isEqualTo: monthKey)
      .snapshots()
      .map((s) => s.docs.map(_budgetFromDoc).toList());

  @override
  Stream<List<Budget>> watchByMonthAndType(
    String uid,
    String monthKey,
    String type,
  ) => _col(uid)
      .where('monthKey', isEqualTo: monthKey)
      .where('type', isEqualTo: type)
      .snapshots()
      .map((s) => s.docs.map(_budgetFromDoc).toList());

  @override
  Future<void> saveBudget(String uid, Budget budget) {
    // Doc id cố định: {monthKey}_{categoryId} → ghi đè nếu tồn tại
    final docId = '${budget.monthKey}_${budget.categoryId}';
    return _col(
      uid,
    ).doc(docId).set(budget.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<void> copyFromPreviousMonth(
    String uid, {
    required String fromMonthKey,
    required String toMonthKey,
  }) async {
    final snapshot = await _col(
      uid,
    ).where('monthKey', isEqualTo: fromMonthKey).get();
    if (snapshot.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      final old = _budgetFromDoc(doc);
      final newBudget = old.copyWith(monthKey: toMonthKey);
      final newDocId = '${toMonthKey}_${newBudget.categoryId}';
      batch.set(
        _col(uid).doc(newDocId),
        newBudget.toFirestore(),
        SetOptions(merge: true),
      );
    }
    await batch.commit();
  }

  @override
  Future<Budget?> getBudget(
    String uid, {
    required String monthKey,
    required String categoryId,
  }) async {
    final doc = await _col(uid).doc('${monthKey}_$categoryId').get();
    if (!doc.exists || doc.data() == null) return null;
    return _budgetFromDoc(doc);
  }

  @override
  Future<void> deleteBudget(
    String uid, {
    required String monthKey,
    required String categoryId,
  }) => _col(uid).doc('${monthKey}_$categoryId').delete();
}

// ---------------------------------------------------------------------------
// MonthSummary Repository
// ---------------------------------------------------------------------------

abstract interface class MonthSummaryRepository {
  /// Stream tổng kết tháng (Tổng quan dùng).
  Stream<MonthSummary?> watchMonthSummary(String uid, String monthKey);

  /// Lấy tổng kết tháng một lần (dùng cho báo cáo).
  Future<MonthSummary?> getMonthSummary(String uid, String monthKey);

  /// Lấy nhiều tháng liên tiếp (dùng cho biểu đồ xu hướng).
  Future<List<MonthSummary>> getRecentMonths(String uid, {int count = 6});

  /// Ghi nhận ngày không chi hoặc ngày có hoạt động ghi chép để duy trì streak (MOT-1).
  Future<void> recordStreakDay(String uid, String monthKey, String dateStr);
}

MonthSummary _summaryFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  final json = <String, dynamic>{...data, 'monthKey': doc.id};
  // Firestore Timestamp → String ISO
  if (json['updatedAt'] is Timestamp) {
    json['updatedAt'] = (json['updatedAt'] as Timestamp)
        .toDate()
        .toIso8601String();
  }
  // byCategory map từ Firestore có thể chứa int hoặc num — đảm bảo là int
  if (json['byCategory'] is Map) {
    json['byCategory'] = (json['byCategory'] as Map).map(
      (k, v) => MapEntry(k.toString(), (v as num).toInt()),
    );
  }
  return MonthSummary.fromJson(json);
}

class FirestoreMonthSummaryRepository implements MonthSummaryRepository {
  FirestoreMonthSummaryRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection(FirestorePaths.monthSummariesCollection(uid));

  @override
  Stream<MonthSummary?> watchMonthSummary(String uid, String monthKey) =>
      _col(uid)
          .doc(monthKey)
          .snapshots()
          .map((doc) => doc.exists ? _summaryFromDoc(doc) : null);

  @override
  Future<MonthSummary?> getMonthSummary(String uid, String monthKey) async {
    final doc = await _col(uid).doc(monthKey).get();
    if (!doc.exists) return null;
    return _summaryFromDoc(doc);
  }

  @override
  Future<List<MonthSummary>> getRecentMonths(
    String uid, {
    int count = 6,
  }) async {
    final snap = await _col(
      uid,
    ).orderBy(FieldPath.documentId, descending: true).limit(count).get();
    return snap.docs.map(_summaryFromDoc).toList();
  }

  @override
  Future<void> recordStreakDay(String uid, String monthKey, String dateStr) =>
      _col(uid).doc(monthKey).set({
        'loggedDays': FieldValue.arrayUnion([dateStr]),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final budgetRepositoryProvider = Provider<BudgetRepository>(
  (ref) => FirestoreBudgetRepository(ref.watch(firestoreProvider)),
  name: 'budgetRepositoryProvider',
);

final monthSummaryRepositoryProvider = Provider<MonthSummaryRepository>(
  (ref) => FirestoreMonthSummaryRepository(ref.watch(firestoreProvider)),
  name: 'monthSummaryRepositoryProvider',
);

/// Stream tổng kết tháng hiện tại — Tổng quan watch cái này.
final monthSummaryStreamProvider = StreamProvider.autoDispose
    .family<MonthSummary?, String>((ref, monthKey) {
      final uid = ref.watch(currentUidProvider);
      if (uid == null) return Stream.value(null);
      return ref
          .watch(monthSummaryRepositoryProvider)
          .watchMonthSummary(uid, monthKey);
    }, name: 'monthSummaryStreamProvider');

/// Stream ngân sách tháng hiện tại.
final budgetsStreamProvider = StreamProvider.autoDispose
    .family<List<Budget>, String>((ref, monthKey) {
      final uid = ref.watch(currentUidProvider);
      if (uid == null) return Stream.value(const []);
      return ref.watch(budgetRepositoryProvider).watchByMonth(uid, monthKey);
    }, name: 'budgetsStreamProvider');
