import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_obs/exception/custom_exception.dart';
import 'package:movie_obs/network/data_agents/movie_data_agents.dart';
import 'package:movie_obs/network/movie_api.dart';
import 'package:movie_obs/network/requests/send_otp_request.dart';
import 'package:movie_obs/network/requests/verify_otp_request.dart';
import 'package:movie_obs/network/responses/otp_response.dart';

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
