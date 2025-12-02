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

  Future<bool> onGoogleSignUp() async {
    clearError();
    setLoading(true);

    try {
      // Use the already initialized GoogleSignInService
      final userCredential = await GoogleSignInService().signInWithGoogle();
      final user = userCredential.user;

      if (user == null) {
        _setError('Google Sign-In failed: user is null');
        return false;
      }

      log('Google Sign-Up successful: ${user.email}, UID: ${user.uid}');
      final token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? "";
      // Send Firebase UID / token to backend
      final result = await _repo.signUpWithGoogle(
        uid: user.uid,
        email: user.email ?? '', // default to empty string if null
        token: token,
      );

      if (result.ok) {
        log('Backend sign-up successful, token: ${result.token}');
        var box = Hive.box('authBox');
        await box.put('token', token);
        return true; // ✅ Sign-up success
      } else {
        _setError(result.error ?? 'Backend sign-up failed');
        return false; // ❌ Backend returned error
      }
    } on FirebaseAuthException catch (e) {
      _setError('Firebase Auth Error: ${e.message}');
      return false;
    } catch (e) {
      _setError('Sign-Up Error: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> onAppleSignUp() async {
    clearError();
    setLoading(true);

    try {
      // Trigger Apple Sign-In
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.userIdentifier == null) {
        _setError('Apple Sign-In failed: user ID is null');
        return false;
      }

      final uid = credential.userIdentifier!;
      final email =
          credential.email ??
          ""; // email may be null if user already signed in before
      final token = credential.identityToken ?? "";

      // Send Apple credentials to your backend
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
        _setError(result.error ?? 'Backend Apple sign-up failed');
        return false;
      }
    } catch (e) {
      _setError('Apple Sign-Up Error: ${e.toString()}');
      return false;
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
