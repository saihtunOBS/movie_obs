import 'package:dio/dio.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/network/api_constants.dart';
import 'package:movie_obs/network/requests/send_otp_request.dart'
    show SendOtpRequest;
import 'package:movie_obs/network/requests/verify_otp_request.dart';
import 'package:movie_obs/network/responses/actor_data_response.dart';
import 'package:movie_obs/network/responses/ads_banner_response.dart';
import 'package:movie_obs/network/responses/category_response.dart';
import 'package:movie_obs/network/responses/genre_response.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/network/responses/movie_response.dart';
import 'package:movie_obs/network/responses/otp_response.dart';
import 'package:movie_obs/network/responses/season_episode_response.dart';
import 'package:movie_obs/network/responses/season_response.dart';
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
  Future<MovieResponse> getMovies();

  @GET('$kEndPointMovie/{id}')
  Future<MovieDetailResponse> getMovieDetail(@Path() String id);

  @GET('$kEndPointSeries/{id}')
  Future<MovieDetailResponse> getSeriesDetail(
    @Path() String id,
    @Query('includeSeasons') bool isSeasonInclude,
  );

  @GET('$kEndPointSeries/{id}/similar-contents')
  Future<List<MovieVO>> getRecommendedSeries(@Path() String id);

  @GET('$kEndPointMovie/{id}/similar-contents')
  Future<List<MovieVO>> getRecommendedMovies(@Path() String id);

  @GET(kEndPointHomeMovieAndSeries)
  Future<MovieResponse> getAllMovies();

  @GET(kEndPointAds)
  Future<AdsBannerResponse> getAds();

  @GET(kEndPointBanner)
  Future<AdsBannerResponse> getBanner();

  @GET(kEndPointSeason)
  Future<SeasonResponse> getAllSeason();

  @GET('$kEndPointSeason/{id}')
  Future<SeasonEpisodeResponse> getSeasonEpisode(
    @Path() String id,
    @Query('include_episodes') bool isSeasonInclude,
  );

  @GET('$kEndPointCast/{id}')
  Future<ActorDataResponse> getActorDetail(
    @Header(kHeaderAuthorization) String token,
    @Path() String id,
    @Query('include_contents') bool isSeasonInclude,
  );

  @GET(kEndPointMovie)
  Future<MovieResponse> getMovieSeriesByGenre(@Query('genre') String id);

  @GET(kEndPointSeason)
  Future<MovieResponse> getMovieSeriesByCategory(@Query('category') String id);

  @GET(kEndPointCategory)
  Future<CategoryResponse> getAllCategory();

  @GET(kEndPointGenre)
  Future<GenreResponse> getAllGenre();

  @GET(kEndPointHomeMovieAndSeries)
  Future<MovieResponse> getTopTrending(@Query('isTrending') bool isTrending);

  @GET(kEndPointHomeMovieAndSeries)
  Future<MovieResponse> getNewRelease(
    @Query('sortBy') String sortBy,
    @Query('sortOrder') String sortOrder,
  );

  @GET(kEndPointSeries)
  Future<MovieResponse> getSeries();
}
