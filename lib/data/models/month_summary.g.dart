// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthSummary _$MonthSummaryFromJson(Map<String, dynamic> json) =>
    _MonthSummary(
      monthKey: json['monthKey'] as String,
      totalIncome: (json['totalIncome'] as num?)?.toInt() ?? 0,
      totalExpense: (json['totalExpense'] as num?)?.toInt() ?? 0,
      totalSaved: (json['totalSaved'] as num?)?.toInt() ?? 0,
      byCategory:
          (json['byCategory'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      loggedDays:
          (json['loggedDays'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MonthSummaryToJson(_MonthSummary instance) =>
    <String, dynamic>{
      'monthKey': instance.monthKey,
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'totalSaved': instance.totalSaved,
      'byCategory': instance.byCategory,
      'loggedDays': instance.loggedDays,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
