import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/adsAndBanner_vo.dart';

class BannerBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';

  List<AdsAndBannerVO> bannerList = [];
  final MovieModel _movieModel = MovieModelImpl();
  // BuildContext? _context;

  BannerBloc({BuildContext? context}) {
    // _context = context;
    token = PersistenceData.shared.getToken();

    getBanner();
  }

  getBanner() {
    _showLoading();
    _movieModel.getBanner(token).then((response) {
      bannerList = response.data ?? [];
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
