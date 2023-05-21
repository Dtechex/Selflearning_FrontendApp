import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/add_media/bloc/add_media_bloc.dart';

import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/utilities/image_picker_helper.dart';

import '../camera/camera_screen.dart';
import '../quick_add/data/bloc/quick_add_bloc.dart';
import '../quick_add/quick_add_screen.dart';

class AddImageScreen extends StatefulWidget {
  final String rootId;
  const AddImageScreen({Key? key, required this.rootId}) : super(key: key);

  @override
  State<AddImageScreen> createState() => _AddImageScreenState();
}

final TextEditingController textEditingController = TextEditingController();

class _AddImageScreenState extends State<AddImageScreen> {

  AddMediaBloc addMediaBloc= AddMediaBloc();

  @override
  void dispose() {
    super.dispose();
    addMediaBloc.close();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => addMediaBloc,child: Scaffold(
        appBar: AppBar(title: const Text('Create Image')),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: BlocConsumer<AddMediaBloc, AddMediaInitial>(
            listener: (context, state) {
              if (state is QuickAddedState) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuickTypeScreen(),
                    ),
                        (route) => false);
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
                state.file==null?  GestureDetector(
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
                         addMediaBloc.add(ImagePickEvent(image: value));
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
                      child: Image.file(File(state.file!.path))
                  ),
                  Positioned(
                      top: 10,right: 10,
                      child: Icon(Icons.delete)),
                ],),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                      addMediaBloc.add(SubmitButtonEvent(
                        mediaType: 'image',
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
        )),);
  }
}
