// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saving_goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavingGoal _$SavingGoalFromJson(Map<String, dynamic> json) => _SavingGoal(
  id: json['id'] as String,
  name: json['name'] as String,
  targetAmount: (json['targetAmount'] as num).toInt(),
  savedAmount: (json['savedAmount'] as num?)?.toInt() ?? 0,
  startDate: DateTime.parse(json['startDate'] as String),
  targetDate: DateTime.parse(json['targetDate'] as String),
  icon: json['icon'] as String,
  colorToken: json['colorToken'] as String,
  status: json['status'] as String? ?? 'active',
  milestonesReached:
      (json['milestonesReached'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$SavingGoalToJson(_SavingGoal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'targetAmount': instance.targetAmount,
      'savedAmount': instance.savedAmount,
      'startDate': instance.startDate.toIso8601String(),
      'targetDate': instance.targetDate.toIso8601String(),
      'icon': instance.icon,
      'colorToken': instance.colorToken,
      'status': instance.status,
      'milestonesReached': instance.milestonesReached,
      'completedAt': instance.completedAt?.toIso8601String(),
    };
