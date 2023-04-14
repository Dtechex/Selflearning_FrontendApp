import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../utilities/shared_pref.dart';

class LoginRepo {
  static Future<int?> loginUser(
      {required String email, required String password}) async {
    final response = await http.post(
        Uri.parse('http://3.110.219.9:8000/web/user/login'),
        body: {"email": email, "password": password});
    if (response.statusCode == 201) {
      var res = jsonDecode(response.body);
      SharedPref().saveToken(res['data']['token']);
    }
    return response.statusCode;
  }
}
