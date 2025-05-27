import 'package:json_annotation/json_annotation.dart';

part 'notification_vo.g.dart';

@JsonSerializable()
class NotificationVo {
  @JsonKey(name: "_id")
  final String? id;
  
  final String? title;
  final String? body;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationVo({
    this.id,
    this.title,
    this.body,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationVo.fromJson(Map<String, dynamic> json) => _$NotificationVoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationVoToJson(this);
}
