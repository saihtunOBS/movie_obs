import 'dart:io';

import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/network/requests/history_request.dart';
import 'package:movie_obs/network/requests/send_otp_request.dart';
import 'package:movie_obs/network/requests/verify_otp_request.dart';
import 'package:movie_obs/network/requests/watchlist_request.dart';
import 'package:movie_obs/network/responses/actor_data_response.dart';
import 'package:movie_obs/network/responses/ads_banner_response.dart';
import 'package:movie_obs/network/responses/category_response.dart';
import 'package:movie_obs/network/responses/faq_response.dart';
import 'package:movie_obs/network/responses/genre_response.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/network/responses/movie_response.dart';
import 'package:movie_obs/network/responses/otp_response.dart';
import 'package:movie_obs/network/responses/package_response.dart';
import 'package:movie_obs/network/responses/season_episode_response.dart';
import 'package:movie_obs/network/responses/season_response.dart';

import '../../data/vos/user_vo.dart';
import '../responses/watchlist_history_response.dart';

abstract class MovieDataAgents {
  Future<OTPResponse> sendOtp(SendOtpRequest request);
  Future<OTPResponse> verifyOtp(VerifyOtpRequest request);

  Future<MovieResponse> getMovies(String token, String plan, String genre);
  Future<MovieResponse> getSeries(String token, String plan, String genre);
  Future<MovieDetailResponse> getMovieDetail(String token, String id);
  Future<MovieDetailResponse> getSeriesDetail(
    String token,
    String id,
    bool isSeasonInclude,
  );
  Future<SeasonResponse> getSeason(String token);

  Future<MovieResponse> getAllMovieAndSeries(
    String token,
    String plan,
    String genre,
    String type,
    bool getAll,
  );
  Future<MovieResponse> getTopTrending(String token, String plan);
  Future<MovieResponse> getNewRelease(String token, String plan);

  Future<MovieResponse> getMovieSeriesByGenre(String id);
  Future<MovieResponse> getMovieSeriesByCategory(String id);

  Future<CategoryResponse> getAllCategory(String token);
  Future<GenreResponse> getAllGenre(String token);

  Future<AdsBannerResponse> getBanner(String token);
  Future<AdsBannerResponse> getAds(String token);

  Future<List<MovieVO>> getRecommendedMovie(String id);
  Future<List<MovieVO>> getRecommendedSeries(String id);
  Future<SeasonEpisodeResponse> getSeasonEpisode(String id);

  Future<ActorDataResponse> getActorDetail(String token, String id);

  Future<PackageResponse> getAllPackage(String token);

  Future<UserVO> getUser(String token);
  Future<FaqResponse> getFaq();

  Future<WatchlistHistoryResponse> getWatchlist(
    String token,
    String plan,
    String genres,
    String type,
    bool getAll,
    String user,
  );
  Future<WatchlistHistoryResponse> getHistory(
    String token,
    bool getAll,
    String user,
  );

  Future<void> toggleWatchlist(String token, WatchlistRequest request);
  Future<void> toggleHistory(String token, HistoryRequest request);

  Future<UserVO> updateUser(
    String token,
    File? photo,
    String name,
    String email,
    String language,
  );
}
