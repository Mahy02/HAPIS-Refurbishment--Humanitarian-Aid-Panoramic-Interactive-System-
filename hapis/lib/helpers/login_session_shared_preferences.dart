import 'package:shared_preferences/shared_preferences.dart';

///`LoginSessionSharedPreferences` to presist data in the app locally
/// A utility class for managing and persisting login session data locally using `shared_preferences`.
class LoginSessionSharedPreferences {
  /// instantce of  `SharedPreferences`
  static SharedPreferences? _prefs;

  /// key property of userID
  static const String _keyUserID = 'userID';

  /// key property of isLoggedIn
  static const String _keyIsLoggedIn = 'isLoggedIn';

  /// Initializes the SharedPreferences instance for local data storage.
  static Future init() async => _prefs = await SharedPreferences.getInstance();

  //for users:
 
 /// Sets the user ID in the session.
  static Future<void> setUserID(String userID) async {
    await _prefs?.setString(_keyUserID, userID);
  }

  /// Retrieves the user ID from the session
  static String? getUserID() {
    return _prefs?.getString(_keyUserID);
  }

   /// Removes the user ID from the session.
  static Future<void> removeUserID() async {
    await _prefs?.remove(_keyUserID);
  }
   
   /// Sets the login status in the session.
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    await _prefs?.setBool(_keyIsLoggedIn, isLoggedIn);
  }

   /// Retrieves the login status from the session.
  static bool getLoggedIn() {
    return _prefs?.getBool(_keyIsLoggedIn) ?? false;
  }

 
}





  


  
