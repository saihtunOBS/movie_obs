// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest(
      json['user'] as String?,
      json['plan'] as String?,
      json['paymentGateway'] as String?,
      json['paymentGatewayMethod'] as String?,
      json['paymentGatewayCustomerPhone'] as String?,
    );

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'user': instance.user,
      'plan': instance.plan,
      'paymentGateway': instance.payment,
      'paymentGatewayMethod': instance.method,
      'paymentGatewayCustomerPhone': instance.phone,
    };
