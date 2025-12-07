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
        "/auth/signup",
        data: {"email": email, "password": password},
      );

      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final msg =
          e.response?.data["detail"] ??
          e.response?.data["message"] ??
          "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
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
        data: {"email": email, "password": password},
      );

      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final msg =
          e.response?.data["detail"] ??
          e.response?.data["message"] ??
          "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
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
        "/auth/google-auth",
        data: {"uid": uid, "email": email, "token": token},
      );

      return SignUpResult(
        ok: true,
        token: response.data["access_token"],
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final msg =
          e.response?.data["detail"] ??
          e.response?.data["message"] ??
          "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }

  /// 🔹 Google Login
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
      final msg =
          e.response?.data["detail"] ??
          e.response?.data["message"] ??
          "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }

  /// 🔹 Apple Signup
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
      final msg =
          e.response?.data["detail"] ??
          e.response?.data["message"] ??
          "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }

  /// 🔹 Forgot Password
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
      final msg =
          e.response?.data["detail"] ??
          e.response?.data["message"] ??
          "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }

  /// 🔹 Apple Login
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
      final msg =
          e.response?.data["detail"] ??
          e.response?.data["message"] ??
          "Something went wrong";
      final statusCode = e.response?.statusCode;
      return SignUpResult(ok: false, error: msg, statusCode: statusCode);
    } catch (e) {
      return SignUpResult(ok: false, error: e.toString());
    }
  }
}
