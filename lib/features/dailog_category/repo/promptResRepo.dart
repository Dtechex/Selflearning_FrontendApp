import 'package:dio/dio.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';

class PromptResRepo {
  static final Dio _dio = Dio();
  static String token = SharedPref.getUserToken();

static Future<Response?> get_Res_Prompt()async{
  final Map<String, dynamic> headers = {
    'Authorization': 'Bearer $token',
  };
  try{
    Response res = await _dio.get("path",options: Options(headers: headers));
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


}