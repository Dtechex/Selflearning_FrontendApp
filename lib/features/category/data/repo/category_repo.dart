import 'dart:convert';
import 'package:http/http.dart';
import 'package:self_learning_app/features/category/data/model/category_model.dart';
import '../../../../utilities/base_client.dart';

class CategoryRepo {
  static Future<List<Record>> getAllCategory() async {
    Response res = await Api().get(
      endPoint: 'category',
    );
    var data = await jsonDecode(res.body);
    List<dynamic> recordata = data['data']['record'];
    List<Record> recordList = [];
    if (recordata.isEmpty) {
      return recordList;
    } else {
      for (var element in recordata) {
        recordList.add(Record.fromJson(element));
      }
    }
    return recordList;
  }
}
