import 'dart:io' show File, Platform;

import 'package:dio/dio.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/data/vos/user_vo.dart';
import 'package:movie_obs/network/api_constants.dart';
import 'package:movie_obs/network/requests/history_request.dart';
import 'package:movie_obs/network/requests/send_otp_request.dart'
    show SendOtpRequest;
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
import 'package:movie_obs/network/responses/watchlist_history_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'movie_api.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class MovieApi {
  factory MovieApi(Dio dio) = _MovieApi;

  @POST(kEndPointSendOtp)
  Future<OTPResponse> sendOTP(@Body() SendOtpRequest request);

  @POST(kEndPointVerifyOtp)
  Future<OTPResponse> verifyOTP(@Body() VerifyOtpRequest request);

  @GET(kEndPointMovie)
  Future<MovieResponse> getMovies(
    @Header(kHeaderAuthorization) String token,
    @Query('plan') String plan,
    @Query('limit') int limit,
    @Query('genres') String genres,
    @Query('page') int page,
  );

  @GET('$kEndPointMovie/{id}')
  Future<MovieDetailResponse> getMovieDetail(
    @Header(kHeaderAuthorization) String token,
    @Path() String id,
  );

  @GET('$kEndPointSeries/{id}')
  Future<MovieDetailResponse> getSeriesDetail(
    @Header(kHeaderAuthorization) String token,
    @Path() String id,
    @Query('includeSeasons') bool isSeasonInclude,
  );

  @GET('$kEndPointSeries/{id}/similar-contents')
  Future<List<MovieVO>> getRecommendedSeries(@Path() String id);

  @GET('$kEndPointMovie/{id}/similar-contents')
  Future<List<MovieVO>> getRecommendedMovies(@Path() String id);

  @GET(kEndPointHomeMovieAndSeries)
  Future<MovieResponse> getAllMoviesAndSeries(
    @Header(kHeaderAuthorization) String token,
    @Query('plan') String plan,
    @Query('limit') int limit,
    @Query('genres') String genres,
    @Query('contentType') String type,
    @Query('getAll') bool getAll,
    @Query('page') int page,
  );

  @GET(kEndPointAds)
  Future<AdsBannerResponse> getAds();

  @GET(kEndPointBanner)
  Future<AdsBannerResponse> getBanner();

  @GET(kEndPointSeason)
  Future<SeasonResponse> getAllSeason();

  @GET('$kEndPointSeason/{id}')
  Future<SeasonEpisodeResponse> getSeasonEpisode(
    @Header(kHeaderAuthorization) String token,
    @Path() String id,
    @Query('include_episodes') bool isSeasonInclude,
  );

  @GET('$kEndPointCast/{id}')
  Future<ActorDataResponse> getActorDetail(
    @Header(kHeaderAuthorization) String token,
    @Path() String id,
    @Query('include_contents') bool isSeasonInclude,
  );

  @GET(kEndPointHomeMovieAndSeries)
  Future<MovieResponse> getMovieSeriesByGenre(
    @Header(kHeaderAuthorization) String token,
    @Query('genre') String id,
  );

  @GET(kEndPointSeason)
  Future<MovieResponse> getMovieSeriesByCategory(
    @Header(kHeaderAuthorization) String token,
    @Query('category') String id,
  );

  @GET(kEndPointCategory)
  Future<CategoryResponse> getAllCategory();

  @GET(kEndPointGenre)
  Future<GenreResponse> getAllGenre();

  @GET(kEndPointHomeMovieAndSeries)
  Future<MovieResponse> getTopTrending(
    @Header(kHeaderAuthorization) String token,
    @Query('isTrending') bool isTrending,
  );

  @GET(kEndPointHomeMovieAndSeries)
  Future<MovieResponse> getNewRelease(
    @Header(kHeaderAuthorization) String token,
    @Query('sortBy') String sortBy,
    @Query('sortOrder') String sortOrder,
    @Query('plan') String plan,
    @Query('limit') int limit,
  );

  @GET(kEndPointSeries)
  Future<MovieResponse> getSeries(
    @Header(kHeaderAuthorization) String token,
    @Query('plan') String plan,
    @Query('limit') int limit,
    @Query('genres') String genres,
    @Query('page') int page,
  );

  @GET(kEndPointPackage)
  Future<PackageResponse> getPackages(
    @Header(kHeaderAuthorization) String token,
  );

  @GET(kEndPointUser)
  Future<UserVO> getUser(@Header(kHeaderAuthorization) String token);

  @GET(kEndPointFaq)
  Future<FaqResponse> getFaqs();

  @GET(kEndPointWatchLists)
  Future<WatchlistHistoryResponse> getWatchLists(
    @Header(kHeaderAuthorization) String token,

    @Query('plan') String plan,
    @Query('limit') int limit,
    @Query('genres') String genres,
    @Query('contentType') String type,
    @Query('getAll') bool getAll,
    @Query('user') String user,
    @Query('page') int page,
  );

  @POST(kEndPointWatchlistToggle)
  Future<void> toggleWatchList(
    @Header(kHeaderAuthorization) String token,
    @Body() WatchlistRequest request,
  );

  @GET(kEndPointHistory)
  Future<WatchlistHistoryResponse> getHistory(
    @Header(kHeaderAuthorization) String token,
    @Query('limit') int limit,
    @Query('getAll') bool getAll,
    @Query('user') String user,
    @Query('page') int page,
  );

  @POST(kEndPointHistoryToggle)
  Future<void> toggleHistory(
    @Header(kHeaderAuthorization) String token,
    @Body() HistoryRequest request,
  );

  @MultiPart()
  @PUT(kEndPointUpdateUser)
  Future<UserVO> updateProfile(
    @Header(kHeaderAuthorization) String token,
    @Header(kHeaderContentType) String contentType,
    @Part(contentType: "image/jpg") File? profilePicture,
    @Part() String name,
    @Part() String email,
    @Part() String languagePreference,
  );
}
