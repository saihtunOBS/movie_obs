import 'package:json_annotation/json_annotation.dart';

part 'otp_response.g.dart';

@JsonSerializable()
class OTPResponse {
  @JsonKey(name: "success")
  final bool? status;

  @JsonKey(name: "requestId")
  final dynamic requestId;

  OTPResponse(
      {this.status,
      this.requestId,
      });

  factory OTPResponse.fromJson(Map<String, dynamic> json) =>
      _$OTPResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OTPResponseToJson(this);
}