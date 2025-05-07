import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/data/vos/user_vo.dart';
import 'package:movie_obs/exception/custom_exception.dart';
import 'package:movie_obs/network/data_agents/movie_data_agents.dart';
import 'package:movie_obs/network/movie_api.dart';
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
import 'package:movie_obs/network/responses/watchlist_history_response.dart';
import 'package:movie_obs/widgets/movie_filter_sheet.dart';

import '../../data/vos/error_vo.dart';

class MovieDataAgentsImpl extends MovieDataAgents {
  late MovieApi movieApi;
  static MovieDataAgentsImpl? _singleton;

  ///singleton
  factory MovieDataAgentsImpl() {
    _singleton ??= MovieDataAgentsImpl._internal();
    return _singleton!;
  }

  ///private constructor
  MovieDataAgentsImpl._internal() {
    final dio = Dio();
    movieApi = MovieApi(dio);
  }

  @override
  Future<OTPResponse> sendOtp(SendOtpRequest request) {
    return movieApi
        .sendOTP(request)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<OTPResponse> verifyOtp(VerifyOtpRequest request) {
    return movieApi
        .verifyOTP(request)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<MovieResponse> getMovies(String token, String plan, String genre) {
    return movieApi
        .getMovies(plan, 10, genre)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<MovieResponse> getAllMovieAndSeries(
    String token,
    String plan,
    String genre,
    String type,
    bool getAll,
  ) {
    return movieApi
        .getAllMoviesAndSeries(plan, 10, genre, type, getAll)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<MovieResponse> getNewRelease(String token, String plan) {
    return movieApi
        .getNewRelease('createdAt', 'desc', plan, 10)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<MovieResponse> getTopTrending(String token, String plan) {
    return movieApi
        .getTopTrending(true)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<MovieResponse> getSeries(String token, String plan, String genre) {
    return movieApi
        .getSeries(plan, 10, genre)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(String token, String id) {
    return movieApi
        .getMovieDetail(id)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<MovieDetailResponse> getSeriesDetail(
    String token,
    String id,
    bool isSeasonInclude,
  ) {
    return movieApi
        .getSeriesDetail(id, isSeasonInclude)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<SeasonResponse> getSeason(String token) {
    return movieApi
        .getAllSeason()
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<CategoryResponse> getAllCategory(String token) {
    return movieApi
        .getAllCategory()
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<GenreResponse> getAllGenre(String token) {
    return movieApi
        .getAllGenre()
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<AdsBannerResponse> getAds(String token) {
    return movieApi
        .getAds()
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<AdsBannerResponse> getBanner(String token) {
    return movieApi
        .getBanner()
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<List<MovieVO>> getRecommendedMovie(String id) {
    return movieApi
        .getRecommendedMovies(id)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<List<MovieVO>> getRecommendedSeries(String id) {
    return movieApi
        .getRecommendedSeries(id)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<SeasonEpisodeResponse> getSeasonEpisode(String id) {
    return movieApi
        .getSeasonEpisode(id, true)
        .asStream()
        .map((response) {
          return response;
        })
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<MovieResponse> getMovieSeriesByCategory(String id) {
    return movieApi
        .getMovieSeriesByCategory(id)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<MovieResponse> getMovieSeriesByGenre(String id) {
    return movieApi
        .getMovieSeriesByGenre(id)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<ActorDataResponse> getActorDetail(String token, String id) {
    return movieApi
        .getActorDetail('Bearer $token', id, true)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<PackageResponse> getAllPackage(String token) {
    return movieApi
        .getPackages('Bearer $token')
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<UserVO> getUser(String token) {
    return movieApi
        .getUser('Bearer $token')
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<FaqResponse> getFaq() {
    return movieApi
        .getFaqs()
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<WatchlistHistoryResponse> getHistory(
    String token,
    bool getAll,
    String user,
  ) {
    return movieApi
        .getHistory(token, 10, getAll, user)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<WatchlistHistoryResponse> getWatchlist(
    String token,
    String plan,
    String genres,
    String type,
    bool getAll,
    String user,
  ) {
    return movieApi
        .getWatchLists(token, plan, 10, genre, user, getAll, user)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<void> toggleHistory(String token, HistoryRequest request) {
    return movieApi
        .toggleHistory(token, request)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<void> toggleWatchlist(String token, WatchlistRequest request) {
    return movieApi
        .toggleWatchList(token, request)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }

  @override
  Future<UserVO> updateUser(
    String token,
    File? photo,
    String name,
    String email,
    String language,
  ) {
    return movieApi
        .updateProfile(token, photo, name, email, language)
        .asStream()
        .map((response) => response)
        .first
        .catchError((error) {
          throw _createException(error);
        });
  }
}

///custom exception
CustomException _createException(dynamic error) {
  ErrorVO errorVO;
  if (error is DioException) {
    errorVO = _parseDioError(error);
  } else {
    errorVO = ErrorVO(status: false, message: "UnExcepted error");
  }
  return CustomException(errorVO);
}

ErrorVO _parseDioError(DioException error) {
  try {
    if (error.response != null || error.response?.data != null) {
      var data = error.response?.data;

      ///Json string to Map<String,dynamic>
      if (data is String) {
        data = jsonDecode(data);
      }

      ///Map<String,dynamic> to ErrorVO
      return ErrorVO.fromJson(data);
    } else {
      return ErrorVO(status: false, message: "No response data");
    }
  } catch (e) {
    return ErrorVO(status: false, message: "Invalid DioException Format");
  }
}
