import 'package:json_annotation/json_annotation.dart';

part 'payment_response.g.dart';

@JsonSerializable()
class PaymentResponse {
  @JsonKey(name: "qrdata")
  final String? qrData;
  @JsonKey(name: "invoiceNo")
  final String? invoiceNo;
  PaymentResponse({this.qrData, this.invoiceNo});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResponseToJson(this);
}
