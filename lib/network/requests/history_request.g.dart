// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryRequest _$HistoryRequestFromJson(Map<String, dynamic> json) =>
    HistoryRequest(
      json['user'] as String?,
      json['reference'] as String?,
      (json['duration'] as num?)?.toInt(),
      json['type'] as String?,
    );

Map<String, dynamic> _$HistoryRequestToJson(HistoryRequest instance) =>
    <String, dynamic>{
      'user': instance.user,
      'reference': instance.reference,
      'duration': instance.duration,
      'type': instance.type,
    };
