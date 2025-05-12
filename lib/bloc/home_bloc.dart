import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/adsAndBanner_vo.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/widgets/common_dialog.dart';
import 'package:movie_obs/widgets/error_dialog.dart';

class HomeBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  List<MovieVO> movieLists = [];
  List<MovieVO> freeMovieLists = [];

  List<MovieVO> topTrendingMoviesList = [];
  List<MovieVO> newReleaseMoviesList = [];
  List<AdsAndBannerVO> bannerList = [];
  List<AdsAndBannerVO> adsLists = [];
  final MovieModel _movieModel = MovieModelImpl();
  BuildContext? _context;

  HomeBloc({BuildContext? context}) {
    _context = context;
    token = PersistenceData.shared.getToken();
    getBanner();
    getFreeMovieAndSeries();
    getAllMovieAndSeries();
    getTopTrending();
    getNewRelease();
    getAds();
  }

  void onRefresh() {
    getBanner();
    getFreeMovieAndSeries();
    getAllMovieAndSeries();
    getTopTrending();
    getNewRelease();
  }

  getAllMovieAndSeries() {
    _movieModel
        .getAllMovieAndSeries(token, '', '', 'BOTH', false)
        .then((response) {
          movieLists = response.data ?? [];
          notifyListeners();
        })
        .catchError((_) {
          PersistenceData.shared.clearToken();
          Future.delayed(Duration(milliseconds: 200), () {
            showCommonDialog(
              context: _context!,
              isBarrierDismiss: false,
              dialogWidget: ErrorDialogView(
                errorMessage: 'Session Expired. Please Login Again',
                isLogin: true,
              ),
            );
          });
        });
  }

  getFreeMovieAndSeries() {
    _showLoading();
    _movieModel
        .getAllMovieAndSeries(token, 'FREE', '', 'BOTH', false)
        .then((response) {
          freeMovieLists = response.data ?? [];
          _hideLoading();
        })
        .whenComplete(() {
          _hideLoading();
        });
  }

  getTopTrending() {
    _movieModel.getTopTrending(token).then((response) {
      topTrendingMoviesList = response.data ?? [];
      notifyListeners();
    });
  }

  getNewRelease() {
    _movieModel.getNewRelease(token, '').then((response) {
      newReleaseMoviesList = response.data ?? [];
      notifyListeners();
    });
  }

  getBanner() {
    _movieModel.getBanner(token).then((response) {
      bannerList = response.data ?? [];
      notifyListeners();
    });
  }

  getAds() {
    _movieModel.getAds(token).then((response) {
      adsLists = response.data ?? [];
      notifyListeners();
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
