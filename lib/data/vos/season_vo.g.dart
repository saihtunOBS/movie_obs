// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeasonVO _$SeasonVOFromJson(Map<String, dynamic> json) => SeasonVO(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt(),
  plan: json['plan'] as String?,
  status: json['status'] as String?,
  isTrending: json['isTrending'] as bool?,
  bannerImageUrl: json['bannerImageUrl'] as String?,
  trailerUrl: json['trailerUrl'] as String?,
  viewCount: (json['viewCount'] as num?)?.toInt(),
  publishedYear: json['publishedYear'] as String?,
  series: json['series'],
  actors:
      (json['actors'] as List<dynamic>?)
          ?.map((e) => SeasonCastVO.fromJson(e as Map<String, dynamic>))
          .toList(),
  actresses:
      (json['actresses'] as List<dynamic>?)
          ?.map((e) => SeasonCastVO.fromJson(e as Map<String, dynamic>))
          .toList(),
  supports:
      (json['supports'] as List<dynamic>?)
          ?.map((e) => SeasonCastVO.fromJson(e as Map<String, dynamic>))
          .toList(),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  duration: (json['duration'] as num?)?.toInt(),
);

Map<String, dynamic> _$SeasonVOToJson(SeasonVO instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'sortOrder': instance.sortOrder,
  'plan': instance.plan,
  'status': instance.status,
  'isTrending': instance.isTrending,
  'bannerImageUrl': instance.bannerImageUrl,
  'trailerUrl': instance.trailerUrl,
  'viewCount': instance.viewCount,
  'publishedYear': instance.publishedYear,
  'series': instance.series,
  'actors': instance.actors,
  'actresses': instance.actresses,
  'supports': instance.supports,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'duration': instance.duration,
};

SeasonCastVO _$SeasonCastVOFromJson(Map<String, dynamic> json) => SeasonCastVO(
  cast: json['cast'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt(),
  characterName: json['characterName'] as String?,
  id: json['_id'] as String?,
);

Map<String, dynamic> _$SeasonCastVOToJson(SeasonCastVO instance) =>
    <String, dynamic>{
      'cast': instance.cast,
      'sortOrder': instance.sortOrder,
      'characterName': instance.characterName,
      '_id': instance.id,
    };
