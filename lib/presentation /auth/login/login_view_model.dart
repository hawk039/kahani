// lib/presentation/auth/login/login_view_model.dart

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../services/google_signin_service.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final AuthRepository _repo = AuthRepository(); // DI later

  void setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> onLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    clearError();

    if (email.isEmpty || password.isEmpty) {
      _setError('Please fill all fields');
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
        _setError(result.error ?? "Login failed");
        return false;
      }
    } catch (e) {
      _setError(e.toString());
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
        _setError('Google Sign-In failed: user is null');
        return false;
      }

      final token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? "";
      final result = await _repo.loginWithGoogle(
        uid: user.uid,
        token: token,
      );

      if (result.ok) {
        var box = Hive.box('authBox');
        await box.put('token', token);

        log('Google Login Successful → Token saved');
        return true;
      } else {
        _setError(result.error ?? 'Backend Login failed');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      _setError("Firebase Auth Error: ${e.message}");
      return false;
    } catch (e) {
      _setError("Login Error: ${e.toString()}");
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
