import 'package:dio/dio.dart';
import '../models/sign_up_result.dart';
import '../network/api_client.dart';

class AuthRepository {
  final Dio _dio = ApiClient.dio;

  Future<SignUpResult> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/login",
        data: {
          "email": email,
          "password": password,
        },
      );

      // SUCCESS → return ok
      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
      );

    } on DioException catch (e) {
      // Server-side error (400/401/500 etc.)
      final msg = e.response?.data["detail"] ??
          e.response?.data["message"] ??
          "Something went wrong";

      return SignUpResult(ok: false, error: msg);
    } catch (e) {
      // Unknown error
      return SignUpResult(ok: false, error: e.toString());
    }
  }
}
