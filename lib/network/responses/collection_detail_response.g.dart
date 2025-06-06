// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionDetailResponse _$CollectionDetailResponseFromJson(
  Map<String, dynamic> json,
) => CollectionDetailResponse(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CollectionItemVO.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$CollectionDetailResponseToJson(
  CollectionDetailResponse instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'items': instance.items,
};
