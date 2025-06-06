// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionResponse _$CollectionResponseFromJson(Map<String, dynamic> json) =>
    CollectionResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => CollectionVO.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$CollectionResponseToJson(CollectionResponse instance) =>
    <String, dynamic>{'data': instance.data};
