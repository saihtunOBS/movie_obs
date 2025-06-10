import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/network/requests/redeem_code_request.dart';
import 'package:movie_obs/network/responses/gift_data_response.dart';

class GiftCartBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  GiftDataResponse? giftResponse;
  final MovieModel _movieModel = MovieModelImpl();

  GiftCartBloc({BuildContext? context}) {
    token = PersistenceData.shared.getToken();
    getGift();
  }

  Future<void> claimGift(String code) {
    var request = RedeemCodeRequest(code);
    return _movieModel.redeemCode(
      token,
      userDataListener.value.id ?? '',
      request,
    );
  }

  void getGift() {
    _showLoading();
    _movieModel
        .getGift(token, userDataListener.value.id ?? '')
        .then((response) {
          giftResponse = response;
          _hideLoading();
        })
        .whenComplete(() {
          _hideLoading();
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
