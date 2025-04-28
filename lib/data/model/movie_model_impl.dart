import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/network/data_agents/movie_data_agents.dart';
import 'package:movie_obs/network/data_agents/movie_data_agents_impl.dart';
import 'package:movie_obs/network/requests/send_otp_request.dart';
import 'package:movie_obs/network/requests/verify_otp_request.dart';
import 'package:movie_obs/network/responses/category_response.dart';
import 'package:movie_obs/network/responses/genre_response.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/network/responses/movie_response.dart';
import 'package:movie_obs/network/responses/otp_response.dart';
import 'package:movie_obs/network/responses/season_response.dart';

class MovieModelImpl extends MovieModel {
  static final MovieModelImpl _singleton = MovieModelImpl._internal();

  factory MovieModelImpl() {
    return _singleton;
  }

  MovieModelImpl._internal();
  MovieDataAgents movieDataAgent = MovieDataAgentsImpl();

  @override
  Future<OTPResponse> sendOtp(SendOtpRequest request) {
    return movieDataAgent.sendOtp(request);
  }

  @override
  Future<OTPResponse> verifyOtp(VerifyOtpRequest request) {
    return movieDataAgent.verifyOtp(request);
  }

  @override
  Future<MovieResponse> getAllMovie(String token) {
    return movieDataAgent.getAllMovie(token);
  }

  @override
  Future<MovieResponse> getMovieLists(String token) {
    return movieDataAgent.getMovies(token);
  }

  @override
  Future<MovieResponse> getNewRelease(String token) {
    return movieDataAgent.getNewRelease(token);
  }

  @override
  Future<MovieResponse> getTopTrending(String token) {
    return movieDataAgent.getTopTrending(token);
  }

  @override
  Future<MovieResponse> getSeriesLists(String token) {
    return movieDataAgent.getSeries(token);
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(String token, String id) {
    return movieDataAgent.getMovieDetail(token, id);
  }

  @override
  Future<MovieDetailResponse> getSeriesDetail(
    String token,
    String id,
    bool isSeasonInclude,
  ) {
    return movieDataAgent.getSeriesDetail(token, id, isSeasonInclude);
  }

  @override
  Future<SeasonResponse> getSeason(String token) {
    return movieDataAgent.getSeason(token);
  }

  @override
  Future<CategoryResponse> getAllCategory(String token) {
    return movieDataAgent.getAllCategory(token);
  }

  @override
  Future<GenreResponse> getAllGenre(String token) {
    return movieDataAgent.getAllGenre(token);
  }
}
