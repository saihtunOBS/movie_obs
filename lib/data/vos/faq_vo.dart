import 'package:json_annotation/json_annotation.dart';

part 'faq_vo.g.dart';

@JsonSerializable()
class FaqVO {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "question")
  final String? question;

  @JsonKey(name: "answer")
  final String? answer;

  @JsonKey(name: "createdAt")
  final DateTime? createdAt;

  @JsonKey(name: "updatedAt")
  final DateTime? updatedAt;

  @JsonKey(name: "__v")
  final int? version;

  FaqVO({
    this.id,
    this.question,
    this.answer,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory FaqVO.fromJson(Map<String, dynamic> json) =>
      _$FaqVOFromJson(json);

  Map<String, dynamic> toJson() => _$FaqVOToJson(this);
}
