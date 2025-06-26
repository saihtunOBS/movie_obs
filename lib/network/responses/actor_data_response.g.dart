// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActorDataResponse _$ActorDataResponseFromJson(Map<String, dynamic> json) =>
    ActorDataResponse(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      movieCounts: (json['movieCounts'] as num?)?.toInt(),
      role:
          json['role'] == null
              ? null
              : RoleVO.fromJson(json['role'] as Map<String, dynamic>),
      movies:
          (json['movies'] as List<dynamic>?)
              ?.map((e) => MovieVO.fromJson(e as Map<String, dynamic>))
              .toList(),
      seasons:
          (json['series'] as List<dynamic>?)
              ?.map((e) => MovieVO.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ActorDataResponseToJson(ActorDataResponse instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'profilePictureUrl': instance.profilePictureUrl,
      'role': instance.role?.toJson(),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'movieCounts': instance.movieCounts,
      'movies': instance.movies?.map((e) => e.toJson()).toList(),
      'series': instance.seasons?.map((e) => e.toJson()).toList(),
    };
