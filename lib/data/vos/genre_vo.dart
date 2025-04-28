import 'package:json_annotation/json_annotation.dart';

part 'genre_vo.g.dart';

@JsonSerializable()
class GenreVO {
  @JsonKey(name: "_id")
  final String? id;
  
  final String? name;
  final String? genreIconUrl;
  final String? createdAt;
  final String? updatedAt;

  GenreVO({
    this.id,
    this.name,
    this.genreIconUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory GenreVO.fromJson(Map<String, dynamic> json) => _$GenreVOFromJson(json);

  Map<String, dynamic> toJson() => _$GenreVOToJson(this);
}
