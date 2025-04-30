// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => UserVO.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{'data': instance.data};
