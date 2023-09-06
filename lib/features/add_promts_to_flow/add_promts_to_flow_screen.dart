


import 'dart:async';
import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/add_promts_to_flow/bloc/data/model/prompt_model.dart';
import 'package:self_learning_app/features/add_promts_to_flow/manage_flow.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../quick_import/bloc/quick_add_bloc.dart';
import '../subcate1.1/bloc/sub_cate1_bloc.dart';
import '../subcate1.1/bloc/sub_cate1_event.dart';
import 'bloc/add_promts_to_flow_bloc.dart';


class PromptListModel{
  String _name;
  String _id;

  PromptListModel(this._name, this._id);

  String get id => _id;

  String get name => _name;


}
class AddPromptsToFlowScreen extends StatefulWidget {
  final String title;
  final String rootId;
  const AddPromptsToFlowScreen({super.key, required this.title, required this.rootId});

  @override
  State<AddPromptsToFlowScreen> createState() => _AddPromptsToFlowScreenState();
}

class _AddPromptsToFlowScreenState extends State<AddPromptsToFlowScreen> {

  final AddPromtsToFlowBloc bloc = AddPromtsToFlowBloc();

  List<PromptListModel> promptList = [];
  StreamController<int> _counterStreamController = StreamController<int>();
  @override
  void initState() {
    context.read<QuickImportBloc>().add(LoadQuickTypeEvent());
    context.read<SubCategory1Bloc>().add(SubCategory1LoadEmptyEvent());
    bloc.add(LoadMainCategoryData(catId: widget.rootId));
    super.initState();
  }

  String ddvalue = '';
  String subCateId = '';
  bool isFirstTime=true;



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => bloc,
  child: Scaffold(
      appBar: AppBar(
        title: Text(widget.title, overflow: TextOverflow.ellipsis,),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: StreamBuilder(
              stream: _counterStreamController.stream,
                initialData: promptList.length,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }else if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }else if(snapshot.data == 0){
                    return MaterialButton(
                        onPressed: () {

                        },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Colors.grey,
                      child: Text('Selected (${snapshot.data})'),
                    );
                  }

                  return MaterialButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ManageFlow(
                          title: widget.title,
                          rootId: widget.rootId,
                          promptList: promptList,
                        ),)).then((value) {
                          if(value != null && value == true){
                            Navigator.pop(context, true);
                          }
                      });

                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text('Selected (${snapshot.data})'),
                  );
                },
            ),
          ),
        ],
      ),
        body: BlocConsumer<AddPromtsToFlowBloc, AddPromtsToFlowInitial>(
  listener: (context, state) {
    // TODO: implement listener

  },
  builder: (context, state) {
    if(state.mainCategory == APIStatus.loading){
      return Center(child: CircularProgressIndicator(),);
    }else if(state.mainCategory == APIStatus.loadSuccess){
      if(state.mainCategoryData == null){
        return Center(
          child: Text(
              'Nothing to show'
          ),
        );
      }else{

        if(state.mainCategoryData!.categoryList.isEmpty && state.mainCategoryData!.promptList.isEmpty){
          return Center(child: Text('No result found!'),);
        }
        return CustomScrollView(
          slivers: [

            ///Main category Prompts
            SliverToBoxAdapter(
              child: (state.mainCategoryData!.promptList.isEmpty)
                  ? Center(child: Text('No Prompts Available'),)
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: state.mainCategoryData!.promptList.length,
                itemBuilder: (context, index) {
                  return PromptTile(
                    data: state.mainCategoryData!.promptList[index],
                    index: index,
                    onTap: (promptData){
                      addOrRemove(data: promptData);
                    }
                  );
                },),
            ),



            ///Sub categories dropdown
            if (state.mainCategoryData?.categoryList.isNotEmpty??false) SliverToBoxAdapter(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox( height: 10,),
                  Divider(height: 1, color: Colors.grey,),
                  SizedBox( height: 20,),
                  Row(
                    children: [
                      const Text(
                        'Subcategory',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: DropdownButtonFormField2(
                          isExpanded: true,
                          hint: const Text(
                            'Select Category',
                            style: TextStyle(color: Colors.black),
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.grey,
                            contentPadding: const EdgeInsets.only(left: 0, top: 15, bottom: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          //value: value,
                          items: state.mainCategoryData!.categoryList.map<DropdownMenuItem<String?>>((e) {

                            return DropdownMenuItem<String>(
                              onTap: () {
                                bloc.add(LoadSubCategoryData(catId: e.categoryId));
                              },
                              value: e.title,
                              child: SizedBox(
                                  width: context.screenWidth/1.5,
                                  child: Text(e.title!,overflow: TextOverflow.ellipsis,)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            //isFirstTime=false;
                            /*context.read<QuickImportBloc>().add(ChangeDropValue(
                                title: value, list: state.list));
                            context.read<SubCategoryBloc>().add(SubCategoryLoadEvent(rootId: value));*/
                          },
                        ),
                      ),
                    ],
                  ),

                  ///Sub category prompts
                  if(state.subCategory == APIStatus.loadSuccess)
                    (state.subCategoryData!.promptList.length == 0)
                        ? Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Text('No Prompts available!'))
                        : ListView.builder(
                    shrinkWrap: true,
                      itemCount: state.subCategoryData?.promptList.length??0,
                      itemBuilder: (context, index) {
                        return PromptTile(data: state.subCategoryData!.promptList[index],
                            onTap: (promptData){
                              addOrRemove(data: promptData);
                            },
                            index: index);
                      },
                  )
                ],
              ),
            ),

            ///Sub-categories1 dropdown
            if (state.subCategoryData?.categoryList.isNotEmpty??false) SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox( height: 10,),
                      Divider(height: 1, color: Colors.grey,),
                      SizedBox( height: 20,),
                      Row(
              children: [
                      const Text(
                        'Subcategory1',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: DropdownButtonFormField2(
                          isExpanded: true,
                          hint: const Text(
                            'Select Category',
                            style: TextStyle(color: Colors.black),
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.grey,
                            contentPadding: const EdgeInsets.only(left: 0, top: 15, bottom: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          //value: value,
                          items: state.subCategoryData!.categoryList.map<DropdownMenuItem<String?>>((e) {

                            return DropdownMenuItem<String>(
                              onTap: () {
                                bloc.add(LoadSubCategory1Data(catId: e.categoryId));
                              },
                              value: e.title,
                              child: SizedBox(
                                  width: context.screenWidth/1.5,
                                  child: Text(e.title!,overflow: TextOverflow.ellipsis,)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            //isFirstTime=false;
                            /*context.read<QuickImportBloc>().add(ChangeDropValue(
                                        title: value, list: state.list));
                                    context.read<SubCategoryBloc>().add(SubCategoryLoadEvent(rootId: value));*/
                          },
                        ),
                      ),
              ],
            ),
                      ///sub category1 prompts
                      if(state.subCategory1 == APIStatus.loadSuccess)
                        (state.subCategory1Data!.promptList.length == 0)
                            ? Container(
                          alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Text('No Prompts available!'))
                            : ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.subCategory1Data!.promptList.length,
                          itemBuilder: (context, index) {
                            return PromptTile(data: state.subCategory1Data!.promptList[index],
                                onTap: (promptData){
                                  addOrRemove(data: promptData);
                                }
                                , index: index);
                          },
                        ),
                    ],
                  ),
                ),

            ///Sub-categories2 dropdown
            if (state.subCategory1Data?.categoryList.isNotEmpty??false) SliverToBoxAdapter(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox( height: 10,),
                  Divider(height: 1, color: Colors.grey,),
                  SizedBox( height: 20,),
                  Row(
                    children: [
                      const Text(
                        'Subcategory2',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: DropdownButtonFormField2(
                          isExpanded: true,
                          hint: const Text(
                            'Select Category',
                            style: TextStyle(color: Colors.black),
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.grey,
                            contentPadding: const EdgeInsets.only(left: 0, top: 15, bottom: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          //value: value,
                          items: state.subCategory1Data!.categoryList.map<DropdownMenuItem<String?>>((e) {

                            return DropdownMenuItem<String>(
                              onTap: () {
                                bloc.add(LoadSubCategory2Data(catId: e.categoryId));
                              },
                              value: e.title,
                              child: SizedBox(
                                  width: context.screenWidth/1.5,
                                  child: Text(e.title!,overflow: TextOverflow.ellipsis,)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            //isFirstTime=false;
                            /*context.read<QuickImportBloc>().add(ChangeDropValue(
                                title: value, list: state.list));
                            context.read<SubCategoryBloc>().add(SubCategoryLoadEvent(rootId: value));*/
                          },
                        ),
                      ),
                    ],
                  ),

                  ///subcategory2 prompts
                  if(state.subCategory2 == APIStatus.loadSuccess)
                    (state.subCategory2Data!.promptList.length == 0)
                        ? Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Text('No Prompts available!'))
                        : ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.subCategory2Data?.promptList.length??0,
                        itemBuilder: (context, index) {
                          return PromptTile(data: state.subCategory2Data!.promptList[index],
                              onTap: (promptData){
                                addOrRemove(data: promptData);
                              },
                              index: index);
                        },
                      ),
                ],
              ),
            ),

/*
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (){

                        },
                        child: Text('Save Flow'))
                  ],
                ),
              ),
            )
*/
          ],
        );
      }
    }else if(state.mainCategory == APIStatus.loadFailed){
      return Center(
        child: Text(
          'Unable to connect to internet!'
        ),
      );
    }
    return Container();
  },
),
    ),
);
  }

  void addOrRemove({required PromptListModel data}) {
    print(promptList.length.toString());
    if(promptList.contains(data)){
      promptList.remove(data);
    }else{
      promptList.add(data);
    }
    _counterStreamController.add(promptList.length);
  }
}

class Range {
  final int start;
  final int end;

  Range(this.start, this.end);

  bool contains(int value) {
    return value >= start && value <= end;
  }
}


class PromptTile extends StatefulWidget {
  final PromptModel data;
  final int index;
  final Function(PromptListModel promptData) onTap;
  const PromptTile({super.key, required this.data, required this.index, required this.onTap});

  @override
  State<PromptTile> createState() => _PromptTileState();
}

class _PromptTileState extends State<PromptTile> {
  late bool _isSelected;
  late final Color color;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    color = generateRandomColor();
    _isSelected = false; //widget.data.isSelected??
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        onTap: () {
          widget.onTap(PromptListModel(widget.data.title!, widget.data.promptId!));
          setState(() {
            _isSelected = !_isSelected;
          });
        },
        leading: SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.height * 0.06,
          child: Card(
            shape: CircleBorder(),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(1.0),
                //height: MediaQuery.of(context).size.height * 1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                child: Text('${widget.index + 1}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
            ),
          ),
        ),
        tileColor: widget.index%2==0?Colors.grey:Colors.blue,
        title: Text('${widget.data.title}'),
        trailing: (_isSelected)?Icon(Icons.check_circle, color: Colors.white,): null,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)
      ),
    ),);
  }

  Color generateRandomColor() {
    Random random = Random();

    // Define RGB value ranges for white, blue, and gray colors
    final whiteRange = Range(200, 256); // RGB values between 200-255
    final blueRange = Range(0, 100);    // RGB values between 0-100
    final grayRange = Range(150, 200);  // RGB values between 150-199

    Color randomColor;

    do {
      // Generate random RGB values
      int red = random.nextInt(256);
      int green = random.nextInt(256);
      int blue = random.nextInt(256);

      randomColor = Color.fromRGBO(red, green, blue, 1.0);
    } while (whiteRange.contains(randomColor.red) &&
        whiteRange.contains(randomColor.green) &&
        whiteRange.contains(randomColor.blue) ||
        blueRange.contains(randomColor.red) &&
            blueRange.contains(randomColor.green) &&
            blueRange.contains(randomColor.blue) ||
        grayRange.contains(randomColor.red) &&
            grayRange.contains(randomColor.green) &&
            grayRange.contains(randomColor.blue));

    return randomColor;
  }

}

