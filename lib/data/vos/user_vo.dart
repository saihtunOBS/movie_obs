import 'package:json_annotation/json_annotation.dart';

part 'user_vo.g.dart';

@JsonSerializable()
class UserVO {
  @JsonKey(name: "_id")
  final String? id;

  final String? name;
  final String? email;
  final String? phone;

  final bool? isBanned;
  final bool? isVerify;

  final String? userType;
  final String? profilePictureUrl;
  final String? status;
  final String? languagePreference;

  @JsonKey(name: "createdAt")
  final String? createdAt;

  @JsonKey(name: "updatedAt")
  final String? updatedAt;

  final PreferencesVO? preferences;

  UserVO({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.isBanned,
    this.isVerify,
    this.userType,
    this.profilePictureUrl,
    this.status,
    this.languagePreference,
    this.createdAt,
    this.updatedAt,
    this.preferences,
  });

  factory UserVO.fromJson(Map<String, dynamic> json) => _$UserVOFromJson(json);

  Map<String, dynamic> toJson() => _$UserVOToJson(this);
}

@JsonSerializable()
class PreferencesVO {
  final List<String>? favoriteGenres;
  final List<String>? favoriteActors;
  final List<String>? favoriteCategories;
  final List<String>? favoriteDirectors;

  PreferencesVO({
    this.favoriteGenres,
    this.favoriteActors,
    this.favoriteCategories,
    this.favoriteDirectors,
  });

  factory PreferencesVO.fromJson(Map<String, dynamic> json) =>
      _$PreferencesVOFromJson(json);

  Map<String, dynamic> toJson() => _$PreferencesVOToJson(this);
}
