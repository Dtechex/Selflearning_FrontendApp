


import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../data/model/flow_model.dart';
import '../data/repo/create_flow_screen_repo.dart';


part 'create_flow_screen_event.dart';
part 'create_flow_screen_state.dart';
class CreateFlowBloc extends Bloc<CreateFlowEvent,CreateFlowState> {
  CreateFlowBloc(): super(FlowLoading()){

    on<LoadAllFlowEvent>((event, emit) async {
      emit(FlowLoading());
      Response response = await CreateFlowRepo.getAllFlow(catID: event.catID);

      print('123456');
      print(response);
      if(response.statusCode == 400){
        emit(LoadFailed());
      }else{
        List<FlowModel> flowList = [];
        for(var item in response.data['data']['record']){
          flowList.add(FlowModel(title: item['title'], id: item['_id']));
        }
        emit(LoadSuccess(flowList));
      }
    });
  }
}


/// List<FlowModel> flowList = []
/*for(var item in response.data['data']['record']){
List<FlowDataModel> flowData = [];

for (var flow in item['flow']){
flowData.add(FlowDataModel(
resourceTitle: flow['resource']['title'],
resourceType: flow['resource']['type'],
resourceContent: flow['resource']['content'],
side1Title: flow['side1']['title'],
side1Type: flow['side1']['type'],
side1Content: flow['side1']['content'],
side2Title: flow['side2']['title'],
side2Type: flow['side2']['type'],
side2Content: flow['side2']['content']));
}
flowList.add(FlowModel(
title: item['title'],
id: item['_id'],
categoryId: item['categoryId'],
flowList: flowData,
));
}*/
