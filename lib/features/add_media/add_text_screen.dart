import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:self_learning_app/utilities/extenstion.dart';

import '../camera/camera_screen.dart';
import '../quick_add/data/bloc/quick_add_bloc.dart';
import '../quick_add/quick_add_screen.dart';

class AddTextScreen extends StatefulWidget {
  final String rootId;
  const AddTextScreen({Key? key, required this.rootId}) : super(key: key);

  @override
  State<AddTextScreen> createState() => _AddTextScreenState();
}

final TextEditingController textEditingController = TextEditingController();

class _AddTextScreenState extends State<AddTextScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Create Text')),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: BlocConsumer<QuickAddBloc, QuickAddState>(
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
                    padding: EdgeInsets.all(10),
                    height: context.screenHeight * 0.15,
                    width: context.screenWidth,
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(hintText: 'title'),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    height: context.screenHeight * 0.24,
                    width: context.screenWidth,
                    child: Center(
                      child: Icon(Icons.image, size: context.screenWidth / 2.5),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context.read<QuickAddBloc>().add(ButtonPressedEvent(
                            title: textEditingController.text.isEmpty
                                ? 'Untitled'
                                : textEditingController.text));
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => QuickTypeScreen(),
                        //     ),
                        //     (route) => false);
                      },
                      child: const Text('Create '))
                ],
              );
            },
          ),
        ));
  }
}
