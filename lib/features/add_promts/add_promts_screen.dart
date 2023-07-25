import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:self_learning_app/features/add_media/bloc/add_media_bloc.dart';
import 'package:self_learning_app/features/add_promts/bloc/add_prompts_bloc.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/utilities/image_picker_helper.dart';

import '../../utilities/colors.dart';

class AddPromptsScreen extends StatefulWidget {
  final String resourceId;
  const AddPromptsScreen({required this.resourceId,Key? key}) : super(key: key);

  @override
  State<AddPromptsScreen> createState() => _AddPromptsScreenState();
}

List<String> mediaType = ['Audio', 'Text', 'Video', 'Image'];



class _AddPromptsScreenState extends State<AddPromptsScreen> {
  final AddPromptsBloc addPromptsBloc = AddPromptsBloc();


  TextEditingController side1_Controller = TextEditingController();
  TextEditingController side2_Controller = TextEditingController();
  @override
  void initState() {
    // side2_Controller.text='';
    // side1_Controller.text='';
    // addPromptsBloc.add(LoadPrompts());
    super.initState();
  }

  @override
  void dispose() {
    side2_Controller.dispose();
    side1_Controller.dispose();
    addPromptsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => addPromptsBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Prompt',style: TextStyle(
            fontSize: 17
          )),
          backgroundColor: primaryColor,
        ),
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: SingleChildScrollView(child: Container(
              width: context.screenWidth,
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: BlocConsumer<AddPromptsBloc, AddPromptsInitial>(
                listener: (BuildContext context, Object? state) {
                  if(state is AddPromptsInitial){
                    if(state.uploadStatus==UploadStatus.uploaded){
                      context.showSnackBar(SnackBar(content: Text("Resource added..")));
                      context.pop();
                    }
                    if(state.uploadStatus==UploadStatus.resourceAdded){
                      context.showSnackBar(SnackBar(content: Text("Resource added..")));

                    }
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Card(
                        child: Padding(
                          padding:
                          EdgeInsets.only(bottom: 10, left: 10, right: 10),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Side 1/ Question'),
                                Row(
                                  children: [
                                    Text('Resources type.        '),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(top: 10),
                                      height: 40,
                                      width: context.screenWidth / 2,
                                      child: Row(
                                        children: [
                                          Icon(Icons.text_format,
                                              color: Colors.white),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          DropdownButton(
                                            dropdownColor: Colors.redAccent,
                                            iconEnabledColor: Colors.white,

                                            style:
                                            TextStyle(color: Colors.white),

                                            // Initial Value
                                            value:
                                            state.side1selectedMediaType ?? mediaType.first,

                                            // Down Arrow Icon
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),

                                            // Array list of items
                                            items:
                                            mediaType.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              );
                                            }).toList(),
                                            onChanged: (Object? value) {
                                              print(value);
                                              addPromptsBloc.add(
                                                  ChangeMediaType(
                                                      whichSide: 0,
                                                      MediaType:
                                                      value.toString()));
                                            },
                                            // After selecting the desired option,it will
                                            // change button value to selected value
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                state.side1selectedMediaType == 'Text'
                                    ? Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black.withOpacity(
                                          0.5), // Set border color to red
                                      width: 2, // Set border width
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    color: Colors.grey.shade200,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    controller: side1_Controller,
                                    onTap: () {},
                                    decoration: InputDecoration.collapsed(
                                        hintText:
                                        'Add Questions',
                                        hintStyle:
                                        TextStyle(fontSize: 12)),
                                  ),
                                )
                                    : GestureDetector(
                                  onTap: () {
                                    print(state.side1selectedMediaType);
                                    if(state.side1selectedMediaType=='Image'){
                                      ImagePickerHelper.pickImage(imageSource: ImageSource.camera).then((value) {
                                        print(value!.path);
                                        print("value");
                                        addPromptsBloc.add(PickResource(mediaUrl: value.path,whichSide: 0));

                                      });
                                    }else if(state.side1selectedMediaType=='Video'){
                                      ImagePickerHelper.pickVideo(imageSource: ImageSource.camera).then((value) {
                                        addPromptsBloc.add(PickResource(mediaUrl: value!.path,whichSide: 0));
                                      });
                                    }else if(state.side1selectedMediaType=='Audio'){
                                      ImagePickerHelper.pickFile().then((value) {
                                        addPromptsBloc.add(PickResource(mediaUrl: value,whichSide: 0));
                                      });
                                    }
                                  },
                                  child: Container(
                                    color: Colors.grey,
                                    height: context.screenHeight / 5,
                                    child:  getFileType(state.side1ResourceUrl!)=='Photo'?Image.file(File(state.side1ResourceUrl!),fit: BoxFit.fill,):Center(
                                      child: Text(state
                                          .side1selectedMediaType ==
                                          'Image'
                                          ? 'Upload Image'
                                          : state.side1selectedMediaType ==
                                          'Video'
                                          ? "Upload Video"
                                          : state.side1selectedMediaType ==
                                          'Audio'
                                          ? 'Upload Audio'
                                          : ''),
                                    ),
                                  ),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll(Colors.red)
                                        ),
                                        onPressed: () {
                                          addPromptsBloc.add(AddResource(mediaUrl: state.side1ResourceUrl,whichSide: 0,name: 'Unitited',resourceId: widget.resourceId,content: side1_Controller.text));
                                        }, child: const Text('     Save    '))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40,),
                      Card(
                        child: Padding(
                          padding:
                          EdgeInsets.only(bottom: 10, left: 10, right: 10),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Side 2/ Question'),
                                Row(
                                  children: [
                                    Text('Resources type.        '),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(top: 10),
                                      height: 40,
                                      width: context.screenWidth / 2,
                                      child: Row(
                                        children: [
                                          Icon(Icons.text_format,
                                              color: Colors.white),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          DropdownButton(
                                            dropdownColor: Colors.redAccent,
                                            iconEnabledColor: Colors.white,

                                            style:
                                            const TextStyle(color: Colors.white),

                                            // Initial Value
                                            value:
                                            state.side2selectedMediaType ??
                                                mediaType.first,

                                            // Down Arrow Icon
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),

                                            // Array list of items
                                            items:
                                            mediaType.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              );
                                            }).toList(),
                                            onChanged: (Object? value) {
                                              print(value);
                                              addPromptsBloc.add(
                                                  ChangeMediaType(
                                                      whichSide: 1,
                                                      MediaType:
                                                      value.toString()));
                                            },
                                            // After selecting the desired option,it will
                                            // change button value to selected value
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                state.side2selectedMediaType == 'Text'
                                    ? Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black.withOpacity(
                                          0.5), // Set border color to red
                                      width: 2, // Set border width
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    color: Colors.grey.shade200,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    controller: side2_Controller,
                                    onTap: () {},
                                    decoration: InputDecoration.collapsed(
                                        hintText:
                                        'Add Question',
                                        hintStyle:
                                        TextStyle(fontSize: 12)),
                                  ),
                                )
                                    : GestureDetector(
                                  onTap: () {
                                    if(state.side2selectedMediaType=='Image'){
                                      ImagePickerHelper.pickImage(imageSource: ImageSource.camera);
                                    }else if(state.side2selectedMediaType=='Video'){
                                      ImagePickerHelper.pickVideo(imageSource: ImageSource.camera);
                                    }else if(state.side2selectedMediaType=='Audio'){
                                      ImagePickerHelper.pickFile();
                                    }

                                  },
                                  child: Container(
                                    color: Colors.grey,
                                    height: context.screenHeight / 5,
                                    child: Center(
                                      child: Text(state
                                          .side2selectedMediaType ==
                                          'Image'
                                          ? 'Upload Image'
                                          : state.side2selectedMediaType ==
                                          'Video'
                                          ? "Upload Video"
                                          : state.side2selectedMediaType ==
                                          'Audio'
                                          ? 'Upload Audio'
                                          : ''),
                                    ),
                                  ),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll(Colors.red)
                                        ),
                                        onPressed: () {
                                          addPromptsBloc.add(AddResource(mediaUrl: state.side2ResourceUrl,whichSide: 1,name: '',resourceId: widget.resourceId,content: side2_Controller.text));
                                        }, child: Text('     Save    '))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(onTap: () {
                        print(state.side1Id);
                        print(state.side2Id);
                        context.read<AddPromptsBloc>().add(AddPromptEvent(resourceId: widget.resourceId!));
                      },child: Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)
                        ),

                        width: 100,
                        height: 40,
                        child: const Center(
                          child: Text('Add Prompt',style: TextStyle(
                              fontSize: 12,color: Colors.white
                          ),),
                        ),
                      ),)
                    ],
                  );
                },

              ))),
        ),
      ),
    );
  }
}


String getFileType(String format) {
  List<String> photoFormats = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
  List<String> videoFormats = ['.mp4', '.mov', '.avi', '.mkv'];
  List<String> audioFormats = ['.mp3', '.wav', '.ogg', '.m4a'];

  String lowerFormat = format.toLowerCase();

  for (String photoFormat in photoFormats) {
    if (lowerFormat.contains(photoFormat)) {
      return 'Photo';
    }
  }

  for (String videoFormat in videoFormats) {
    if (lowerFormat.contains(videoFormat)) {
      return 'Video';
    }
  }

  for (String audioFormat in audioFormats) {
    if (lowerFormat.contains(audioFormat)) {
      return 'Audio';
    }
  }

  return 'Unknown'; // Return 'Unknown' if no matching format is found.
}
