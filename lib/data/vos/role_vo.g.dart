// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleVO _$RoleVOFromJson(Map<String, dynamic> json) => RoleVO(
  id: json['_id'] as String?,
  role: json['role'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  v: (json['v'] as num?)?.toInt(),
);

Map<String, dynamic> _$RoleVOToJson(RoleVO instance) => <String, dynamic>{
  '_id': instance.id,
  'role': instance.role,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'v': instance.v,
};
