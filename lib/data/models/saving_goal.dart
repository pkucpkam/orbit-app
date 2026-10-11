import 'package:freezed_annotation/freezed_annotation.dart';

part 'saving_goal.freezed.dart';
part 'saving_goal.g.dart';

@freezed
abstract class SavingGoal with _$SavingGoal {
  const factory SavingGoal({
    required String id,
    required String name,
    required int targetAmount,
    @Default(0) int savedAmount,
    required DateTime startDate,
    required DateTime targetDate,
    required String icon,
    required String colorToken,
    @Default('active') String status, // 'active', 'completed', 'archived'
    @Default([]) List<int> milestonesReached,
    DateTime? completedAt,
  }) = _SavingGoal;

  factory SavingGoal.fromJson(Map<String, dynamic> json) =>
      _$SavingGoalFromJson(json);
}
