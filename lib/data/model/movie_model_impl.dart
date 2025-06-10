import 'dart:io';

import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/vos/movie_vo.dart' show MovieVO;
import 'package:movie_obs/data/vos/user_vo.dart';
import 'package:movie_obs/network/data_agents/movie_data_agents.dart';
import 'package:movie_obs/network/data_agents/movie_data_agents_impl.dart';
import 'package:movie_obs/network/requests/history_request.dart';
import 'package:movie_obs/network/requests/redeem_code_request.dart';
import 'package:movie_obs/network/requests/send_otp_request.dart';
import 'package:movie_obs/network/requests/verify_otp_request.dart';
import 'package:movie_obs/network/requests/view_count_request.dart';
import 'package:movie_obs/network/requests/watchlist_request.dart';
import 'package:movie_obs/network/responses/actor_data_response.dart';
import 'package:movie_obs/network/responses/ads_banner_response.dart';
import 'package:movie_obs/network/responses/category_response.dart';
import 'package:movie_obs/network/responses/collection_detail_response.dart';
import 'package:movie_obs/network/responses/collection_response.dart';
import 'package:movie_obs/network/responses/faq_response.dart';
import 'package:movie_obs/network/responses/genre_response.dart';
import 'package:movie_obs/network/responses/gift_data_response.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/network/responses/movie_response.dart';
import 'package:movie_obs/network/responses/notification_response.dart';
import 'package:movie_obs/network/responses/otp_response.dart';
import 'package:movie_obs/network/responses/package_response.dart';
import 'package:movie_obs/network/responses/season_episode_response.dart';
import 'package:movie_obs/network/responses/season_response.dart';
import 'package:movie_obs/network/responses/term_privacy_response.dart';
import 'package:movie_obs/network/responses/watchlist_history_response.dart';

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
  Future<MovieResponse> getAllMovieAndSeries(
    String token,
    String plan,
    String genre,
    String type,
    bool getAll,
    int page,
  ) {
    return movieDataAgent.getAllMovieAndSeries(
      token,
      plan,
      genre,
      type,
      getAll,
      page,
    );
  }

  @override
  Future<MovieResponse> getMovieLists(
    String token,
    String plan,
    String genre,
    int page,
  ) {
    return movieDataAgent.getMovies(token, plan, genre, page);
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
  Future<MovieResponse> getSeriesLists(
    String token,
    String plan,
    String genre,
    int page,
  ) {
    return movieDataAgent.getSeries(token, plan, genre, page);
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
  Future<SeasonEpisodeResponse> getSeasonEpisode(String token, String id) {
    return movieDataAgent.getSeasonEpisode(token, id);
  }

  @override
  Future<MovieResponse> getMovieSeriesByCategory(String token, String id) {
    return movieDataAgent.getMovieSeriesByCategory(token, id);
  }

  @override
  Future<MovieResponse> getMovieSeriesByGenre(String token, String id) {
    return movieDataAgent.getMovieSeriesByGenre(token, id);
  }

  @override
  Future<ActorDataResponse> getActorDetail(String token, String id) {
    return movieDataAgent.getActorDetail(token, id);
  }

  @override
  Future<PackageResponse> getAllPackage(String token) {
    return movieDataAgent.getAllPackage(token);
  }

  @override
  Future<UserVO> getUser(String token) {
    return movieDataAgent.getUser(token);
  }

  @override
  Future<FaqResponse> getFaqs() {
    return movieDataAgent.getFaq();
  }

  @override
  Future<WatchlistHistoryResponse> getHistory(
    String token,
    bool getAll,
    String user,
    int page,
  ) {
    return movieDataAgent.getHistory(token, getAll, user, page);
  }

  @override
  Future<WatchlistHistoryResponse> getWatchlist(
    String token,
    String plan,
    String genres,
    String type,
    bool getAll,
    String user,
    int page,
  ) {
    return movieDataAgent.getWatchlist(
      token,
      plan,
      genres,
      type,
      getAll,
      user,
      page,
    );
  }

  @override
  Future<void> toggleHistory(String token, HistoryRequest request) {
    return movieDataAgent.toggleHistory(token, request);
  }

  @override
  Future<void> toggleWatchlist(String token, WatchlistRequest request) {
    return movieDataAgent.toggleWatchlist(token, request);
  }

  @override
  Future<UserVO> updateUser(
    String token,
    File? photo,
    String name,
    String email,
    String language,
    String fcmToken,
  ) {
    return movieDataAgent.updateUser(
      token,
      photo,
      name,
      email,
      language,
      fcmToken,
    );
  }

  @override
  Future<void> deleteUser(String token) {
    return movieDataAgent.deleteUser(token);
  }

  @override
  Future<TermPrivacyResponse> getPrivacyPolicy(String token) {
    return movieDataAgent.getPrivacyPolicy(token);
  }

  @override
  Future<TermPrivacyResponse> getTremAndConditions(String token) {
    return movieDataAgent.getTremAndConditions(token);
  }

  @override
  Future<NotificationResponse> getNotifications(String token) {
    return movieDataAgent.getNotifications(token);
  }

  @override
  Future<void> updateViewCount(
    String token,
    String id,
    ViewCountRequest request,
  ) {
    return movieDataAgent.updateViewCount(token, id, request);
  }

  @override
  Future<CollectionResponse> getCategoryCollection(String token) {
    return movieDataAgent.getCategoryCollection(token);
  }

  @override
  Future<void> redeemCode(
    String token,
    String userId,
    RedeemCodeRequest request,
  ) {
    return movieDataAgent.redeemCode(token, userId, request);
  }

  @override
  Future<CollectionDetailResponse> getCategoryCollectionDetail(
    String token,
    String id,
  ) {
    return movieDataAgent.getCategoryCollectionDetail(token, id);
  }

  @override
  Future<GiftDataResponse> getGift(String token, String userId) {
    return movieDataAgent.getGift(token, userId);
  }
}
