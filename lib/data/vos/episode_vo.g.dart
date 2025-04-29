// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeVO _$EpisodeVOFromJson(Map<String, dynamic> json) => EpisodeVO(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt(),
  description: json['description'] as String?,
  status: json['status'] as String?,
  plan: json['plan'] as String?,
  trailerUrl: json['trailerUrl'] as String?,
  videoUrl: json['videoUrl'] as String?,
  viewCount: (json['viewCount'] as num?)?.toInt(),
  season: json['season'] as String?,
  duration: (json['duration'] as num?)?.toInt(),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$EpisodeVOToJson(EpisodeVO instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'sortOrder': instance.sortOrder,
  'description': instance.description,
  'status': instance.status,
  'plan': instance.plan,
  'trailerUrl': instance.trailerUrl,
  'videoUrl': instance.videoUrl,
  'viewCount': instance.viewCount,
  'season': instance.season,
  'duration': instance.duration,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
