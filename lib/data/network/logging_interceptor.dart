import 'package:dio/dio.dart';
import 'dart:developer';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('--> ${options.method} ${options.uri}');
    log('Headers: ${options.headers}');
    log('Body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('<-- ${response.statusCode} ${response.requestOptions.uri}');
    log('Response: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('<-- Error: ${err.response?.statusCode} ${err.requestOptions.uri}');
    log('Error: ${err.response?.data}');
    super.onError(err, handler);
  }
}
