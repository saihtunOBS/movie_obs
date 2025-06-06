import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';

part 'collection_vo.g.dart';

@JsonSerializable()
class CollectionVO {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'items')
  final List<CollectionItemVO>? items;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  @JsonKey(name: '__v')
  final int? version;

  CollectionVO({
    this.id,
    this.name,
    this.items,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory CollectionVO.fromJson(Map<String, dynamic> json) =>
      _$CollectionVOFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionVOToJson(this);
}

@JsonSerializable()
class CollectionItemVO {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'reference')
  final MovieVO? reference;

  @JsonKey(name: 'referenceModel')
  final String? referenceModel;

  CollectionItemVO({this.id, this.reference, this.referenceModel});

  factory CollectionItemVO.fromJson(Map<String, dynamic> json) =>
      _$CollectionItemVOFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionItemVOToJson(this);
}
