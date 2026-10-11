/// Repository mục tiêu tiết kiệm (SavingGoal).
///
/// Lưu ý: savedAmount KHÔNG được cập nhật trực tiếp ở đây.
/// savedAmount chỉ thay đổi qua WriteBatch trong TransactionRepository
/// khi có giao dịch loại 'saving'.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quy_dao/data/firestore_paths.dart';
import 'package:quy_dao/data/models/saving_goal.dart';
import 'package:quy_dao/data/repositories/app_providers.dart';

// ---------------------------------------------------------------------------
// Interface
// ---------------------------------------------------------------------------

abstract interface class GoalRepository {
  /// Stream danh sách mục tiêu active, sắp xếp theo ngày tạo.
  Stream<List<SavingGoal>> watchActiveGoals(String uid);

  /// Stream tất cả mục tiêu (kể cả completed/archived).
  Stream<List<SavingGoal>> watchAllGoals(String uid);

  /// Tạo mục tiêu mới.
  Future<String> createGoal(String uid, SavingGoal goal);

  /// Cập nhật thông tin mục tiêu (tên, targetAmount, targetDate, icon, colorToken).
  Future<void> updateGoal(String uid, SavingGoal goal);

  /// Cập nhật trạng thái (active/completed/archived) và milestonesReached.
  Future<void> updateGoalStatus(
    String uid,
    String goalId, {
    required String status,
    int? milestoneReached,
    DateTime? completedAt,
  });

  /// Lấy một mục tiêu theo ID.
  Future<SavingGoal?> getGoal(String uid, String goalId);
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

SavingGoal _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  final json = <String, dynamic>{...data, 'id': doc.id};
  // Firestore Timestamp → ISO String
  for (final key in ['startDate', 'targetDate', 'completedAt']) {
    if (json[key] is Timestamp) {
      json[key] = (json[key] as Timestamp).toDate().toIso8601String();
    }
  }
  return SavingGoal.fromJson(json);
}

Map<String, dynamic> _toFirestore(SavingGoal goal) => {
  'name': goal.name,
  'targetAmount': goal.targetAmount,
  'savedAmount': goal.savedAmount,
  'startDate': Timestamp.fromDate(goal.startDate),
  'targetDate': Timestamp.fromDate(goal.targetDate),
  'icon': goal.icon,
  'colorToken': goal.colorToken,
  'status': goal.status,
  'milestonesReached': goal.milestonesReached,
  if (goal.completedAt != null)
    'completedAt': Timestamp.fromDate(goal.completedAt!),
};

// ---------------------------------------------------------------------------
// Implementation
// ---------------------------------------------------------------------------

class FirestoreGoalRepository implements GoalRepository {
  FirestoreGoalRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection(FirestorePaths.goalsCollection(uid));

  @override
  Stream<List<SavingGoal>> watchActiveGoals(String uid) => _col(uid)
      .where('status', isEqualTo: 'active')
      .orderBy('startDate', descending: true)
      .snapshots()
      .map((s) => s.docs.map(_fromDoc).toList());

  @override
  Stream<List<SavingGoal>> watchAllGoals(String uid) => _col(uid)
      .orderBy('startDate', descending: true)
      .snapshots()
      .map((s) => s.docs.map(_fromDoc).toList());

  @override
  Future<String> createGoal(String uid, SavingGoal goal) async {
    final ref = goal.id.isEmpty ? _col(uid).doc() : _col(uid).doc(goal.id);
    await ref.set(_toFirestore(goal));
    return ref.id;
  }

  @override
  Future<void> updateGoal(String uid, SavingGoal goal) =>
      _col(uid).doc(goal.id).update({
        'name': goal.name,
        'targetAmount': goal.targetAmount,
        'targetDate': Timestamp.fromDate(goal.targetDate),
        'icon': goal.icon,
        'colorToken': goal.colorToken,
        // savedAmount KHÔNG cập nhật ở đây — chỉ qua WriteBatch của transaction
      });

  @override
  Future<void> updateGoalStatus(
    String uid,
    String goalId, {
    required String status,
    int? milestoneReached,
    DateTime? completedAt,
  }) {
    final data = <String, dynamic>{'status': status};
    if (milestoneReached != null) {
      data['milestonesReached'] = FieldValue.arrayUnion([milestoneReached]);
    }
    if (completedAt != null) {
      data['completedAt'] = Timestamp.fromDate(completedAt);
    }
    return _col(uid).doc(goalId).update(data);
  }

  @override
  Future<SavingGoal?> getGoal(String uid, String goalId) async {
    final doc = await _col(uid).doc(goalId).get();
    if (!doc.exists) return null;
    return _fromDoc(doc);
  }
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final goalRepositoryProvider = Provider<GoalRepository>(
  (ref) => FirestoreGoalRepository(ref.watch(firestoreProvider)),
  name: 'goalRepositoryProvider',
);

/// Stream mục tiêu active của user.
final activeGoalsStreamProvider = StreamProvider.autoDispose<List<SavingGoal>>((
  ref,
) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(const []);
  return ref.watch(goalRepositoryProvider).watchActiveGoals(uid);
}, name: 'activeGoalsStreamProvider');
