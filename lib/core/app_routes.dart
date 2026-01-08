import 'package:flutter/material.dart';
import 'package:kahani_app/data/models/story.dart';
import 'package:kahani_app/presentation%20/auth/login/login_view.dart';
import 'package:kahani_app/presentation%20/auth/password_reset/forget_password.dart';
import 'package:kahani_app/presentation%20/auth/password_reset/password_reset_confirmation_screen.dart';
import 'package:kahani_app/presentation%20/auth/signup/signup_view.dart';
import 'package:kahani_app/presentation%20/home/home.dart'; // Import HomePage
import 'package:kahani_app/presentation%20/stories/stories.dart';
import 'package:kahani_app/presentation%20/stories/story_detail_page.dart';

class AppRoutes {
  static const login = LoginScreen.routeName;
  static const signup = SignUpView.routeName;
  static const stories = StoriesPage.routeName;
  static const home = HomePage.routeName; // Add Home Route
  static const forgotPassword = ForgotPasswordScreen.routeName;
  static const passwordResetConfirmation =
      PasswordResetConfirmationScreen.routeName;
  static const storyDetail = StoryDetailPage.routeName;

  static final routes = {
    login: (context) => const LoginScreen(),
    signup: (context) => const SignUpView(),
    stories: (context) => const StoriesPage(),
    home: (context) => const HomePage(), // Add to route map
    forgotPassword: (context) => ForgotPasswordScreen(),
    passwordResetConfirmation: (context) =>
        const PasswordResetConfirmationScreen(),
    storyDetail: (context) {
      final story = ModalRoute.of(context)!.settings.arguments as Story;
      return StoryDetailPage(story: story);
    },
  };
}
