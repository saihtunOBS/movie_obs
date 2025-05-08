// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_history_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchlistHistoryVo _$WatchlistHistoryVoFromJson(Map<String, dynamic> json) =>
    WatchlistHistoryVo(
      id: json['_id'] as String?,
      user: json['user'] as String?,
      type: json['type'] as String?,
      reference:
          json['reference'] == null
              ? null
              : MovieVO.fromJson(json['reference'] as Map<String, dynamic>),
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$WatchlistHistoryVoToJson(WatchlistHistoryVo instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'type': instance.type,
      'reference': instance.reference,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
