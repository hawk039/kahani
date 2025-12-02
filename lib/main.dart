import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kahani_app/presentation%20/auth/login/login_view.dart';
import 'package:kahani_app/presentation%20/auth/login/login_view_model.dart';
import 'package:kahani_app/presentation%20/auth/signup/signup_view.dart';
import 'package:kahani_app/presentation%20/auth/signup/signup_view_model.dart';
import 'package:kahani_app/presentation%20/home/home.dart';
import 'package:kahani_app/presentation%20/home/home_view_model.dart';
import 'package:kahani_app/presentation%20/stories/stories.dart';
import 'package:kahani_app/services/google_signin_service.dart';
import 'package:provider/provider.dart'; // <-- added provider
import 'core/utils/theme.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive Init
  await Hive.initFlutter();
  await Hive.openBox('authBox');
  final authBox = Hive.box('authBox');

  final String? token = authBox.get('token');

  // Firebase Init
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Google Sign-In Init
  await GoogleSignInService().initialize(
    serverClientId:
        "483636251174-ivros4mu1nii96q3d583fgdoiqci3sbs.apps.googleusercontent.com",
  );

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: MyApp(isLoggedIn: token != null && token.isNotEmpty),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kahani',
      theme: AppTheme.darkTheme,
      home: isLoggedIn ? const StoriesPage() : const SignUpView(),
    );
  }
}
