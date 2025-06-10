import 'package:json_annotation/json_annotation.dart';

part 'gift_data_response.g.dart';

@JsonSerializable()
class GiftDataResponse {
  final List<GiftVO>? data;
  final int? count;
  final int? currentPage;
  final int? totalPages;

  GiftDataResponse({this.data, this.count, this.currentPage, this.totalPages});

  factory GiftDataResponse.fromJson(Map<String, dynamic> json) =>
      _$GiftDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GiftDataResponseToJson(this);
}

@JsonSerializable()
class GiftVO {
  @JsonKey(name: "_id")
  final String? id;
  final String? code;
  final String? sender;
  final String? receiver;
  final PlanVO? plan;
  final String? status;

  final String? subscription;

  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? redeemedAt;

  GiftVO({
    this.id,
    this.code,
    this.sender,
    this.receiver,
    this.plan,
    this.status,
    this.subscription,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
    this.redeemedAt,
  });

  factory GiftVO.fromJson(Map<String, dynamic> json) => _$GiftVOFromJson(json);

  Map<String, dynamic> toJson() => _$GiftVOToJson(this);
}

@JsonSerializable()
class PlanVO {
  @JsonKey(name: "_id")
  final String? id;
  final String? name;
  final String? description;
  final int? price;
  final String? currency;
  final int? duration;
  final bool? status;
  final bool? isPopular;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PlanVO({
    this.id,
    this.name,
    this.description,
    this.price,
    this.currency,
    this.duration,
    this.status,
    this.isPopular,
    this.createdAt,
    this.updatedAt,
  });

  factory PlanVO.fromJson(Map<String, dynamic> json) => _$PlanVOFromJson(json);

  Map<String, dynamic> toJson() => _$PlanVOToJson(this);
}
