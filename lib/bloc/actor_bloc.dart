import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/network/responses/actor_data_response.dart';

class ActorBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  ActorDataResponse? actorData;
  final MovieModel _movieModel = MovieModelImpl();
  String id = '';

  ActorBloc({BuildContext? context, String? actorId}) {
    id = actorId ?? '';
    token = PersistenceData.shared.getToken();
    getActorDetail();
  }

  getActorDetail() {
    _showLoading();
    _movieModel
        .getActorDetail(token, id)
        .then((response) {
          actorData = response;
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
