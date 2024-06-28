import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../../utilities/shared_pref.dart';

class ScheduleRepo{

 static Future<Response?> getFlow({String? queary}) async {

    Response response;

    try{
      final token = await SharedPref().getToken();
      dynamic check = Jwt.parseJwt(token.toString());
      print("to decode token $check");
      response = await Dio().get(
          'https://backend.savant.app/web/flow?keyword=$queary',
          options: Options(
              headers: {"Authorization": 'Bearer $token'}
          ));
    }on DioError catch (e) {
      response = Response(requestOptions: RequestOptions());
      response.data = {
        'msg' : 'Failed to communicate with server!',
        'errorMsg' : e.toString(),
      };
      response.statusCode = 400;
    }

    print('Flowww $response');
    return response;  }
 static Future<Response?> addDateTime({required String? flowId, required DateTime? scheduledDateTime,}) async {

   Response response;
   String formattedDateTime = scheduledDateTime!.toIso8601String();

   try{
     final token = await SharedPref().getToken();
     dynamic check = Jwt.parseJwt(token.toString());
     print("to decode token $check");
     response = await Dio().put(
         'https://backend.savant.app/web/flow/update/$flowId',
         data: {
           'scheduledDateTime': formattedDateTime,

         },
         options: Options(
             headers: {"Authorization": 'Bearer $token'}
         ));
   }on DioError catch (e) {
     response = Response(requestOptions: RequestOptions());
     response.data = {
       'msg' : 'Failed to communicate with server!',
       'errorMsg' : e.toString(),
     };
     response.statusCode = 400;
   }

   print('Flowww $response');
   return response;  }


}