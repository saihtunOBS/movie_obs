
import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_request.g.dart';

@JsonSerializable()
class VerifyOtpRequest {
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "userType")
  String? userType;
  @JsonKey(name: "otp")
  String? otp;
  @JsonKey(name: "request")
  String? requestId;

  VerifyOtpRequest(this.phone);

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}