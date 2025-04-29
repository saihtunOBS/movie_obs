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

  final MovieModel _movieModel = MovieModelImpl();

  MovieBloc() {
    token = PersistenceData.shared.getToken();
    getAllMovie();
    getAllCategory();
    getAllGenre();
  }

  getAllMovie() {
    _movieModel.getMovieLists(token).then((response) {
      movieLists = response.data ?? [];
      notifyListeners();
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
        movieLists
            .where(
              (item) => item.name!.toLowerCase().contains(value.toLowerCase()),
            )
            .toList();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
