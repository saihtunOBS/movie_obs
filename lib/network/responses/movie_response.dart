import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';

part 'movie_response.g.dart';

@JsonSerializable()
class MovieResponse {
  List<MovieVO>? data;

  MovieResponse({this.data});

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}
