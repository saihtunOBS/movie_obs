import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/network/data_agents/movie_data_agents.dart';
import 'package:movie_obs/network/data_agents/movie_data_agents_impl.dart';

class MovieModelImpl extends MovieModel {
  static final MovieModelImpl _singleton = MovieModelImpl._internal();

  factory MovieModelImpl() {
    return _singleton;
  }

  MovieModelImpl._internal();
  MovieDataAgents tmsDataAgent = MovieDataAgentsImpl();
}
