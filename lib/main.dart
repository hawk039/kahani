import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kahani_app/services/google_signin_service.dart';

import 'package:kahani_app/data/models/story.dart';
import 'package:kahani_app/data/models/story_metadata.dart';
import 'package:kahani_app/core/config/config.dart';
import 'package:kahani_app/data/network/api_client.dart';

import 'package:kahani_app/presentation /auth/login/login_view.dart';
import 'package:kahani_app/presentation /auth/login/login_view_model.dart';
import 'package:kahani_app/presentation /home/home_view_model.dart';
import 'package:kahani_app/presentation /stories/stories.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/app_routes.dart';
import 'core/utils/theme.dart';
import 'firebase_options.dart';

// Read the server client ID from the environment variables passed at build time.
const serverClientId = String.fromEnvironment('SERVER_CLIENT_ID');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (serverClientId.isEmpty) {
    throw Exception('SERVER_CLIENT_ID is not provided. Please pass it as a --dart-define flag.');
  }

  // Initialize the environment first
  Environment().initialize();

  // Then initialize the ApiClient
  ApiClient.init();

  log("Running with base URL: ${Environment().config.baseUrl}");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the GoogleSignInService with the key from the environment.
  await GoogleSignInService().initialize(
    serverClientId: serverClientId,
  );

  await Hive.initFlutter();

  Hive.registerAdapter(StoryAdapter());
  Hive.registerAdapter(StoryMetadataAdapter());

  await Hive.openBox('authBox');
  await Hive.openBox<Story>('storiesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Kahani App',
            themeMode: ThemeMode.dark,
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppTheme.primary,
              primaryColor: AppTheme.primary,
              colorScheme: const ColorScheme.dark(
                primary: AppTheme.primary,
                secondary: AppTheme.secondary,
              ),
              dialogBackgroundColor: AppTheme.primary,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: child,
            routes: AppRoutes.routes,
          );
        },
        child: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('authBox');
    final token = box.get('token', defaultValue: null);

    if (token != null && token.isNotEmpty) {
      return const StoriesPage();
    } else {
      return const LoginScreen();
    }
  }
}
