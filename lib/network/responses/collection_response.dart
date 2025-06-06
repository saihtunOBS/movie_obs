import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/collection_vo.dart';

part 'collection_response.g.dart';

@JsonSerializable()
class CollectionResponse {
  List<CollectionVO>? data;

  CollectionResponse({this.data});

  factory CollectionResponse.fromJson(Map<String, dynamic> json) =>
      _$CollectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionResponseToJson(this);
}
