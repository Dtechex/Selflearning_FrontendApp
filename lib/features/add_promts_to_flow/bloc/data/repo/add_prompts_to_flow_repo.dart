



import 'dart:convert';

import 'package:bloc/src/bloc.dart';

import 'package:self_learning_app/features/add_promts_to_flow/bloc/add_promts_to_flow_bloc.dart';

import '../../../../../utilities/base_client.dart';
import '../model/add_prompt_to_flow_model.dart';

class AddPromptsToFlowRepo {

  /*static Future<AddPromptToFlowModel?> getData({required String mainCatId, required Emitter<AddPromtsToFlowInitial> emit}) async {
    Response res = await Api().get(
      endPoint: 'prompt?q=$mainCatId',);
    print(res.body);
    var data = await jsonDecode(res.body);
    final List<PromtModel> list = [];

    final List<dynamic> mylist = data['data']['record'];
    AddFlowModel.fromJson(data);
    if (mylist.isNotEmpty) {
      for (var l in mylist) {
        list.add(PromtModel.fromJson(l));
      }
    }

    if(res.status != 200 ) {
      return null;
    }
    return AddPromptToFlowModel(
      name: ,

    );
  }*/
}