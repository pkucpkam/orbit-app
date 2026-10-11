// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
  id: json['id'] as String,
  type: json['type'] as String,
  amount: (json['amount'] as num).toInt(),
  walletId: json['walletId'] as String,
  toWalletId: json['toWalletId'] as String?,
  categoryId: json['categoryId'] as String?,
  goalId: json['goalId'] as String?,
  note: json['note'] as String? ?? '',
  date: DateTime.parse(json['date'] as String),
  monthKey: json['monthKey'] as String,
  recurringId: json['recurringId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'walletId': instance.walletId,
      'toWalletId': instance.toWalletId,
      'categoryId': instance.categoryId,
      'goalId': instance.goalId,
      'note': instance.note,
      'date': instance.date.toIso8601String(),
      'monthKey': instance.monthKey,
      'recurringId': instance.recurringId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
