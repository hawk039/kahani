// lib/presentation/auth/signup/signup_view_model.dart
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart'
    show SignInWithApple, AppleIDAuthorizationScopes;

import '../../../data/repositories/auth_repository.dart';
import '../../../services/google_signin_service.dart';

class SignUpViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  String? _passwordErrorMessage;

  String? get passwordErrorMessage => _passwordErrorMessage;

  final AuthRepository _repo = AuthRepository(); // replace with DI later

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

  Future<bool> onSignUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    clearError();
    clearPasswordError();

    // --- Client-side validation ---
    if (email.isEmpty || password.isEmpty) {
      _setError('Something went wrong');
      return false;
    }

    if (password.length < 6) {
      _setPasswordError('Password must be at least 6 characters');
      return false;
    }

    setLoading(true);
    try {
      final result = await _repo.signUp(email: email, password: password);

      if (result.ok) {
        log(result.token.toString());
        var box = Hive.box('authBox');
        await box.put('token', result.token);
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

  Future<bool> onGoogleSignUp() async {
    clearError();
    setLoading(true);

    try {
      final userCredential = await GoogleSignInService().signInWithGoogle();
      final user = userCredential.user;

      if (user == null) {
        _setError('Something went wrong');
        return false;
      }

      log('Google Sign-Up successful: ${user.email}, UID: ${user.uid}');
      final token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? "";
      final result = await _repo.signUpWithGoogle(
        uid: user.uid,
        email: user.email ?? '',
        token: token,
      );

      if (result.ok) {
        log('Backend sign-up successful, token: ${result.token}');
        var box = Hive.box('authBox');
        await box.put('token', token);
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

  Future<bool> onAppleSignUp() async {
    clearError();
    setLoading(true);

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.userIdentifier == null) {
        _setError('Something went wrong');
        return false;
      }

      final uid = credential.userIdentifier!;
      final email = credential.email ?? "";
      final token = credential.identityToken ?? "";

      final result = await _repo.signUpWithApple(
        uid: uid,
        email: email,
        token: token,
      );

      if (result.ok) {
        log('Backend Apple Sign-Up successful, token: ${result.token}');
        var box = Hive.box('authBox');
        await box.put('token', result.token);
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
