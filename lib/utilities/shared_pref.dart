import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  String tokenkey = "token";

  Future<void> saveToken(String getToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenkey, getToken);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(tokenkey);
    return token;
  }

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}