// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailResponse _$MovieDetailResponseFromJson(Map<String, dynamic> json) =>
    MovieDetailResponse(
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
      duration: (json['duration'] as num?)?.toInt(),
      payPerViewPrice: (json['payPerViewPrice'] as num?)?.toInt(),
      publishedYear: json['publishedYear'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreVO.fromJson(e as Map<String, dynamic>))
              .toList(),
      director: json['director'] as String?,
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
      seasons:
          (json['seasons'] as List<dynamic>?)
              ?.map((e) => SeasonVO.fromJson(e as Map<String, dynamic>))
              .toList(),
      isWatchlist: json['isWatchlisted'] as bool?,
    );

Map<String, dynamic> _$MovieDetailResponseToJson(
  MovieDetailResponse instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'plan': instance.plan,
  'payPerViewPrice': instance.payPerViewPrice,
  'status': instance.status,
  'isTrending': instance.isTrending,
  'posterImageUrl': instance.posterImageUrl,
  'bannerImageUrl': instance.bannerImageUrl,
  'trailerUrl': instance.trailerUrl,
  'videoUrl': instance.videoUrl,
  'tags': instance.tags,
  'scriptWriter': instance.scriptWriter,
  'viewCount': instance.viewCount,
  'duration': instance.duration,
  'publishedYear': instance.publishedYear,
  'genres': instance.genres,
  'director': instance.director,
  'actors': instance.actors,
  'actresses': instance.actresses,
  'supports': instance.supports,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'seasons': instance.seasons,
  'isWatchlisted': instance.isWatchlist,
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

ActorVO _$ActorVOFromJson(Map<String, dynamic> json) => ActorVO(
  cast:
      json['cast'] == null
          ? null
          : CastVO.fromJson(json['cast'] as Map<String, dynamic>),
  sortOrder: (json['sortOrder'] as num?)?.toInt(),
  characterName: json['characterName'] as String?,
  id: json['_id'] as String?,
);

Map<String, dynamic> _$ActorVOToJson(ActorVO instance) => <String, dynamic>{
  'cast': instance.cast,
  'sortOrder': instance.sortOrder,
  'characterName': instance.characterName,
  '_id': instance.id,
};

CastVO _$CastVOFromJson(Map<String, dynamic> json) => CastVO(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  profilePictureUrl: json['profilePictureUrl'] as String?,
  role:
      json['role'] == null
          ? null
          : RoleVO.fromJson(json['role'] as Map<String, dynamic>),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$CastVOToJson(CastVO instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'profilePictureUrl': instance.profilePictureUrl,
  'role': instance.role,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
