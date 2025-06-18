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
  List<MovieVO> allMovieLists = [];
  List<MovieVO> filteredSuggestions = [];
  List<CategoryVO> categoryLists = [];
  List<GenreVO> genreLists = [];

  List<MovieVO> movieSeriesList = [];

  bool isLoadMore = false;
  int page = 1;
  String moviePlan = '';
  String movieGenre = '';

  final MovieModel _movieModel = MovieModelImpl();

  MovieBloc() {
    token = PersistenceData.shared.getToken();
    getMovieByPage();
    getAllMovies();
    getAllCategory();
    getAllGenre();
  }

  filterMovies(String plan, String genre) async {
    moviePlan = plan;
    movieGenre = genre;
    _showLoading();
    await _movieModel
        .getMovieLists(token, plan, genre, false, 1)
        .then((response) {
          movieLists = response.data ?? [];
        })
        .whenComplete(() {
          _hideLoading();
        });
  }

  getMovieByPage() {
    movieGenre = '';
    moviePlan = '';
    page = 1;
    _showLoading();
    _movieModel.getMovieLists(token, '', '', false, 1).then((response) {
      movieLists = response.data ?? [];
      _hideLoading();
    });
  }

  getAllMovies() {
    _showLoading();
    _movieModel.getMovieLists(token, '', '', true, 0).then((response) {
      allMovieLists = response.data ?? [];
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

  void onSearchChanged(String value) {
    notifyListeners();
    if (value.isEmpty) {
      filteredSuggestions.clear();
      return;
    }
    filteredSuggestions =
        allMovieLists
            .where(
              (item) => item.name!.toLowerCase().contains(value.toLowerCase()),
            )
            .toList();
    notifyListeners();
  }

  loadMoreData() {
    if (isLoadMore) return;
    _showLoadMoreLoading();
    page += 1;

    _movieModel
        .getMovieLists(token, moviePlan, movieGenre, false, page)
        .then((response) => movieLists.addAll(response.data ?? []))
        .whenComplete(() => _hideLoadMoreLoading());
  }

  _showLoadMoreLoading() {
    isLoadMore = true;
    _notifySafely();
  }

  _hideLoadMoreLoading() {
    isLoadMore = false;
    _notifySafely();
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
