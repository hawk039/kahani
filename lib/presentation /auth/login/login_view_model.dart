// lib/presentation/auth/login/login_view_model.dart

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../services/google_signin_service.dart';
import '../../../services/apple_signin_service.dart'; // 🔹 Apple Sign-In service

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  String? _passwordErrorMessage;

  String? get passwordErrorMessage => _passwordErrorMessage;

  final AuthRepository _repo = AuthRepository(); // DI later

  void setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void _setPasswordError(String? msg) {
    _passwordErrorMessage = msg;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearPasswordError() {
    _passwordErrorMessage = null;
    notifyListeners();
  }

  Future<bool> onLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    clearError();
    clearPasswordError();

    if (email.isEmpty || password.isEmpty) {
      _setError('Something went wrong');
      return false;
    }

    setLoading(true);

    try {
      final result = await _repo.login(email: email, password: password);

      if (result.ok) {
        final token = result.token ?? "";
        var box = Hive.box('authBox');
        await box.put('token', token);

        log("Login Success: $token");
        return true;
      } else {
        if (result.statusCode == 400) {
          _setPasswordError(result.error);
        } else {
          _setError('Something went wrong');
        }
        return false;
      }
    } catch (e) {
      _setError('Something went wrong');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// 🔥 Google Login
  Future<bool> onGoogleLogin() async {
    clearError();
    setLoading(true);

    try {
      final userCredential = await GoogleSignInService().signInWithGoogle();
      final user = userCredential.user;

      if (user == null) {
        _setError('Something went wrong');
        return false;
      }

      final token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? "";
      final result = await _repo.loginWithGoogle(
        uid: user.uid,
        email: user.email!,
        token: token,
      );

      if (result.ok) {
        var box = Hive.box('authBox');
        await box.put('token', token);

        log('Google Login Successful → Token saved');
        return true;
      } else {
        if (result.statusCode == 400) {
          _setError(result.error);
        } else {
          _setError('Something went wrong');
        }
        return false;
      }
    } catch (e) {
      _setError('Something went wrong');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// 🍏 Apple Login
  Future<bool> onAppleLogin() async {
    clearError();
    setLoading(true);

    try {
      final UserCredential userCred = await AppleSignInService()
          .signInWithApple();

      final user = userCred.user;

      if (user == null) {
        _setError('Something went wrong');
        return false;
      }

      final uid = user.uid;
      final email =
          user.email ?? ""; // Apple may not return email after first login
      final firebaseToken = await user.getIdToken(); // Firebase JWT Token

      // Optional: raw Apple identity token if backend needs it
      final OAuthCredential? oauthCred =
          userCred.credential as OAuthCredential?;
      final rawAppleToken = oauthCred?.idToken ?? "";

      log("Apple Login → UID: $uid, Email: $email");
      log("Firebase Token: $firebaseToken");
      log("Apple Raw Token: $rawAppleToken");

      // Send to backend
      final result = await _repo.loginWithApple(
        uid: uid,
        email: email,
        token: firebaseToken ?? "", // Use Firebase Token to authenticate
      );

      if (result.ok) {
        var box = Hive.box('authBox');
        await box.put('token', result.token ?? "");

        log('Apple Login Successful → Token saved locally');
        return true;
      } else {
        if (result.statusCode == 400) {
          _setError(result.error);
        } else {
          _setError('Something went wrong');
        }
        return false;
      }
    } catch (e) {
      _setError("Something went wrong");
      return false;
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
