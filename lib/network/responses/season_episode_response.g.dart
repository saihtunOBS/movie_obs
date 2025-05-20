// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_episode_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeasonEpisodeResponse _$SeasonEpisodeResponseFromJson(
  Map<String, dynamic> json,
) => SeasonEpisodeResponse(
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
  actors:
      (json['actors'] as List<dynamic>?)
          ?.map((e) => ActorVO.fromJson(e as Map<String, dynamic>))
          .toList(),
  actresses:
      (json['actresses'] as List<dynamic>?)
          ?.map((e) => ActorVO.fromJson(e as Map<String, dynamic>))
          .toList(),
  supports:
      (json['supports'] as List<dynamic>?)
          ?.map((e) => ActorVO.fromJson(e as Map<String, dynamic>))
          .toList(),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  episodes:
      (json['episodes'] as List<dynamic>?)
          ?.map((e) => EpisodeVO.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$SeasonEpisodeResponseToJson(
  SeasonEpisodeResponse instance,
) => <String, dynamic>{
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
  'actors': instance.actors,
  'actresses': instance.actresses,
  'supports': instance.supports,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'episodes': instance.episodes,
};
