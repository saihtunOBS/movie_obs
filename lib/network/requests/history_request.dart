
import 'package:json_annotation/json_annotation.dart';

part 'history_request.g.dart';

@JsonSerializable()
class HistoryRequest {
  @JsonKey(name: "user")
  String? user;
  @JsonKey(name: "reference")
  String? reference;
  @JsonKey(name: "duration")
  int? duration;
  @JsonKey(name: "type")
  String? type;

  HistoryRequest(this.user,this.reference,this.duration,this.type);

  factory HistoryRequest.fromJson(Map<String, dynamic> json) =>
      _$HistoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryRequestToJson(this);
}