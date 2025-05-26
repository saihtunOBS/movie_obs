import 'package:json_annotation/json_annotation.dart';

part 'term_privacy_response.g.dart';

@JsonSerializable()
class TermPrivacyResponse {
  @JsonKey(name: "_id")
  final String? id;
  final String? content;
  
  
  TermPrivacyResponse({
    this.id,
    this.content
  });

  factory TermPrivacyResponse.fromJson(Map<String, dynamic> json) =>
      _$TermPrivacyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TermPrivacyResponseToJson(this);
}
