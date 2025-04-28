import 'package:json_annotation/json_annotation.dart';

part 'adsAndBanner_vo.g.dart';

@JsonSerializable()
class AdsAndBannerVO {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "imageUrl")
  final String? image;

  AdsAndBannerVO({this.id, this.image});

  factory AdsAndBannerVO.fromJson(Map<String, dynamic> json) => _$AdsAndBannerVOFromJson(json);

  Map<String, dynamic> toJson() => _$AdsAndBannerVOToJson(this);
}
