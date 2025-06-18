import 'package:json_annotation/json_annotation.dart';

part 'call_mpu_request.g.dart';

@JsonSerializable()
class CallMpuRequest {
  @JsonKey(name: "amount")
  String? amount;
  @JsonKey(name: "merchantID")
  String? merchantID;
  @JsonKey(name: "currencyCode")
  String? currencyCode;
  @JsonKey(name: "userDefined1")
  String? userDefined1;
  @JsonKey(name: "productDesc")
  String? productDesc;
  @JsonKey(name: "invoiceNo")
  String? invoiceNo;
  @JsonKey(name: "hashValue")
  String? hashValue;

  CallMpuRequest({
    required this.amount,
    required this.merchantID,
    required this.currencyCode,
    required this.userDefined1,
    required this.productDesc,
    required this.invoiceNo,
    required this.hashValue,
  });

  factory CallMpuRequest.fromJson(Map<String, dynamic> json) =>
      _$CallMpuRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CallMpuRequestToJson(this);
}
