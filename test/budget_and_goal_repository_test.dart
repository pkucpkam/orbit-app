import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quy_dao/data/firestore_paths.dart';
import 'package:quy_dao/data/models/budget.dart';
import 'package:quy_dao/data/models/saving_goal.dart';
import 'package:quy_dao/data/repositories/budget_repository.dart';
import 'package:quy_dao/data/repositories/goal_repository.dart';

void main() {
  group('FirestoreBudgetRepository Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirestoreBudgetRepository budgetRepo;
    const uid = 'test_budget_uid';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      budgetRepo = FirestoreBudgetRepository(fakeFirestore);
    });

    test(
      'saveBudget and deleteBudget operate on {monthKey}_{categoryId}',
      () async {
        const budget = Budget(
          monthKey: '2026-10',
          categoryId: 'cat_food',
          type: 'expense',
          plannedAmount: 3000000,
        );

        await budgetRepo.saveBudget(uid, budget);

        final doc = await fakeFirestore
            .collection(FirestorePaths.budgetsCollection(uid))
            .doc('2026-10_cat_food')
            .get();
        expect(doc.exists, isTrue);
        expect(doc.data()?['plannedAmount'], 3000000);

        // Xóa budget
        await budgetRepo.deleteBudget(
          uid,
          monthKey: '2026-10',
          categoryId: 'cat_food',
        );
        final deletedDoc = await fakeFirestore
            .collection(FirestorePaths.budgetsCollection(uid))
            .doc('2026-10_cat_food')
            .get();
        expect(deletedDoc.exists, isFalse);
      },
    );

    test(
      'copyFromPreviousMonth copies all budgets from previous month',
      () async {
        // Seed tháng 9
        await fakeFirestore
            .collection(FirestorePaths.budgetsCollection(uid))
            .doc('2026-09_cat_food')
            .set({
              'monthKey': '2026-09',
              'categoryId': 'cat_food',
              'type': 'expense',
              'plannedAmount': 4000000,
            });
        await fakeFirestore
            .collection(FirestorePaths.budgetsCollection(uid))
            .doc('2026-09_cat_rent')
            .set({
              'monthKey': '2026-09',
              'categoryId': 'cat_rent',
              'type': 'expense',
              'plannedAmount': 5000000,
            });

        // Sao chép sang tháng 10
        await budgetRepo.copyFromPreviousMonth(
          uid,
          fromMonthKey: '2026-09',
          toMonthKey: '2026-10',
        );

        final copiedFood = await fakeFirestore
            .collection(FirestorePaths.budgetsCollection(uid))
            .doc('2026-10_cat_food')
            .get();
        expect(copiedFood.exists, isTrue);
        expect(copiedFood.data()?['plannedAmount'], 4000000);

        final copiedRent = await fakeFirestore
            .collection(FirestorePaths.budgetsCollection(uid))
            .doc('2026-10_cat_rent')
            .get();
        expect(copiedRent.exists, isTrue);
        expect(copiedRent.data()?['plannedAmount'], 5000000);
      },
    );
  });

  group('FirestoreGoalRepository Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirestoreGoalRepository goalRepo;
    const uid = 'test_goal_uid';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      goalRepo = FirestoreGoalRepository(fakeFirestore);
    });

    test('createGoal, updateGoal, and markMilestoneCelebrated', () async {
      final goal = SavingGoal(
        id: '',
        name: 'Quỹ khẩn cấp',
        targetAmount: 50000000,
        savedAmount: 0,
        startDate: DateTime(2026, 10, 1),
        targetDate: DateTime(2027, 10, 1),
        icon: '🛡️',
        colorToken: 'signalOrange',
        status: 'active',
        milestonesReached: const [],
      );

      final goalId = await goalRepo.createGoal(uid, goal);
      expect(goalId, isNotEmpty);

      // Đánh dấu mốc 25% đã chúc mừng
      await goalRepo.updateGoalStatus(
        uid,
        goalId,
        status: 'active',
        milestoneReached: 25,
      );

      final goalDoc = await fakeFirestore
          .collection(FirestorePaths.goalsCollection(uid))
          .doc(goalId)
          .get();
      expect(goalDoc.data()?['milestonesReached'], contains(25));

      // Archive goal
      await goalRepo.updateGoalStatus(uid, goalId, status: 'archived');
      final archivedDoc = await fakeFirestore
          .collection(FirestorePaths.goalsCollection(uid))
          .doc(goalId)
          .get();
      expect(archivedDoc.data()?['status'], 'archived');
    });
  });
}
