import 'package:json_annotation/json_annotation.dart';

part 'redeem_code_request.g.dart';

@JsonSerializable()
class RedeemCodeRequest {
  @JsonKey(name: "code")
  String? code;

  RedeemCodeRequest(this.code);

  factory RedeemCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$RedeemCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RedeemCodeRequestToJson(this);
}
