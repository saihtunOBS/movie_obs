import 'dart:io';

import 'package:dio/dio.dart';

import '../widgets/toast_service.dart';
import 'api_constants.dart';

Future<void> updateCustomer({
  required String token,
  required String name,
  File? profilePicture,
  required String email,
  required String languagePreference,
}) async {
  final dio = Dio();

  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ),
  );

  try {
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'languagePreference': languagePreference,
    });

    if (profilePicture != null) {
      if (await profilePicture.exists()) {
        final fileName = profilePicture.path.split('/').last;

        formData.files.add(
          MapEntry(
            'profilePicture',
            await MultipartFile.fromFile(
              profilePicture.path,
              filename: fileName,
            ),
          ),
        );
      }
    }

    final response = await dio.put(
      '$kBaseUrl$kEndPointUser',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    print('✅ Response Data: ${response.data}');
  } on DioException catch (e) {
    print('❌ Dio Error: ${e.response?.data}');
    final errorMessage =
        e.response?.data?['message'] ??
        'Failed to update profile (${e.response?.statusCode})';
    ToastService.warningToast(errorMessage);
  } catch (e) {
    print('❌ Unexpected Error: $e');
    ToastService.warningToast(e.toString().replaceAll('Exception: ', ''));
  }
}
