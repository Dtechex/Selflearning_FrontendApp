import 'dart:convert';
import 'package:http/http.dart';
import 'package:self_learning_app/features/category/data/model/category_model.dart';
import 'package:self_learning_app/features/subcategory/model/sub_cate_model.dart';
import '../../../../utilities/base_client.dart';

class CategoryRepo {

  static Future<List<CategoryModel>> getAllCategory() async {
    Response res = await Api().get(
      endPoint: 'category',
    );
    var data = await jsonDecode(res.body);
    print(data);
    List<dynamic> recordata = data['data']['record'];
    List<CategoryModel> recordList = [];
    if (recordata.isEmpty) {
      return recordList;
    } else {
      for (var element in recordata) {
        recordList.add(CategoryModel.fromJson(element));
      }
    }
    return recordList;
  }


  static Future<List<SubCategoryModel>> getAllSubCategory(String? rootId) async {
    print('subcategory api called');
    Response res = await Api().get(
      endPoint: 'category/?rootId=$rootId',
    );
    print(rootId);
    print(res.body);
    print('subcategory body');
    var data = await jsonDecode(res.body);
    List<dynamic> recordata = data['data']['record'];
    List<SubCategoryModel> recordList = [];
    if (recordata.isEmpty) {
      return recordList;
    } else {
      for (var element in recordata) {
        recordList.add(SubCategoryModel.fromJson(element));
      }
    }
    return recordList;
  }

  //Search Category


}
