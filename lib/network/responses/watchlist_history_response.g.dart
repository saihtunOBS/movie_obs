// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchlistHistoryResponse _$WatchlistHistoryResponseFromJson(
  Map<String, dynamic> json,
) => WatchlistHistoryResponse(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => WatchlistHistoryVo.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$WatchlistHistoryResponseToJson(
  WatchlistHistoryResponse instance,
) => <String, dynamic>{'data': instance.data};
