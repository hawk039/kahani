// lib/presentation/auth/signup/signup_view.dart
import 'package:flutter/material.dart';
import 'package:kahani_app/presentation%20/auth/signup/widgets/password_field.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/theme.dart';
import '../../../core/utils/assets.dart';
import '../../common _widgets/social_button.dart';
import 'signup_view_model.dart';
import 'widgets/email_field.dart';
import 'widgets/signup_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: const _SignUpScreen(),
    );
  }
}

class _SignUpScreen extends StatelessWidget {
  const _SignUpScreen();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SignUpViewModel>();

    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      // adjust if you use dark by default
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon container (rounded 5px, white svg)
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      AppAssets.signUpIllustration,
                      height: 48,
                      width: 48,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'Begin Your Adventure',
                    style: AppTheme.heading.copyWith(
                      color: AppTheme.textLight,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Create Account.',
                    style: AppTheme.input.copyWith(
                      color: AppTheme.textMutedLight,
                      fontSize: 20,
                    ),

                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 50),

                  // Form
                  EmailField(controller: vm.emailController),
                  const SizedBox(height: 16),
                  PasswordField(
                    controller: vm.passwordController,
                    errorText: vm.errorMessage,
                  ),
                  const SizedBox(height: 50),
                  // Sign up / loading
                  vm.isLoading
                      ? const CircularProgressIndicator(
                          color: AppTheme.secondary,
                        )
                      : SignupButton(onPressed: vm.onSignUp),

                  const SizedBox(height: 18),

                  // Divider with text
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppTheme.borderDark)),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Or sign up with',
                          style: AppTheme.input.copyWith(
                            color: AppTheme.textMutedLight,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppTheme.borderDark)),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Social buttons
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
                          // iconPath can be a raster or svg path from AppAssets if you add it
                          onPressed: () {
                            vm.onGoogleSignUp();
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
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {
                      // navigate to login screen - implement routing in app.dart
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style: AppTheme.input.copyWith(
                          color: AppTheme.textLight,
                        ),
                        children: [
                          TextSpan(
                            text: 'Log In',
                            style: AppTheme.input.copyWith(
                              color: AppTheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
