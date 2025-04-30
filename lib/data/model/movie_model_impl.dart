import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/vos/movie_vo.dart' show MovieVO;
import 'package:movie_obs/network/data_agents/movie_data_agents.dart';
import 'package:movie_obs/network/data_agents/movie_data_agents_impl.dart';
import 'package:movie_obs/network/requests/send_otp_request.dart';
import 'package:movie_obs/network/requests/verify_otp_request.dart';
import 'package:movie_obs/network/responses/actor_data_response.dart';
import 'package:movie_obs/network/responses/ads_banner_response.dart';
import 'package:movie_obs/network/responses/category_response.dart';
import 'package:movie_obs/network/responses/genre_response.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/network/responses/movie_response.dart';
import 'package:movie_obs/network/responses/otp_response.dart';
import 'package:movie_obs/network/responses/package_response.dart';
import 'package:movie_obs/network/responses/season_episode_response.dart';
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
  Future<MovieResponse> getAllMovie(String token, String plan) {
    return movieDataAgent.getAllMovie(token, plan);
  }

  @override
  Future<MovieResponse> getMovieLists(String token, String plan) {
    return movieDataAgent.getMovies(token, plan);
  }

  @override
  Future<MovieResponse> getNewRelease(String token, String plan) {
    return movieDataAgent.getNewRelease(token, plan);
  }

  @override
  Future<MovieResponse> getTopTrending(String token) {
    return movieDataAgent.getTopTrending(token, '');
  }

  @override
  Future<MovieResponse> getSeriesLists(String token, String plan) {
    return movieDataAgent.getSeries(token, plan);
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

  @override
  Future<AdsBannerResponse> getAds(String token) {
    return movieDataAgent.getAds(token);
  }

  @override
  Future<AdsBannerResponse> getBanner(String token) {
    return movieDataAgent.getBanner(token);
  }

  @override
  Future<List<MovieVO>> getRecommendedMovie(String id) {
    return movieDataAgent.getRecommendedMovie(id);
  }

  @override
  Future<List<MovieVO>> getRecommendedSeries(String id) {
    return movieDataAgent.getRecommendedSeries(id);
  }

  @override
  Future<SeasonEpisodeResponse> getSeasonEpisode(String id) {
    return movieDataAgent.getSeasonEpisode(id);
  }

  @override
  Future<MovieResponse> getMovieSeriesByCategory(String id) {
    return movieDataAgent.getMovieSeriesByCategory(id);
  }

  @override
  Future<MovieResponse> getMovieSeriesByGenre(String id) {
    return movieDataAgent.getMovieSeriesByGenre(id);
  }

  @override
  Future<ActorDataResponse> getActorDetail(String token, String id) {
    return movieDataAgent.getActorDetail(token, id);
  }

  @override
  Future<PackageResponse> getAllPackage(String token) {
    return movieDataAgent.getAllPackage(token);
  }
}
