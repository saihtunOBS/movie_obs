import 'package:json_annotation/json_annotation.dart';

import '../../data/vos/movie_vo.dart';

part 'category_response.g.dart';

@JsonSerializable()
class CategoryResponse {
  List<CategoryVO>? data;

  CategoryResponse({this.data});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}
