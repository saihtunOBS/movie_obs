import 'package:json_annotation/json_annotation.dart';

part 'episode_vo.g.dart';

@JsonSerializable()
class EpisodeVO {
  @JsonKey(name: "_id")
  final String? id;
  final String? name;
  final int? sortOrder;
  final String? description;
  final String? status;
  final String? plan;
  final String? trailerUrl;
  final String? videoUrl;
  final int? viewCount;
  final String? season;
  @JsonKey(name: "posterImageUrl")
  final String? posterImageUrl;
  final int? duration;
  final String? createdAt;
  final String? updatedAt;

  EpisodeVO({
    this.id,
    this.name,
    this.sortOrder,
    this.description,
    this.status,
    this.plan,
    this.trailerUrl,
    this.videoUrl,
    this.viewCount,
    this.season,
    this.posterImageUrl,
    this.duration,
    this.createdAt,
    this.updatedAt,
  });

  factory EpisodeVO.fromJson(Map<String, dynamic> json) => _$EpisodeVOFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeVOToJson(this);
}
