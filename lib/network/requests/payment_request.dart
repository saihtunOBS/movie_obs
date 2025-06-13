import 'package:json_annotation/json_annotation.dart';

part 'payment_request.g.dart';

@JsonSerializable()
class PaymentRequest {
  @JsonKey(name: "user")
  String? user;
  @JsonKey(name: "plan")
  String? plan;
  @JsonKey(name: "paymentGateway")
  String? payment;
  @JsonKey(name: "paymentGatewayMethod")
  String? method;
  @JsonKey(name: "paymentGatewayCustomerPhone")
  String? phone;

  PaymentRequest(this.user, this.plan, this.payment, this.method, this.phone);

  factory PaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}
