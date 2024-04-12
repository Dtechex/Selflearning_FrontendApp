import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import '../../../../utilities/shared_pref.dart';

class LoginRepo {
  static Future<int?> loginUser(
      {required String email, required String password}) async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? fcmtoken = await _firebaseMessaging.getToken();

    print("fcm token is ${fcmtoken}");
    final response = await http.post(
        Uri.parse('https://selflearning.dtechex.com/web/user/login'),
        body: {"email": email, "password": password,
        "deviceToken":fcmtoken
        });
    if (response.statusCode == 201) {
      print("login response ${response.body}");
      print("---------break");
      print(response.body);
      var res = jsonDecode(response.body);
      SharedPref().clear();
      SharedPref().saveToken(res['data']['token']);
    }
    return response.statusCode;
  }
}
