import 'dart:convert';
import '../../../../utilities/base_client.dart';
import '../../../subcategory/model/resources_model.dart';
import 'package:http/http.dart';

class ResourcesRepo {
  static Future<AllResourcesModel?> getResources(
      {required String rootId, required String mediaType, String ?resQueary}) async {
    Response res = await Api().get(
      endPoint: 'resource?rootId=$rootId&type=$mediaType&title=$resQueary',
    );

    if (res.statusCode == 200) {
      var data = await jsonDecode(res.body);
      print("Fetched Data ===>>> ${jsonDecode(res.body)}");
      return AllResourcesModel.fromJson(data);
    }
    print(res.body);
  }

  static Future<int?> deleteResource({
    required String rootId,
  }) async {
    print('delete');
    Response res = await Api().delete(
      endPoint: 'resource/$rootId',
    );
    print(res.body);
    print("res.body");
    return res.statusCode;
  }

  static Future<AllResourcesModel?> addResources(
      {required String rootId,
      required String type,
      required String mediaPath}) async {
    Response res = await Api().get(
      endPoint: 'resource',
    );
    if (res.statusCode == 200) {
      var data = await jsonDecode(res.body);
      return AllResourcesModel.fromJson(data);
    }
    print(res.body);
  }
}
