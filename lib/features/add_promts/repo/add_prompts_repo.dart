import 'package:mime/mime.dart';

import '../../../utilities/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'dart:io';
import '../../../utilities/shared_pref.dart';
import 'package:http_parser/http_parser.dart';

class AddPromtsRepo {
  static Future<http.Response?> addSidePrompts(
      {required String resourcesId,
      String? name,
      String? side1,
      String? side2, required String categoryId}) async {
    print('addpromt');
    try {
      final token = await SharedPref().getToken();
      print(name);

      final data = {
        "name": name ?? 'Untitled',
        "side1": side1!,
        "side2": side2!,
        "resourceId": resourcesId,
        "categoryId": categoryId,
      };
      final gg = jsonEncode(data);
      print(gg);
      print("gg");
      var request = await http.post(
          Uri.parse('https://selflearning.dtechex.com/web/prompt/'),
          body: data,
          headers: {"Authorization": 'Bearer $token'});
      return request;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<http.Response> addResourcesForSide(
      {required int whichSide,
      String? content,
      required String resourceId,
      required int mediaType}) async {
    print('api called');
    final token = await SharedPref().getToken();
    var request = http.MultipartRequest(
      "POST",
      Uri.parse('https://selflearning.dtechex.com/web/resource/'),
    );
    print("mediaType ===>>> $mediaType");
    print("content ===>>> $content");
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['rootId'] = resourceId;
    request.fields["content"] = content ?? 'untitled';
    request.fields["title"] = 'unittled';
    print(mediaType);
    print("mediaType");

    // if (whichSide == 0) {
    //   request.fields['type'] = 'text-side1';
    // } else {
    //   request.fields['type'] = 'text-side2';
    // }
    bool isText = false;
    if (whichSide == 0) {
      print('side 1');

      switch (mediaType) {
        case 0:
          {
            request.fields['type'] = 'text-side1';
            request.fields['content'] = content!;
            isText = true;
          }
          break;
        case 1:
          {
            request.fields['type'] = 'image-side1';
          }
          break;
        case 2:
          {
            request.fields['type'] = 'audio-side1';
          }
          break;
        case 3:
          {
            request.fields['type'] = 'video-side1';
          }
      }
    } else {
      print('side 2');
      switch (mediaType) {
        case 0:
          {
            request.fields['type'] = 'text-side2';
            request.fields['content'] = content!;
            isText = true;
          }
          break;
        case 1:
          {
            request.fields['type'] = 'image-side2';
          }
          break;
        case 2:
          {
            request.fields['type'] = 'audio-side2';
          }
          break;
        case 3:
          {
            request.fields['type'] = 'video-side2';
          }
      }
    }

    // print(imagePath!.isEmpty);
    print('imagePath');
    if (!isText) {
      if (content!.isNotEmpty) {
        print('inside multitpart');
        var file = File(content);
        var mimeType = lookupMimeType(file.path);
        request.files.add(http.MultipartFile.fromBytes(
          'content',
          await file.readAsBytes(),
          filename: file.path.split('/').last,
          contentType: MediaType.parse(mimeType!),
        ));
      }
    }

    print(request.files);
    print(request.fields);
    print("request.fields");

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    final data = await jsonDecode(response.body);

    print(response.body);

    return response;
  }
}
