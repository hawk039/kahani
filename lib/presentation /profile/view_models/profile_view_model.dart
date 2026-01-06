import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../data/repositories/auth_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();

  Future<void> logout() async {
    final box = Hive.box('authBox');
    final token = box.get('token');

    if (token != null) {
      await _authRepo.logout(token);
    }

    await box.clear();
  }
}
