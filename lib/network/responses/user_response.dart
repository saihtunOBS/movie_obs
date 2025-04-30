import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/user_vo.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse {
  @JsonKey(name: "data")
  final List<UserVO>? data;


  UserResponse({this.data});

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
