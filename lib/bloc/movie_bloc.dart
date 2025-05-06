import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/genre_vo.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';

class MovieBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  List<MovieVO> movieLists = [];
  List<MovieVO> topTrendingMoviesList = [];
  List<MovieVO> newReleaseMoviesList = [];
  List<MovieVO> filteredSuggestions = [];
  List<CategoryVO> categoryLists = [];
  List<GenreVO> genreLists = [];

  List<MovieVO> movieSeriesList = [];

  final MovieModel _movieModel = MovieModelImpl();

  MovieBloc() {
    token = PersistenceData.shared.getToken();
    getAllMovie();
    getMovieSeries();
    getAllCategory();
    getAllGenre();
  }

  getMovieSeries() {
    _showLoading();
    _movieModel.getAllMovie(token, '', '').then((response) {
      movieSeriesList = response.data ?? [];
      _hideLoading();
    });
  }

  filterMovies(String type, String genre) {
    _showLoading();
    _movieModel.getAllMovie(token, type, genre).then((response) {
      movieSeriesList = response.data ?? [];
      _hideLoading();
    });
    // movieLists =
    //     movieLists.where((movie) {
    //       return movie.type == type && (movie.genres?.contains(genre) ?? true);
    //     }).toList();
    // notifyListeners();
  }

  getAllMovie() {
    _showLoading();
    _movieModel.getMovieLists(token, '', '').then((response) {
      movieLists = response.data ?? [];
      _hideLoading();
    });
  }

  clearFilter() {
    filteredSuggestions.clear();
    notifyListeners();
  }

  getAllCategory() {
    _movieModel.getAllCategory(token).then((response) {
      categoryLists = response.data ?? [];
      notifyListeners();
    });
  }

  getAllGenre() {
    _movieModel.getAllGenre(token).then((response) {
      genreLists = response.data ?? [];
      notifyListeners();
    });
  }

  void onSearchChanged(String value, {bool? isSearchScreen}) {
    notifyListeners();
    if (value.isEmpty) {
      filteredSuggestions.clear();
      return;
    }
    filteredSuggestions =
        isSearchScreen == true
            ? movieSeriesList
                .where(
                  (item) =>
                      item.name!.toLowerCase().contains(value.toLowerCase()),
                )
                .toList()
            : movieLists
                .where(
                  (item) =>
                      item.name!.toLowerCase().contains(value.toLowerCase()),
                )
                .toList();
    notifyListeners();
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
