// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchlistRequest _$WatchlistRequestFromJson(Map<String, dynamic> json) =>
    WatchlistRequest(
      json['user'] as String?,
      json['reference'] as String?,
      json['type'] as String?,
    );

Map<String, dynamic> _$WatchlistRequestToJson(WatchlistRequest instance) =>
    <String, dynamic>{
      'user': instance.user,
      'reference': instance.reference,
      'type': instance.type,
    };
