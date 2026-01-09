import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../services/google_signin_service.dart';
import '../../../services/apple_signin_service.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _passwordErrorMessage;
  String? get passwordErrorMessage => _passwordErrorMessage;

  // FIX: Added a state for successful login to drive reactive navigation
  bool _loginSuccess = false;
  bool get loginSuccess => _loginSuccess;

  final AuthRepository _repo = AuthRepository();
  final GoogleSignInService _googleSignInService = GoogleSignInService();

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

  // FIX: Reset the success state
  void clearLoginSuccess() {
    _loginSuccess = false;
  }

  Future<void> onLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    clearError();
    clearPasswordError();

    if (email.isEmpty || password.isEmpty) {
      _setError('Something went wrong');
      return;
    }

    setLoading(true);

    try {
      final result = await _repo.login(email: email, password: password);

      if (result.ok) {
        final token = result.token ?? "";
        var box = Hive.box('authBox');
        await box.put('token', token);

        log("Login Success: $token");
        _loginSuccess = true; // Set success state
        notifyListeners();
      } else {
        if (result.statusCode == 400) {
          _setPasswordError(result.error);
        } else {
          _setError('Something went wrong');
        }
      }
    } catch (e) {
      _setError('Something went wrong');
    } finally {
      setLoading(false);
    }
  }

  Future<void> onGoogleLogin() async {
    clearError();
    setLoading(true);

    try {
      final userCredential = await _googleSignInService.signInWithGoogle();
      final user = userCredential.user;

      if (user == null) {
        _setError('Something went wrong');
        return;
      }

      final token = await user.getIdToken();
      final result = await _repo.loginWithGoogle(
        uid: user.uid,
        email: user.email!,
        token: token ?? '',
      );

      if (result.ok) {
        var box = Hive.box('authBox');
        await box.put('token', result.token);

        log('Google Login Successful → Token saved');
        _loginSuccess = true; // Set success state
        notifyListeners();
      } else {
        if (result.statusCode == 400) {
          _setError(result.error);
        } else {
          _setError('Something went wrong');
        }
      }
    } catch (e) {
      _setError('Something went wrong');
    } finally {
      setLoading(false);
    }
  }

  Future<void> onAppleLogin() async {
    clearError();
    setLoading(true);

    try {
      final UserCredential userCred = await AppleSignInService().signInWithApple();

      final user = userCred.user;

      if (user == null) {
        _setError('Something went wrong');
        return;
      }

      final uid = user.uid;
      final email = user.email ?? "";
      final firebaseToken = await user.getIdToken();

      final result = await _repo.loginWithApple(
        uid: uid,
        email: email,
        token: firebaseToken ?? "",
      );

      if (result.ok) {
        var box = Hive.box('authBox');
        await box.put('token', result.token ?? "");

        log('Apple Login Successful → Token saved locally');
        _loginSuccess = true; // Set success state
        notifyListeners();
      } else {
        if (result.statusCode == 400) {
          _setError(result.error);
        } else {
          _setError('Something went wrong');
        }
      }
    } catch (e) {
      _setError("Something went wrong");
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
