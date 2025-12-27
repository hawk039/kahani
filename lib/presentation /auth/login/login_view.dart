import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kahani_app/core/utils/theme.dart';
import 'package:kahani_app/presentation%20/auth/login/login_view_model.dart';
import 'package:kahani_app/presentation%20/auth/password_reset/forget_password.dart';
import 'package:kahani_app/presentation%20/auth/signup/signup_view.dart';
import 'package:kahani_app/presentation%20/common%20_widgets/email_field.dart';
import 'package:kahani_app/presentation%20/common%20_widgets/password_field.dart';
import 'package:kahani_app/presentation%20/common%20_widgets/buttons.dart';
import 'package:kahani_app/presentation%20/common%20_widgets/social_button.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/assets.dart';
import '../../common _widgets/auth_redirect_text.dart';
import '../../stories/stories.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = context.watch<LoginViewModel>();

    // Listen for non-password errors and show a SnackBar
    if (vm.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              vm.errorMessage!,
              style: const TextStyle(color: AppTheme.textLight),
            ),
            backgroundColor: AppTheme.secondary,
          ),
        );
        vm.clearError(); // Clear the error after showing it
      });
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101522) : AppTheme.primary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: SvgPicture.asset(
                    AppAssets.signUpIllustration,
                    height: 32,
                    width: 32,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                "Log in to continue your journey.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),

              const SizedBox(height: 32),

              EmailField(controller: vm.emailController),
              const SizedBox(height: 16),

              PasswordField(
                controller: vm.passwordController,
                errorText: vm.passwordErrorMessage,
                onForgotPassword: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                  );
                },
              ),

              const SizedBox(height: 24),

              SignupButton(
                onPressed: () async {
                  final loggedIn = await vm.onLogin();
                  if (loggedIn) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const StoriesPage()),
                    );
                  }
                },
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.withOpacity(.4))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("or continue with"),
                  ),
                  Expanded(child: Divider(color: Colors.grey.withOpacity(.4))),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: SocialButton(
                      leading: SvgPicture.asset(
                        AppAssets.google_logo,
                        width: 40,
                        height: 40,
                      ),
                      label: 'Google',
                      onPressed: () async {
                        final ok = await vm.onGoogleLogin();
                        if (ok) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const StoriesPage(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SocialButton(
                      leading: SvgPicture.asset(
                        AppAssets.apple_logo,
                        width: 40,
                        height: 40,
                      ),
                      label: 'Apple',
                      onPressed: () async {
                        final ok = await vm.onAppleLogin();
                        if (ok) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const StoriesPage(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              AuthRedirectText(
                leadingText: "Don't have an account?",
                actionText: "Sign Up",
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpView()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
