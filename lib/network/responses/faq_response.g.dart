// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqResponse _$FaqResponseFromJson(Map<String, dynamic> json) => FaqResponse(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => FaqVO.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$FaqResponseToJson(FaqResponse instance) =>
    <String, dynamic>{'data': instance.data};
