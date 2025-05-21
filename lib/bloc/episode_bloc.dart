import 'package:flutter/cupertino.dart';
import 'package:movie_obs/data/vos/episode_vo.dart';

class EpisodeBloc extends ChangeNotifier {
  EpisodeVO? currentEpisode;
  EpisodeBloc(EpisodeVO episode) {
    currentEpisode = episode;
  }

  changeEpisode(EpisodeVO newEpisode) {
    currentEpisode = newEpisode;
    notifyListeners();
  }
}
