import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kahani_app/presentation%20/auth/login/login_view.dart';
import 'package:kahani_app/presentation%20/auth/login/login_view_model.dart';
import 'package:kahani_app/presentation%20/home/home_view_model.dart';
import 'package:kahani_app/presentation%20/stories/stories.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/utils/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('authBox');

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
            themeMode: ThemeMode.dark, // 1. Force dark mode
            darkTheme: ThemeData( // 2. Define the dark theme
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppTheme.primary,
              primaryColor: AppTheme.primary,
              colorScheme: const ColorScheme.dark(
                primary: AppTheme.primary,
                secondary: AppTheme.secondary,
              ),
              dialogBackgroundColor: AppTheme.primary, // Set a default dialog background
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: child,
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
