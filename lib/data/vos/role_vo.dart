import 'package:json_annotation/json_annotation.dart';

part 'role_vo.g.dart';

@JsonSerializable()
class RoleVO {
  @JsonKey(name: "_id")
  final String? id;
  final String? role;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  RoleVO({
    this.id,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory RoleVO.fromJson(Map<String, dynamic> json) => _$RoleVOFromJson(json);

  Map<String, dynamic> toJson() => _$RoleVOToJson(this);
}
