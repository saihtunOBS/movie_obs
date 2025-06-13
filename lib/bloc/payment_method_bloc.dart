import 'package:flutter/cupertino.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/network/requests/payment_request.dart';
import 'package:movie_obs/network/responses/payment_response.dart';

class PaymentMethodBloc extends ChangeNotifier {
  bool isSelectPayment = false;
  String method = '';
  String payment = '';
  String digitalWalletPayment = '';
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  PaymentResponse? paymentResponse;
  final MovieModel _movieModel = MovieModelImpl();

  PaymentMethodBloc() {
    token = PersistenceData.shared.getToken();
  }

  selectedPayment(String paymentType) {
    payment = paymentType;
    if (paymentType == 'Pay with AYA Pay') {
      digitalWalletPayment = 'aya_inApp';
    } else {
      digitalWalletPayment = 'kbz_inApp';
    }

    notifyListeners();
  }

  selectedInAppOrQr(String type) {
    digitalWalletPayment = type;
    notifyListeners();
  }

  onSelectPaymentMethod(String selectedMethod) {
    method = selectedMethod;
    isSelectPayment = true;
    notifyListeners();
  }

  Future<PaymentResponse> createPayment(String paymentType, String plan) async {
    return Future.delayed(Duration(seconds: 1), () {
      var request = PaymentRequest(
        userDataListener.value.id ?? '',
        plan,
        paymentType,
        'QR_CODE',
        userDataListener.value.phone,
      );
      return _movieModel.createPayment(token, request);
    });
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
