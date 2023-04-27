import 'dart:convert';
import 'package:http/http.dart';
import '../../../../utilities/base_client.dart';
import 'package:http/http.dart' as http;

import '../../../../utilities/shared_pref.dart';
import 'model/quick_type_model.dart';

class QuickImportRepo {

  static Future<List<QuickImportModel>> getAllCategory({String? rootId}) async {

    Response res = await Api().get(
      endPoint: 'category/${rootId??''}',
    );
    var data = await jsonDecode(res.body);
    print(data);
    List<dynamic> recordata = data['data']['record'];
    List<QuickImportModel> recordList = [];
    if (recordata.isEmpty) {
      return recordList;
    } else {
      for (var element in recordata) {
        recordList.add(QuickImportModel.fromJson(element));
      }
    }
    return recordList;
  }


  static Future<int?> deletequickAdd({required String id,}) async {
    print('deletee category');
    var token = await SharedPref().getToken();
    var url= Uri.parse('http://3.110.219.9:8000/web/resource/$id');
    print(url);
    Response res = await http.delete(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
    },);

   print(res.body);
   print('res.body');

    //'resource/quickAdd'
    var data = await jsonDecode(res.body);
    print(data);

    return res.statusCode;

  }

  static Future<int?> addCategory({String? title,String? rootId}) async {
    Map<String, dynamic> payload = {};
    List<String> keywords = [];
    List<Map<String, String>> styles = [
      {"key": "font-size", "value": "12"},
      {"key": "background-color", "value": '4280079139'}
    ];
    payload.addAll({
      "name": title,
    });
    payload.addAll({"keywords": keywords});
    payload.addAll({"styles": styles});
    if(rootId!=null) {
      payload.addAll({"rootId":rootId});
    }
    print(payload);
    print('payload');
    var token = await SharedPref().getToken();
      var res = await http.post(
        Uri.parse('http://3.110.219.9:8000/web/category/create'),
        body: jsonEncode(payload),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      print(res);
      print(res.body);
      print('added to category');

    return res.statusCode;
  }


}
