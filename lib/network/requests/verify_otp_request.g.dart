// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpRequest _$VerifyOtpRequestFromJson(Map<String, dynamic> json) =>
    VerifyOtpRequest(json['phone'] as String?)
      ..userType = json['userType'] as String?
      ..otp = json['otp'] as String?
      ..requestId = json['request'] as String?;

Map<String, dynamic> _$VerifyOtpRequestToJson(VerifyOtpRequest instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'userType': instance.userType,
      'otp': instance.otp,
      'request': instance.requestId,
    };
