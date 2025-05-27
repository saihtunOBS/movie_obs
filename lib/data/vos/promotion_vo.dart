import 'package:json_annotation/json_annotation.dart';

part 'promotion_vo.g.dart';

@JsonSerializable()
class PromotionVo {
  @JsonKey(name: "_id")
  final String? id;
  final String? name;
  final bool? status;
  final int? discount;
  final DateTime? startDate;
  final DateTime? endDate;
  
  PromotionVo({
    this.id,
    this.name,
    this.discount,
    this.status,
    this.startDate,
    this.endDate
  });

  factory PromotionVo.fromJson(Map<String, dynamic> json) =>
      _$PromotionVoFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionVoToJson(this);
}
