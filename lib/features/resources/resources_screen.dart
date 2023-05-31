import 'dart:convert';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/add_media/bloc/add_media_bloc.dart';
import 'package:self_learning_app/features/resources/bloc/resources_bloc.dart';
import 'package:self_learning_app/features/subcategory/model/resources_model.dart';
import 'package:self_learning_app/promt/promts_screen.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:mime/mime.dart';
import '../../utilities/shared_pref.dart';
import '../../widgets/add_resources_screen.dart';
import '../../widgets/play_music.dart';
import '../../widgets/pop_up_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class AllResourcesList extends StatefulWidget {
  final String rootId;
  final String mediaType;

  const AllResourcesList({Key? key, required this.rootId,required this.mediaType}) : super(key: key);

  @override
  State<AllResourcesList> createState() => _AllResourcesListState();
}

class _AllResourcesListState extends State<AllResourcesList> {
  final ResourcesBloc resourcesBloc = ResourcesBloc();
  TextEditingController textEditingController= TextEditingController();

  @override
  void initState() {
    resourcesBloc.add(LoadResourcesEvent(rootId: widget.rootId,mediaType: widget.mediaType));
    super.initState();
  }

  static Future<String?> addPrompt({required String resourcesId,required String name,context,promtId}) async {
    print(name);
    print('name');
    print('addpromt');
    try{
      final token = await SharedPref().getToken();
      final res = await http.post(Uri.parse('http://3.110.219.9:8000/web/prompt/'),body: {
        "name" : name,
        "resourceId": promtId
      },headers: {
        'Authorization': "Bearer $token"
      });
      print(res.statusCode);
      print(res.statusCode);
     // final response =jsonDecode(res.body);
     // print(response.body);
      if(res.statusCode==200 ||res.statusCode==201){
        Navigator.pop(context);
        // Navigator.push(context, MaterialPageRoute(
        //   builder: (context) {
        //     return PromtsScreen(
        //         promtId: promtId);
        //   },
        // ));
      }
      final data=jsonDecode(res.body);
      return data[''];

    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => resourcesBloc,
      child: Scaffold(
        appBar: AppBar(title: Text('Resources')),
        body: BlocConsumer<ResourcesBloc, ResourcesState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ResourcesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ResourcesLoaded) {
              if (state.allResourcesModel.data!.record!.records!.isEmpty) {
                return const Center(
                  child: Text('No Resources found.'),
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        state.allResourcesModel.data!.record!.records!.length,
                    itemBuilder: (context, index) {
                      final content = state.allResourcesModel.data!.record!
                          .records![index].content
                          .toString();
                      print(content);
                      print('content');

                      return SizedBox(
                        width: context.screenWidth,
                        height: 60,
                        child: ListTile(
                            trailing: ElevatedButton(
                              child: Text('View Prompts'),
                              onPressed: () {
                                print(state.allResourcesModel.data!.record!.records![index].content);

                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return PromtsScreen(
                                      content: state.allResourcesModel.data!.record!.records![index].content??state.allResourcesModel.data!.record!.records![index].title,
                                      mediaType: state.allResourcesModel.data!.record!.records![index].type!,
                                        promtId: state.allResourcesModel.data!
                                            .record!.records![index].sId!);
                                  },
                                ));
                              },
                            ),
                            leading: content.contains('.jpeg') ||
                                    content.contains('.jpg') ||
                                    content.contains('.png') ||
                                    content.contains('.gif')
                                ? CachedNetworkImage(
                                    imageUrl:
                                        'http://3.110.219.9:8000/public/image/$content',
                                    fit: BoxFit.fill,
                                    height: 40,
                                    width: 50,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                : SizedBox(
                                    width: 50,
                                    child: getMediaType(content) == 'video'
                                        ? const Icon(
                                            Icons.video_camera_back_outlined,
                                            size: 50,
                                          )
                                        : getMediaType(content) !='audio'
                                            ? const Icon(Icons.text_format_sharp,
                                                size: 50)
                                            : Icon(Icons.audiotrack, size: 50)),
                            title: ElevatedButton(
                              child: const Text('Add Promt'),
                              onPressed: () {
                                print(state.allResourcesModel.data!.record!
                                    .records![index].sId);
                                context.showNewDialog(AlertDialog(
                                  title: Text('Add Question'),
                                  content: TextField(
                                    controller: textEditingController,
                                    decoration: InputDecoration(hintText: 'Enter your question'),
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text('Add'),
                                      onPressed: () {
                                        String question = textEditingController.text;
                                        // You can handle the entered question here, e.g., add it to a list
                                        // or perform any other required operation.
                                        print('Entered question: $question');
                                        print(textEditingController.text);
                                        Navigator.of(context).pop();
                                        addPrompt(name: textEditingController.text,context: context,promtId: state.allResourcesModel.data!.record!.records![index].sId, resourcesId: state.allResourcesModel.data!.record!.records![index].iV.toString());

                                      },
                                    ),
                                  ],
                                ));
                               //  Navigator.push(context, MaterialPageRoute(builder: (context) {
                               // return   AddQuestionDialog();
                               //  },));
                              },
                            )),
                      );
                    });
              }
            }
            return const Text('someth9ng went wrong');
          },
        ),
      ),
    );
  }
}

String getMediaType(String filePath) {
  final mimeType = lookupMimeType(filePath);

  if (mimeType != null) {
    if (mimeType.startsWith('image/')) {
      return 'image';
    } else if (mimeType.startsWith('audio/')) {
      return 'audio';
    } else if (mimeType.startsWith('video/')) {
      return 'video';
    }
  }

  return 'unknown';
}
