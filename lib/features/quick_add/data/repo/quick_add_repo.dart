import 'dart:convert';
import 'package:http/http.dart';
import 'package:self_learning_app/features/quick_add/data/repo/model/quick_type_model.dart';
import '../../../../utilities/base_client.dart';

class QuickAddRepo {
  static Future<int?> quickAdd({required String title}) async {
    print('add category');
    Response res = await Api().post(
      payload: {
        "type":"QUICKADD",
        "content":title
      },
      endPoint: 'resource/quickAdd',
    );
    var data = await jsonDecode(res.body);
    print(data);
    return res.statusCode;
  }

  static Future<List<QuickTypeModel>> getAllQuickTypes() async {
    Response res = await Api().get(
      endPoint: 'resource/quickAdd',
    );
    var data = await jsonDecode(res.body);
    // print(data);
    // print('quick type srespne');
    List<dynamic> recordata = data['data']['record'];
    // print(recordata);
    // print('recordata');
    List<QuickTypeModel> recordList = [];
    if (recordata.isEmpty) {
      return recordList;
    } else {
      for (var element in recordata) {
          print('${element} this is one element');
        recordList.add(QuickTypeModel.fromJson(element));
      }
        print(QuickTypeModel().content);
    }
    // print(recordList.runtimeType);
    // print(recordList[0].content);
    return recordList;
  }


}
