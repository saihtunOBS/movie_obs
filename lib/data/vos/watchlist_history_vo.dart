import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';

part 'watchlist_history_vo.g.dart';

@JsonSerializable()
class WatchlistHistoryVo {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "user")
  final String? user;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "reference")
  final MovieVO? reference;

  WatchlistHistoryVo({this.id, this.user, this.type, this.reference});

  factory WatchlistHistoryVo.fromJson(Map<String, dynamic> json) =>
      _$WatchlistHistoryVoFromJson(json);

  Map<String, dynamic> toJson() => _$WatchlistHistoryVoToJson(this);
}
