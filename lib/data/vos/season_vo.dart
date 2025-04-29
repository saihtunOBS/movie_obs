import 'package:json_annotation/json_annotation.dart';

part 'season_vo.g.dart';

@JsonSerializable()
class SeasonVO {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "name")
  final String? name;

  @JsonKey(name: "description")
  final String? description;

  @JsonKey(name: "sortOrder")
  final int? sortOrder;

  @JsonKey(name: "plan")
  final String? plan;

  @JsonKey(name: "status")
  final String? status;

  @JsonKey(name: "isTrending")
  final bool? isTrending;

  @JsonKey(name: "bannerImageUrl")
  final String? bannerImageUrl;

  @JsonKey(name: "trailerUrl")
  final String? trailerUrl;

  @JsonKey(name: "viewCount")
  final int? viewCount;

  @JsonKey(name: "publishedYear")
  final String? publishedYear;

  @JsonKey(name: "series")
  final String? series;

  @JsonKey(name: "actors")
  final List<SeasonCastVO>? actors;

  @JsonKey(name: "actresses")
  final List<SeasonCastVO>? actresses;

  @JsonKey(name: "supports")
  final List<SeasonCastVO>? supports;

  @JsonKey(name: "createdAt")
  final String? createdAt;

  @JsonKey(name: "updatedAt")
  final String? updatedAt;

  @JsonKey(name: "duration")
  final int? duration;

  SeasonVO({
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
    this.series,
    this.actors,
    this.actresses,
    this.supports,
    this.createdAt,
    this.updatedAt,
    this.duration
  });

  factory SeasonVO.fromJson(Map<String, dynamic> json) => _$SeasonVOFromJson(json);

  Map<String, dynamic> toJson() => _$SeasonVOToJson(this);
}

@JsonSerializable()
class SeasonCastVO {
  @JsonKey(name: "cast")
  final String? cast;

  @JsonKey(name: "sortOrder")
  final int? sortOrder;

  @JsonKey(name: "characterName")
  final String? characterName;

  @JsonKey(name: "_id")
  final String? id;

  SeasonCastVO({
    this.cast,
    this.sortOrder,
    this.characterName,
    this.id,
  });

  factory SeasonCastVO.fromJson(Map<String, dynamic> json) => _$SeasonCastVOFromJson(json);

  Map<String, dynamic> toJson() => _$SeasonCastVOToJson(this);
}
