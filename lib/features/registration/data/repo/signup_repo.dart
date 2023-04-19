import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../utilities/shared_pref.dart';

class SignUpRepo {
  static Future<int?> loginUser(
      {required String name,
      required String email,
      required String password}) async {
    final response = await http
        .post(Uri.parse('http://3.110.219.9:8000/web/user/register'), body: {
      "name": name,
      "email": email,
      "password": password
    });
    print(response.body);
    return response.statusCode;
  }
}
