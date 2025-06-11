import 'package:json_annotation/json_annotation.dart';

part 'google_login_request.g.dart';

@JsonSerializable()
class GoogleLoginRequest {
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "fcmToken")
  String? fcmToken;

  GoogleLoginRequest(this.email, this.name, this.fcmToken);

  factory GoogleLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleLoginRequestToJson(this);
}
