import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/adsAndBanner_vo.dart';
import 'package:movie_obs/data/vos/collection_vo.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/network/requests/view_count_request.dart';
import 'package:movie_obs/network/responses/collection_detail_response.dart';

class HomeBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  bool isLoadMore = false;
  String token = '';
  List<MovieVO> movieLists = [];
  List<MovieVO> freeMovieLists = [];
  int page = 1;
  String? moviePlan;
  String? movieGenre;
  String? movieContentType;

  List<MovieVO> topTrendingMoviesList = [];
  List<MovieVO> newReleaseMoviesList = [];
  List<AdsAndBannerVO> bannerList = [];
  List<CollectionVO> categoryCollectionLists = [];
  CollectionDetailResponse? collectionDetail;

  final MovieModel _movieModel = MovieModelImpl();

  HomeBloc({
    BuildContext? context,
    bool? isCollectionDetail,
    String? collectionId,
  }) {
    token = PersistenceData.shared.getToken();

    getBanner();
    if (isCollectionDetail == true) {
      getCollectionDetail(collectionId ?? '');
    }
  }

  void onRefresh() {
    getBanner();
  }

  void updateToken() {
    token = PersistenceData.shared.getToken();
    notifyListeners();
  }

  Future<void> updateViewCount(String type, String id) {
    updateToken();
    var request = ViewCountRequest(type);
    return _movieModel.updateViewCount(token, id, request);
  }

  getAllMovieAndSeries() {
    _movieModel
        .getAllMovieAndSeries(token, '', '', 'BOTH', false, 1)
        .then((response) {
          movieLists = response.data ?? [];
          getTopTrending();
          notifyListeners();
        })
        .catchError((_) {});
  }

  getFreeMovieAndSeries() {
    page = 1;
    moviePlan = '';
    movieGenre = '';
    movieContentType = '';
    _showLoading();
    _movieModel
        .getAllMovieAndSeries(token, 'FREE', '', 'BOTH', false, 1)
        .then((response) {
          freeMovieLists = response.data ?? [];
          getAllMovieAndSeries();
          _hideLoading();
        })
        .whenComplete(() {
          _hideLoading();
        });
  }

  filter(String plan, String genre, String contentType) async {
    moviePlan = plan;
    movieGenre = genre;
    movieContentType = contentType;
    _showLoading();
    _movieModel
        .getAllMovieAndSeries(token, 'FREE', genre, contentType, false, 1)
        .then((response) {
          freeMovieLists = response.data ?? [];
          _hideLoading();
        })
        .whenComplete(() {
          _hideLoading();
        });
  }

  getCollectionDetail(String id) {
    _showLoading();
    _movieModel
        .getCategoryCollectionDetail(token, id)
        .then((response) {
          collectionDetail = response;
          _hideLoading();
        })
        .whenComplete(() {
          _hideLoading();
        });
  }

  loadMoreFreeMovieAndSeries() {
    if (isLoadMore) return;
    _showLoadMoreLoading();
    page += 1;

    _movieModel
        .getAllMovieAndSeries(
          token,
          'FREE',
          movieGenre ?? '',
          movieContentType ?? '',
          false,
          page,
        )
        .then((response) => freeMovieLists.addAll(response.data ?? []))
        .whenComplete(() => _hideLoadMoreLoading());
  }

  onTapExpansion() {
    notifyListeners();
  }

  _showLoadMoreLoading() {
    isLoadMore = true;
    _notifySafely();
  }

  _hideLoadMoreLoading() {
    isLoadMore = false;
    _notifySafely();
  }

  getTopTrending() {
    _movieModel.getTopTrending(token).then((response) {
      topTrendingMoviesList = response.data ?? [];
      getNewRelease();
      notifyListeners();
    });
  }

  getNewRelease() {
    _movieModel.getNewRelease(token, '').then((response) {
      newReleaseMoviesList = response.data ?? [];
      getCategoryCollections();
      notifyListeners();
    });
  }

  getCategoryCollections() async {
    _movieModel.getCategoryCollection(token).then((response) {
      categoryCollectionLists = response.data ?? [];
      notifyListeners();
    });
  }

  getBanner() {
    _movieModel.getBanner(token).then((response) {
      bannerList = response.data ?? [];
      getFreeMovieAndSeries();
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
