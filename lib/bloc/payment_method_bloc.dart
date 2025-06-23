import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/network/requests/call_mpu_request.dart';
import 'package:movie_obs/network/requests/mpu_payment_request_.dart';
import 'package:movie_obs/network/requests/payment_request.dart';
import 'package:movie_obs/network/responses/payment_response.dart';
import 'package:movie_obs/screens/profile/payment_web_screen.dart';
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
  BuildContext? myContext;
  final MovieModel _movieModel = MovieModelImpl();

  PaymentMethodBloc(BuildContext context) {
    myContext = context;
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

  void show() {
    _showLoading();
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
      '0988888888888',
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

          var request = CallMpuRequest(
            amount: amount,
            merchantID: merchantID,
            currencyCode: currencyCode,
            userDefined1: userDefined1,
            productDesc: productDesc,
            invoiceNo: invoiceNo,
            hashValue: hashValue,
          );

          Future.delayed(Duration(milliseconds: 300), () {
            launchPayment(request);
          });
        })
        .catchError((e) {
          _hideLoading();
          ToastService.warningToast(e.toString());
        });
  }

  Future<void> createGlobalPayment(bool isGift, String plan) async {
    _showLoading();
    var request = MpuPaymentRequest(
      userDataListener.value.id ?? '',
      plan,
      'cybersource',
      false,
      '',
      '0988888888888',
    );
    _movieModel
        .createMpuPayment(token, request)
        .then((response) {
          final url = Uri.parse(response.paymentUrl ?? '');

          var formRequest = <String, String>{
            "access_key": url.queryParameters['access_key'] ?? '',
            "profile_id": url.queryParameters['profile_id'] ?? '',
            "transaction_uuid": url.queryParameters['transaction_uuid'] ?? '',
            "signed_date_time": url.queryParameters['signed_date_time'] ?? '',
            "signed_field_names":
                url.queryParameters['signed_field_names'] ?? '',
            "locale": url.queryParameters['locale'] ?? '',
            "transaction_type": url.queryParameters['transaction_type'] ?? '',
            "reference_number": url.queryParameters['reference_number'] ?? '',
            "amount": url.queryParameters['amount'] ?? '',
            "currency": url.queryParameters['currency'] ?? '',
            "signature": url.queryParameters['signature'] ?? '',
          };

          Future.delayed(Duration(milliseconds: 300), () {
            launchGlobalPayment(formRequest);
          });
        })
        .catchError((e) {
          _hideLoading();
          ToastService.warningToast(e.toString());
        });
  }

  Future<void> launchGlobalPayment(dynamic formRequest) async {
    _hideLoading();

    showDialog(
      context: myContext!,
      useSafeArea: true,

      barrierColor: Colors.transparent,
      builder: (context) {
        return PaymentWebScreen(
          paymentUrl: 'https://testsecureacceptance.cybersource.com/pay',
          postData: formRequest,
        );
      },
    );
  }

  Future<void> launchPayment(CallMpuRequest request) async {
    _hideLoading();
    var formRequest = <String, String>{
      "amount": request.amount ?? '',
      "merchantID": request.merchantID ?? '',
      "currencyCode": request.currencyCode ?? '',
      "userDefined1": request.userDefined1 ?? '',
      "productDesc": request.productDesc ?? '',
      "invoiceNo": request.invoiceNo ?? '',
      "hashValue": request.hashValue ?? '',
    };

    showDialog(
      context: myContext!,
      useSafeArea: true,

      barrierColor: Colors.transparent,
      builder: (context) {
        return PaymentWebScreen(
          paymentUrl: 'https://www.mpuecomuat.com/UAT/Payment/Payment/pay',
          postData: formRequest,
        );
      },
    );
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
