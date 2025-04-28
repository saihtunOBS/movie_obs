import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/login_screen.dart';

class HomeBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  List<MovieVO> movieLists = [];
  List<MovieVO> topTrendingMoviesList = [];
  List<MovieVO> newReleaseMoviesList = [];

  final MovieModel _movieModel = MovieModelImpl();

  HomeBloc(BuildContext context) {
    token = PersistenceData.shared.getToken();
    getAllMovie(context);
    getTopTrending();
    getNewRelease();
  }

  getAllMovie(BuildContext context) {
    _movieModel
        .getAllMovie(token)
        .then((response) {
          movieLists = response.data ?? [];
          notifyListeners();
        })
        .catchError((_) {
          PersistenceData.shared.clearToken();
          PageNavigator(ctx: context).nextPageOnly(page: LoginScreen());
        });
  }

  getTopTrending() {
    _movieModel.getTopTrending(token).then((response) {
      topTrendingMoviesList = response.data ?? [];
      notifyListeners();
    });
  }

  getNewRelease() {
    _movieModel.getNewRelease(token).then((response) {
      newReleaseMoviesList = response.data ?? [];
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
