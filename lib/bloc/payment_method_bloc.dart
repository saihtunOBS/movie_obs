import 'package:flutter/cupertino.dart';

class PaymentMethodBloc extends ChangeNotifier {
  bool isSelectPayment = false;
  String method = '';
  String payment = '';
  selectedPayment(String paymentType) {
    payment = paymentType;
    notifyListeners();
  }

  onSelectPaymentMethod(String selectedMethod) {
    method = selectedMethod;
    isSelectPayment = true;
    notifyListeners();
  }
}
