import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/watchlist_history_vo.dart';

part 'watchlist_history_response.g.dart';

@JsonSerializable()
class WatchlistHistoryResponse {
  @JsonKey(name: "data")
  final List<WatchlistHistoryVo>? data;

  WatchlistHistoryResponse({this.data});

  factory WatchlistHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$WatchlistHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WatchlistHistoryResponseToJson(this);
}
