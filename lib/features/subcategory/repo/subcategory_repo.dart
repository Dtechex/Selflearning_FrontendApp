import 'package:http/http.dart' as http;
class SubcategoryRepo{

  static Future<void> getResources(String rootId)async {
    final response = await http
        .get(Uri.parse('http://3.110.219.9:8000/web/resource/'));
    print(response);
  }
}