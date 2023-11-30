

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:self_learning_app/features/create_flow/bloc/create_flow_screen_bloc.dart';
import 'package:self_learning_app/features/create_flow/data/model/flow_model.dart';
import 'package:self_learning_app/features/create_flow/show_prompts_screen.dart';

import '../../utilities/shared_pref.dart';
import '../add_promts/add_promts_screen.dart';
import '../add_promts_to_flow/add_promts_to_flow_screen.dart';
import '../promt/promts_screen.dart';
import '../resources/bloc/resources_bloc.dart';
import '../resources/maincategory_resources_screen.dart';

class FlowScreen extends StatefulWidget {
  final String rootId;
  final String categoryname;
  const FlowScreen({super.key, required this.rootId, required this.categoryname});

  @override
  State<FlowScreen> createState() => _FlowScreenState();
}

class _FlowScreenState extends State<FlowScreen> {
  List<int> saveIndex = [];
  List<FlowModel> getFlowId = [];


  @override

  Future<void> PrimaryfetchData() async {
    try {
      final idList = await getPrimaryflow(catId: widget.rootId);

      setState(() {
        getFlowId.clear();
        getFlowId = idList;
        print("to get flow id===>${getFlowId.length}");
      });
    } catch (error) {
      print('Error: $error');
    }
  }
  Future<List<FlowModel>> getPrimaryflow({required String catId})async {
    Response response;
    List<FlowModel> flowList = [];

    try{
      final token = await SharedPref().getToken();
      response = await Dio().get(
          'https://selflearning.dtechex.com/web/flow?categoryId=$catId&type=primary',
          options: Options(
              headers: {"Authorization": 'Bearer $token'}
          ),
          data: {'type':'primary'}

      );

      print("checking flow id in this data ${response.data}");
      print("checkPrimaryResponse====${response.data["data"]["record"][0]['type']}");
      print("--------->Break");
      print("catId ---$catId");

      if(response.statusCode == 400){
        throw Exception('Failed to fetch data from the API');
      }
      if(response.statusCode==200 && response.data['data']['record'][0]['type'] == 'primary'){

        for(var item in response.data['data']['record']) {


          flowList.add(FlowModel(
            title: item['title'],
            id: item['_id'],
            categoryId: item['categoryId'],
            flowList: [],
          ));
        }
        return flowList;
        }

  }on DioError catch (e) {
      print(e);
      throw e;
    }
 return flowList;
  }
  void initState() {
    context.read<CreateFlowBloc>().add(LoadAllFlowEvent(catID: widget.rootId));
    PrimaryfetchData();

    super.initState();
  }
  Widget build(BuildContext context) {
    print("ui is refresh");
    return Scaffold(

      appBar: AppBar(
        title: Text('Select Primary flow for ${widget.categoryname}'),
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
                    int selectedIndex = -1;

                    final title = state.flowList[index].title;
                    // final isSelected = saveIndex.contains(index);
                    // getFlowId.clear();
                    // PrimaryfetchData();
                    bool isSelected = false;
                     isSelected = getFlowId.any((getFlow) => getFlow.id == state.flowList[index].id);
                    print("to view flow id length==>${isSelected}");
                    print('content');

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(

                          onLongPress: () async {


                            context.read<CreateFlowBloc>().add(FlowSelected(
                                  flowId: state.flowList[index].id,
                                  type: "primary",
                                  flowList: state.flowList,
                                  index: index,
                                rootId: widget.rootId
                              ));
                            await Future.delayed(Duration(seconds: 1));
                             PrimaryfetchData();
                            getPrimaryflow(catId: widget.rootId);



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
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, ),),
                        leading: const Icon(Icons.folder, color: Colors.orange, size: 30.0,),
                      trailing:isSelected==true?
                          Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue.withOpacity(0.3)
                              ),
                              child: Icon(Icons.check, color: Colors.green)):null
                      ),

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

// class SaveIndexModel extends Equatable {
//   final List<int> selectedIndices;
//   // final List<FlowModel> itemList;
//
//   SaveIndexModel(this.selectedIndices);
//
//   @override
//   List<Object?> get props => [selectedIndices];
// }