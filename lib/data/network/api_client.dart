import 'package:dio/dio.dart';
import 'package:kahani_app/core/config/config.dart';

class ApiClient {
  ApiClient._();

  // 1. Change _dio to be a 'late static' variable
  static late Dio _dio;

  // 2. Create an init() method to set it up
  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Environment().config.baseUrl, // Now this will be safely initialized
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  // 3. The getter remains the same
  static Dio get dio => _dio;
}
