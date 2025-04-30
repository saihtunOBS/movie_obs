// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageVO _$PackageVOFromJson(Map<String, dynamic> json) => PackageVO(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toInt(),
  currency: json['currency'] as String?,
  duration: (json['duration'] as num?)?.toInt(),
  status: json['status'] as bool?,
  isPopular: json['isPopular'] as bool?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$PackageVOToJson(PackageVO instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'currency': instance.currency,
  'duration': instance.duration,
  'status': instance.status,
  'isPopular': instance.isPopular,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
