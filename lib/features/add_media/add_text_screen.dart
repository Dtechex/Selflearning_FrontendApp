import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:self_learning_app/utilities/extenstion.dart';

import '../camera/camera_screen.dart';
import '../promt/promts_screen.dart';
import '../quick_add/data/bloc/quick_add_bloc.dart';
import '../quick_add/quick_add_screen.dart';
import '../resources/bloc/resources_bloc.dart';
import '../resources/resources_screen.dart';
import 'bloc/add_media_bloc.dart';

class AddTextScreen extends StatefulWidget {
  final String rootId;
  final int whichResources;
  final String? resourceId;
  const AddTextScreen({Key? key, required this.rootId,required this.whichResources,this.resourceId}) : super(key: key);

  @override
  State<AddTextScreen> createState() => _AddTextScreenState();
}

final TextEditingController textEditingController = TextEditingController();

class _AddTextScreenState extends State<AddTextScreen> {
  AddMediaBloc addMediaBloc= AddMediaBloc();


  @override
  void initState() {

    super.initState();
    textEditingController.text='';
  }

  @override
  void dispose() {
    context.loaderOverlay.hide();
    super.dispose();
    print('dispose');
    addMediaBloc.close();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => addMediaBloc,child: Scaffold(
        appBar: AppBar(title: Text('Create Text')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: BlocConsumer<AddMediaBloc, AddMediaInitial>(
            listener: (context, state) {
              if (state.apiState==ApiState.submitted ) {
                context.loaderOverlay.hide();
                print(state.wichResources);
                print('state.wichResources');
                context.read<ResourcesBloc>().add(LoadResourcesEvent(rootId: widget.rootId, mediaType: ''));
                Navigator.pop(context);
                /*switch(state.wichResources){
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
                        builder: (context) => AllResourcesList(rootId: widget.rootId,mediaType: ''),
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
                }*/
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
                    padding: EdgeInsets.all(10),
                    height: context.screenHeight * 0.15,
                    width: context.screenWidth,
                    child: TextField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(80),
                      ],
                      controller: textEditingController,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                  ),

                  ElevatedButton(
                      onPressed: () {

                          addMediaBloc.add(SubmitButtonEvent(
                          MediaType: 0,
                          //  resourcesId: widget.resourceId,
                           whichResources: widget.whichResources,
                            rootId: widget.rootId,
                            title: textEditingController.text == ''
                                ? 'Untitled'
                                : textEditingController.text));
                        },
                      child: const Text('Create '))
                ],
              );
            },
          ),
        )),);
  }
}
