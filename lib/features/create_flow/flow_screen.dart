

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:self_learning_app/features/create_flow/bloc/create_flow_screen_bloc.dart';
import 'package:self_learning_app/features/create_flow/show_prompts_screen.dart';

import '../add_promts/add_promts_screen.dart';
import '../add_promts_to_flow/add_promts_to_flow_screen.dart';
import '../promt/promts_screen.dart';
import '../resources/bloc/resources_bloc.dart';
import '../resources/maincategory_resources_screen.dart';

class FlowScreen extends StatefulWidget {
  final String rootId;
  const FlowScreen({super.key, required this.rootId});

  @override
  State<FlowScreen> createState() => _FlowScreenState();
}

class _FlowScreenState extends State<FlowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Category Flow'),
        backgroundColor: Colors.yellow,
      ),
      body: BlocConsumer<CreateFlowBloc, CreateFlowState>(
        listener: (context, state) {
         // if(state is flowSelected){
         //   print("flow select from flow screen");
         // }
         // if(state is flowSelectionFailed){
         //   ScaffoldMessenger(child: Text("opps sorry is selected"),);
         //
         // }

        },
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
                  itemCount: state.flowList.length,
                  itemBuilder: (context, index) {

                    final title = state.flowList[index].title;

                    print('content');

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onLongPress: (){
                          context.read<CreateFlowBloc>().add(FlowSelected(flowId: state.flowList[index].id, type: "primary"));

                        },
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ShowPromtsScreen(flowList: state.flowList[index].flowList, flowName: state.flowList[index].title,),));
                        },
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        title: Text(
                          title != null
                              ?'${title.substring(0,1).toUpperCase()}${title.substring(1)}'
                              : 'Untitled',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),),
                        leading: const Icon(Icons.folder, color: Colors.orange, size: 30.0,),),
                    );
                  });
            }
          }
          return const Text('something went wrong');
        },
      ),
    );
  }
}
