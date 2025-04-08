import 'package:dio/dio.dart';
import 'package:movie_obs/network/api_constants.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'movie_api.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class MovieApi {
  factory MovieApi(Dio dio) = _MovieApi;
}