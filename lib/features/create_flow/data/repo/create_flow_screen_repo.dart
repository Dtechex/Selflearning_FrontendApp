

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../utilities/base_client.dart';
import '../../../../utilities/shared_pref.dart';

class CreateFlowRepo {
  static Future<Response?> createFlow(
      {required String title,}) async {
    try {
      final token = await SharedPref().getToken();

      var request = await Dio().post(
          'https://selflearning.dtechex.com/web/prompt/',
          data: {
            'title': title,
          },
          options: Options(
              headers: {"Authorization": 'Bearer $token'}
          ));
      return request;
    } catch (e) {
      print(e);
    }
    return null;
  }
  static Future<Response?> selectFlow({required String flowId,required String flowType, required String rootId }) async {
    try {
      final token = await SharedPref.getUserToken();
      print("---$token");
      Response res = await Dio().put(
          'https://selflearning.dtechex.com/web/flow/update/$flowId',
          data: {
            'type': "primary",
          },
          options: Options(
              headers: {"Authorization": 'Bearer $token'}
          ));
      print(res.data);
      return res;
    }catch(e){
      print(e);
    }
  }

  static Future<Response> getAllFlow({required String catID}) async {
    Response response;

    try{
      final token = await SharedPref().getToken();
      response = await Dio().get(
          'https://selflearning.dtechex.com/web/flow?categoryId=$catID',
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
    return response;
  }

  static Future<Response> deleteFlow({required String flowId}) async {
    Response response;

    try{
      final token = await SharedPref().getToken();
      response = await Dio().delete(
          'https://selflearning.dtechex.com/web/flow/$flowId',
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

    return response;
  }
  static Future<Response> selectedPrompts ({required String flowId}) async{
    Response response;
    try{
      final token = await SharedPref().getToken();
      response = await Dio().post("https://selflearning.dtechex.com/web/flow/$flowId",
      options: Options(
        headers: {"Authorization": 'Bearer $token'}
      )
      );

    }on DioError catch (e) {
      response = Response(requestOptions: RequestOptions());
      response.data = {
        'msg' : 'Failed to communicate with server!',
        'errorMsg' : e.toString(),
      };
      response.statusCode = 400;
    }
    return response;

  }

}
