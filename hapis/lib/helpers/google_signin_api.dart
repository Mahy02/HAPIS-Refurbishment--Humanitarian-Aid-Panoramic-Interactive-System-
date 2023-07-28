import 'package:google_sign_in/google_sign_in.dart';

/// `GoogleSignInApi` class which is responsible for all functionalities related to google signing in
class GoogleSignInApi {
  /// property that defines instance of `GoogleSignIn`
  static final _googleSignIn = GoogleSignIn();

  /// `login` function that calls Google signIn method
  static Future login() => _googleSignIn.signIn();

  /// `logout` function that calls Google disconnect method
  static Future logout() => _googleSignIn.disconnect();

  /// function to determine whether user is signed in or not by getting currentUser and checking if null
  bool isUserSignedIn() {
    return _googleSignIn.currentUser != null;
  }

  /// function for getting the current authorized user
  GoogleSignInAccount? getCurrentUser() {
    return _googleSignIn.currentUser;
  }
}
