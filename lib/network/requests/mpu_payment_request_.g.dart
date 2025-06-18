// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mpu_payment_request_.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MpuPaymentRequest _$MpuPaymentRequestFromJson(Map<String, dynamic> json) =>
    MpuPaymentRequest(
      json['user'] as String?,
      json['plan'] as String?,
      json['paymentGateway'] as String?,
      json['isGift'] as bool?,
      json['paymentGatewayMethod'] as String?,
      json['paymentGatewayCustomerPhone'] as String?,
    );

Map<String, dynamic> _$MpuPaymentRequestToJson(MpuPaymentRequest instance) =>
    <String, dynamic>{
      'user': instance.user,
      'plan': instance.plan,
      'paymentGateway': instance.payment,
      'isGift': instance.isGift,
      'paymentGatewayMethod': instance.method,
      'paymentGatewayCustomerPhone': instance.phone,
    };
