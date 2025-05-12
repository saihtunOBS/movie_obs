import 'package:json_annotation/json_annotation.dart';

import '../../network/responses/movie_detail_response.dart';
part 'movie_vo.g.dart';

@JsonSerializable()
class MovieVO {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "type")
  final String? type;

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

  @JsonKey(name: "scheduleAt")
  final String? scheduleAt;

  @JsonKey(name: "genres")
  final List<GenreVO>? genres;

  @JsonKey(name: "director")
  final String? director;

  @JsonKey(name: "actors")
  final List<CastVO>? actors;

  @JsonKey(name: "actresses")
  final List<CastVO>? actresses;

  @JsonKey(name: "supports")
  final List<CastVO>? supports;

  @JsonKey(name: "isWatchlisted")
  bool? isWatchlist;

  @JsonKey(name: "createdAt")
  final String? createdAt;

  @JsonKey(name: "updatedAt")
  final String? updatedAt;

  MovieVO({
    this.type,
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
    this.scheduleAt,
    this.genres,
    this.director,
    this.actors,
    this.actresses,
    this.supports,
    this.createdAt,
    this.updatedAt,
    this.isWatchlist
  });

  factory MovieVO.fromJson(Map<String, dynamic> json) =>
      _$MovieVOFromJson(json);

  Map<String, dynamic> toJson() => _$MovieVOToJson(this);
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
class CastVO {
  @JsonKey(name: "cast")
  final String? cast;

  @JsonKey(name: "sortOrder")
  final int? sortOrder;

  @JsonKey(name: "characterName")
  final String? characterName;

  @JsonKey(name: "_id")
  final String? id;

  CastVO({this.cast, this.sortOrder, this.characterName, this.id});

  factory CastVO.fromJson(Map<String, dynamic> json) => _$CastVOFromJson(json);

  Map<String, dynamic> toJson() => _$CastVOToJson(this);
}
