import 'package:dio/dio.dart';
import 'package:movie_obs/network/api_constants.dart';
import 'package:movie_obs/network/requests/send_otp_request.dart'
    show SendOtpRequest;
import 'package:movie_obs/network/requests/verify_otp_request.dart';
import 'package:movie_obs/network/responses/otp_response.dart';
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
}
