import 'package:json_annotation/json_annotation.dart';

part 'package_vo.g.dart';

@JsonSerializable()
class PackageVO {
  @JsonKey(name: "_id")
  final String? id;

  final String? name;
  final String? description;
  final int? price;
  final String? currency;
  final int? duration;
  final bool? status;
  final bool? isPopular;

  @JsonKey(name: "createdAt")
  final String? createdAt;

  @JsonKey(name: "updatedAt")
  final String? updatedAt;

  PackageVO({
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

  factory PackageVO.fromJson(Map<String, dynamic> json) =>
      _$PackageVOFromJson(json);

  Map<String, dynamic> toJson() => _$PackageVOToJson(this);
}
