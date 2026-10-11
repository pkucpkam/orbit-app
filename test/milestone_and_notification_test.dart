import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/data/models/saving_goal.dart';
import 'package:quy_dao/data/repositories/goal_repository.dart';
import 'package:quy_dao/features/savings/presentation/milestone_celebration_dialog.dart';

void main() {
  group('calculateNewMilestonesReached (SAV-4)', () {
    final baseGoal = SavingGoal(
      id: 'g1',
      name: 'Quỹ khẩn cấp',
      targetAmount: 10000000,
      savedAmount: 0,
      startDate: DateTime(2026, 1, 1),
      targetDate: DateTime(2026, 12, 31),
      icon: 'savings',
      colorToken: 'orange',
      status: 'active',
      milestonesReached: const [],
    );

    test('Chạm đúng cột mốc 25% lần đầu', () {
      final newlyReached = calculateNewMilestonesReached(
        goal: baseGoal,
        addedAmount: 2500000,
      );
      expect(newlyReached, equals([25]));
    });

    test('Không kích hoạt nếu chưa đủ 25%', () {
      final newlyReached = calculateNewMilestonesReached(
        goal: baseGoal,
        addedAmount: 2000000,
      );
      expect(newlyReached, isEmpty);
    });

    test('Nhảy vọt từ 0% lên 55% thì kích hoạt cả 25% và 50%', () {
      final newlyReached = calculateNewMilestonesReached(
        goal: baseGoal,
        addedAmount: 5500000,
      );
      expect(newlyReached, equals([25, 50]));
    });

    test('Đã đạt 25% trước đó, nạp thêm chạm 50% chỉ trả về [50]', () {
      final goalWith25 = baseGoal.copyWith(
        savedAmount: 2500000,
        milestonesReached: const [25],
      );
      final newlyReached = calculateNewMilestonesReached(
        goal: goalWith25,
        addedAmount: 2500000, // Tổng 5.000.000 = 50%
      );
      expect(newlyReached, equals([50]));
    });

    test('Nạp về đích 100% kích hoạt cột mốc 100%', () {
      final goalWith75 = baseGoal.copyWith(
        savedAmount: 7500000,
        milestonesReached: const [25, 50, 75],
      );
      final newlyReached = calculateNewMilestonesReached(
        goal: goalWith75,
        addedAmount: 2500000, // Đạt 10.000.000 = 100%
      );
      expect(newlyReached, equals([100]));
    });

    test('Nạp thêm khi đã hoàn thành 100% không báo lại', () {
      final completedGoal = baseGoal.copyWith(
        savedAmount: 10000000,
        milestonesReached: const [25, 50, 75, 100],
        status: 'completed',
      );
      final newlyReached = calculateNewMilestonesReached(
        goal: completedGoal,
        addedAmount: 1000000,
      );
      expect(newlyReached, isEmpty);
    });
  });

  group('GoalRepository - Lưu trữ Milestones và Status trên Firestore', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirestoreGoalRepository goalRepo;
    const uid = 'user_test_milestone';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      goalRepo = FirestoreGoalRepository(fakeFirestore);
    });

    test('Ghi nhận mốc 25% và 50% vào milestonesReached', () async {
      final initialGoal = SavingGoal(
        id: 'goal_macbook',
        name: 'Mua MacBook M3',
        targetAmount: 30000000,
        savedAmount: 0,
        startDate: DateTime(2026, 1, 1),
        targetDate: DateTime(2026, 12, 31),
        icon: 'laptop',
        colorToken: 'orange',
        status: 'active',
        milestonesReached: const [],
      );

      await goalRepo.createGoal(uid, initialGoal);

      // Chạm mốc 25%
      await goalRepo.updateGoalStatus(
        uid,
        'goal_macbook',
        status: 'active',
        milestoneReached: 25,
      );

      var updated = await goalRepo.getGoal(uid, 'goal_macbook');
      expect(updated, isNotNull);
      expect(updated!.milestonesReached, contains(25));
      expect(updated.status, equals('active'));

      // Chạm mốc 50%
      await goalRepo.updateGoalStatus(
        uid,
        'goal_macbook',
        status: 'active',
        milestoneReached: 50,
      );

      updated = await goalRepo.getGoal(uid, 'goal_macbook');
      expect(updated!.milestonesReached, containsAll([25, 50]));

      // Hoàn thành 100%
      final completedTime = DateTime(2026, 10, 11, 20, 0);
      await goalRepo.updateGoalStatus(
        uid,
        'goal_macbook',
        status: 'completed',
        milestoneReached: 100,
        completedAt: completedTime,
      );

      updated = await goalRepo.getGoal(uid, 'goal_macbook');
      expect(updated!.status, equals('completed'));
      expect(updated.milestonesReached, containsAll([25, 50, 100]));
      expect(updated.completedAt, isNotNull);
    });
  });

  group('AppStrings - Động lực Cột mốc & Cảnh báo Ngân sách', () {
    test('Tiêu đề chúc mừng cho từng mốc', () {
      expect(AppStrings.milestoneTitle(25), equals('Khởi đầu tuyệt vời!'));
      expect(AppStrings.milestoneTitle(50), equals('Hơn nửa chặng đường!'));
      expect(AppStrings.milestoneTitle(75), equals('Rất gần đích đến!'));
      expect(
        AppStrings.milestoneTitle(100),
        equals('Chúc mừng bạn đã về đích!'),
      );
    });

    test('Thông điệp động lực với thời gian còn lại', () {
      final msg = AppStrings.milestoneMessage(
        milestone: 50,
        goalName: 'Xe máy mới',
        remainingMonths: 3,
      );
      expect(msg, contains('Còn 3 tháng'));
      expect(msg, contains('Xe máy mới'));
      expect(msg, contains('nửa chặng đường'));
    });

    test('Thông điệp khi hoàn thành 100%', () {
      final msg = AppStrings.milestoneMessage(
        milestone: 100,
        goalName: 'Xe máy mới',
      );
      expect(msg, contains('hoàn thành trọn vẹn'));
      expect(msg, contains('Xe máy mới'));
    });

    test('Cảnh báo ngân sách ngôn ngữ trung tính', () {
      final alert80 = AppStrings.budgetUsageNotice(
        percent: 80,
        category: 'Ăn uống',
      );
      expect(alert80, equals('Đã dùng 80% ngân sách Ăn uống'));

      final alert100 = AppStrings.budgetUsageNotice(
        percent: 100,
        category: 'Mua sắm',
      );
      expect(alert100, equals('Đã dùng 100% ngân sách Mua sắm'));
    });
  });
}
