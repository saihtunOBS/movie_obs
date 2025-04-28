import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/genre_vo.dart';

part 'genre_response.g.dart';

@JsonSerializable()
class GenreResponse {
  List<GenreVO>? data;

  GenreResponse({this.data});

  factory GenreResponse.fromJson(Map<String, dynamic> json) =>
      _$GenreResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenreResponseToJson(this);
}
