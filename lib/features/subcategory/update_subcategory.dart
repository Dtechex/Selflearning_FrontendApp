import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';

import '../category/bloc/category_bloc.dart';
import '../dashboard/dashboard_screen.dart';

class UpdateSubCateScreen extends StatefulWidget {
  final String? rootId;
  final Color? selectedColor;
  final String? categoryTitle;
  const UpdateSubCateScreen({Key? key, this.rootId, this.selectedColor, this.categoryTitle}) : super(key: key);

  @override
  State<UpdateSubCateScreen> createState() => _UpdateSubCateScreenState();
}

class _UpdateSubCateScreenState extends State<UpdateSubCateScreen> {
  Color? pickedColor;

  @override
  void initState() {
    pickedColor=widget.selectedColor;
    super.initState();
  }


  TextEditingController categoryNameController = TextEditingController();

  bool? isLoading = false;

  void pickColor({required BuildContext context}) {

    print(widget.rootId);
    print(widget.rootId);
    context.showNewDialog(
      AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            portraitOnly: true,
            pickerColor: widget.selectedColor!,
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
    List<String> keywords = ['test,test1'];
    List<Map<String, String>> styles = [
      {"key": "font-size", "value": "2rem"},
      {"key": "background-color", "value": pickedColor!.value.toString()}
    ];
    Map<String, dynamic> payload = {};
    payload.addAll({
      "name": categoryNameController.text,
    });
    payload.addAll({"keywords": keywords});
    payload.addAll({"styles": styles});
    var token = await SharedPref().getToken();
    try {
      var res = await http.patch(
        Uri.parse('http://3.110.219.9:8000/web/category/${widget.rootId}'),
        body: jsonEncode(payload),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (res.statusCode == 200) {
        context.showSnackBar(
            SnackBar(content: Text('Category update Successfully')));
        context.read<CategoryBloc>().add(CategoryLoadEvent());
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return DashBoardScreen();
          },
        ));
      } else {
        context
            .showSnackBar(const SnackBar(content: Text('opps something went worng')));
      }
      print(res.body);
      print('data');
    } finally {
      isLoading = true;
    }

    return null;
  }


  Future<int?> deleteCategory() async {
    isLoading = true;
    var token = await SharedPref().getToken();
    try {
      var res = await http.delete(
        Uri.parse('http://3.110.219.9:8000/web/category/${widget.rootId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (res.statusCode == 200) {
        context.showSnackBar(
            SnackBar(content: Text('Category deleted Successfully')));
        context.read<CategoryBloc>().add(CategoryLoadEvent());
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return DashBoardScreen();
          },
        ));
      } else {
        context
            .showSnackBar(const SnackBar(content: Text('opps something went worng')));
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
    print(widget.categoryTitle);
    print('subcateg .11. edit');

    return Scaffold(
        appBar: AppBar(title: const Text('Update SubCategory')),
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
                        initialValue: widget.categoryTitle,

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
                      child: Container(
                          height: 25,
                          width: 25,
                          color:pickedColor)),
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
                            content: Text('SubCategory Name is Requried')));
                      } else {
                        addCategory();
                      }
                    },
                    child: isLoading == true
                        ? const CircularProgressIndicator()
                        : Text('Update SubCategory')),
              ),
              SizedBox(
                height: 20,
              ),

              SizedBox(
                width: context.screenWidth * 0.35,
                height: context.screenHeight * 0.068,
                child: ElevatedButton(
                    onPressed: () {
                      if (categoryNameController.text.isEmpty ||
                          categoryNameController == null) {
                        context.showSnackBar(const SnackBar(
                            content: Text('SubCategory Name is Requried')));
                      } else {
                        deleteCategory();
                      }
                    },
                    child: isLoading == true
                        ? const CircularProgressIndicator()
                        : const Text('Delete SubCategory')),
              )
            ],
          ),
        ));
  }
}
