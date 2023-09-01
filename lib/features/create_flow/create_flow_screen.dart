

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:self_learning_app/features/create_flow/bloc/create_flow_screen_bloc.dart';

import '../add_promts/add_promts_screen.dart';
import '../add_promts_to_flow/add_promts_to_flow_screen.dart';
import '../promt/promts_screen.dart';
import '../resources/bloc/resources_bloc.dart';
import '../resources/maincategory_resources_screen.dart';

class CreateFlowScreen extends StatefulWidget {
  const CreateFlowScreen({super.key});

  @override
  State<CreateFlowScreen> createState() => _CreateFlowScreenState();
}

class _CreateFlowScreenState extends State<CreateFlowScreen> {
  final CreateFlowBloc bloc = CreateFlowBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => bloc,
      child: Scaffold(
        floatingActionButton: InkWell(
          onTap: () {
            bloc.add(AddFlow(showDialog: true));
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
          title: Text('Main Category Flow'),
        ),
        body: BlocListener(
          bloc: bloc,
          listener: (BuildContext context, state) {
            if(state is CreateFlowState){
              if(state.showAddDialog!){
                _showDialog(context);
              }
              if(state.showLoading){
                EasyLoading.show();
              }else if(EasyLoading.isShow){
                EasyLoading.dismiss();
              }
            }
          },
          child: BlocConsumer<ResourcesBloc, ResourcesState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ResourcesLoading) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is ResourcesLoaded) {
                if (state.allResourcesModel.data!.record!.records!.isEmpty) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: const Center(
                      child: Text('No Resources found.'),
                    ),
                  );
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.allResourcesModel.data!.record!.records!.length,
                      itemBuilder: (context, index) {
                        final content = state.allResourcesModel.data!.record!
                            .records![index].content
                            .toString();
                        final title = state.allResourcesModel.data!.record!
                            .records![index].title;
                        print(content);
                        print('content');

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddPromptsToFlowScreen(title: 'New', quickAddId: '', mediaType: '',),));
                            },
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            title: Text(
                              title != null
                                  ?'${title.substring(0,1).toUpperCase()}${title.substring(1)}'
                                  : 'Untitled',
                              style: TextStyle(fontSize: 20.0, letterSpacing: 1, fontWeight: FontWeight.w600),),
                            leading: const Icon(Icons.create_new_folder, color: Colors.orange, size: 30.0,),),
                        );
                      });
                }
              }
              return const Text('something went wrong');
            },
          ),
        ),
      ),
    );
  }


  void _showDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: '');
    bloc.add(AddFlow(showDialog: false));
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

                bloc.add(CreateAndSaveFlow(title: titleController.text));


                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

}
