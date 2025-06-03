import 'package:json_annotation/json_annotation.dart';

part 'view_count_request.g.dart';

@JsonSerializable()
class ViewCountRequest {
  @JsonKey(name: "type")
  String? type;

  ViewCountRequest(this.type);

  factory ViewCountRequest.fromJson(Map<String, dynamic> json) =>
      _$ViewCountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ViewCountRequestToJson(this);
}
