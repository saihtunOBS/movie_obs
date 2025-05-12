import 'package:json_annotation/json_annotation.dart';

import '../../data/vos/season_vo.dart';

part 'movie_detail_response.g.dart';

@JsonSerializable()
class MovieDetailResponse {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "name")
  final String? name;

  @JsonKey(name: "description")
  final String? description;

  @JsonKey(name: "plan")
  final String? plan;

  @JsonKey(name: "status")
  final String? status;

  @JsonKey(name: "isTrending")
  final bool? isTrending;

  @JsonKey(name: "posterImageUrl")
  final String? posterImageUrl;

  @JsonKey(name: "bannerImageUrl")
  final String? bannerImageUrl;

  @JsonKey(name: "trailerUrl")
  final String? trailerUrl;

  @JsonKey(name: "videoUrl")
  final String? videoUrl;

  @JsonKey(name: "tags")
  final List<String>? tags;

  @JsonKey(name: "scriptWriter")
  final String? scriptWriter;

  @JsonKey(name: "viewCount")
  final int? viewCount;

  @JsonKey(name: "category")
  final CategoryVO? category;

  @JsonKey(name: "duration")
  final int? duration;

  @JsonKey(name: "publishedYear")
  final String? publishedYear;

  @JsonKey(name: "genres")
  final List<GenreVO>? genres;

  @JsonKey(name: "director")
  final String? director;

  @JsonKey(name: "actors")
  final List<ActorVO>? actors;

  @JsonKey(name: "actresses")
  final List<ActorVO>? actresses;

  @JsonKey(name: "supports")
  final List<ActorVO>? supports;

  @JsonKey(name: "createdAt")
  final String? createdAt;

  @JsonKey(name: "updatedAt")
  final String? updatedAt;

  @JsonKey(name: "seasons")
  final List<SeasonVO>? seasons;

  @JsonKey(name: "isWatchlisted")
  bool? isWatchlist;

  MovieDetailResponse({
    this.id,
    this.name,
    this.description,
    this.plan,
    this.status,
    this.isTrending,
    this.posterImageUrl,
    this.bannerImageUrl,
    this.trailerUrl,
    this.videoUrl,
    this.tags,
    this.scriptWriter,
    this.viewCount,
    this.category,
    this.duration,
    this.publishedYear,
    this.genres,
    this.director,
    this.actors,
    this.actresses,
    this.supports,
    this.createdAt,
    this.updatedAt,
    this.seasons,
    this.isWatchlist
  });

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailResponseToJson(this);
}

@JsonSerializable()
class CategoryVO {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "name")
  final String? name;

  @JsonKey(name: "createdAt")
  final String? createdAt;

  @JsonKey(name: "updatedAt")
  final String? updatedAt;

  CategoryVO({this.id, this.name, this.createdAt, this.updatedAt});

  factory CategoryVO.fromJson(Map<String, dynamic> json) =>
      _$CategoryVOFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryVOToJson(this);
}

@JsonSerializable()
class GenreVO {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "name")
  final String? name;

  @JsonKey(name: "genreIconUrl")
  final String? genreIconUrl;

  @JsonKey(name: "createdAt")
  final String? createdAt;

  @JsonKey(name: "updatedAt")
  final String? updatedAt;

  GenreVO({
    this.id,
    this.name,
    this.genreIconUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory GenreVO.fromJson(Map<String, dynamic> json) =>
      _$GenreVOFromJson(json);

  Map<String, dynamic> toJson() => _$GenreVOToJson(this);
}

@JsonSerializable()
class ActorVO {
  @JsonKey(name: "cast")
  final CastVO? cast;

  @JsonKey(name: "sortOrder")
  final int? sortOrder;

  @JsonKey(name: "characterName")
  final String? characterName;

  @JsonKey(name: "_id")
  final String? id;

  ActorVO({this.cast, this.sortOrder, this.characterName, this.id});

  factory ActorVO.fromJson(Map<String, dynamic> json) =>
      _$ActorVOFromJson(json);

  Map<String, dynamic> toJson() => _$ActorVOToJson(this);
}

@JsonSerializable()
class CastVO {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "name")
  final String? name;

  @JsonKey(name: "profilePictureUrl")
  final String? profilePictureUrl;

  @JsonKey(name: "role")
  final String? role;

  @JsonKey(name: "createdAt")
  final String? createdAt;

  @JsonKey(name: "updatedAt")
  final String? updatedAt;

  CastVO({
    this.id,
    this.name,
    this.profilePictureUrl,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory CastVO.fromJson(Map<String, dynamic> json) => _$CastVOFromJson(json);

  Map<String, dynamic> toJson() => _$CastVOToJson(this);
}
