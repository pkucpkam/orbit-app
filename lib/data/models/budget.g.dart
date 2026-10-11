// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Budget _$BudgetFromJson(Map<String, dynamic> json) => _Budget(
  monthKey: json['monthKey'] as String,
  categoryId: json['categoryId'] as String,
  type: json['type'] as String,
  plannedAmount: (json['plannedAmount'] as num).toInt(),
);

Map<String, dynamic> _$BudgetToJson(_Budget instance) => <String, dynamic>{
  'monthKey': instance.monthKey,
  'categoryId': instance.categoryId,
  'type': instance.type,
  'plannedAmount': instance.plannedAmount,
};
