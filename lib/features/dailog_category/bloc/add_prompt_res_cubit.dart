import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meta/meta.dart';
import 'package:self_learning_app/features/create_flow/data/model/flow_model.dart';

import '../../add_Dailog/model/addDailog_model.dart';
import '../repo/promptResRepo.dart';

part 'add_prompt_res_state.dart';

class AddPromptResCubit extends Cubit<AddPromptResState> {
  AddPromptResCubit() : super(AddPromptResInitial());
  getResPrompt({required String dailogId}) async {
    emit(AddPromptResLoading());
    var res = await PromptResRepo.get_Res_Prompt(dailogId: dailogId);

    print("getPromptRes Function is hit");
    if (res!.statusCode == 200) {
      print("check for prompt res ${res.data}");
      List<AddResourceListModel> getListRes_prompt = [];
      List<AddPromptListModel> getPromotList = [];
      List<dynamic> resourcesList = res.data['dialogList']['resourcesList'];

      for (var resource in resourcesList) {
        getListRes_prompt.add(AddResourceListModel(
          resourceId: resource['_id'],
          resourceName: resource['title'],
          resourceType: resource['type'],
          resourceContent: '', resPromptList: [], // Empty string for resourceContent
        ));
      }

      List<dynamic> promptList = res.data['dialogList']['promptList'];

      for (var prompt in promptList) {
        getPromotList.add(AddPromptListModel(
          promptId: prompt['_id'],
          promptTitle: prompt['name'],
          promptSide1Content: prompt['side1'],
          promptSide2Content: prompt['side2'],
          parentPromptId: '1a',
        ));
      }

      emit(GetResourcePromptDailog(
        res_prompt_list: getListRes_prompt,
        def_prompt_list: getPromotList,
      ));
    }
  }

  addpromptRes({required String promptId, required String promptName, required String resourceId, required String resourceName, required BuildContext context})async{
    print("Cubit function hit");
    var res = await PromptResRepo.AddPromptInResource(promptId: promptId, resourceId: resourceId);
    if(res?.statusCode ==200){
      Navigator.pop(context);
      emit(AddPromptResSuccess(promptName: promptName, resourceName: resourceName));
    }
    else{
      print("Else condition is run");
      Navigator.pop(context);
      emit(AddPromptResSuccess(promptName: promptName, resourceName: resourceName));
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 5, // Adjust the elevation as needed
            backgroundColor: Colors.white, // Background overlay color
            child: Container(
              height: MediaQuery.of(context).size.height*0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("$promptName is successfully added in $resourceName", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(90)
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 48,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
  /*    Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });*/
    }


  }


getPromptFromResource({required String resourceId})async{

    var res = await PromptResRepo.getPrompResource(resourceId: resourceId);
    List<FlowDataModel> getPromptData = [];
    print("resourceId --$resourceId");
    if(res!.statusCode==200){

      print("resource prompt is ${res.data}");
      List<dynamic> resPrompt = res.data['data']['record'];
      List<FlowDataModel> flowModel=[];
      for(var list in resPrompt){
       flowModel.add(FlowDataModel(
           resourceTitle: list['resourceId']['title'],
           resourceType: list['resourceId']['type'],
           resourceContent: "resourceContent",
           side1Title: list['side1']['title'],
           side1Type: list['side1']['type'],
           side1Content: list['side1']['content'],
           side2Title: list['side2']['title'],
           side2Type: list['side2']['type'],
           side2Content: list['side2']['content'],
           promptName: list['name'], promptId: list["_id"])) ;
      }
      emit(GetPromptFromResourceSuccess(flowModel: flowModel));
    }

}
deleteResource({required String resourceId}) async{
    var res = await PromptResRepo.deleteResource(resourceId: resourceId);
    if(res.statusCode==200){
     emit(ResourceDeletedSuccess());
    }
    else{
      EasyLoading.showToast("Sorry to delete failed");
    }
}
}
