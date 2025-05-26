import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/network/responses/term_privacy_response.dart';

import '../data/persistence/persistence_data.dart';

class TermPrivacyBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;

  TermPrivacyResponse? termPrivacyResponse;
  TermPrivacyResponse? privacyResponse;
  final MovieModel _movieModel = MovieModelImpl();
  String token = '';
  TermPrivacyBloc({BuildContext? context}) {
    token = PersistenceData.shared.getToken();
    getTermAndConditions();
    getPrivacyPolicy();
  }

  getTermAndConditions() {
    _showLoading();
    _movieModel.getTremAndConditions(token).then((response) {
      termPrivacyResponse = response;
      _hideLoading();
    });
  }

  getPrivacyPolicy() {
    _showLoading();
    _movieModel.getPrivacyPolicy(token).then((response) {
      privacyResponse = response;
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
