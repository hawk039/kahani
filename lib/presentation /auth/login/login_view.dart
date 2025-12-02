import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kahani_app/presentation%20/auth/login/login_view_model.dart';
import 'package:kahani_app/presentation%20/auth/signup/signup_view.dart';
import 'package:kahani_app/presentation%20/common%20_widgets/email_field.dart';
import 'package:kahani_app/presentation%20/common%20_widgets/password_field.dart';
import 'package:kahani_app/presentation%20/common%20_widgets/signup_button.dart';
import 'package:kahani_app/presentation%20/common%20_widgets/social_button.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/assets.dart';
import '../../../core/utils/theme.dart';
import '../../common _widgets/auth_redirect_text.dart';
import '../../stories/stories.dart';
import '../signup/signup_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF101522)
          : const Color(0xFFF6F6F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 🔹 Title Section
              SvgPicture.asset(
                AppAssets.signUpIllustration,
                height: 48,
                width: 48,
                color: Colors.white,
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
              const SizedBox(height: 8),
              Text(
                "Log in to continue your journey.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),

              const SizedBox(height: 32),

              /// 🔹 Reused Inputs
              EmailField(controller: vm.emailController),
              const SizedBox(height: 16),
              PasswordField(controller: vm.passwordController),

              const SizedBox(height: 24),

              /// 🔹 Reuse Primary CTA Button
              SignupButton(
                onPressed: () {
                  // TODO: Connect backend
                },
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.withOpacity(.4))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("or continue with"),
                  ),
                  Expanded(child: Divider(color: Colors.grey.withOpacity(.4))),
                ],
              ),

              const SizedBox(height: 24),

              /// 🔹 Reused Auth Buttons
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
                        final isAuthenticated = await vm.onGoogleLogin();
                        if (isAuthenticated) {
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
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// 🔹 Sign Up Navigation
              AuthRedirectText(
                leadingText: "Don't have an account?",
                actionText: "Sign Up",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SignUpView()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
