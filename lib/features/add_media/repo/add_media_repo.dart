import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'dart:io';
import '../../../utilities/shared_pref.dart';
import 'package:http_parser/http_parser.dart';

class AddMediaRepo {
  static Future<String?> addQuickAddwithResources(
      {String? imagePath, required String title,required int contenttype}) async {
    print('quickadd');
    try {
      final token = await SharedPref().getToken();
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('http://3.110.219.9:8000/web/resource/quickAdd/'),
      );

      request.headers['Authorization'] = 'Bearer $token';
     switch(contenttype){
       case 0:{
         request.fields['type'] = 'QUICKADD-text';
       }
       break;
       case 1:{
         request.fields['type'] = 'QUICKADD-image';
       }
       break;
       case 2:{
         request.fields['type'] = 'QUICKADD-audio';
       }
       break;
       case 3:{
         request.fields['type'] = 'QUICKADD-video';
       }
     }
      request.fields['title'] = title;
      print(imagePath!.length);


      if (imagePath.isNotEmpty) {
        print('inide');
        var file = File(imagePath);
        var mimeType = lookupMimeType(file.path);
        request.files.add(http.MultipartFile.fromBytes(
          'content',
          await file.readAsBytes(),
          filename: file.path
              .split('/')
              .last,
          contentType: MediaType.parse(mimeType!),
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print(response.body);
      print('response of quick add');
      return response.body;
    } catch (e) {
      print(e);
      print('erroeer');
      return null;
    }
  }

  static Future<String?> addPrompt({String? imagePath,required String resourcesId,required String name,}) async {
    print('addpromt');
    try{
      final token = await SharedPref().getToken();
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('http://3.110.219.9:8000/web/prompt/'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['resourceId'] = resourcesId;
      request.fields['name'] = name;

      if (imagePath != null) {
        var file = File(imagePath);
        var mimeType = lookupMimeType(file.path);

        request.files.add(http.MultipartFile(
          'content',
          file.openRead(),
          await file.length(),
          filename: file.path
              .split('/')
              .last,
          contentType: MediaType.parse(mimeType!),
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final data=jsonDecode(response.body);
      print(data);
      print('gg');
      return data[''];

    }catch(e){
      print(e);
    }
  }

  static Future<String?> addResources(
      {String? imagePath, required String resourceId}) async {
    print(resourceId);
    print('resource inside add reouse' );
    print('add resources');
    final token = await SharedPref().getToken();
    var request = http.MultipartRequest(
      "POST", Uri.parse('http://3.110.219.9:8000/web/resource/'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['rootId'] = resourceId;
    request.fields['type'] = 'image';
    print(imagePath!.isEmpty);
    print('imagePath');

    if (imagePath.isNotEmpty) {
      print('inside multitpart');
      var file = File(imagePath);
      var mimeType = lookupMimeType(file.path);
      request.files.add(http.MultipartFile.fromBytes('content', await file.readAsBytes(), filename: file.path.split('/').last, contentType: MediaType.parse(mimeType!),
      ));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);


      print(response.body);
      return response.body;
    }
  }
