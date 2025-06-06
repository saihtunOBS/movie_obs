// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionVO _$CollectionVOFromJson(Map<String, dynamic> json) => CollectionVO(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CollectionItemVO.fromJson(e as Map<String, dynamic>))
          .toList(),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  version: (json['__v'] as num?)?.toInt(),
);

Map<String, dynamic> _$CollectionVOToJson(CollectionVO instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'items': instance.items,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      '__v': instance.version,
    };

CollectionItemVO _$CollectionItemVOFromJson(Map<String, dynamic> json) =>
    CollectionItemVO(
      id: json['_id'] as String?,
      reference:
          json['reference'] == null
              ? null
              : MovieVO.fromJson(json['reference'] as Map<String, dynamic>),
      referenceModel: json['referenceModel'] as String?,
    );

Map<String, dynamic> _$CollectionItemVOToJson(CollectionItemVO instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'reference': instance.reference,
      'referenceModel': instance.referenceModel,
    };
