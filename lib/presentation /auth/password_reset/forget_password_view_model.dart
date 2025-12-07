import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final emailController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> sendResetEmail() async {
    final email = emailController.text.trim();
    clearError();

    if (email.isEmpty) {
      _setError("Please enter your email");
      return false;
    }

    if (!email.contains("@")) {
      _setError("Please enter a valid email");
      return false;
    }

    setLoading(true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      return true; // success
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? "Error sending reset link");
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  //TODO: we either have to use firebase for authentication completely or our backend ////

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
