import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kahani_app/services/apple_signin_service.dart';
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

  // FIX: Added state for successful signup to drive reactive navigation
  bool _signUpSuccess = false;
  bool get signUpSuccess => _signUpSuccess;

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

  // FIX: Reset success state
  void clearSignUpSuccess() {
    _signUpSuccess = false;
  }

  Future<void> onSignUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    clearError();
    clearPasswordError();

    if (email.isEmpty || password.isEmpty) {
      _setError('Something went wrong');
      return;
    }

    if (password.length < 6) {
      _setPasswordError('Password must be at least 6 characters');
      return;
    }

    setLoading(true);
    try {
      final result = await _repo.signUp(email: email, password: password);

      if (result.ok) {
        log(result.token.toString());
        var box = Hive.box('authBox');
        await box.put('token', result.token);
        _signUpSuccess = true; // Set success state
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

  Future<void> onGoogleSignUp() async {
    clearError();
    setLoading(true);

    try {
      final userCredential = await _googleSignInService.signInWithGoogle();
      final user = userCredential.user;

      if (user == null) {
        _setError('Something went wrong');
        return;
      }

      log('Google Sign-Up successful: ${user.email}, UID: ${user.uid}');
      final token = await user.getIdToken();

      final result = await _repo.signUpWithGoogle(
        uid: user.uid,
        email: user.email ?? '',
        token: token ?? '',
      );

      if (result.ok) {
        log('Backend sign-up successful, token: ${result.token}');
        var box = Hive.box('authBox');
        await box.put('token', result.token);
        _signUpSuccess = true; // Set success state
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

  Future<void> onAppleSignUp() async {
    clearError();
    setLoading(true);

    try {
      final credential = await AppleSignInService().signInWithApple();

      final user = credential.user;
      if (user == null) {
        _setError('Something went wrong');
        return;
      }

      final uid = user.uid;
      final email = user.email ?? "";
      final token = await user.getIdToken() ?? "";

      final result = await _repo.signUpWithApple(
        uid: uid,
        email: email,
        token: token,
      );

      if (result.ok) {
        log('Backend Apple Sign-Up successful, token: ${result.token}');
        var box = Hive.box('authBox');
        await box.put('token', result.token);
        _signUpSuccess = true; // Set success state
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
