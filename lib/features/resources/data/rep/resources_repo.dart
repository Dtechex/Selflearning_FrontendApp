
import 'dart:convert';

import '../../../../utilities/base_client.dart';
import '../../../subcategory/model/resources_model.dart';
import 'package:http/http.dart';

class ResourcesRepo{

  static Future<AllResourcesModel?> getResources({required String rootId})async {
    Response res = await Api().get(
      endPoint: 'resource',);
    if(res.statusCode==201){
      var data = await jsonDecode(res.body);
      return AllResourcesModel.fromJson(data);
    }
    print(res.body);
  }
}