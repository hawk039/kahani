import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../core/utils/theme.dart';

class AuthRedirectText extends StatelessWidget {
  final String leadingText;       // e.g. "Already have an account?"
  final String actionText;        // e.g. "Log In"
  final VoidCallback onTap;       // Navigation action

  const AuthRedirectText({
    super.key,
    required this.leadingText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "$leadingText ",
        style: AppTheme.input.copyWith(color: AppTheme.textLight),
        children: [
          TextSpan(
            text: actionText,
            style: AppTheme.input.copyWith(
              color: AppTheme.secondary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
