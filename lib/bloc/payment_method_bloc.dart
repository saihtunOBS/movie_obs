import 'package:flutter/cupertino.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/network/requests/mpu_payment_request_.dart';
import 'package:movie_obs/network/requests/payment_request.dart';
import 'package:movie_obs/network/responses/payment_response.dart';
import 'package:movie_obs/widgets/toast_service.dart';

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

  Future<void> createMpuPayment(bool isGift, String plan) async {
    _showLoading();
    var request = MpuPaymentRequest(
      userDataListener.value.id ?? '',
      plan,
      'mpu',
      isGift,
      '',
      '',
    );
    _movieModel
        .createMpuPayment(token, request)
        .then((response) {
          final url = Uri.parse(response.paymentUrl ?? '');
          final amount = url.queryParameters['amount'];
          final merchantID = url.queryParameters['merchantID'];
          final currencyCode = url.queryParameters['currencyCode'];
          final userDefined1 = url.queryParameters['userDefined1'];
          final productDesc = url.queryParameters['productDesc'];
          final invoiceNo = url.queryParameters['invoiceNo'];
          final hashValue = url.queryParameters['hashValue'];

          Future.delayed(Duration(milliseconds: 300), () {
            callMpuPayment(
              amount ?? '',
              merchantID,
              currencyCode,
              userDefined1,
              productDesc,
              invoiceNo,
              hashValue,
            );
          });
        })
        .catchError((e) {
          _hideLoading();
          ToastService.warningToast(e.toString());
        });
  }

  Future<void> callMpuPayment(
    String amount,
    merchantID,
    currencyCode,
    userDefined1,
    productDesc,
    invoiceNo,
    hashValue,
  ) {
    return _movieModel
        .callMpuPayment(
          amount: amount,
          merchantID: merchantID,
          currencyCode: currencyCode,
          userDefined1: userDefined1,
          productDesc: productDesc,
          invoiceNo: invoiceNo,
          hashValue: hashValue,
        )
        .then((response) {
          _hideLoading();
        })
        .catchError((e) {
          _hideLoading();
          print('youur error.....${e.toString()}');
          ToastService.warningToast(e.toString());
        });
  }

  _showLoading() {
    isLoading = true;
    _notifySafely();
  }

  _hideLoading() {
    isLoading = false;
    _notifySafely();
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
