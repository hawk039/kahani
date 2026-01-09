import 'package:flutter/material.dart';
import 'package:kahani_app/core/app_routes.dart';
import 'package:kahani_app/presentation /common _widgets/password_field.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/theme.dart';
import '../../../core/utils/assets.dart';
import '../../common _widgets/auth_redirect_text.dart';
import '../../common _widgets/buttons.dart';
import '../../common _widgets/social_button.dart';
import 'signup_view_model.dart';
import '../../common _widgets/email_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpView extends StatelessWidget {
  static const routeName = '/signup';
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

    // FIX: Centralized reactive listener for success, error, and password error states
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.signUpSuccess) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        vm.clearSignUpSuccess();
      }

      if (vm.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vm.errorMessage!, style: const TextStyle(color: AppTheme.textLight)),
            backgroundColor: AppTheme.secondary,
          ),
        );
        vm.clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  Text(
                    'Create Account.',
                    style: AppTheme.input.copyWith(
                      color: AppTheme.textMutedLight,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 50),

                  EmailField(controller: vm.emailController),
                  const SizedBox(height: 16),
                  PasswordField(
                    controller: vm.passwordController,
                    errorText: vm.passwordErrorMessage,
                  ),
                  const SizedBox(height: 50),
                  
                  vm.isLoading
                      ? const CircularProgressIndicator(
                          color: AppTheme.secondary,
                        )
                      : PrimaryButton(
                          label: 'Sign Up',
                          onPressed: vm.onSignUp,
                        ),

                  const SizedBox(height: 18),

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
                          onPressed: vm.onGoogleSignUp,
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
                          onPressed: vm.onAppleSignUp,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  AuthRedirectText(
                    leadingText: "Already have an account?",
                    actionText: "Log In",
                    onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
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
