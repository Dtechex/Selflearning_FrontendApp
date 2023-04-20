import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:self_learning_app/features/subcategory/bloc/sub_cate_bloc.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';

import '../category/bloc/category_bloc.dart';
import '../dashboard/dashboard_screen.dart';

class CreateSubCateScreen extends StatefulWidget {
  final String? rootId;
  final String? subCatName;

  const CreateSubCateScreen({Key? key, this.rootId, this.subCatName}) : super(key: key);

  @override
  State<CreateSubCateScreen> createState() => _CreateSubCateScreenState();
}

class _CreateSubCateScreenState extends State<CreateSubCateScreen> {
  Color? pickedColor = Colors.green;
  TextEditingController categoryNameController = TextEditingController();

  bool? isLoading = false;

  void pickColor({required BuildContext context}) {
    context.showNewDialog(
      AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            portraitOnly: true,
            pickerColor: pickedColor!,
            onColorChanged: (value) {
              setState(() {
                pickedColor = value;
              });
            },
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<int?> addCategory() async {
    isLoading = true;
    Map<String, dynamic> payload = {};
    List<String> keywords = [];
    List<Map<String, String>> styles = [
      {"key": "font-size", "value": "2rem"},
      {"key": "background-color", "value": pickedColor!.value.toString()}
    ];
    payload.addAll({
      "name": categoryNameController.text,
    });
    payload.addAll({"keywords": keywords});
    payload.addAll({"styles": styles});
    payload.addAll({
      "rootId": widget.rootId,
    });
    var token = await SharedPref().getToken();
    try {
      var res = await http.post(
        Uri.parse('http://3.110.219.9:8000/web/category/create'),
        body: jsonEncode(payload),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (res.statusCode == 201) {
        context.showSnackBar(
            SnackBar(content: Text('Subcategory created successfully')));
        context
            .read<SubCategoryBloc>()
            .add(SubCategoryLoadEvent(rootId: widget.rootId));
        Navigator.pop(context);
      } else {
        context.showSnackBar(
            const SnackBar(content: Text('opps something went worng')));
      }
      print(res.body);
      print('data');
    } finally {
      isLoading = true;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    print('inside update');
    return Scaffold(
        appBar: AppBar(title: const Text('Create SubCategory')),
        body: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create Categories',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  height: context.screenHeight * 0.08,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10)),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        controller: categoryNameController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: 'SubCategory Name',
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.add,
                            size: context.screenWidth * 0.08,
                          ),
                          // errorText: state.email.invalid
                          //     ? 'Please ensure the email entered is valid'
                          //     : null,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (value) {},
                        textInputAction: TextInputAction.next,
                      ))),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        pickColor(context: context);
                      },
                      child:
                          Container(height: 25, width: 25, color: pickedColor)),
                  const Text('  Choose Color ')
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              SizedBox(
                width: context.screenWidth * 0.35,
                height: context.screenHeight * 0.068,
                child: ElevatedButton(
                    onPressed: () {
                      if (categoryNameController.text.isEmpty ||
                          categoryNameController == null) {
                        context.showSnackBar(const SnackBar(
                            content: Text('Category Name is Requried')));
                      } else {
                        addCategory();
                      }
                    },
                    child: isLoading == true
                        ? const CircularProgressIndicator()
                        : Center(
                            child: Text('      Create\n SubCategory'),
                          )),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
