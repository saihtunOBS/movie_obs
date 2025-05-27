import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/faq_vo.dart';

class FaqBloc extends ChangeNotifier {
  int selectedExpensionIndex = -1;
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  List<FaqVO> faqs = [];
  final MovieModel _movieModel = MovieModelImpl();

  FaqBloc() {
    token = PersistenceData.shared.getToken();
    getFaqs();
  }

  getFaqs() {
    _showLoading();
    _movieModel
        .getFaqs()
        .then((response) {
          faqs = response.data ?? [];
          notifyListeners();
        })
        .whenComplete(() {
          _hideLoading();
        });
  }

  _showLoading() {
    isLoading = true;
    _notifySafely();
  }
  onTapExpansion() {
    notifyListeners();
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
