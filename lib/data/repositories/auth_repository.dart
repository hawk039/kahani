import 'package:dio/dio.dart';
import '../models/api_result.dart';
import '../models/sign_up_result.dart';
import '../network/api_client.dart';

class AuthRepository {
  final Dio _dio = ApiClient.dio;

  Future<ApiResult> logout(String token) async {
    try {
      await _dio.post(
        "/auth/logout",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return ApiResult(success: true);
    } on DioException catch (e) {
      // Even if the token is already expired, we count it as a success locally.
      if (e.response?.statusCode == 401) {
        return ApiResult(success: true);
      }
      return ApiResult(success: false, error: e.message);
    } catch (e) {
      return ApiResult(success: false, error: e.toString());
    }
  }

  Future<SignUpResult> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/signup",
        data: {"email": email, "password": password},
      );

      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data["detail"] ??
              e.response?.data["message"] ??
              "Something went wrong"
          : "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }

  Future<SignUpResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
      );

      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data["detail"] ??
              e.response?.data["message"] ??
              "Something went wrong"
          : "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }

  Future<SignUpResult> signUpWithGoogle({
    required String uid,
    required String email,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/google-signup",
        data: {"uid": uid, "email": email, "token": token},
      );

      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data["detail"] ??
              e.response?.data["message"] ??
              "Something went wrong"
          : "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }

  Future<SignUpResult> loginWithGoogle({
    required String uid,
    required String token,
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/google-signin",
        data: {"uid": uid, "token": token, "email": email},
      );

      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data["detail"] ??
              e.response?.data["message"] ??
              "Something went wrong"
          : "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }

  Future<SignUpResult> signUpWithApple({
    required String uid,
    required String email,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/apple-signup",
        data: {"uid": uid, "email": email, "token": token},
      );

      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data["detail"] ??
              e.response?.data["message"] ??
              "Something went wrong"
          : "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }

  Future<SignUpResult> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/fpassword",
        data: {"email": email, "new_password": newPassword},
      );

      return SignUpResult(
        ok: true,
        token:
            response.data["access_token"] ??
            "", // optional if backend returns token
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data["detail"] ??
              e.response?.data["message"] ??
              "Something went wrong"
          : "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }

  Future<SignUpResult> loginWithApple({
    required String uid,
    required String token,
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/apple-signin",
        data: {"uid": uid, "token": token, "email": email},
      );

      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data["detail"] ??
              e.response?.data["message"] ??
              "Something went wrong"
          : "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }
}
