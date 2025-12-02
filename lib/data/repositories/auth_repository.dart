import 'package:dio/dio.dart';
import '../models/sign_up_result.dart';
import '../network/api_client.dart';

class AuthRepository {
  final Dio _dio = ApiClient.dio;

  /// 🔹 Email + Password Signup
  Future<SignUpResult> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/register",
        data: {
          "email": email,
          "password": password,
        },
      );

      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
      );
    } on DioException catch (e) {
      final msg = e.response?.data["detail"] ??
          e.response?.data["message"] ??
          "Something went wrong";
      return SignUpResult(ok: false, error: msg);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }

  /// 🔹 Email + Password Login
  Future<SignUpResult> login({
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

      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
      );
    } on DioException catch (e) {
      final msg = e.response?.data["detail"] ??
          e.response?.data["message"] ??
          "Something went wrong";
      return SignUpResult(ok: false, error: msg);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }

  /// 🔹 Google Signup
  Future<SignUpResult> signUpWithGoogle({
    required String uid,
    required String email,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/google-signup",
        data: {
          "uid": uid,
          "email": email,
          "token": token,
        },
      );

      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
      );
    } on DioException catch (e) {
      final msg = e.response?.data["detail"] ??
          e.response?.data["message"] ??
          "Something went wrong";
      return SignUpResult(ok: false, error: msg);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }

  /// 🔹 Google Login
  Future<SignUpResult> loginWithGoogle({
    required String uid,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/google-login",
        data: {
          "uid": uid,
          "token": token,
        },
      );

      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
      );
    } on DioException catch (e) {
      final msg = e.response?.data["detail"] ??
          e.response?.data["message"] ??
          "Something went wrong";
      return SignUpResult(ok: false, error: msg);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }
}
