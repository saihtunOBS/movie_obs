// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreResponse _$GenreResponseFromJson(Map<String, dynamic> json) =>
    GenreResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => GenreVO.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$GenreResponseToJson(GenreResponse instance) =>
    <String, dynamic>{'data': instance.data};
