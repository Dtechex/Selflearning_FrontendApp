import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meta/meta.dart';

import '../repo/promptResRepo.dart';

part 'add_prompt_res_state.dart';

class AddPromptResCubit extends Cubit<AddPromptResState> {
  AddPromptResCubit() : super(AddPromptResInitial());

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
}
