import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/data/vos/role_vo.dart';
import 'package:movie_obs/data/vos/season_vo.dart';

part 'actor_data_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ActorDataResponse {
  @JsonKey(name: "_id")
  final String? id;

  final String? name;

  @JsonKey(name: "profilePictureUrl")
  final String? profilePictureUrl;

  @JsonKey(name: "role")
  final RoleVO? role;

  @JsonKey(name: "createdAt")
  final String? createdAt;

  @JsonKey(name: "updatedAt")
  final String? updatedAt;

  @JsonKey(name: "movieCounts")
  final int? movieCounts;

  @JsonKey(name: "movies")
  final List<MovieVO>? movies;

  @JsonKey(name: "seasons")
  final List<SeasonVO>? seasons;

  ActorDataResponse({
    this.id,
    this.name,
    this.profilePictureUrl,
    this.createdAt,
    this.updatedAt,
    this.movieCounts,
    this.role,
    this.movies,
    this.seasons,
  });

  factory ActorDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ActorDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ActorDataResponseToJson(this);
}
