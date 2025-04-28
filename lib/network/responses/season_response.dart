import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/season_vo.dart';

part 'season_response.g.dart';

@JsonSerializable()
class SeasonResponse {
  List<SeasonVO>? data;

  SeasonResponse({this.data});

  factory SeasonResponse.fromJson(Map<String, dynamic> json) =>
      _$SeasonResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SeasonResponseToJson(this);
}
