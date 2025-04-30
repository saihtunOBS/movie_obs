import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/package_vo.dart';

part 'package_response.g.dart';

@JsonSerializable()
class PackageResponse {
  @JsonKey(name: "data")
  final List<PackageVO>? data;


  PackageResponse({this.data});

  factory PackageResponse.fromJson(Map<String, dynamic> json) =>
      _$PackageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PackageResponseToJson(this);
}
