
import 'package:json_annotation/json_annotation.dart';

part 'watchlist_request.g.dart';

@JsonSerializable()
class WatchlistRequest {
  @JsonKey(name: "user")
  String? user;
  @JsonKey(name: "reference")
  String? reference;
  @JsonKey(name: "type")
  String? type;

  WatchlistRequest(this.user,this.reference,this.type);

  factory WatchlistRequest.fromJson(Map<String, dynamic> json) =>
      _$WatchlistRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WatchlistRequestToJson(this);
}