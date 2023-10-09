

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:self_learning_app/features/create_flow/bloc/create_flow_screen_bloc.dart';
import 'package:self_learning_app/utilities/colors.dart';

import '../add_promts/add_promts_screen.dart';
import '../add_promts_to_flow/add_promts_to_flow_screen.dart';
import '../promt/promts_screen.dart';
import '../resources/bloc/resources_bloc.dart';
import '../resources/maincategory_resources_screen.dart';

class CreateFlowScreen extends StatefulWidget {
  final String rootId;
  const
  CreateFlowScreen({super.key, required this.rootId});

  @override
  State<CreateFlowScreen> createState() => _CreateFlowScreenState();
}

class _CreateFlowScreenState extends State<CreateFlowScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final createflowbloc = BlocProvider.of<CreateFlowBloc>(context);
    createflowbloc.add(LoadAllFlowEvent(catID: widget.rootId));
  }
  @override
  Widget build(BuildContext context) {
    print("create flow root id ---${widget.rootId}");
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          _showDialog(context);
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12.0)
          ),
          child: Icon(Icons.add, color: Colors.white,),
        ),
      ),
      appBar: AppBar(
        title: Text('Show Category Flow'),
      ),
      body: BlocConsumer<CreateFlowBloc, CreateFlowState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FlowLoading) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if(state is LoadFailed){
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: const Center(
                child: Text('Failed to Load data!'),
              ),
            );
          }
          if (state is LoadSuccess) {
            if(state.flowList.length == 0){
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: const Center(
                  child: Text('No Flow created yet!'),
                ),
              );
            }else{
              return ListView.builder(
                  shrinkWrap: true,
                  //physics: NeverScrollableScrollPhysics(),
                  itemCount: state.flowList.length,
                  itemBuilder: (context, index) {

                    final title = state.flowList[index].title;
                    final flowId = state.flowList[index].id;
                    print('content');

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () {

                          List<PromptListModel> promptList = [];
                          state.flowList[index].flowList.forEach((item) {
                            promptList.add(PromptListModel(item.promptName, item.promptId, generateRandomColor()));
                          }
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPromptsToFlowScreen(
                            update: true,
                            title: title,
                            flowId: flowId,
                            promptList: promptList,
                            rootId: widget.rootId,
                          ),)).then((value) {
                            context.read<CreateFlowBloc>().add(LoadAllFlowEvent(catID: widget.rootId));
                          });
                        },
                        tileColor: Colors.white,
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: primaryColor,),
                          onPressed: () {
                            context.read<CreateFlowBloc>().add(
                                DeleteFlow(
                                    flowId: state.flowList[index].id,
                                  flowList: state.flowList,
                                  deleteIndex: index,
                                  context: context
                                )
                            );
                          },
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        title: Text(
                          title != null
                              ?'${title.substring(0,1).toUpperCase()}${title.substring(1)}'
                              : 'Untitled',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),),
                        leading: const Icon(Icons.create_new_folder, color: Colors.orange, size: 30.0,),),
                    );
                  });
            }
          }
          return const Text('something went wrong');
        },
      ),
    );
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



  void _showDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: '');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add new Flow'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter Flow name...',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Do something with the TextField value

                //bloc.add(CreateAndSaveFlow(title: titleController.text));


                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPromptsToFlowScreen(
                        title: titleController.text,
                        rootId: widget.rootId, promptList: [],),)).then((value) {
                          if(value != null && value == true){
                            Navigator.pop(context, true);
                          }else{
                            Navigator.pop(context, false);
                          }
                });
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    ).then((value) {
      if(value != null && value == true){
        Future.delayed(Duration(seconds: 1));
        context.read<CreateFlowBloc>().add(LoadAllFlowEvent(catID: widget.rootId));
      }
    });
  }

}
