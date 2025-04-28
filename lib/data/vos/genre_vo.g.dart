// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreVO _$GenreVOFromJson(Map<String, dynamic> json) => GenreVO(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  genreIconUrl: json['genreIconUrl'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$GenreVOToJson(GenreVO instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'genreIconUrl': instance.genreIconUrl,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
