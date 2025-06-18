import 'package:json_annotation/json_annotation.dart';

part 'mpu_payment_response.g.dart';

@JsonSerializable()
class MpuPaymentResponse {
  @JsonKey(name: "paymentPageUrl")
  final String? paymentUrl;
  @JsonKey(name: "invoiceNo")
  final String? invoiceNo;
  MpuPaymentResponse({this.paymentUrl, this.invoiceNo});

  factory MpuPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$MpuPaymentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MpuPaymentResponseToJson(this);
}
