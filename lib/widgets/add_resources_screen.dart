import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/add_media/add_audio_screen.dart';
import 'package:self_learning_app/features/add_media/add_text_screen.dart';
import 'package:self_learning_app/features/add_media/add_video_screen.dart';
import 'package:self_learning_app/features/resources/bloc/resources_bloc.dart';
import 'package:self_learning_app/promt/promts_screen.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../features/add_media/add_image_screen.dart';
import '../features/resources/resources_screen.dart';


//without app bar for add category or subcatrogry resource or promt

class AddResourceScreen extends StatefulWidget {
  final int whichResources;
  final String rootId;
   AddResourceScreen({Key? key, required this.rootId,required this.whichResources}) : super(key: key);

  @override
  State<AddResourceScreen> createState() => _AddResourceScreenState();
}


  List<String> mediaTitle = [
    'Take Picture',
    'Record Video',
    'Record Audio',
    'Enter Text'
  ];

  List<IconData> mediaIcons = [
    Icons.camera,
    Icons.video_call_outlined,
    Icons.audio_file_outlined,
    Icons.text_increase
  ];



class _AddResourceScreenState extends State<AddResourceScreen> {

  @override
  void initState() {
    context.read<ResourcesBloc>().add(LoadResourcesEvent(rootId: widget.rootId,mediaType: ''));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.rootId);
    print('rootId');
    return Scaffold(
        body: SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: mediaIcons.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 0,top: 10),
                child: Container(
                  padding: const EdgeInsets.only(top: 5,bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue[50]
                  ),
                  child: ListTile(
                      title: Text(mediaTitle[index]),
                      leading: Icon(mediaIcons[index]),trailing: SizedBox(
                    width: context.screenWidth/2.7,
                    child: Row(
                      children: [
                        SizedBox(
                          width: context.screenWidth*0.04,
                        ),
                        IconButton(icon: const Icon(Icons.add),onPressed: () {
                          switch(index){
                            case 0 : {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return  AddImageScreen(rootId:  widget.rootId,whichResources: widget.whichResources,);
                              },));
                            }
                            break;
                            case 1 : {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return  AddVideoScreen(rootId: widget.rootId,whichResources: widget.whichResources,);
                              },));
                            }
                            break;
                            case 2 : {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return  AddAudioScreen(rootId:  widget.rootId,whichResources: widget.whichResources,);
                              },));
                            }
                            break;
                            case 3 : {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return  AddTextScreen(rootId:  widget.rootId, whichResources: widget.whichResources);
                              },));
                            }
                          }
                        },),
                        SizedBox(
                          width: context.screenWidth*0.04,
                        ),
                        IconButton(
                          icon:  Icon(Icons.remove_red_eye),onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            switch(index){
                              case 0: {
                                return  AllResourcesList(rootId:  widget.rootId,mediaType: 'image',);
                              }
                              case 1: {
                                return  AllResourcesList(rootId:  widget.rootId,mediaType: 'video',);

                              }
                              case 2: {
                                return  AllResourcesList(rootId:  widget.rootId,mediaType: 'audio',);

                              }
                              case 3: {
                                return  AllResourcesList(rootId:  widget.rootId,mediaType: 'text',);

                              }
                            }

                            return  AllResourcesList(rootId: widget.rootId,mediaType: 'text',);
                          },
                          ));

                        },),

                        BlocConsumer<ResourcesBloc,ResourcesState>(builder: (context, state) {
                          if(state is ResourcesLoaded){
                            // print(state.allResourcesModel.data!.record!.count!.videoCount.toString());
                            // print('state.allResourcesModel.data!.record!.count!.videoCount.toString()');
                           List<String> count=[];
                           final i =state.allResourcesModel.data!.record!.count!.imageCount.toString();
                           final v =state.allResourcesModel.data!.record!.count!.videoCount.toString();
                           final a =state.allResourcesModel.data!.record!.count!.audioCount.toString();
                           final t =state.allResourcesModel.data!.record!.count!.textCount.toString();
                           count.add(i);
                           count.add(v);
                           count.add(a);
                           count.add(t);


                            return Text(count[index]);
                          }
                          return Text('0');
                        }, listener:  (context, state) {

                        },)
                      ],
                    ),
                  )),
                ),
              );
            },),
        ));
  }
}



/// this for r


class AddResourceScreen2 extends StatelessWidget {
 final int whichResources;
  final String? resourceId;
  AddResourceScreen2({Key? key, required this.whichResources,this.resourceId}) : super(key: key);


  List<String> mediaTitle = [
    'Take Picture',
    'Record Video',
    'Record Audio',
    'Enter Text'
  ];

  List<IconData> mediaIcons = [
    Icons.camera,
    Icons.video_call_outlined,
    Icons.audio_file_outlined,
    Icons.text_increase
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  const Text('Add resources')),
        body: SizedBox(
          //  height: context.screenHeight/2.8,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: mediaIcons.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 0,top: 10),
                child: Container(
                  padding: const EdgeInsets.only(top: 5,bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue[50]
                  ),
                  child: ListTile(
                      title: Text(mediaTitle[index]),
                      leading: Icon(mediaIcons[index]),trailing: SizedBox(
                    width: context.screenWidth/3,
                    child: Row(
                      children: [

                        SizedBox(
                          width: context.screenWidth*0.035,
                        ),
                        IconButton(icon: Icon(Icons.add),onPressed: () {
                          switch(index){
                            case 0 : {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return  AddImageScreen(whichResources: whichResources, rootId: resourceId!,);
                              },));
                            }
                            break;
                            case 1 : {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return  AddVideoScreen(whichResources: whichResources,resourceId: resourceId, rootId: resourceId!,);
                              },));
                            }
                            break;
                            case 2 : {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return AddAudioScreen(whichResources: whichResources,resourceId: resourceId, rootId: resourceId!,);
                              },));
                            }
                            break;
                            case 3 : {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return AddTextScreen(whichResources: whichResources,resourceId: resourceId, rootId: resourceId!,);
                              },));
                            }
                          }
                        },),
                        if(whichResources!=2)
                          SizedBox(
                            width: context.screenWidth*0.035,
                          ),
                        //  IconButton(
                        //   icon:  const Icon(Icons.remove_red_eye),onPressed: () {
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                        //     return  AllResourcesList(rootId: resourceId!,mediaType: '',);
                        //   },));
                        // },)
                      ],
                    ),
                  )),
                ),
              );
            },),
        ));
  }
}


