
import 'package:flutter/material.dart';
import 'package:kahani_app/core/utils/theme.dart';

class PasswordResetConfirmationScreen extends StatelessWidget {
  const PasswordResetConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor =
         AppTheme.primary;
    final Color textColor = isDarkMode ? AppTheme.textLight : AppTheme.textDark;
    final Color mutedTextColor =
        isDarkMode ? AppTheme.textMutedDark : AppTheme.textMutedLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mail_outline,
                    color: AppTheme.secondary,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Password Reset Email Sent!',
                  textAlign: TextAlign.center,
                  style: AppTheme.heading.copyWith(
                    color: textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "We\'ve sent a link to reset your password to your email address. Please check your inbox.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: mutedTextColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                     Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
