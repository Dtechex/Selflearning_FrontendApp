import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photo_view/photo_view.dart';
import 'package:self_learning_app/features/add_Dailog/dailog_screen.dart';
import 'package:self_learning_app/features/create_flow/slide_show_screen.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:video_player/video_player.dart';

import '../../utilities/colors.dart';
import '../../widgets/add_prompt_quickAddresourceScreen.dart';
import '../../widgets/add_resources_screen.dart';
import '../add_Dailog/createflowfordailog/createDailogFlow.dart';
import '../add_Dailog/dailogPrompt/dailog_prompt.dart';
import '../add_Dailog/model/addDailog_model.dart';
import '../create_flow/create_flow_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../create_flow/data/model/flow_model.dart';
import '../promt/promts_screen.dart';
import '../resources/maincategory_resources_screen.dart';
import 'bloc/add_prompt_res_cubit.dart';

class DailogCategoryScreen extends StatefulWidget {
  String dailogId;
  List<AddResourceListModel> resourceList;
  List<AddPromptListModel> promptList;

  DailogCategoryScreen(
      {super.key, required this.resourceList, required this.promptList, required this.dailogId});

  @override
  State<DailogCategoryScreen> createState() => _DailogCategoryScreenState();
}

class _DailogCategoryScreenState extends State<DailogCategoryScreen> {
  @override
  TextEditingController dailog_create_controller = TextEditingController();

  AwesomeDialog createDailog() {
    return AwesomeDialog(
      context: context,
      headerAnimationLoop: true,
      animType: AnimType.RIGHSLIDE,
      // Set the desired animation type
      // Adjust the animation duration
      dialogType: DialogType.QUESTION,
      customHeader: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blue[100], borderRadius: BorderRadius.circular(90)),
        child: Icon(
          Icons.file_copy, // Change this to the desired icon
          size: 48.0, // Adjust the icon size
          color: Colors.red, // Change the icon color
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Create Flow',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: dailog_create_controller,
              decoration: InputDecoration(
                hintText: 'Dialog Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
              ),
            ),
          )
        ],
      ),
      title: 'This is Ignored',
      desc: 'This is also Ignored',
      btnOkOnPress: () {
        if (dailog_create_controller.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              /// need to set following properties for best effect of awesome_snackbar_content
              elevation: 0,

              duration: Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: "Error",
                message: 'Dailog is not be empty!',

                /// change contentType to ContentType.success, ContentType.warning, or ContentType.help for variants
                contentType: ContentType.failure,
              ),
            ),
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateDailogFlow(
                        reswithPromptList: widget.resourceList,
                        dailog_flow_name: dailog_create_controller.text,
                        defaultDailogPromptlist: widget.promptList,
                      )));
        }
      },
      btnOkColor: Colors.green,
      closeIcon: Icon(Icons.close),
      btnCancelOnPress: () {},
      btnOkText: "Create dailog",
    )..show();
  }

  List<ListItem> itemCheck = [];


  AwesomeDialog successDailog({required String promptName, required String resourceName, required BuildContext context}){
    return AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        dialogType: DialogType.SUCCES,
        body: Center(child: Text(
          '$promptName is successfully added in $resourceName',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),),
        title: 'This is Ignored',
        desc:   'This is also Ignored',


    )..show();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AddPromptResCubit>().getResPrompt(dailogId: widget.dailogId);
  }

  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => AddPromptResCubit(),
  child: BlocListener<AddPromptResCubit, AddPromptResState>(
  listener: (context, state) {
    if(state is AddPromptResSuccess){

        }
  },
  child:Text("")
),
);
  }

  Future<void> _showImageDialog(
      BuildContext context, String content, String title) async {
    FlickManager? _flickManager;
    final audioPlayer = AudioPlayer();
    _flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
          'https://selflearning.dtechex.com/public/video/$content'),
    );

    print("getfilecontent==>${getFileType(content)}");
    print("content$content");
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                        flickManager: _flickManager!,
                      )
                    : getFileType(content) == "Audio"
                        ? Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StreamBuilder<PlaybackEvent>(
                                  stream: audioPlayer.playbackEventStream,
                                  builder: (context, snapshot) {
                                    final processingState =
                                        snapshot.data?.processingState ??
                                            ProcessingState.idle;
                                    final playing = processingState ==
                                        ProcessingState.ready;
                                    final buffering = processingState ==
                                        ProcessingState.buffering;
                                    final audioCompleted = processingState ==
                                        ProcessingState.completed;
                                    bool _isPlaying = false;

                                    // Display different icons based on the processing state
                                    return BlurryContainer(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      color: Colors.white,
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(90),
                                      child: IconButton(
                                        icon: buffering
                                            ? CircularProgressIndicator()
                                            : playing
                                                ? Icon(Icons.pause)
                                                : Icon(Icons.play_arrow),
                                        onPressed: () async {
                                          if (playing) {
                                            audioPlayer.pause();
                                          } else {
                                            audioPlayer.setUrl(
                                                "https://selflearning.dtechex.com/public/audio/$content");
                                            audioPlayer.play();
                                            if (audioCompleted) {
                                              await audioPlayer.seek(
                                                  const Duration(seconds: 0));
                                              await audioPlayer.pause();
                                            }
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                                StreamBuilder<Duration>(
                                  stream: audioPlayer.durationStream.map(
                                      (duration) => duration ?? Duration.zero),
                                  builder: (context, snapshot) {
                                    final duration =
                                        snapshot.data ?? Duration.zero;
                                    return StreamBuilder<Duration>(
                                      stream: audioPlayer.positionStream,
                                      builder: (context, snapshot) {
                                        final position =
                                            snapshot.data ?? Duration.zero;
                                        return Slider(
                                          value: position.inMilliseconds
                                              .toDouble()
                                              .clamp(
                                                  0.0,
                                                  duration.inMilliseconds
                                                      .toDouble()),
                                          min: 0.0,
                                          max: duration.inMilliseconds
                                              .toDouble(),
                                          onChanged: (value) {
                                            final newPosition = Duration(
                                                milliseconds: value.toInt());
                                            audioPlayer.seek(newPosition);
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                                StreamBuilder<Duration>(
                                  stream: audioPlayer.durationStream.map(
                                      (duration) => duration ?? Duration.zero),
                                  builder: (context, snapshot) {
                                    final duration =
                                        snapshot.data ?? Duration.zero;
                                    return Text(
                                      "${formatDuration(duration)}",
                                    );
                                  },
                                ),
                              ],
                            ),
                          ) // Display the title for audio content
                        : Center(
                            child: Container(
                                color: Colors.white,
                                width: double.maxFinite,
                                height: double.maxFinite,
                                child: Center(
                                    child: Text(
                                  title,
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )))), // Display the title for unsupported content
          ),
          actions: <Widget>[
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

class ListItem {
  int index;
  bool isCheck;

  ListItem({required this.index, this.isCheck = false});
}

class BottomSheet extends StatefulWidget {
  String promptId;
  String promptName;
  List<AddResourceListModel> resourceList;

  BottomSheet(
      {super.key,
      required this.promptName,
      required this.resourceList,
      required this.promptId});

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  @override
  List<ListItem> itemCheck = [];
   String resId="";
  String? resourceName;

  Widget build(BuildContext context) {
    return Column(children: [
        SizedBox(
          height: 10,
        ),
        Text(
          "Choose Resource for ${widget.promptName}",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: 20),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.4, // Set the height
          child: ListView.builder(
            itemCount: widget.resourceList.length,
            itemBuilder: (BuildContext context, int index) {
              String firstLetter =
                  widget.resourceList[index].resourceName.substring(0, 1);
              itemCheck.add(ListItem(index: index, isCheck: false));
              return Card(
                color: Colors.blue[50],
                child: ListTile(
                  leading: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: Colors.red[200]),
                      child: Text(
                        firstLetter.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      )),
                  title: Text(widget.resourceList[index].resourceName),
                  trailing: itemCheck[index].isCheck
                      ? Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.red[200],
                              borderRadius: BorderRadius.circular(90)),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ))
                      : null,
                  onTap: () {
                    resId = widget.resourceList[index].resourceId;
                    resourceName = widget.resourceList[index].resourceName;
                    EasyLoading.showToast(resId.toString(),
                        duration: Duration(seconds: 2));
                    setState(() {
                      for (int i = 0; i < itemCheck.length; i++) {
                        if (i == index) {
                          itemCheck[i].isCheck = true;
                        } else {
                          itemCheck[i].isCheck = false;
                        }
                      }
                    });
                    // Define the action when a list item is tapped.
                    // You can add your logic here.
                  },
                ),
              );
            },
          ),
        ),
        Spacer(),
        Container(
            width: MediaQuery.of(context).size.width * 0.98,
            height: 50,
            color: Colors.cyanAccent,
            child: ElevatedButton(
                onPressed: () {
                  print("onpress is $resourceName");
                  if(resId ==""){
                    EasyLoading.showError(duration: Duration(seconds: 2),"please choose resource");

                        }
                  else if(resId != "") {
                    context.read<AddPromptResCubit>().addpromptRes(
                        promptId: widget.promptId,
                        promptName: widget.promptName,
                        resourceId: resId,
                        resourceName: resourceName!,
                        context: context

                    );
                  }
                },
                child: Text("Submit"))),
        SizedBox(
          height: 2,
        )
      ]);
  }
}

class SideSheetDrawer extends StatefulWidget {
  String ResourceName;
  List<PromptListforResourceModel> resPromptList;
   SideSheetDrawer({super.key, required this.resPromptList, required this.ResourceName});

  @override
  State<SideSheetDrawer> createState() => _SideSheetDrawerState();
}

class _SideSheetDrawerState extends State<SideSheetDrawer> {
  List<FlowDataModel> flowList=[];
  void initilizeflowList(){
    for(int index=0; index<widget.resPromptList.length; index++){
      flowList.add(FlowDataModel(resourceTitle: widget.ResourceName, resourceType: "text", resourceContent: "", side1Title: widget.resPromptList[index].promptSide1Content, side1Type: "", side1Content: widget.resPromptList[index].promptSide1Content, side2Title:  widget.resPromptList[index].promptSide2Content, side2Type: "", side2Content: widget.resPromptList[index].promptSide2Content, promptName:  widget.resPromptList[index].promptTitle, promptId:  widget.resPromptList[index].promptId));

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initilizeflowList();
  }
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.deepOrangeAccent[100],
      child: Column(
        children: [
          SizedBox(height: 10,),
          Text(widget.ResourceName,style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),),
          Container(
            color: Colors.deepOrangeAccent[100],
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ReorderableListView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10),
              children: <Widget>[
                for (int index = 0;
                index < flowList.length;
                index += 1)

                  Container(
                    height: 50,
                    key: Key('$index'),
                    color: Colors.green[100],
                    margin: EdgeInsets.only(bottom: 10),



                    child: ListTile(
                      leading: CircleAvatar(
                        maxRadius: 17, backgroundColor: Colors.deepOrangeAccent,
                        foregroundColor: Colors.black,
                        child: Text(
                          extractFirstLetter(flowList[index].promptName),
                          style: TextStyle(fontWeight: FontWeight.bold),)
                        ,),
                      trailing: Icon(Icons.menu),
                      tileColor: index.isOdd ? oddItemColor : evenItemColor,
                      title: Row(
                        children: [
                          Text('${flowList[index].promptName}')
                        ],
                      ),
                    ),
                  ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  //print(state.addFlowModel)
                  FlowDataModel item = flowList.removeAt(oldIndex);
                  flowList.insert(newIndex, item);
/*
                  PromtModel model = state.promtModel!.removeAt(oldIndex);
                  state.promtModel!.insert(newIndex, model);*/
                });
              },
            ),



          ),

          Container(
            width: MediaQuery.of(context).size.width*0.6,
            height: 50,
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SlideShowScreen(flowList: flowList, flowName: "flowName")));

            },
            child: Text("Play prompts")),
          )

        ],
      ),
    );
  }
  String extractFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text.substring(0,1).toUpperCase();
  }
}


