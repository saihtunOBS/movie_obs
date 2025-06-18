// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_mpu_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallMpuRequest _$CallMpuRequestFromJson(Map<String, dynamic> json) =>
    CallMpuRequest(
      amount: json['amount'] as String?,
      merchantID: json['merchantID'] as String?,
      currencyCode: json['currencyCode'] as String?,
      userDefined1: json['userDefined1'] as String?,
      productDesc: json['productDesc'] as String?,
      invoiceNo: json['invoiceNo'] as String?,
      hashValue: json['hashValue'] as String?,
    );

Map<String, dynamic> _$CallMpuRequestToJson(CallMpuRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'merchantID': instance.merchantID,
      'currencyCode': instance.currencyCode,
      'userDefined1': instance.userDefined1,
      'productDesc': instance.productDesc,
      'invoiceNo': instance.invoiceNo,
      'hashValue': instance.hashValue,
    };
