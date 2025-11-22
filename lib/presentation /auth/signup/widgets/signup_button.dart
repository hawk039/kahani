// lib/presentation/auth/signup/widgets/signup_button.dart
import 'package:flutter/material.dart';
import '../../../../core/utils/theme.dart';

class SignupButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SignupButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary == Colors.black ? AppTheme.secondary : AppTheme.secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text('Sign Up', style: AppTheme.buttonText.copyWith(color: AppTheme.textLight)),
      ),
    );
  }
}
