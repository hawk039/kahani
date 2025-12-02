import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';

class AppleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in with Apple for both Android & iOS
  Future<UserCredential> signInWithApple() async {
    // On Android: Apple Sign-In must use a Web Authentication flow
    final isAndroid = Platform.isAndroid;

    final AuthorizationCredentialAppleID appleCredential =
    await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],

      // Only needed on Android web based auth
      webAuthenticationOptions: isAndroid
          ? WebAuthenticationOptions(
        clientId:
        'com.kahani.app', // Service ID from Apple Developer Console (NOT bundle id)
        redirectUri:
        Uri.parse('https://com.kahani.app/callbacks/sign_in_with_apple'),
      )
          : null,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    // Firebase sign-in
    final userCredential =
    await _auth.signInWithCredential(oauthCredential);

    return userCredential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
