import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kahani_app/presentation%20/common%20_widgets/email_field.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/assets.dart';
import '../../../core/utils/theme.dart';
import '../../common _widgets/buttons.dart';
import '../login/login_view.dart';
import 'forget_password_view_model.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = Provider.of<ForgotPasswordViewModel>(context);

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Icon inside circle border
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(14),
                child: SvgPicture.asset(
                  AppAssets.signUpIllustration,
                  height: 32,
                  width: 32,
                  color: AppTheme.textLight,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                "Forgot Password?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                "Enter your email and we'll send you a link to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),

              const SizedBox(height: 32),
              EmailField(controller: vm.emailController),

              const SizedBox(height: 24),

              // Send Reset Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ForgotPasswordButton(
                  onPressed: () async {
                    final ok = await vm.sendResetEmail();
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Reset link sent!",
                            style: TextStyle(color: AppTheme.textLight),
                          ),
                          backgroundColor: AppTheme.primary,
                        ),
                      );
                    }
                  },
                  isLoading: vm.isLoading,
                ),
              ),

              const SizedBox(height: 28),

              // Bottom login redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Remember your password? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textMutedDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
