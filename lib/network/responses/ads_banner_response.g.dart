// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_banner_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdsBannerResponse _$AdsBannerResponseFromJson(Map<String, dynamic> json) =>
    AdsBannerResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => AdsAndBannerVO.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$AdsBannerResponseToJson(AdsBannerResponse instance) =>
    <String, dynamic>{'data': instance.data};
