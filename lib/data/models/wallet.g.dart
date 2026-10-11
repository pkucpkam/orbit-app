// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Wallet _$WalletFromJson(Map<String, dynamic> json) => _Wallet(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  balance: (json['balance'] as num).toInt(),
  initialBalance: (json['initialBalance'] as num?)?.toInt() ?? 0,
  archived: json['archived'] as bool? ?? false,
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$WalletToJson(_Wallet instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'balance': instance.balance,
  'initialBalance': instance.initialBalance,
  'archived': instance.archived,
  'order': instance.order,
};
