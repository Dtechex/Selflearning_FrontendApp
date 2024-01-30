import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:self_learning_app/features/add_media/bloc/add_media_bloc.dart';
import 'package:self_learning_app/features/dailog_category/bloc/add_prompt_res_cubit.dart';

import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/utilities/image_picker_helper.dart';

import '../camera/camera_screen.dart';
import '../promt/promts_screen.dart';
import '../quick_add/data/bloc/quick_add_bloc.dart';
import '../quick_add/quick_add_screen.dart';
import '../resources/bloc/resources_bloc.dart';
import '../resources/resources_screen.dart';

class AddImageScreen extends StatefulWidget {
  final String rootId;
  final int  whichResources;

   AddImageScreen({Key? key, required this.rootId,required this.whichResources}) : super(key: key);

  @override
  State<AddImageScreen> createState() => _AddImageScreenState();
}

final TextEditingController textEditingController = TextEditingController();

class _AddImageScreenState extends State<AddImageScreen> {


  AddMediaBloc addMediaBloc = AddMediaBloc();
  final AddPromptResCubit cubitAddPromptRes = AddPromptResCubit();


  @override
  void initState() {
    textEditingController.text = '';
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
      create: (context) => addMediaBloc, child: Scaffold(
        appBar: AppBar(title: const Text('Add Image Resource'),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: BlocConsumer<AddMediaBloc, AddMediaInitial>(
            listener: (context, state) {
              if (state.apiState == ApiState.submitted) {
                context.loaderOverlay.hide();
                print(state.wichResources);
                print('state.wichResources');
                context.read<ResourcesBloc>().add(LoadResourcesEvent(rootId: widget.rootId, mediaType: ''));
                context.read<AddPromptResCubit>()..getResPrompt(dailogId: widget.rootId);
                Navigator.pop(context,true);


                /*switch (state.wichResources) {
                  case 0:
                    {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuickTypeScreen(),
                        ),
                      );
                    }
                    break;
                  case 1:
                    {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllResourcesList(
                              rootId: widget.rootId, mediaType: ''),
                        ),
                      );
                    }
                    break;
                  case 2:
                    {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PromtsScreen(promtId: widget.rootId),
                        ),
                      );
                    }
                    break;
                }*/
              }
              else if (state.apiState == ApiState.submitting) {
                context.loaderOverlay.show();
                context.showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Adding resources...')));

              } else if (state.apiState == ApiState.submitError) {
                context.loaderOverlay.hide();
                context.showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Something went wrong.')));
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: context.screenHeight * 0.15,
                    width: context.screenWidth,
                    child: TextField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(80),
                      ],
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.red),
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        hintText: 'Enter Title here...',
                        hintStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0))
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Container(
                              child: Wrap(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.photo_library),
                                    title: Text('Photo Library'),
                                    onTap: () {
                                      ImagePickerHelper.pickImage(
                                          imageSource: ImageSource.gallery)
                                          .then((value) {
                                        if (value != null) {
                                          addMediaBloc.add(ImagePickEvent(
                                              image: value.path));
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.camera_alt),
                                    title: Text('Camera'),
                                    onTap: () {
                                      ImagePickerHelper.pickImage(
                                          imageSource: ImageSource.camera)
                                          .then((value) {
                                        if (value != null) {
                                          addMediaBloc.add(ImagePickEvent(
                                              image: value.path));
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Choose File'),
                  ),
                  const Spacer(),
                  if(state.selectedFilepath!.isNotEmpty) Stack(children: [

                    Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        height: context.screenHeight * 0.24,
                        width: context.screenWidth,
                        child: Image.file(File(state.selectedFilepath!))
                    ),
                    Positioned(
                        top: 10, right: 10,
                        child: IconButton(
                          icon: Icon(Icons.delete), onPressed: () {
                          addMediaBloc.add(RemoveMedia());
                        },)),
                  ],),
                  /*state.selectedFilepath!.isEmpty ? GestureDetector(
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
                              Icon(
                                  Icons.image, size: context.screenWidth / 2.5),
                              const Text('Upload')
                            ],
                          )
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Container(
                              child: Wrap(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.photo_library),
                                    title: Text('Photo Library'),
                                    onTap: () {
                                      ImagePickerHelper.pickImage(
                                          imageSource: ImageSource.gallery)
                                          .then((value) {
                                        if (value != null) {
                                          addMediaBloc.add(ImagePickEvent(
                                              image: value.path));
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.camera_alt),
                                    title: Text('Camera'),
                                    onTap: () {
                                      ImagePickerHelper.pickImage(
                                          imageSource: ImageSource.camera)
                                          .then((value) {
                                        if (value != null) {
                                          addMediaBloc.add(ImagePickEvent(
                                              image: value.path));
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ) : Stack(children: [

                    Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        height: context.screenHeight * 0.24,
                        width: context.screenWidth,
                        child: Image.file(File(state.selectedFilepath!))
                    ),
                    Positioned(
                        top: 10, right: 10,
                        child: IconButton(
                          icon: Icon(Icons.delete), onPressed: () {
                          addMediaBloc.add(RemoveMedia());
                        },)),
                  ],),*/
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if(state.selectedFilepath!.isEmpty){
                          context.showSnackBar(const SnackBar(content: Text('Please attach file'),duration: Duration(seconds: 1),));
                        }else {
                          addMediaBloc.add(SubmitButtonEvent(
                            MediaType: 1,
                            whichResources: widget.whichResources,
                            rootId: widget.rootId,
                            title: textEditingController.text.isEmpty
                                ? 'Untitled'
                                : textEditingController.text));

                        }
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: De(context) => const QuickTypeScreen(),
                        //     ),
                        //         (route) => false);
                      },
                      child: const Text('Upload Resource')),
                  const Spacer(flex: 3,),
                ],
              );
            },
          ),
        )),);
  }
}


