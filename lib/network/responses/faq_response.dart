import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/faq_vo.dart';

part 'faq_response.g.dart';

@JsonSerializable()
class FaqResponse {
  List<FaqVO>? data;

  FaqResponse({this.data});

  factory FaqResponse.fromJson(Map<String, dynamic> json) =>
      _$FaqResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FaqResponseToJson(this);
}
