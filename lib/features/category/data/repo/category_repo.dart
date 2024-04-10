import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart';
import 'package:self_learning_app/features/category/data/model/category_model.dart';
import 'package:self_learning_app/features/subcategory/model/sub_cate_model.dart';
import '../../../../utilities/base_client.dart';
import '../../../../utilities/shared_pref.dart';

class CategoryRepo {

  static Future<dio.Response> deleteCategory({required String rootId}) async {
    var token = await SharedPref().getToken();
    dio.Response res;
    try {
      res = await dio.Dio().delete(
        'https://virtuosocity.com/web/category/${rootId}',
        options: dio.Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        )
      );

      //print(res.body);
      //print('data');
    } on dio.DioError catch (_) {
      res = dio.Response(requestOptions: dio.RequestOptions());
      res.statusCode = 400;
    }

    return res;
  }

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
    print("we are printing recorddata${recordata}");
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
