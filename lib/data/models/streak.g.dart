// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Streak _$StreakFromJson(Map<String, dynamic> json) => _Streak(
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
  longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
  lastLogDate: json['lastLogDate'] as String?,
);

Map<String, dynamic> _$StreakToJson(_Streak instance) => <String, dynamic>{
  'currentStreak': instance.currentStreak,
  'longestStreak': instance.longestStreak,
  'lastLogDate': instance.lastLogDate,
};
