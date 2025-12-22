import 'package:dio/dio.dart';

class DioClient {
  // 🔓 Public (NO TOKEN)
  static final Dio publicDio = Dio(
    BaseOptions(
      baseUrl: 'http://babikids.test/api/v1',
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // 🔐 Authenticated (WITH TOKEN)
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://babikids.test/api/v1',
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static void setToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static void clearToken() {
    dio.options.headers.remove('Authorization');
  }
}
