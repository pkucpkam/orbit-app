// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  icon: json['icon'] as String,
  colorToken: json['colorToken'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
  archived: json['archived'] as bool? ?? false,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'icon': instance.icon,
  'colorToken': instance.colorToken,
  'order': instance.order,
  'archived': instance.archived,
};
