import 'package:json_annotation/json_annotation.dart';

part 'otp_response.g.dart';

@JsonSerializable()
class OTPResponse {
  @JsonKey(name: "success")
  final bool? status;

  @JsonKey(name: "requestId")
  final dynamic requestId;

  @JsonKey(name: 'accessToken')
  final String? accessToken;

  @JsonKey(name: 'refreshToken')
  final String? refreshToken;

  @JsonKey(name: 'userId')
  final String? userId;

  OTPResponse({this.status, this.requestId,this.accessToken,this.refreshToken,this.userId});

  factory OTPResponse.fromJson(Map<String, dynamic> json) =>
      _$OTPResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OTPResponseToJson(this);
}
