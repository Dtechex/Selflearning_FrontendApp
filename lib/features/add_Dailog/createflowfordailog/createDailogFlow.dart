import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:self_learning_app/features/add_Dailog/repo/create_dailog_repo.dart';

import '../model/addDailog_model.dart';

class CreateDailogFlow extends StatefulWidget {
  String dailogId;
  String dailog_flow_name;
  List<AddResourceListModel> reswithPromptList;
  List<AddPromptListModel> promptList;
   CreateDailogFlow({super.key, required this.reswithPromptList, required this.dailog_flow_name, required this.promptList,
   required this.dailogId
   });

  @override
  State<CreateDailogFlow> createState() => _CreateDailogFlowState();
}
List<ResPromptcheckModel> _list =[];
List<SelectResPromptModel> selectedResPrompt =[];
List<checkModelforDefPrompt>_defPromptList = [];
List<String> selectedResourceIds =[];
List<QuickPromptModel> quickPromptList = [];

class _CreateDailogFlowState extends State<CreateDailogFlow> {
  void updateSelectedPromptIds(String resourceId, bool isChecked) {
    if (isChecked) {
      if (!selectedResourceIds.contains(resourceId)) {
        setState(() {
          selectedResourceIds.add(resourceId);
        });
      }
    } else {
      setState(() {
        selectedResourceIds.remove(resourceId);
      });
    }
  }
  Color lightenRandomColor(Color color, double factor) {
    assert(factor >= 0 && factor <= 1.0);
    final int red = (color.red + (255 - color.red) * factor).round();
    final int green = (color.green + (255 - color.green) * factor).round();
    final int blue = (color.blue + (255 - color.blue) * factor).round();
    return Color.fromARGB(255, red, green, blue);
  }
  Color generateRandomColor() {
    final Random random = Random();
    final int red = random.nextInt(256); // 0-255 for the red channel
    final int green = random.nextInt(256); // 0-255 for the green channel
    final int blue = random.nextInt(256); // 0-255 for the blue channel
    final originalColor = Color.fromARGB(255, red, green, blue);
    final pastelColor = lightenRandomColor(originalColor, 0.8); // 30% lighter

    return pastelColor;
  }

  late List<bool> isExpandableList;
  bool isExpandedefprompt= false;
  double ?container_height;
  void ContainerHeight(){
    if(widget.promptList.length>3){
      container_height = 150;
    }
    else{
      container_height =200;
    }
  }
  List<PromptSelectedModel> promptSelect = [];
  List<String> promptIds = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isExpandableList = List.generate(widget.reswithPromptList.length, (index) => false);
    ContainerHeight();

  }
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Dailog flow"),
      actions: [
        Container(
          padding: EdgeInsets.symmetric( horizontal: 10),
          alignment: Alignment.center,

          child: GestureDetector(
            onTap: () async {
              print("dailog hit ${promptIds}");
              print("dailogId ${widget.dailogId}");
              print("dailogflowtitle ${widget.dailog_flow_name}");

             DailogRepo.saveDailog(dailogId: widget.dailogId, title: widget.dailog_flow_name, promptId: promptIds, context: context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: promptIds.length==0?Colors.grey:Colors.white,

              ),
                child: Row(
                  children: [
                    Text("Save elected",style: TextStyle(color: Colors.black),),

                    Text("(${count.toString()})",style: TextStyle(color: Colors.black),),
                  ],
                )),
          ),
        )
      ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 500.0,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 5.0,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    promptSelect.add(PromptSelectedModel(promptId: widget.promptList[index].promptId, ischeck: false));
                return Card(
                  color: Colors.teal[50],
                  margin: EdgeInsets.only(left: 5,right: 5,top: 10),

                  child: Container(
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Text(widget.promptList[index].promptTitle),
                    leading: Container(
                      height: 40, width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: Colors.pinkAccent,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(index.toString(),style: TextStyle(color: Colors.white),),
                    ),
                    trailing: promptSelect[index].ischeck?
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: Colors.white,
                      ),
                      child: Icon(Icons.check, color: Colors.lightGreen,),

                    ):SizedBox(),
                      onTap: (){
                      if(promptSelect[index].ischeck==true){
                        promptSelect[index].ischeck=false;
                        promptIds.remove(widget.promptList[index].promptId);
                        count = count-1;
                        print("promptIds remove $promptIds");
                        setState(() {

                        });
                      }
                      else if(promptSelect[index].ischeck==false){
                        promptSelect[index].ischeck=true;
                        count = count+1;
                        promptIds.add(widget.promptList[index].promptId);
                        print("promptIds add $promptIds");

                        setState(() {

                        });
                      }
                      // promptSelect[index].ischeck=true;
                      // setState(() {
                      //
                      // });
                      },
                    ),
                  ),
                );
              },
              childCount: widget.promptList.length,
            ),
          ),

//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//                   (BuildContext context, int index) {
//                 return
//                   Card(
//                     elevation: 4, // Customize the elevation
//                     margin: EdgeInsets.all(8),
//                     child: Theme(
//                       data:  Theme.of(context).copyWith(cardColor: generateRandomColor()),
//                       child:
//                       ExpansionPanelList(
//                         expandIconColor: Colors.blue,
//                         animationDuration: Duration(milliseconds:1000),
//                         dividerColor:Colors.red,
//                         elevation:1,
//                         children: [
//
//                           ExpansionPanel(
//
//                             body: Container(
//                               padding: EdgeInsets.all(10),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment:CrossAxisAlignment.start,
//                                 children: <Widget>[
//
//                                   Container(
//                                     height: 300,
//                                     width: double.infinity,
//                                     child: ListView.builder(
//                                       itemCount: widget.reswithPromptList[index].resPromptList.length,
//                                       itemBuilder: (context, index) {
// /*
//                                          EasyLoading.showToast(widget.reswithPromptList[index].resPromptList.length.toString());
// */
//                                         _list.add(ResPromptcheckModel(selectedResPrompt, false));
//
//                                         return
//                                           Container(
//                                               margin: EdgeInsets.symmetric(vertical: 2),
//                                               color: Colors.blue[50],
//                                               child: CheckboxListTile(
//                                                 activeColor: Colors.red,
//                                                 checkColor: Colors.white,
//                                                 // value: _saved.contains(context), // changed
//                                                 value:_list[index].isCheck,
//                                                 onChanged: (val) {
//                                                   print("object  ${val}");
//                                                   setState(() {
//                                                     _list[index].isCheck = val!;
//                                                     if (val) {
//                                                       count=count+1;
//                                                       selectedResPrompt.add(SelectResPromptModel(resId: widget.reswithPromptList[index].resourceId, promptId: widget.reswithPromptList[index].resPromptList[index].promptId));
//                                                     } else {
//                                                       count=count-1;
//                                                       // If the checkbox is unchecked, remove the promptId from the list.
//                                                       selectedResPrompt.remove(SelectResPromptModel(resId: widget.reswithPromptList[index].resourceId, promptId: widget.reswithPromptList[index].resPromptList[index].promptId));
//                                                     }
//                                                   });
//                                                 },
//                                                 title: Text(widget.reswithPromptList[index].resPromptList![index].promptTitle.toString()),
//                                               )
//                                           );
//                                       },
//                                     ),
//                                   ),
//
//
//
//
//                                 ],
//                               ),
//                             ),
//                             headerBuilder: (BuildContext context, bool isExpanded) {
//                               return Container(
//                                 padding: EdgeInsets.all(10),
//                                 child: Text(
//                                   "Select prompt from ${widget.reswithPromptList[index].resourceName}",
//                                   style: TextStyle(
//                                     color:Colors.black,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w500
//                                   ),
//                                 ),
//                               );
//                             },
//                             isExpanded: isExpandableList[index],
//                             canTapOnHeader: true
//                           ),
//
//                         ],
//                         expansionCallback: (int item, bool status) {
//                           setState(() {
//                             isExpandableList[index] = !isExpandableList[index];
//                           });
//                         },
//                       ),
//                     ),
//                   );
//
//               },
//               childCount: widget.reswithPromptList.length,
//             ),
//           ),
//           SliverToBoxAdapter(
//             child:
//             ExpansionPanelList(
//               expandIconColor: Colors.blue,
//               animationDuration: Duration(milliseconds:1000),
//               dividerColor:Colors.red,
//               elevation:1,
//               children: [
//
//                 ExpansionPanel(
//
//                     body: Container(
//                       padding: EdgeInsets.all(10),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment:CrossAxisAlignment.start,
//                         children: <Widget>[
//
//                              Container(
//                                height: container_height,
//                               width: double.infinity,
//                               child: ListView.builder(
//                                 itemCount: widget.defaultDailogPromptlist.length,
//                                 itemBuilder: (context, index) {
//                                   _defPromptList.add(checkModelforDefPrompt(selectedResourceIds.toString(), false));
//                                   return
//                                     Container(
//                                         margin: EdgeInsets.symmetric(vertical: 2),
//                                         color: Colors.blue[50],
//                                         child: CheckboxListTile(
//                                           activeColor: Colors.red,
//                                           checkColor: Colors.white,
//                                           // value: _saved.contains(context), // changed
//                                           value:_defPromptList[index].isCheck,
//                                           onChanged: (val) {
//                                             print("object  ${val}");
//                                             setState(() {
//                                               _defPromptList[index].isCheck = val!;
//
//                                               /*updateSelectedPromptIds(
//                                                 quickPromptList[index].PromptId.toString(),
//                                                 val!,
//                                               );*/
//                                             });
//                                           },
//                                           title: Text(widget.defaultDailogPromptlist[index].promptTitle),
//                                         )
//                                     );
//                                 },
//                               ),
//                           ),
//
//
//
//
//                         ],
//                       ),
//                     ),
//                     headerBuilder: (BuildContext context, bool isExpanded) {
//                       return Container(
//                         padding: EdgeInsets.all(10),
//                         child: Text(
//                           "Select prompt from default prompt",
//                           style: TextStyle(
//                               color:Colors.black,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500
//                           ),
//                         ),
//                       );
//                     },
//                     isExpanded: isExpandedefprompt,
//                     canTapOnHeader: true
//                 ),
//
//               ],
//               expansionCallback: (int item, bool status) {
//                 setState(() {
//                   isExpandedefprompt= !isExpandedefprompt;
//                 });
//               },
//             ),
//
//           )
        ],
      ),
    );
  }
}
class ResPromptcheckModel{
  List<SelectResPromptModel> ids;
  bool isCheck;

  ResPromptcheckModel(this.ids, this.isCheck);

}
class SelectResPromptModel{
  String resId;
  String promptId;
  SelectResPromptModel({required this.resId, required this.promptId});

}
class checkModelforDefPrompt{
  String name;
  bool isCheck;

  checkModelforDefPrompt(this.name, this.isCheck);

}
class QuickPromptModel{
  String? PromptName;
  String? PromptId;

  QuickPromptModel({required this.PromptName, required this.PromptId});


}

class PromptSelectedModel{
  String promptId;
  bool ischeck;
  PromptSelectedModel({required this.promptId, required this.ischeck});
}