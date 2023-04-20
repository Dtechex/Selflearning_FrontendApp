import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:http_parser/http_parser.dart';

import '../../../utilities/shared_pref.dart';

class UploadResRepo {

  static Future<int?> uploadMediaFiles({XFile? file,String? rootId}) async {
    print('upload api');
    var postUri = Uri.parse("http://3.110.219.9:8000/web/resource/add");
    var request = http.MultipartRequest("POST", postUri);
    var token = await SharedPref().getToken();
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },);
    request.fields['type'] = 'image';
    request.fields['rootId'] = rootId!;
    request.files.add(http.MultipartFile.fromBytes(
        'content', await File.fromUri(Uri.parse(file!.path)).readAsBytes(),
        contentType: MediaType('image', 'jpeg')));
    
    request.send().then((response) {
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        print('value');
      });
      if (response.statusCode == 200) print("Uploaded!");
    });
  }
}
