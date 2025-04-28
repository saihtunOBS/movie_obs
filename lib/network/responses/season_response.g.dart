// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeasonResponse _$SeasonResponseFromJson(Map<String, dynamic> json) =>
    SeasonResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => SeasonVO.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$SeasonResponseToJson(SeasonResponse instance) =>
    <String, dynamic>{'data': instance.data};
