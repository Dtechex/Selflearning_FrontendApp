import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:self_learning_app/features/add_media/bloc/add_media_bloc.dart';
import 'package:self_learning_app/promt/promts_screen.dart';

import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/utilities/image_picker_helper.dart';

import '../camera/camera_screen.dart';
import '../quick_add/data/bloc/quick_add_bloc.dart';
import '../quick_add/quick_add_screen.dart';
import '../resources/resources_screen.dart';

class AddImageScreen extends StatefulWidget {
  final String rootId;
  final int  whichResources;

  const AddImageScreen({Key? key, required this.rootId,required this.whichResources,}) : super(key: key);

  @override
  State<AddImageScreen> createState() => _AddImageScreenState();
}

final TextEditingController textEditingController = TextEditingController();

class _AddImageScreenState extends State<AddImageScreen> {


  AddMediaBloc addMediaBloc= AddMediaBloc();


  @override
  void initState() {
    textEditingController.text='';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    addMediaBloc.close();
  }


  @override
  Widget build(BuildContext context) {
    print(widget.rootId);
    print('inse image add image');
    return BlocProvider(
      create: (context) => addMediaBloc,child: Scaffold(
        appBar: AppBar(title: const Text('Create Image')),
        body: SingleChildScrollView(child:  Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: BlocConsumer<AddMediaBloc, AddMediaInitial>(
            listener: (context, state) {
              if (state.apiState==ApiState.submitted ) {
                context.loaderOverlay.hide();
                print(state.wichResources);
                print('state.wichResources');
                switch(state.wichResources){
                  case 0: {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuickTypeScreen(),
                      ),
                    );
                  }break;
                  case 1: {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllResourcesList(rootId: widget.rootId),
                      ),
                    );
                  }break;
                  case 2: {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PromtsScreen(promtId: widget.rootId),
                      ),
                    );

                  }break;
                }
              }
              else if  (state.apiState==ApiState.submitting) {
                context.loaderOverlay.show();
                context.showSnackBar(const SnackBar(duration: Duration(seconds: 1),content: Text('Adding resources...')));
              } else if  (state.apiState==ApiState.submitError) {
                context.loaderOverlay.hide();
                context.showSnackBar(const SnackBar(duration: Duration(seconds: 1),content: Text('Something went wrong.')));
              }
            },
            builder: (context, state) {

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: context.screenHeight * 0.15,
                    width: context.screenWidth,
                    child: TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(hintText: 'title'),
                    ),
                  ),
                  state.selectedFilepath!.isEmpty?  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      height: context.screenHeight * 0.24,
                      width: context.screenWidth,
                      child: Center(
                          child:
                          Row(
                            children: [
                              Icon(Icons.image, size: context.screenWidth / 2.5),
                              const Text('Upload')
                            ],
                          )
                      ),
                    ),
                    onTap: () {
                      ImagePickerHelper.pickImage().then((value) {
                        if(value!=null){
                          addMediaBloc.add(ImagePickEvent(image: value.path));
                        }
                      });
                    },
                  ):Stack(children: [

                    Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        height: context.screenHeight * 0.24,
                        width: context.screenWidth,
                        child: Image.file(File(state.selectedFilepath!))
                    ),
                    Positioned(
                        top: 10,right: 10,
                        child: IconButton(icon: Icon(Icons.delete),onPressed: () {
                          addMediaBloc.add(RemoveMedia());
                        },)),
                  ],),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addMediaBloc.add(SubmitButtonEvent(
                          MediaType: 1,
                            whichResources: widget.whichResources,
                            rootId: widget.rootId,
                            title: textEditingController.text.isEmpty
                                ? 'Untitled'
                                : textEditingController.text));
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const QuickTypeScreen(),
                        //     ),
                        //         (route) => false);
                      },
                      child: const Text('Create '))
                ],
              );
            },
          ),
        ),)),);
  }
}
