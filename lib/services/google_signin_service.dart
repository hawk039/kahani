import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  // Use the singleton instance
  final GoogleSignIn _google = GoogleSignIn.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Call once during app startup (eg. main() or arg init service).
  /// serverClientId: the **Web/Server client id** from Google Cloud console / Firebase
  /// (the web client id is required on Android for the new Credential Manager flow).
  Future<void> initialize({String? serverClientId}) async {
    await _google.initialize(serverClientId: serverClientId);
  }

  /// Returns a Firebase [UserCredential] on success.
  Future<UserCredential> signInWithGoogle() async {
    try {
      // interactive sign-in
      final GoogleSignInAccount googleAccount = await _google.authenticate();

      // If authenticate throws/cancels it will be caught below
      // Get the idToken (v7 returns idToken via GoogleSignInAuthentication)
      final GoogleSignInAuthentication auth = await googleAccount.authentication;

      final String? idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        // Could happen if the configuration is wrong (missing client id, SHA, etc.)
        throw FirebaseAuthException(
          code: 'NO_ID_TOKEN',
          message: 'No id token returned by Google Sign-In. Check your client IDs and Firebase config.',
        );
      }

      // Create Firebase credential using idToken only (accessToken not required here)
      final credential = GoogleAuthProvider.credential(idToken: idToken);

      // Sign in to Firebase with that credential
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } on GoogleSignInException catch (e) {
      // google_sign_in new exception; convert to understandable FirebaseAuthException-like error
      throw FirebaseAuthException(code: e.code.name, message: e.description);
    } on FirebaseAuthException {
      rethrow;
    } catch (e, st) {
      // wrap unexpected errors
      throw FirebaseAuthException(code: 'UNKNOWN', message: e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await _google.signOut();
    } catch (_) {}
  }
}