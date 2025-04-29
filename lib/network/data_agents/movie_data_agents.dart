import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/network/requests/send_otp_request.dart';
import 'package:movie_obs/network/requests/verify_otp_request.dart';
import 'package:movie_obs/network/responses/ads_banner_response.dart';
import 'package:movie_obs/network/responses/category_response.dart';
import 'package:movie_obs/network/responses/genre_response.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/network/responses/movie_response.dart';
import 'package:movie_obs/network/responses/otp_response.dart';
import 'package:movie_obs/network/responses/season_episode_response.dart';
import 'package:movie_obs/network/responses/season_response.dart';

abstract class MovieDataAgents {
  Future<OTPResponse> sendOtp(SendOtpRequest request);
  Future<OTPResponse> verifyOtp(VerifyOtpRequest request);

  Future<MovieResponse> getMovies(String token);
  Future<MovieResponse> getSeries(String token);
  Future<MovieDetailResponse> getMovieDetail(String token, String id);
  Future<MovieDetailResponse> getSeriesDetail(
    String token,
    String id,
    bool isSeasonInclude,
  );
  Future<SeasonResponse> getSeason(String token);

  Future<MovieResponse> getAllMovie(String token);
  Future<MovieResponse> getTopTrending(String token);
  Future<MovieResponse> getNewRelease(String token);

  Future<CategoryResponse> getAllCategory(String token);
  Future<GenreResponse> getAllGenre(String token);

  Future<AdsBannerResponse> getBanner(String token);
  Future<AdsBannerResponse> getAds(String token);

  Future<List<MovieVO>> getRecommendedMovie(String id);
  Future<List<MovieVO>> getRecommendedSeries(String id);
  Future<SeasonEpisodeResponse> getSeasonEpisode(String id);


}
