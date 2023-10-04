import 'package:dio/dio.dart';
import 'package:self_learning_app/features/subcategory/primaryflow/data/primary_model.dart';

import '../../../../../utilities/shared_pref.dart';

class AddPromptsToPrimaryFlowRepo {
  static Future<Response> getData({required String mainCatId}) async {
    final token = await SharedPref().getToken();

    final Options options = Options(
      headers: {"Authorization": 'Bearer $token'},
    );

    Response res = await Dio().get(
      'https://selflearning.dtechex.com/web/prompt?categoryId=$mainCatId',
      options: options,
    );
    print("@----$res");
    print("break");

    return res;
  }
}
