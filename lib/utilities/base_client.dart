import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';
import 'constants.dart';


class Api with ChangeNotifier
{
  // get client helper
  Future<Response> get({required String endPoint}) async {
    try {
      var token = await SharedPref().getToken();
      const int TIME_OUT_DURATION = 50;
      String base = DEVELOPMENT_BASE_URL;
      var url = Uri.parse(base + endPoint);
      final response = await http.get(url,headers: {
        'Authorization': 'bearer' + ' ' + token.toString(),
      },).timeout(const Duration(seconds: TIME_OUT_DURATION));
      return response;
    } on SocketException {
      throw ('No Internet Connection');
    } on TimeoutException {
      throw ('API not responded in time');
    }
  }

  // post api client

  Future<http.Response> post(
      {required BuildContext context ,required String endPoint,
        required Map<String, dynamic> payload}) async {
    try{
      var token = await SharedPref().getToken();
      String base = DEVELOPMENT_BASE_URL;
      var uri = Uri.parse(base + endPoint);

      var response = await http.post(uri,headers: {
        'Authorization': 'bearer' + ' ' + token.toString(),
      }, body: payload);
      return response;
    }on SocketException {
      context.showSnackBar(SnackBar(content: Text('No Internet')));
    }
      throw ('No Internet Connection');
  }



  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final decoderesponse =
        json.decode(response.body) as Map<String, dynamic>;
        return decoderesponse;
      case 201:
        final responsejson = json.decode(response.body) as Map<String, dynamic>;
        return responsejson;
      case 400:
      // throw BadRequestException(
      //     utf8.decode(response.bodyBytes), response.request.url.toString());
      case 401:

      case 403:
      // throw UnAuthroizedExcpetion(
      //     utf8.decode(response.bodyBytes), response.request.url.toString());
      case 500:
        final decoderesponse =
        json.decode(response.body) as Map<String, dynamic>;
        return decoderesponse;

      default:
      // throw FetchDataException('Error occured with code :${response.statusCode}',
      //     response.request.url.toString());
    }
  }
}