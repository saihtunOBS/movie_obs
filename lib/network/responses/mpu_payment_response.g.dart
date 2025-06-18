// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mpu_payment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MpuPaymentResponse _$MpuPaymentResponseFromJson(Map<String, dynamic> json) =>
    MpuPaymentResponse(
      paymentUrl: json['paymentPageUrl'] as String?,
      invoiceNo: json['invoiceNo'] as String?,
    );

Map<String, dynamic> _$MpuPaymentResponseToJson(MpuPaymentResponse instance) =>
    <String, dynamic>{
      'paymentPageUrl': instance.paymentUrl,
      'invoiceNo': instance.invoiceNo,
    };
