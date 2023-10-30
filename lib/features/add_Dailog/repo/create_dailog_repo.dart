import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';

class DailogRepo{
  static Dio _dio = Dio();

  static Future<Response?> addDailog({required String dailog_name, required List resourceId, required List prompt, required String color,
    required List tags

  }) async{
    print("add dailog fun run");
    print("select prompt Id $prompt, selected resourceid=$resourceId");
    String token = SharedPref.getUserToken();
    print("shredpref=====$token");
    final Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };
    print("colors$color");
    List<Map<String, String>> styles = [
      {"key": "font-size", "value": "2rem"},
      {"key": "background-color", "value": color!.toString()}
    ];
    print("${dailog_name + color + tags.toString()}");
    Map<String, dynamic> payload = {};
    payload.addAll({
      "name": dailog_name.toString(),
    });
    payload.addAll({"resourceIds": resourceId});
    payload.addAll({'promptIds':prompt});
    payload.addAll({"keywords": tags});
    payload.addAll({"styles": styles});
    print("keywrods-==$payload");
    print("requestBody$payload");
    try{
      print("try bloc is run");
      Response res = await _dio.post("https://selflearning.dtechex.com/web/category/create-dialog",
          data: jsonEncode(payload),
          options: Options(headers: headers)
          );
      print("respone of dailog ${res.data}");
      if(res.statusCode == 200){
        print(res);
        print("inside of 2000 respone of dailog ${res.data}");

      }
      else{
        print(res);
        print("inside of else condition respone of dailog ${res.data}");

      }
      return res;
    }
    catch(e){
      print("error $e");
      return null;
    }

  }

  static Future<Response?> getDailog() async{
    String token = SharedPref.getUserToken();
    final Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };
    try{
      Response res = await _dio.get("https://selflearning.dtechex.com/web/category/get-dialogs",  options: Options(headers: headers));
      return res;
    }
    catch(e){
      print("error ${e.toString()}");
    }

  }

  static Future<Response> deleteDailog({required String dailogId}) async {
    var token = await SharedPref().getToken();
    Response res;
    try {
      res = await _dio.delete(
          'https://selflearning.dtechex.com/web/category/${dailogId}',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
          )
      );
      print("dailog delete response$res");

      //print(res.body);
      //print('data');
    } on DioError catch (_) {
      res = Response(requestOptions: RequestOptions());
      res.statusCode = 400;
    }

    return res;
  }


}