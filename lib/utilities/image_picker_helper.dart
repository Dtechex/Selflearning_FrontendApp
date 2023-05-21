import 'package:image_picker/image_picker.dart';

class ImagePickerHelper{
  static Future<XFile?> pickImage()async{
    final ImagePicker picker = ImagePicker();
    try{
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image;
    }catch(e){
      print('${e} ======> error while pick image');
    }
  }

}