import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/vos/adsAndBanner_vo.dart';

class AdsBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;

  List<AdsAndBannerVO> adsLists = [];
  final MovieModel _movieModel = MovieModelImpl();
  // BuildContext? _context;

  AdsBloc({BuildContext? context}) {
    getAds();
  }

  getAds() async {
    _showLoading();
    await _movieModel.getAds('').then((response) {
      adsLists = response.data ?? [];
      notifyListeners();
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
