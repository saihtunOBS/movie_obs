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
    );

Map<String, dynamic> _$WatchlistHistoryVoToJson(WatchlistHistoryVo instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'type': instance.type,
      'reference': instance.reference,
    };
