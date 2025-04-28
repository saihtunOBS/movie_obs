import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/adsAndBanner_vo.dart';

part 'ads_banner_response.g.dart';

@JsonSerializable()
class AdsBannerResponse {
  List<AdsAndBannerVO>? data;

  AdsBannerResponse({this.data});

  factory AdsBannerResponse.fromJson(Map<String, dynamic> json) =>
      _$AdsBannerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdsBannerResponseToJson(this);
}
