


import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../data/model/flow_model.dart';
import '../data/repo/create_flow_screen_repo.dart';


part 'create_flow_screen_event.dart';
part 'create_flow_screen_state.dart';
class CreateFlowBloc extends Bloc<CreateFlowEvent,CreateFlowState> {
  CreateFlowBloc(): super(
      CreateFlowState(
      showAddDialog: false,
      showLoading: false, apiStatus: APIStatus.initial
  )){
    on<AddFlow>(_showAddFlowDialog);
    on<CreateAndSaveFlow>(_saveFlow);
    on<LoadAllFlowEvent>((event, emit){
      CreateFlowRepo.getAllFlow(catID: event.catID).then((value) {

        if(value.statusCode == 400){
          emit(state.copyWith(apiStatus: APIStatus.failed));
        }else{
          List<FlowModel> flowList = [];
          for(var item in value.data['']){
            flowList.add(FlowModel(title: item[''], id: item['']));
          }
          emit(state.copyWith(apiStatus: APIStatus.successful, flowList: flowList));
        }
      });
    });
  }

  _showAddFlowDialog(AddFlow event, Emitter<CreateFlowState> emit){
    emit(state.copyWith(showAddDialog: event.showDialog));
  }
  _saveFlow(CreateAndSaveFlow event, Emitter<CreateFlowState> emit) async {
    EasyLoading.show();
    await Future.delayed(const Duration(seconds: 3),);
    //Response? response = await CreateFlowRepo.createFlow(title: event.title);
    EasyLoading.dismiss();

    /*if(response == null){

    }else{

    }*/
  }
}