import 'package:shared_preferences/shared_preferences.dart';

///`LoginSessionSharedPreferences` to presist data in the app locally

class LoginSessionSharedPreferences {
  /// instantce of  `SharedPreferences`
  static SharedPreferences? _prefs;

  /// key property of token
  static const _keyAccessToken = 'token';

  /// key property of expirty time
  static const String _expiryTimeKey = 'expiryTime';

  /// key property of userID
  static const String _keyUserID = 'userID';

  /// key property of isLoggedIn
  static const String _keyIsLoggedIn = 'isLoggedIn';

  ///initialization
  static Future init() async => _prefs = await SharedPreferences.getInstance();

  //for users:

  static Future<void> setUserID(String userID) async {
    await _prefs?.setString(_keyUserID, userID);
  }

  static String? getUserID() {
    return _prefs?.getString(_keyUserID);
  }

  static Future<void> removeUserID() async {
    await _prefs?.remove(_keyUserID);
  }

  static Future<void> setLoggedIn(bool isLoggedIn) async {
    await _prefs?.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  static bool getLoggedIn() {
    return _prefs?.getBool(_keyIsLoggedIn) ?? false;
  }

  //for google users:
  static Future<void> saveToken(String accessToken, DateTime expiryTime) async {
    await _prefs!.setString(_keyAccessToken, accessToken);
    await _prefs!.setString(_expiryTimeKey, expiryTime.toIso8601String());
  }

  static Future<String?> getToken() async {
    String? accessToken = _prefs!.getString(_keyAccessToken);
    String? expiryTimeString = _prefs!.getString(_expiryTimeKey);
    if (accessToken != null && expiryTimeString != null) {
      DateTime expiryTime = DateTime.parse(expiryTimeString);
      if (expiryTime.isAfter(DateTime.now())) {
        // token is still valid
        return accessToken;
      }
    }
    // token has expired or does not exist
    return null;
  }

// // Generate a JWT for the user
// Future<void> generateJWT(String userIdentifier, String secret) async {
//   // Set the expiration time to 1 hour from now
//   int expirationTime = DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000;

//   Map<String, dynamic> payload = {
//     'sub': userIdentifier,
//     'exp': expirationTime,
//   };

//   String token = JWT.encode(payload, secret);

//   await _prefs.setString('jwt', token);
// }

// // Retrieve the JWT from SharedPreferences
// Future<String> getJWT() async {
//   String jwt = _prefs.getString('jwt') ?? '';
//   return jwt;
// }
}
