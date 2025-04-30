// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVO _$UserVOFromJson(Map<String, dynamic> json) => UserVO(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  isBanned: json['isBanned'] as bool?,
  isVerify: json['isVerify'] as bool?,
  userType: json['userType'] as String?,
  profilePictureUrl: json['profilePictureUrl'] as String?,
  status: json['status'] as String?,
  languagePreference: json['languagePreference'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  preferences:
      json['preferences'] == null
          ? null
          : PreferencesVO.fromJson(json['preferences'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'isBanned': instance.isBanned,
  'isVerify': instance.isVerify,
  'userType': instance.userType,
  'profilePictureUrl': instance.profilePictureUrl,
  'status': instance.status,
  'languagePreference': instance.languagePreference,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'preferences': instance.preferences,
};

PreferencesVO _$PreferencesVOFromJson(Map<String, dynamic> json) =>
    PreferencesVO(
      favoriteGenres:
          (json['favoriteGenres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      favoriteActors:
          (json['favoriteActors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      favoriteCategories:
          (json['favoriteCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      favoriteDirectors:
          (json['favoriteDirectors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$PreferencesVOToJson(PreferencesVO instance) =>
    <String, dynamic>{
      'favoriteGenres': instance.favoriteGenres,
      'favoriteActors': instance.favoriteActors,
      'favoriteCategories': instance.favoriteCategories,
      'favoriteDirectors': instance.favoriteDirectors,
    };
