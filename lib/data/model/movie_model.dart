import 'dart:io';

import 'package:movie_obs/data/vos/movie_vo.dart' show MovieVO;
import 'package:movie_obs/data/vos/user_vo.dart';
import 'package:movie_obs/network/requests/history_request.dart' show HistoryRequest;
import 'package:movie_obs/network/responses/movie_response.dart';
import 'package:movie_obs/network/responses/otp_response.dart';

import '../../network/requests/send_otp_request.dart' show SendOtpRequest;
import '../../network/requests/verify_otp_request.dart';
import '../../network/requests/watchlist_request.dart';
import '../../network/responses/actor_data_response.dart';
import '../../network/responses/ads_banner_response.dart';
import '../../network/responses/category_response.dart';
import '../../network/responses/faq_response.dart';
import '../../network/responses/genre_response.dart';
import '../../network/responses/movie_detail_response.dart';
import '../../network/responses/package_response.dart';
import '../../network/responses/season_episode_response.dart';
import '../../network/responses/season_response.dart';
import '../../network/responses/term_privacy_response.dart';
import '../../network/responses/watchlist_history_response.dart';

abstract class MovieModel {
  Future<OTPResponse> sendOtp(SendOtpRequest request);
  Future<OTPResponse> verifyOtp(VerifyOtpRequest request);
  Future<MovieResponse> getMovieLists(String token, String plan,String genre,int page);
  Future<MovieResponse> getSeriesLists(String token, String plan,String genre,int page);
  Future<MovieDetailResponse> getMovieDetail(String token, String id);
  Future<MovieDetailResponse> getSeriesDetail(
    String token,
    String id,
    bool isSeasonInclude,
  );
  Future<SeasonResponse> getSeason(String token);

  Future<MovieResponse> getAllMovieAndSeries(String token, String plan,String genre,String type,bool getAll,int page);
  Future<MovieResponse> getTopTrending(String token);
  Future<MovieResponse> getNewRelease(String token, String plan);

  Future<CategoryResponse> getAllCategory(String token);
  Future<GenreResponse> getAllGenre(String token);

  Future<AdsBannerResponse> getBanner(String token);
  Future<AdsBannerResponse> getAds(String token);

  Future<MovieResponse> getMovieSeriesByGenre(String token,String id);
  Future<MovieResponse> getMovieSeriesByCategory(String token,String id);

  Future<List<MovieVO>> getRecommendedMovie(String id);
  Future<List<MovieVO>> getRecommendedSeries(String id);
  Future<SeasonEpisodeResponse> getSeasonEpisode(String token,String id);

  Future<ActorDataResponse> getActorDetail(String token, String id);

  Future<PackageResponse> getAllPackage(String token);
  Future<UserVO> getUser(String token);
  Future<FaqResponse> getFaqs();

  Future<WatchlistHistoryResponse> getWatchlist(
    String token,
    String plan,
    String genres,
    String type,
    bool getAll,
    String user,
    int page
  );

  Future<WatchlistHistoryResponse> getHistory(
    String token,
    bool getAll,
    String user,
    int page
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
  Future<TermPrivacyResponse> getTremAndConditions(String token);
  Future<TermPrivacyResponse> getPrivacyPolicy(String token);
  Future<void> deleteUser(String token);
}
