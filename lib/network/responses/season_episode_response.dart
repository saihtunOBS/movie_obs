import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/season_vo.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';

part 'season_episode_response.g.dart';

@JsonSerializable()
class SeasonEpisodeResponse {
  @JsonKey(name: "_id")
  final String? id;
  final String? name;
  final String? description;
  final int? sortOrder;
  final String? plan;
  final String? status;
  final bool? isTrending;
  final String? bannerImageUrl;
  final String? trailerUrl;
  final int? viewCount;
  final String? publishedYear;

  
  final List<ActorVO>? actors;
  final List<ActorVO>? actresses;
  final List<ActorVO>? supports;
  final String? createdAt;
  final String? updatedAt;

  @JsonKey(name: "episodes")
  final List<SeasonVO>? episodes;

  SeasonEpisodeResponse({
    this.id,
    this.name,
    this.description,
    this.sortOrder,
    this.plan,
    this.status,
    this.isTrending,
    this.bannerImageUrl,
    this.trailerUrl,
    this.viewCount,
    this.publishedYear,
    this.actors,
    this.actresses,
    this.supports,
    this.createdAt,
    this.updatedAt,
    this.episodes,
  });

  factory SeasonEpisodeResponse.fromJson(Map<String, dynamic> json) =>
      _$SeasonEpisodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SeasonEpisodeResponseToJson(this);
}
