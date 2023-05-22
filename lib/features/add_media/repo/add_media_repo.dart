import 'package:http/http.dart' as http;

import '../../../utilities/shared_pref.dart';

class AddMediaRepo {

  static Future <String?> uploadFileToServer({String? imagePath}) async {
    print(imagePath);
    final token = await SharedPref().getToken();
    var request = http.MultipartRequest(
        "POST", Uri.parse('http://3.110.219.9:8000/web/resource/quickAdd'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['type'] = 'QUICKADD';
    request.fields['title'] = 'My first image';
   // request.fields['content'] = 'My first image';
    request.files.add(await http.MultipartFile.fromPath('content', imagePath!));
    request.send().then((response) {
      http.Response.fromStream(response).then((onValue) {
        try {
          print(onValue.body);
          // get your response here...
        } catch (e) {
          print(e);
          print('error');
          // handle exeption
        }
      });
    });
  }
      // var response = await dio.post(
      //   'web/resource/quickAdd',
      //   data: data,);
      // print(response);

      // final data = response.data;
      // print(data);
      //
      // String imageUrl = data['image'];
     // return imageUrl;
    }

// final token= await SharedPref().getToken();
// http.MultipartRequest request = http.MultipartRequest("POST", Uri.parse('http://3.110.219.9:8000/web/resource/quickAdd'));
// request.headers['Authorization'] = 'Bearer $token';
// request.fields['title'] = 'dfgdfgdsf';
// request.fields['type'] = 'QUICKADD';


  // Future<void> postJob(context) async {
  //   try{
  //     var latitude = await SharedPref().getLat();
  //     var longitude = await SharedPref().getLong();
  //     String fbid = await SharedPref().getfbId();
  //     String token = await SharedPref().getToken();
  //     setState(() {
  //       _isloading = true;
  //     });
  //     List<File> _image = []; //=   File( imageArray[0].path);
  //     for (int i = 0; i < imageArray.length; i++) {
  //
  //       File img = File(imageArray[i].path);
  //       _image.add(img);
  //     }
  //     Map<String, String> headers = {"Authorization": 'bearer' + ' ' + token,
  //       'socialId':fbid==null?'':fbid};
  //     final uri = Uri.parse(DEVELOPMENT_BASE_URL+endPoints.postJob);
  //     var request = http.MultipartRequest('POST', uri);
  //     for (var file in _image) {
  //       String fileName = file.path.split("/").last;
  //       var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
  //       // get file length
  //       var length = await file.length(); //imageFile is your image file
  //       // multipart that takes file
  //       var multipartFileSign = new http.MultipartFile(
  //           'image[]', stream, length,
  //           filename: fileName);
  //       request.files.add(multipartFileSign);
  //     }
  //     request.headers.addAll(headers);
  //     request.fields["address"] = _locationController.text;
  //     request.fields["title"] = _titleController.text;
  //     request.fields["contact_person"] = _contactPersonController.text;
  //     request.fields["phone_no"] = _phoneNumberController.text;
  //     request.fields["email"] = _emailController.text;
  //     request.fields["latitude"] = latitude.toString();
  //     request.fields["longitude"] = longitude.toString();
  //     request.fields["job_cat_ids"] = selectedjobcatid;
  //     request.fields["job_type"] = '1';
  //     request.fields["description"] = _descriptionController.text;
  //
  //     var response = await request.send();
  //     response.stream.transform(utf8.decoder).listen((value) {
  //       setState(() {
  //         _isloading = false;
  //         var res = jsonDecode(value);
  //         if (response.statusCode == 200) {
  //           CustomSnackbar.ShowSnackBar(context, 'Job added successfully', '');
  //           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage(index: 1),), (route) => false).then((value){
  //             Provider.of<ChatProvider>(context,listen: false).fetchchatCount(context);
  //           });
  //         } else {
  //           res['data'] == null
  //               ? CustomSnackbar.ShowSnackBar(
  //               context, res['error'].toString(), '')
  //               : CustomSnackbar.ShowSnackBar(
  //               context, res['error']['message'].toString(), "");
  //         }
  //       });
  //     });
  //   }catch(e){
  //   }finally{
  //     setState(() {
  //       _isloading = false;
  //     });
  //   }
  //
  //
  // }
  //


