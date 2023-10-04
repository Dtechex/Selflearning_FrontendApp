import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/create_flow/bloc/create_flow_screen_bloc.dart';
import 'package:self_learning_app/features/create_flow/slide_show_screen.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../../../utilities/shared_pref.dart';
import '../../create_flow/data/model/flow_model.dart';

class PrimaryFlow extends StatefulWidget {
  final String CatId;
  final String flowId;

  const PrimaryFlow({super.key, required this.CatId, required this.flowId});

  @override
  State<PrimaryFlow> createState() => _PrimaryFlowState();
}






class _PrimaryFlowState extends State<PrimaryFlow> {
  List<String> names = [];
  List<FlowDataModel> flowList = [];
  bool showdefaultFlow= false;

  @override
  void initState() {
    super.initState();
      if(widget.flowId == "0"){
        setState(() {
          showdefaultFlow = true;
        });
      }
    fetchData();
    fetchdataList();
  }

Future<void> fetchdataList() async{
    try{
      final datalist = await fetchList(mainCatId: widget.CatId);
         datalist;
      setState(() {
        flowList = datalist;

      });

      print("0-0-0-${flowList.length}");


    }
    catch (error) {
      print('Error: $error');
    }
}

  Future<void> fetchData() async {
    try {
      final nameList = await getData(mainCatId: widget.CatId);

      setState(() {
        names = nameList;
      });
    } catch (error) {
      print('Error: $error');
    }
  }
  Future<List<String>> getData({required String mainCatId}) async {
    final token = await SharedPref().getToken();

    final Options options = Options(
      headers: {"Authorization": 'Bearer $token'},
    );

    try {
      Response res = await Dio().get(
        'https://selflearning.dtechex.com/web/prompt?categoryId=$mainCatId',
        options: options,
      );

      if (res.statusCode == 200) {
        final data = res.data;
        final records = data['data']['record'];
        print("#########${records}");
        print("######break");

        List<String> names = records.map<String>((record) => record['name'].toString()).toList();
/*
        List<FlowDataModel> flowDataList = records.map<FlowDataModel>((item) {
          return FlowDataModel(
            resourceTitle: item['name'],
            resourceType: item['resourceId'] == null ? 'text' : 'image',
            resourceContent: '', // You can populate this based on your needs.
            side1Title: item['side1']['title'],
            side1Type: item['side1']['type'],
            side1Content: item['side1']['content'],
            side2Title: item['side2']['title'],
            side2Type: item['side2']['type'],
            side2Content: item['side2']['content'],
            promptName: '', // You can populate this based on your needs.
            promptId: '', // You can populate this based on your needs.
          );
        }).toList();
*/
       /* print("${flowDataList.length}");
        for (FlowDataModel flowDataModel in flowDataList) {
          print("---------->${flowDataModel.side2Content}");
        }*/
        return names;
      } else {
        throw Exception('Failed to fetch data from the API');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }


  Future<List<FlowDataModel>> fetchList({required String mainCatId}) async {
    final token = await SharedPref().getToken();

    final Options options = Options(
      headers: {"Authorization": 'Bearer $token'},
    );

    try {
      Response res = await Dio().get(
        'https://selflearning.dtechex.com/web/prompt?categoryId=$mainCatId',
        options: options,
      );

      if (res.statusCode == 200) {
        final data = res.data;
        final records = data['data']['record'];
        print("#########${records}");
        print("######break");

        List<FlowDataModel> flowDataList = records.map<FlowDataModel>((item) {
          return FlowDataModel(
            resourceTitle: item['name'],
            resourceType: item['resourceId'] == null ? 'text' : 'image',
            resourceContent: '', // You can populate this based on your needs.
            side1Title: item['side1']['title'],
            side1Type: item['side1']['type'],
            side1Content: item['side1']['content'],
            side2Title: item['side2']['title'],
            side2Type: item['side2']['type'],
            side2Content: item['side2']['content'],
            promptName: '', // You can populate this based on your needs.
            promptId: '', // You can populate this based on your needs.
          );
        }).toList();
        print("${flowDataList.length}");
        for (FlowDataModel flowDataModel in flowDataList) {

          print("---------->${flowDataModel.side2Content}");
        }
        return flowDataList;
      } else {
        throw Exception('Failed to fetch data from the API');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }
  @override
  Widget build(BuildContext context) {

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return showdefaultFlow?
      Scaffold(
        appBar: AppBar(title: const Text('Prompts'),
          backgroundColor: Colors.green,

        ),
        floatingActionButton: SizedBox(
          height: context.screenHeight * 0.1,
          child: FittedBox(
            child: ElevatedButton(

              onPressed: () {
                if(flowList.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opps sorry no data is found'),
                    ),
                  );
                }
                if(flowList.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SlideShowScreen(
                      flowList: flowList, flowName: "MainCategoryFlow",
                    );
                  },));
                }

              },
              child: const Row(
                children: [
                  Text(
                    'Start Flow',
                    style: TextStyle(fontSize: 9),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child:
                ReorderableListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  children: <Widget>[
                    for (int index = 0;
                    index < flowList.length;
                    index += 1)
                      ListTile(
                        leading: CircleAvatar(
                          maxRadius: 17, backgroundColor: generateRandomColor(),
                          foregroundColor: Colors.white,
                          child: Text(
                            extractFirstLetter(names.first),
                            style: TextStyle(fontWeight: FontWeight.bold),)
                          ,),
                        trailing: Icon(Icons.menu),
                        key: Key('$index'),
                        tileColor: index.isOdd ? oddItemColor : evenItemColor,
                        title: Row(
                          children: [
                            Text('${flowList[index].resourceTitle.toString()}')
                          ],
                        ),
                      ),
                  ],
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      FlowDataModel item = flowList.removeAt(oldIndex);
                      flowList.insert(newIndex, item);

                    /*  PromtModel model = state.promtModel!.removeAt(oldIndex);
                      state.promtModel!.insert(newIndex, model);*/
                    });
                  },
                )),
          ],
        ),
      ):Scaffold(
      appBar: AppBar(title: const Text('Prompts'),
        backgroundColor: Colors.green,

      ),
      body: Center(
        child: Text("no data found"),
      ),
    );

  }
  Color generateRandomColor() {
    final Random random = Random();
    Color color;

    do {
      color = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    } while (_isBright(color) || color == Colors.white);

    return color;
  }
  bool _isBright(Color color) {
    // Calculate the luminance of the color using the formula
    // Luminance = 0.299 * Red + 0.587 * Green + 0.114 * Blue
    double luminance = 0.299 * color.red + 0.587 * color.green + 0.114 * color.blue;

    // Return true if the luminance is greater than a threshold (adjust as needed)
    return luminance > 180;
  }
  String extractFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text.substring(0,1).toUpperCase();
  }
}

