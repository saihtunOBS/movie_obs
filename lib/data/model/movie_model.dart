import 'package:movie_obs/network/responses/movie_response.dart';
import 'package:movie_obs/network/responses/otp_response.dart';

import '../../network/requests/send_otp_request.dart' show SendOtpRequest;
import '../../network/requests/verify_otp_request.dart';
import '../../network/responses/category_response.dart';
import '../../network/responses/genre_response.dart';
import '../../network/responses/movie_detail_response.dart';
import '../../network/responses/season_response.dart';

abstract class MovieModel {
  Future<OTPResponse> sendOtp(SendOtpRequest request);
  Future<OTPResponse> verifyOtp(VerifyOtpRequest request);
  Future<MovieResponse> getMovieLists(String token);
  Future<MovieResponse> getSeriesLists(String token);
  Future<MovieDetailResponse> getMovieDetail(String token, String id);
  Future<MovieDetailResponse> getSeriesDetail(String token, String id,bool isSeasonInclude);
  Future<SeasonResponse> getSeason(String token);

  Future<MovieResponse> getAllMovie(String token);
  Future<MovieResponse> getTopTrending(String token);
  Future<MovieResponse> getNewRelease(String token);

  Future<CategoryResponse> getAllCategory(String token);
  Future<GenreResponse> getAllGenre(String token);
}
