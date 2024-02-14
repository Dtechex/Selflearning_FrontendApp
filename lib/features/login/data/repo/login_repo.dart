import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../utilities/shared_pref.dart';
import '../../../UrlEanc/UrlEncap.dart';

class LoginRepo {
  static UrlEncapsulation urlEcapsulation = UrlEncapsulation();
  static String? baseUrl = urlEcapsulation.getUrl().toString();
  static Future<int?> loginUser(
      {required String email, required String password}) async {
    final response = await http.post(
        Uri.parse('https://virtuosocity.com/web/user/login'),
        body: {"email": email, "password": password});
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
