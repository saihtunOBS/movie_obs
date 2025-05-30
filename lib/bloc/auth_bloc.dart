import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
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

  _hideLoading() {
    isLoading = false;
    _notifySafely();
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  Future<OTPResponse> verifyOtp(String phone, String requestId, String otp) {
    _showLoading();
    var request = VerifyOtpRequest(phone, 'CUSTOMER', otp, requestId);
    return _movieModel.verifyOtp(request).whenComplete(() {
      _hideLoading();
    });
  }

  Future<OTPResponse> userLogin(String phoneNubmer) async {
    _showLoading();
    var request = SendOtpRequest(phoneNubmer);
    return _movieModel.sendOtp(request).whenComplete(() {
      _hideLoading();
    });
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
