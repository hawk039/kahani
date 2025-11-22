// lib/presentation/auth/signup/signup_view_model.dart
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../services/google_signin_service.dart';

class SignUpViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  final AuthRepository _repo = AuthRepository(); // replace with DI later

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

  Future<void> onSignUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    clearError();
    // basic validation (you can extract validators)
    if (email.isEmpty || password.isEmpty) {
      _setError('Please fill all fields');
      return;
    }

    if (password.length < 6) {
      _setError('Password must be at least 6 characters');
      return;
    }

    setLoading(true);
    try {
      // call repository to sign up - stubbed method in repo
      final result = await _repo.signUp(email: email, password: password);

      // handle result — for now assume result.ok boolean
      if (result.ok) {
        log(result.token.toString());
      } else {
        _setError(result.error ?? 'Signup failed');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> onGoogleSignUp() async {
    try {
      setLoading(true);

      final credential = await GoogleSignInService().signInWithGoogle();

      // send credential.user?.uid or google token to backend here
      print("Signed in as: ${credential.user?.email}");

    } catch (e) {
      _setError(e.toString());
    } finally {
      setLoading(false);
    }
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
