import 'package:dio/dio.dart';
import 'package:kahani_app/core/config/config.dart'; // 1. Import config

class ApiClient {
  ApiClient._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Environment().config.baseUrl, // 2. Use the dynamic URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Dio get dio => _dio;
}
