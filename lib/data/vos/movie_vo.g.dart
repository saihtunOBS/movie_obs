// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieVO _$MovieVOFromJson(Map<String, dynamic> json) => MovieVO(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  plan: json['plan'] as String?,
  status: json['status'] as String?,
  isTrending: json['isTrending'] as bool?,
  posterImageUrl: json['posterImageUrl'] as String?,
  bannerImageUrl: json['bannerImageUrl'] as String?,
  trailerUrl: json['trailerUrl'] as String?,
  videoUrl: json['videoUrl'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  scriptWriter: json['scriptWriter'] as String?,
  viewCount: (json['viewCount'] as num?)?.toInt(),
  category:
      json['category'] == null
          ? null
          : CategoryVO.fromJson(json['category'] as Map<String, dynamic>),
  duration: (json['duration'] as num?)?.toInt(),
  publishedYear: json['publishedYear'] as String?,
  scheduleAt: json['scheduleAt'] as String?,
  genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
  director: json['director'] as String?,
  actors:
      (json['actors'] as List<dynamic>?)
          ?.map((e) => CastVO.fromJson(e as Map<String, dynamic>))
          .toList(),
  actresses:
      (json['actresses'] as List<dynamic>?)
          ?.map((e) => CastVO.fromJson(e as Map<String, dynamic>))
          .toList(),
  supports:
      (json['supports'] as List<dynamic>?)
          ?.map((e) => CastVO.fromJson(e as Map<String, dynamic>))
          .toList(),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$MovieVOToJson(MovieVO instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'plan': instance.plan,
  'status': instance.status,
  'isTrending': instance.isTrending,
  'posterImageUrl': instance.posterImageUrl,
  'bannerImageUrl': instance.bannerImageUrl,
  'trailerUrl': instance.trailerUrl,
  'videoUrl': instance.videoUrl,
  'tags': instance.tags,
  'scriptWriter': instance.scriptWriter,
  'viewCount': instance.viewCount,
  'category': instance.category,
  'duration': instance.duration,
  'publishedYear': instance.publishedYear,
  'scheduleAt': instance.scheduleAt,
  'genres': instance.genres,
  'director': instance.director,
  'actors': instance.actors,
  'actresses': instance.actresses,
  'supports': instance.supports,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

CategoryVO _$CategoryVOFromJson(Map<String, dynamic> json) => CategoryVO(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$CategoryVOToJson(CategoryVO instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

CastVO _$CastVOFromJson(Map<String, dynamic> json) => CastVO(
  cast: json['cast'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt(),
  characterName: json['characterName'] as String?,
  id: json['_id'] as String?,
);

Map<String, dynamic> _$CastVOToJson(CastVO instance) => <String, dynamic>{
  'cast': instance.cast,
  'sortOrder': instance.sortOrder,
  'characterName': instance.characterName,
  '_id': instance.id,
};
