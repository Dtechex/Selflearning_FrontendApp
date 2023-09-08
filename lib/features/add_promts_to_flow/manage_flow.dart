


import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:self_learning_app/features/add_promts_to_flow/add_promts_to_flow_screen.dart';

import '../../utilities/shared_pref.dart';

class ManageFlow extends StatefulWidget {
  final String title;

  final String rootId;

  final List<PromptListModel> promptList;

  const ManageFlow({super.key, required this.title, required this.rootId, required this.promptList});

  @override
  State<ManageFlow> createState() => _ManageFlowState();
}

class _ManageFlowState extends State<ManageFlow> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: MaterialButton(
              onPressed: () {
                saveFlow(
                    catId: widget.rootId,
                  title: widget.title,
                  data: widget.promptList,
                );
              },
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text('Save'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ReorderableListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
                children: <Widget>[
                  for (int index = 0; index < widget.promptList.length; index += 1)
                    PromptsTile(prompt: widget.promptList[index],
                      key: Key('$index'),
                      index: index,),
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    //print(state.addFlowModel)
                    PromptListModel item = widget.promptList.removeAt(oldIndex);
                    widget.promptList.insert(newIndex, item);
                  });
                },
              )),
        ],
      ),
    );
  }

  Future<void> saveFlow({required String catId, required String title, required List<PromptListModel> data}) async {
    EasyLoading.show(dismissOnTap: true);
    final token = await SharedPref().getToken();
    final Options options = Options(
        headers: {"Authorization": 'Bearer $token'}
    );
    final List<Map<String, String>> dataToSend = data
        .map((data) => {'promptId': data.id})
        .toList();
    Response response = await Dio().post(
      'https://selflearning.dtechex.com/web/flow',
      data: {
        'categoryId': catId,
        'title': title,
        'flow': dataToSend,
      },
      options: options,

    );
    print('Successful $response');
    if(response.statusCode == 200 || response.statusCode == 201){
      Navigator.pop(context, true);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to process your request')));
    }
    EasyLoading.dismiss();
  }

}

class PromptsTile extends StatefulWidget {
  final PromptListModel prompt;
  final int index;
  const PromptsTile({super.key, required this.prompt, required this.index});

  @override
  State<PromptsTile> createState() => _PromptsTileState();
}

class _PromptsTileState extends State<PromptsTile> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return ListTile(
      leading: CircleAvatar(
        maxRadius: 17,
        backgroundColor: widget.prompt.bgColor,
        foregroundColor: Colors.white,
        child: Text(
          extractFirstLetter(widget.prompt.name),
          style: TextStyle(fontWeight: FontWeight.bold),)
        ,),
      trailing: Icon(Icons.menu),
      tileColor: widget.index.isOdd ? oddItemColor : evenItemColor,
      title: Row(
        children: [
          Text('${widget.prompt.name}')
        ],
      ),
    );
  }

  String extractFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text.substring(0,1).toUpperCase();
  }

}
