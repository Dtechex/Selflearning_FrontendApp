import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meta/meta.dart';
import 'package:self_learning_app/features/add_Dailog/repo/create_dailog_repo.dart';

import '../../model/addDailog_model.dart';

part 'get_dailog_event.dart';
part 'get_dailog_state.dart';

class GetDailogBloc extends Bloc<GetDailogEvent, GetDailogState> {
  GetDailogBloc() : super(GetDailogInitial()) {
  on<HitGetDailogEvent>(onGetDailog);
  on<DeleteDailogEvent>(onDeleteDailog);
  }
  void onGetDailog(HitGetDailogEvent event,
      Emitter<GetDailogState> emit) async {
    emit(GetDailogLoadingState());

    print("event is trigger");
    var res = await DailogRepo.getDailog();
    print("status code ${res?.statusCode}");
    print("get dailog ${res?.data}");
    if(res?.statusCode == 200){

      List<dynamic> dialogs = res!.data['dialogs'];

      // Create a list to store AddDailogModel objects
      List<AddDailogModel> getlist = [];
      List<AddResourceListModel> getResourceList = [];
      List<AddPromptListModel> getPromptList = [];
     getResourceList.add(AddResourceListModel(resourceId: "1", resourceName: "amit", resourceType: "Video", resourceContent: "videoUrl"));
      getResourceList.add(AddResourceListModel(resourceId: "2", resourceName: "vipin", resourceType: "Audio", resourceContent: "audioUrl"));
      getResourceList.add(AddResourceListModel(resourceId: "3", resourceName: "Rakesh", resourceType: "Image", resourceContent: "imageUrl"));
      getResourceList.add(AddResourceListModel(resourceId: "4", resourceName: "atul", resourceType: "Text", resourceContent: "noramal"));
      getResourceList.add(AddResourceListModel(resourceId: "1", resourceName: "amit", resourceType: "Video", resourceContent: "videoUrl"));
      getResourceList.add(AddResourceListModel(resourceId: "2", resourceName: "vipin", resourceType: "Audio", resourceContent: "audioUrl"));
      getResourceList.add(AddResourceListModel(resourceId: "3", resourceName: "Rakesh", resourceType: "Image", resourceContent: "imageUrl"));
      getResourceList.add(AddResourceListModel(resourceId: "4", resourceName: "atul", resourceType: "Text", resourceContent: "noramal"));
      getResourceList.add(AddResourceListModel(resourceId: "1", resourceName: "amit", resourceType: "Video", resourceContent: "videoUrl"));
      getResourceList.add(AddResourceListModel(resourceId: "2", resourceName: "vipin", resourceType: "Audio", resourceContent: "audioUrl"));
      getResourceList.add(AddResourceListModel(resourceId: "3", resourceName: "Rakesh", resourceType: "Image", resourceContent: "imageUrl"));
      getResourceList.add(AddResourceListModel(resourceId: "4", resourceName: "atul", resourceType: "Text", resourceContent: "noramal"));
      getResourceList.add(AddResourceListModel(resourceId: "1", resourceName: "amit", resourceType: "Video", resourceContent: "videoUrl"));
      getResourceList.add(AddResourceListModel(resourceId: "2", resourceName: "vipin", resourceType: "Audio", resourceContent: "audioUrl"));
      getResourceList.add(AddResourceListModel(resourceId: "3", resourceName: "Rakesh", resourceType: "Image", resourceContent: "imageUrl"));
      getResourceList.add(AddResourceListModel(resourceId: "4", resourceName: "atul", resourceType: "Text", resourceContent: "noramal"));
      getPromptList.add(AddPromptListModel(promptId: "1", parentPromptId: "1a", promptTitle: "promptTitle1",
          promptSide1Content: "promptSide1Content", promptSide2Content: "promptSide2Content"));
      getPromptList.add(AddPromptListModel(promptId: "2", parentPromptId: "1b", promptTitle: "promptTitle2",
          promptSide1Content: "promptSide1Content2", promptSide2Content: "promptSide2Content2"));

      // Iterate through the dialogs and populate getlist
      for (var dialog in dialogs) {
        String dailogId = dialog['_id'];
        String userId = dialog['userId'];
        String dailogName = dialog['name'];

        getlist.add(AddDailogModel(
          dailogName: dailogName,
          dailogId: dailogId,
          userId: userId,
        ));
      }
      emit(GetDailogSuccessState(dailogList: getlist, resourceList: getResourceList, promptList: getPromptList));
       }


 else{
   print("false condition is run");
   emit(GetDailogErrorState(errorMessage: "error"));
 }



  }


  void onDeleteDailog(DeleteDailogEvent event,
      Emitter<GetDailogState> emit) async{

    var res = await DailogRepo.deleteDailog(dailogId: event.dailogId);
    print("status code of dailog delete${res.statusCode}");
    if(res.statusCode==200){
      state.dailogList?.removeAt(event.index);
      emit(DailogDeleteSuccessfully(dailogname: event.dailogName));

    }
    else{
      EasyLoading.showToast("Error form dailog delete${res.data}");
    }

    /*if(res?.statusCode == 200){
      state.dailogList?.removeAt(event.index);
      emit(DailogDeleteSuccessfully(dailogname: event.dailogName));
    }
    else{
      emit(DailogDeleteSuccessfully(dailogname: event.dailogName));

      EasyLoading.showToast("Sorry this dailog is not delted");

    }*/



  }
}
