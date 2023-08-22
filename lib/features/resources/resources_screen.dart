import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/add_media/bloc/add_media_bloc.dart';
import 'package:self_learning_app/features/add_promts/add_promts_screen.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';
import 'package:self_learning_app/features/flow_screen/start_flow_screen.dart';
import 'package:self_learning_app/features/resources/bloc/resources_bloc.dart';
import 'package:self_learning_app/features/subcategory/model/resources_model.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:mime/mime.dart';
import '../../utilities/shared_pref.dart';
import '../../widgets/add_resources_screen.dart';
import '../../widgets/play_music.dart';
import '../../widgets/pop_up_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../promt/promts_screen.dart';

class AllResourcesList extends StatefulWidget {
  final String rootId;
  final String mediaType;

  const AllResourcesList(
      {Key? key, required this.rootId, required this.mediaType})
      : super(key: key);

  @override
  State<AllResourcesList> createState() => _AllResourcesListState();
}

class _AllResourcesListState extends State<AllResourcesList> {
  final ResourcesBloc resourcesBloc = ResourcesBloc();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    resourcesBloc.add(
        LoadResourcesEvent(rootId: widget.rootId, mediaType: widget.mediaType));
    super.initState();
  }

  static Future<String?> addPrompt(
      {required String resourcesId,
      required String name,
      context,
      promtId,
      required String mediatype,
      required String content}) async {
    print(name);
    print('name');
    print('addpromt');
    try {
      final token = await SharedPref().getToken();
      final res = await http.post(
          Uri.parse('https://selflearning.dtechex.com/web/prompt/'),
          body: {"name": name, "resourceId": promtId},
          headers: {'Authorization': "Bearer $token"});

      if (res.statusCode == 200 || res.statusCode == 201) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return PromtsScreen(
                content: content, mediaType: mediatype, promtId: promtId);
          },
        ));
      }
      final data = jsonDecode(res.body);
      return data[''];
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => resourcesBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Resources')),
        body: BlocConsumer<ResourcesBloc, ResourcesState>(
          listener: (context, state) {
            if (state is ResourcesDelete) {
              context.showSnackBar(const SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Ressource deleted successfully')));
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) {
                  return const DashBoardScreen();
                },
              ), (route) => false);
            }
          },
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
                    itemCount: state.allResourcesModel.data!.record!.records!.length,
                    itemBuilder: (context, index) {
                      final content = state.allResourcesModel.data!.record!
                          .records![index].content
                          .toString();
                      print(content);
                      print('content');

                      return SizedBox(
                        width: context.screenWidth,
                        height: 60,
                        child: Row(
                          children: [

                            Spacer(),
                            content.contains('.jpeg') ||
                                content.contains('.jpg') ||
                                content.contains('.png') ||
                                content.contains('.gif')
                                ? CachedNetworkImage(
                              imageUrl:
                              'https://selflearning.dtechex.com/public/image/$content',
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
                                    : getMediaType(content) != 'audio'
                                    ? const Icon(
                                    Icons.text_format_sharp,
                                    size: 50)
                                    : Icon(Icons.audiotrack, size: 50)),
                            Spacer(),
                            ElevatedButton(
                              child: const Text('Add'),
                              onPressed: () {
                                context.push(AddPromptsScreen(
                                  resourceId: state.allResourcesModel.data!
                                      .record!.records![index].sId
                                      .toString(),
                                ));
                              },
                            ),
                            SizedBox(width: 5.0,),
                            ElevatedButton(
                              child: const Text('Start Flow'),
                              onPressed: () {
                                print(state.allResourcesModel.data!
                                    .record!.records![index].content);

                                Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return PromtsScreen(
                                            content: state
                                                .allResourcesModel
                                                .data!
                                                .record!
                                                .records![index]
                                                .content ??
                                                state
                                                    .allResourcesModel
                                                    .data!
                                                    .record!
                                                    .records![index]
                                                    .title,
                                            mediaType: state
                                                .allResourcesModel
                                                .data!
                                                .record!
                                                .records![index]
                                                .type!,
                                            promtId: state
                                                .allResourcesModel
                                                .data!
                                                .record!
                                                .records![index]
                                                .sId!);
                                      },
                                    ));
                              },
                            ),
                            /*SizedBox(width: 5.0,),
                            ElevatedButton(
                              child: const Text('Start'),
                              onPressed: () {
                                print(state.allResourcesModel.data!
                                    .record!.records![index].content);

                                Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return StartFlowScreen(
                                            content: state
                                                .allResourcesModel
                                                .data!
                                                .record!
                                                .records![index]
                                                .content ??
                                                state
                                                    .allResourcesModel
                                                    .data!
                                                    .record!
                                                    .records![index]
                                                    .title,
                                            mediaType: state
                                                .allResourcesModel
                                                .data!
                                                .record!
                                                .records![index]
                                                .type!,
                                            promtId: state
                                                .allResourcesModel
                                                .data!
                                                .record!
                                                .records![index]
                                                .sId!);
                                      },
                                    ));
                              },
                            ),*/
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  resourcesBloc.add(
                                      DeleteResourcesEvent(
                                          rootId: state
                                              .allResourcesModel
                                              .data!
                                              .record!
                                              .records![index]
                                              .sId
                                              .toString()));
                                },
                                icon: const Icon(Icons.delete)),
                            Spacer(),
                          ],
                        ),
                      );
                    });
              }
            }
            return const Text('something went wrong');
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
