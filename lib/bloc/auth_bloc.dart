import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/network/requests/send_otp_request.dart';
import 'package:movie_obs/network/requests/verify_otp_request.dart';
import 'package:movie_obs/network/responses/otp_response.dart';

class AuthBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;

  final MovieModel _movieModel = MovieModelImpl();

  _showLoading() {
    isLoading = true;
    _notifySafely();
  }

  hideLoading() {
    isLoading = false;
    _notifySafely();
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  Future getAuthUser() async {
    _showLoading();
    var _token = PersistenceData.shared.getToken();
    return _movieModel.getUser(_token).then((value) {
      print(value.email);
      hideLoading();
    });
  }

  Future<OTPResponse> verifyOtp(String phone, String requestId, String otp) {
    _showLoading();
    var request = VerifyOtpRequest(phone, 'CUSTOMER', otp, requestId);
    return _movieModel.verifyOtp(request).whenComplete(() {
      hideLoading();
    });
  }

  Future<OTPResponse> userLogin(String phoneNubmer) async {
    _showLoading();
    var request = SendOtpRequest(phoneNubmer);
    return _movieModel.sendOtp(request).whenComplete(() {
      hideLoading();
    });
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
