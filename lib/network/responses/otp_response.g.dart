// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTPResponse _$OTPResponseFromJson(Map<String, dynamic> json) =>
    OTPResponse(status: json['success'] as bool?, requestId: json['requestId']);

Map<String, dynamic> _$OTPResponseToJson(OTPResponse instance) =>
    <String, dynamic>{
      'success': instance.status,
      'requestId': instance.requestId,
    };
