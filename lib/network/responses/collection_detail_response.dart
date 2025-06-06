import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/collection_vo.dart';

part 'collection_detail_response.g.dart';

@JsonSerializable()
class CollectionDetailResponse {
  @JsonKey(name: "_id")
  final String? id;

  final String? name;
  @JsonKey(name: 'items')
  final List<CollectionItemVO>? items;

  CollectionDetailResponse({this.id, this.name, this.items});

  factory CollectionDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$CollectionDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionDetailResponseToJson(this);
}
