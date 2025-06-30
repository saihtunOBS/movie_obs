import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/genre_vo.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/widgets/toast_service.dart';

class SearchBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  List<MovieVO> movieSeriesLists = [];
  final MovieModel _movieModel = MovieModelImpl();
  String id = '';
  List<GenreVO> genreLists = [];
  List<MovieVO> filteredSuggestions = [];

  SearchBloc({BuildContext? context, String? genreId}) {
    id = genreId ?? '';
    token = PersistenceData.shared.getToken();
    getMovieByGenre();
    getAllGenre();
  }

  getMovieByGenre() async {
    _showLoading();
    await _movieModel
        .getAllMovieAndSeries(token, '', id, 'BOTH', true, 1, '', '')
        .then((response) {
          movieSeriesLists = response.data ?? [];
          _hideLoading();
        })
        .catchError((e) {
          _hideLoading();
          ToastService.warningToast(e.toString());
        });
  }

  getAllGenre() {
    _movieModel.getAllGenre(token).then((response) {
      genreLists = response.data ?? [];
      notifyListeners();
    });
  }

  clearFilter() {
    filteredSuggestions.clear();
    notifyListeners();
  }

  void onSearchChanged(String value) {
    notifyListeners();
    if (value.isEmpty) {
      filteredSuggestions.clear();
      return;
    }
    filteredSuggestions =
        movieSeriesLists
            .where(
              (item) => item.name!.toLowerCase().contains(value.toLowerCase()),
            )
            .toList();

    notifyListeners();
  }

  filter(String type, String contextType) async {
    _showLoading();
    await _movieModel
        .getAllMovieAndSeries(token, type, id, contextType, false, 1, '', '')
        .then((response) {
          movieSeriesLists = response.data ?? [];
        })
        .whenComplete(() {
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
