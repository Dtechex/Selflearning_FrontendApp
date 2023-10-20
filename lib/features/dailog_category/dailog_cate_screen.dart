import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

import '../../utilities/colors.dart';
import '../../widgets/add_prompt_quickAddresourceScreen.dart';
import '../../widgets/add_resources_screen.dart';
import '../create_flow/create_flow_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../resources/maincategory_resources_screen.dart';


class DailogCategoryScreen extends StatefulWidget {
  const DailogCategoryScreen({super.key});

  @override
  State<DailogCategoryScreen> createState() => _DailogCategoryScreenState();
}

class _DailogCategoryScreenState extends State<DailogCategoryScreen> {
  @override

  List<dynamic> mixList = ["amit", 40, 60,"vipin", 30, 20, "abhi","govind" ];
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: SpeedDial(
          animationDuration: Duration(seconds: 500),
          animatedIcon: AnimatedIcons.list_view,
          overlayColor: Colors.transparent,
          elevation: 10,
          curve: Curves.easeInSine,
          animationAngle:0.5,
          shape: CircleBorder(),
          animatedIconTheme: IconThemeData(size: 22.0),
          activeBackgroundColor: Colors.blue,
          overlayOpacity: 0.1,
          spacing: 12,
          spaceBetweenChildren: 12,
          children: [
            SpeedDialChild(
                label: "Add Resource",
                backgroundColor: Colors.green[100],
                child: Icon(Icons.source, color:primaryColor),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return
                      AddResourceScreen(rootId: "widget.rootId",
                          whichResources: 1,
                          categoryName: "widget.categoryName");
                  },
                ));



              }
            ),
            SpeedDialChild(
              label: "Add Prompt",
              backgroundColor: Colors.green[100],
              child: Icon(Icons.add_box, color: primaryColor,),
            ),
            SpeedDialChild(
              label: "create flow",
              backgroundColor: Colors.green[100],
              child: Icon(Icons.file_copy, color: primaryColor,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return CreateFlowScreen(
                        rootId: "widget.rootId!", categoryName: "widget.categoryName",
                      );
                    }));
              }
              ),
            SpeedDialChild(
                label: "select primary flow",
                backgroundColor: Colors.green[100],
                child: Icon(Icons.play_arrow, color:primaryColor),
              onTap: (){

              }
            ),
            SpeedDialChild(
                label: "schedule",
                backgroundColor: Colors.green[100],
                child: Icon(Icons.schedule, color:primaryColor)
            )
          ],
        ),

        appBar: AppBar(
        elevation: 1,
        title: Text("Dailog Category Screen"),

            actions: [
/*
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFlowScreen(rootId: widget.rootId!),));
                },),
*/
              IconButton(
                  onPressed: () {


                  },
                  icon: Icon(Icons.play_circle,size: 30,)
              ),

          SizedBox(width: 10,)

            ]

        ),
      body:
      CustomScrollView(
        slivers: <Widget>[

          SliverToBoxAdapter(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            height: 100, color: Colors.red,
          child: BlurryContainer(
            height: 50,
            color: Colors.white,
            elevation: 5,
            borderRadius: BorderRadius.circular(20),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Search"),
                Icon(Icons.search)
              ],
            ),
          ),

          )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                final item = mixList[index];
                Color iconColor = Colors.transparent; // Provide a default value
                String? leadingText;
                final content ="resource";
                String? title = "new resource";

                if (item is String) {
                  // If the item is a string, display it as a card that navigates to a screen
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the string screen
                      /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return StringScreen(item);
                      }));*/
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      height: 70,
                      child: Card(
                        color: Colors.blue[50],
                        elevation: 1,
                        child: Center(
                          child: ListTile(
                            title: Text('Resource: $item'),
                            leading: GestureDetector(
                              onTap: (){
                                print("popupmenuIcon dailogbox");
                                _showImageDialog(context,content, item.toString() );

                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange[300],
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                child: getFileType(content)=='Photo'
                                    ? CachedNetworkImage(
                                  imageUrl: 'https://selflearning.dtechex.com/public/image/$content',
                                  fit: BoxFit.fitHeight,
                                  height: 35,
                                  width: 35,
                                  progressIndicatorBuilder: (context, url,
                                      downloadProgress) =>
                                      Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )
                                    :getMediaType(content) == 'video'
                                    ? const Icon(Icons.video_camera_back_outlined, size: 35,)
                                    : getMediaType(content) == 'audio'
                                    ? const Icon(Icons.audiotrack, size: 35)
                                    : Text("R", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold ),),
                              ),
                            ),
                            trailing:PopupMenuButton(

                              icon: Icon(Icons.more_vert,color: Colors.red,),
                              itemBuilder: (context) {
                                return [

                                  const PopupMenuItem(
                                      value: 'update',
                                      child: InkWell(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(Icons.update, color: primaryColor,),
                                              SizedBox(width: 8.0,),
                                              Text("Update"),
                                            ],
                                          ))
                                  ),
                                  const PopupMenuItem(
                                      value: 'delete',
                                      child: InkWell(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(Icons.delete, color: primaryColor,),
                                              SizedBox(width: 8.0,),
                                              Text("Delete"),
                                            ],
                                          ))
                                  )
                                ];
                              },
                              onSelected: (String value) {
                                switch(value){
                                  case 'update':
                                  /*  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return UpdateCateScreen(
                                          rootId: state.cateList[index].sId,
                                          selectedColor: currentColor,
                                          categoryTitle: state.cateList[index].name,
                                          tags: state.cateList[index].keywords,
                                        );
                                      },
                                    ));*/
                                    break;
                                  case 'delete':
                                  /*  context.read<CategoryBloc>().add(CategoryDeleteEvent(
                                      rootId: state.cateList[index].sId??'',
                                      context: context,
                                      catList: state.cateList,
                                      deleteIndex: index,
                                    ));*/
                                    break;
                                }
                              },
                            ),

                          ),
                        ),
                      ),
                    ),
                  );
                } else if (item is int) {
                  // If the item is an integer, display it as a card that navigates to a different screen
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the integer screen
                     /* Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return IntScreen(item);
                      }));*/
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      height: 70,
                      child: Card(
                        color: Colors.teal[50],
                        elevation: 1,
                        child: Center(
                          child: ListTile(
                            title: Text('Prompt: $item'),
                            leading: Container(
                              margin: EdgeInsets.symmetric(vertical: 2),
                              alignment: Alignment.center,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Colors.pink[200],
                                borderRadius: BorderRadius.circular(90),
                              ),
                              child: Text("P", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                            trailing:PopupMenuButton(

                              icon: Icon(Icons.more_vert,color: Colors.red,),
                              itemBuilder: (context) {
                                return [

                                  const PopupMenuItem(
                                      value: 'viewprompt',
                                      child: InkWell(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(Icons.update, color: primaryColor,),
                                              SizedBox(width: 8.0,),
                                              Text("View Prompt"),
                                            ],
                                          ))
                                  ),
                                  const PopupMenuItem(
                                      value: 'delete',
                                      child: InkWell(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(Icons.delete, color: primaryColor,),
                                              SizedBox(width: 8.0,),
                                              Text("Delete"),
                                            ],
                                          ))
                                  )
                                ];
                              },
                              onSelected: (String value) {
                                switch(value){
                                  case 'viewprompt':
                                    /*Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return UpdateCateScreen(
                                          rootId: state.cateList[index].sId,
                                          selectedColor: currentColor,
                                          categoryTitle: state.cateList[index].name,
                                          tags: state.cateList[index].keywords,
                                        );
                                      },
                                    ));*/
                                    break;
                                  case 'delete':
                                  /*  context.read<CategoryBloc>().add(CategoryDeleteEvent(
                                      rootId: state.cateList[index].sId??'',
                                      context: context,
                                      catList: state.cateList,
                                      deleteIndex: index,
                                    ));*/
                                    break;
                                }
                              },
                            ),

                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(); // Handle other data types or just skip them
                }
              },
              childCount: mixList.length,
            ),
          ),


        ],


      )
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
