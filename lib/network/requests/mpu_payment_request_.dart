import 'package:json_annotation/json_annotation.dart';

part 'mpu_payment_request_.g.dart';

@JsonSerializable()
class MpuPaymentRequest {
  @JsonKey(name: "user")
  String? user;
  @JsonKey(name: "plan")
  String? plan;
  @JsonKey(name: "paymentGateway")
  String? payment;
  @JsonKey(name: "isGift")
  bool? isGift;
  @JsonKey(name: "paymentGatewayMethod")
  String? method;
  @JsonKey(name: "paymentGatewayCustomerPhone")
  String? phone;

  MpuPaymentRequest(
    this.user,
    this.plan,
    this.payment,
    this.isGift,
    this.method,
    this.phone,
  );

  factory MpuPaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$MpuPaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MpuPaymentRequestToJson(this);
}
