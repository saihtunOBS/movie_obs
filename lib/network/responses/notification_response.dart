import 'package:json_annotation/json_annotation.dart';
import 'package:movie_obs/data/vos/notification_vo.dart';

part 'notification_response.g.dart';

@JsonSerializable()
class NotificationResponse {
  List<NotificationVo>? data;

  NotificationResponse({this.data});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);
}

