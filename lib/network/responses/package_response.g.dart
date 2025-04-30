// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageResponse _$PackageResponseFromJson(Map<String, dynamic> json) =>
    PackageResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => PackageVO.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$PackageResponseToJson(PackageResponse instance) =>
    <String, dynamic>{'data': instance.data};
