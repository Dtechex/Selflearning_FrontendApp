import 'dart:convert';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photo_view/photo_view.dart';
import 'package:self_learning_app/features/add_media/bloc/add_media_bloc.dart';
import 'package:self_learning_app/features/add_promts/add_promts_screen.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';
import 'package:self_learning_app/features/flow_screen/start_flow_screen.dart';
import 'package:self_learning_app/features/resources/bloc/resources_bloc.dart';
import 'package:self_learning_app/features/resources/subcategory_resources_screen.dart';
import 'package:self_learning_app/features/subcategory/model/resources_model.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';
import '../../utilities/colors.dart';
import '../../utilities/shared_pref.dart';
import '../../widgets/add_resources_screen.dart';
import '../../widgets/play_music.dart';
import '../../widgets/pop_up_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../promt/promts_screen.dart';
import '../subcate1.1/sub_category_1.1_screen.dart';
import '../subcategory/bloc/sub_cate_bloc.dart';
import '../subcategory/bloc/sub_cate_state.dart';

class MaincategoryResourcesList extends StatefulWidget {
  final String rootId;
  final String mediaType;
  final String title;
  final String level;

  const MaincategoryResourcesList(
      {Key? key, required this.rootId, required this.mediaType, required this.title, required this.level})
      : super(key: key);

  @override
  State<MaincategoryResourcesList> createState() => _MaincategoryResourcesListState();
}

class _MaincategoryResourcesListState extends State<MaincategoryResourcesList> {
  final ResourcesBloc resourcesBloc = ResourcesBloc();
  TextEditingController textEditingController = TextEditingController();
  bool _resourcesVisible = true;
  ChewieController? _chewieController;

  bool _isLoading = true;
  String? videoContent;




  @override
  void initState() {
    resourcesBloc.add(LoadResourcesEvent(rootId: widget.rootId, mediaType: widget.mediaType));

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
                content: content, mediaType: mediatype, promtId: promtId, fromType: Prompt.fromResource,);
          },
        ));
      }
      final data = jsonDecode(res.body);
      return data[''];
    } catch (e) {}
  }


  @override
  Widget build(BuildContext context) {
    print("checking category id ${widget.rootId}");

    return BlocProvider(
      create: (context) => resourcesBloc,
      child: Scaffold(

        backgroundColor: const Color(0xFFEEEEEE),
        floatingActionButton: SizedBox(
          height: context.screenHeight * 0.1,
          child: FittedBox(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _resourcesVisible = !_resourcesVisible;
                });
              },
              child: Row(
                children: [
                  Text(
                    _resourcesVisible ? 'Show Subcategories' : 'Show Resources',
                    style: TextStyle(fontSize: 9),
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue,
            title: Text('${widget.title} Resources  (${widget.level})'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _resourcesVisible
                  ? BlocConsumer<ResourcesBloc, ResourcesState>(
                listener: (context, state) {
                  if (state is ResourcesDelete) {
                    context.showSnackBar(const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('Ressource deleted successfully')));
                    resourcesBloc.add(LoadResourcesEvent(rootId: widget.rootId, mediaType: widget.mediaType));
                    //context.read<ResourcesBloc>().add(LoadResourcesEvent(rootId: widget.rootId, mediaType: ''));
                  }
                },
                builder: (context, state) {
                  if (state is ResourcesLoading) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.9,

                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is ResourcesLoaded) {


                    if (state.allResourcesModel.data!.record!.records!.isEmpty) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: const Center(
                          child: Text('No Resources found.'),
                        ),
                      );
                    } else {

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.allResourcesModel.data!.record!.records!.length,
                        itemBuilder: (context, index) {
                          final content = state.allResourcesModel.data!.record!.records![index].content.toString();
                          final title = state.allResourcesModel.data!.record!.records![index].title;
                          final sortedRecords = List.from(state.allResourcesModel.data!.record!.records!);
                          sortedRecords.sort((a, b) => DateTime.parse(a.createdAt).compareTo(DateTime.parse(a.createdAt)));
                          final rNumber = sortedRecords.indexOf(state.allResourcesModel.data!.record!.records![index]) + 1; // Get index of current record in sorted list and add 1 to make it R1, R2, ...

                          return Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 8.0),
                                          GestureDetector(
                                            onTap: () {
                                              print("popupmenuIcon dailogbox");
                                              _showImageDialog(context, content, title.toString());
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12.0),
                                                color: const Color(0xFFF5F5F5),
                                              ),
                                              child: getFileType(content) == 'Photo'
                                                  ? CachedNetworkImage(
                                                imageUrl: 'https://selflearning.dtechex.com/public/image/$content',
                                                fit: BoxFit.fitHeight,
                                                height: 35,
                                                width: 35,
                                                progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                  child: CircularProgressIndicator(value: downloadProgress.progress),
                                                ),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                              )
                                                  : getMediaType(content) == 'video'
                                                  ? const Icon(Icons.video_camera_back_outlined, size: 35,)
                                                  : getMediaType(content) == 'audio'
                                                  ? const Icon(Icons.audiotrack, size: 35)
                                                  : const Icon(Icons.text_format_sharp, size: 35),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                                            child: Text("R$rNumber", // Use rNumber here
                                                style: TextStyle(fontSize: 18.0, letterSpacing: 1, fontWeight: FontWeight.w500)
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                                            child: Text(
                                              (title != null ? '${title.substring(0, 1).toUpperCase()}${title.substring(1)}' : 'Untitled'),
                                              style: TextStyle(fontSize: 18.0, letterSpacing: 1, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton(
                                    icon: Icon(Icons.more_vert,color: Colors.red,),
                                    itemBuilder: (context) {
                                      return [
                                        const PopupMenuItem(
                                            value: 'play',
                                            child: InkWell(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.update, color: primaryColor,),
                                                    SizedBox(width: 8.0,),
                                                    Text("Play prompts"),
                                                  ],
                                                ))
                                        ),

                                        const PopupMenuItem(
                                            value: 'add',
                                            child: InkWell(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.update, color: primaryColor,),
                                                    SizedBox(width: 8.0,),
                                                    Text("Add prompts"),
                                                  ],
                                                ))
                                        ),
                                        const PopupMenuItem(
                                            value: 'remove',
                                            child: InkWell(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.delete, color: primaryColor,),
                                                    SizedBox(width: 8.0,),
                                                    Text("Remove prompts"),
                                                  ],
                                                ))
                                        ),
                                      ];
                                    },
                                    onSelected: (String value) {
                                      switch(value){
                                        case 'play':
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return PromtsScreen(
                                                    content: state.allResourcesModel.data!.record!.records![index].content ?? state.allResourcesModel.data!.record!.records![index].title,
                                                    mediaType: state.allResourcesModel.data!.record!.records![index].type!,
                                                    promtId: state.allResourcesModel.data!.record!.records![index].sId!,
                                                    fromType: Prompt.fromResource,
                                                  );
                                                },
                                              ));
                                          break;
                                        case 'add':
                                          context.push(AddPromptsScreen(
                                            resourceId: state.allResourcesModel.data!.record!.records![index].sId.toString(),
                                            categoryId: widget.rootId,
                                          ));
                                          break;
                                        case 'remove':
                                          resourcesBloc.add(
                                              DeleteResourcesEvent(
                                                  rootId: state.allResourcesModel.data!.record!.records![index].sId.toString()
                                              )
                                          );
                                          break;
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                  return const Text('something went wrong');
                },
              )
                  : BlocBuilder<SubCategoryBloc, SubCategoryState>(
                builder: (context, state) {
                  if (state is SubCategoryLoading) {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: const Center(child: CircularProgressIndicator()));
                  } else if (state is SubCategoryLoaded) {
                    return state.cateList.isEmpty
                        ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: const Center(
                        child: Text(
                          'No Subcategory added',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: state.cateList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async{
                            //   await SharedPref().savesubcateId(state.cateList[index].sId!);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return SubcategoryResourcesList(
                                  //subCateTitle: state.cateList[index].name!,
                                  rootId: state.cateList[index].sId!,
                                  title: state.cateList[index].name!,
                                  mediaType: '',
                                  //color: widget.color,
                                  //keyWords: state.cateList[index].keywords!,
                                );
                              },
                            ));
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Color(int.parse(state
                                            .cateList[index]
                                            .styles![1]
                                            .value!)),
                                        width: 3),
                                    color: Colors.transparent),
                                padding: const EdgeInsets.only(left: 10),
                                child: ListTile(
                                    title: Text(
                                      state.cateList[index].name.toString(),
                                      style: const TextStyle(
                                          color: primaryColor),
                                    )),
                              )),
                        );
                      },
                    );
                  }
                  return const SizedBox(child: Text('Something went wrong'),);
                },
              ),
              SizedBox(height: 120.0,),
            ],
          ),
        )

        ),
      );
  }
  Future<void> _showImageDialog(BuildContext context, String content, String title) async {
    FlickManager? _flickManager;
    final audioPlayer = AudioPlayer();
    _flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network('https://selflearning.dtechex.com/public/video/$content'),
    );

    print("getfilecontent==>${getFileType(content)}");
 print("content$content");
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
          content: Container(
             padding: EdgeInsets.zero,
            width: double.maxFinite,
            height: 300,
            child: getFileType(content) == 'Photo'
                ? PhotoView(
                  imageProvider: NetworkImage(
              "https://selflearning.dtechex.com/public/image/$content",
            ),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,

            )
                : getFileType(content) == 'Video'
                ? FlickVideoPlayer(
              flickVideoWithControls: FlickVideoWithControls(
                videoFit: BoxFit.contain,
                controls: FlickPortraitControls(),
              ),

              flickManager:
              _flickManager!,

            )
                : getFileType(content) == "Audio"
                ?
            Container(
              color: Colors.white,
                  child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  StreamBuilder<PlaybackEvent>(
                    stream: audioPlayer.playbackEventStream,
                    builder: (context, snapshot) {
                      final processingState = snapshot.data?.processingState ?? ProcessingState.idle;
                      final playing = processingState == ProcessingState.ready;
                      final buffering = processingState == ProcessingState.buffering;
                      final audioCompleted = processingState == ProcessingState.completed;
                      bool _isPlaying = false;

                      // Display different icons based on the processing state
                      return BlurryContainer(
                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        color: Colors.white,
                        elevation: 5,
                        borderRadius: BorderRadius.circular(90),

                        child:
                        IconButton(
                          icon: buffering
                              ? CircularProgressIndicator()
                              : playing
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow),
                          onPressed: () async {
                            if (playing) {

                              audioPlayer.pause();
                            } else {
                              audioPlayer.setUrl("https://selflearning.dtechex.com/public/audio/$content");
                              audioPlayer.play();
                              if(audioCompleted){
                                await audioPlayer.seek(const Duration(seconds: 0));
                                await audioPlayer.pause();                            }
                            }
                          },
                        ),
                      );
                    },
                  )  ,
                    StreamBuilder<Duration>(
                  stream: audioPlayer.durationStream.map((duration) => duration ?? Duration.zero),
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;
                      return StreamBuilder<Duration>(
                        stream: audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          return
                            Slider(
                              value: position.inMilliseconds.toDouble().clamp(0.0, duration.inMilliseconds.toDouble()),
                              min: 0.0,
                              max: duration.inMilliseconds.toDouble(),
                              onChanged: (value) {
                                final newPosition = Duration(milliseconds: value.toInt());
                                audioPlayer.seek(newPosition);
                              },
                            );
                        },
                      );
                    },
                  ),
                  StreamBuilder<Duration>(
                    stream: audioPlayer.durationStream.map((duration) => duration ?? Duration.zero),
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;
                      return Text(
                        "${formatDuration(duration)}",
                      );
                    },
                  ),
              ],
            ),
                )// Display the title for audio content
                : Center(child: Container(
              color: Colors.white,
              width: double.maxFinite,
                height: double.maxFinite,
                child: Center(child: Text(title, style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),)))), // Display the title for unsupported content
          ),          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _flickManager?.dispose();

              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

}
String formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
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
