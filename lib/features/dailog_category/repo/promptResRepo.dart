import 'package:dio/dio.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';

class PromptResRepo {
  static final Dio _dio = Dio();
  static String token = SharedPref.getUserToken();

static Future<Response?> get_Res_Prompt({required String dailogId})async{
  final Map<String, dynamic> headers = {
    'Authorization': 'Bearer $token',
  };
  try{
    Response res = await _dio.get("https://selflearning.dtechex.com/web/category/get-dialog-detail?dialogId=$dailogId",options: Options(headers: headers));
    return res;

  }catch(e){

  }
}
  static Future<Response?> AddPromptInResource({required String resourceId, required String promptId})async{
    final Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };
   try{
     Response res = await _dio.post("path",options: Options(headers: headers));
     return res;

   }catch(e){

   }


  }

  static Future<Response?> getPrompResource({required String resourceId}) async {

    final Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };
    try{
      Response res = await _dio.get("https://selflearning.dtechex.com/web/prompt?resourceId=$resourceId",options: Options(headers: headers));
      return res;

    }catch(e){
        print(e);
    }

  }

  static Future<Response> deleteResource({required String resourceId}) async {
    var token = await SharedPref().getToken();
    Response res;
    try {
      res = await _dio.delete(
          'https://selflearning.dtechex.com/web/resource/${resourceId}',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
          )
      );

      //print(res.body);
      //print('data');
    } on DioError catch (_) {
      res = Response(requestOptions: RequestOptions());
      res.statusCode = 400;
    }

    return res;
  }

}