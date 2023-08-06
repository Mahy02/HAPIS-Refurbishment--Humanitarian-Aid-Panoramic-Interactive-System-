import 'package:shared_preferences/shared_preferences.dart';

///`LoginSessionSharedPreferences` to presist data in the app locally

class LgConnectionSharedPref {
  static SharedPreferences? _prefs;
  static const String _keyIP = 'ip';
  static const String _keyPort = 'port';
  static const String _keyUserName = 'userName';
  static const String _keyPassword = 'pass';
  static const String _keyScreenAmount = 'screenAmount';
  static const String _keyIsConnected = 'isConnected';

  static Future init() async => _prefs = await SharedPreferences.getInstance();

  // Setters
  static Future<void> setIP(String ip) async =>
      await _prefs?.setString(_keyIP, ip);

  static Future<void> setPort(String port) async =>
      await _prefs?.setString(_keyPort, port);

  static Future<void> setUserName(String userName) async =>
      await _prefs?.setString(_keyUserName, userName);

  static Future<void> setPassword(String pass) async =>
      await _prefs?.setString(_keyPassword, pass);

  static Future<void> setScreenAmount(int screenAmount) async =>
      await _prefs?.setInt(_keyScreenAmount, screenAmount);
  
  //  static Future<void> setIsConnected(bool isConnected) async =>
  //     await _prefs?.setBool(_keyIsConnected, isConnected);

  // Getters
  static String? getIP() => _prefs?.getString(_keyIP);

  static String? getPort() => _prefs?.getString(_keyPort);

  static String? getUserName() => _prefs?.getString(_keyUserName);

  static String? getPassword() => _prefs?.getString(_keyPassword);

  static int? getScreenAmount() => _prefs?.getInt(_keyScreenAmount);

  // static bool? getIsConnected() => _prefs?.getBool(_keyIsConnected);

  // Removers
  static Future<void> removeIP() async => await _prefs?.remove(_keyIP);

  static Future<void> removePort() async => await _prefs?.remove(_keyPort);

  static Future<void> removeUserName() async =>
      await _prefs?.remove(_keyUserName);

  static Future<void> removePassword() async =>
      await _prefs?.remove(_keyPassword);

  static Future<void> removeScreenAmount() async =>
      await _prefs?.remove(_keyScreenAmount);

  // static Future<void> removeIsConnected() async =>
  //     await _prefs?.remove(_keyIsConnected);

}
