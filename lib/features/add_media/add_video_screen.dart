import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:self_learning_app/features/add_media/bloc/add_media_bloc.dart';

import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/utilities/image_picker_helper.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import '../camera/camera_screen.dart';
import '../promt/promts_screen.dart';
import '../quick_add/data/bloc/quick_add_bloc.dart';
import '../quick_add/quick_add_screen.dart';
import '../resources/bloc/resources_bloc.dart';
import '../resources/resources_screen.dart';

class AddVideoScreen extends StatefulWidget {
  final String rootId;
  final int whichResources;
  final String? resourceId;

  const AddVideoScreen({Key? key, required this.rootId, required this.whichResources, this.resourceId}) : super(key: key);

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

final TextEditingController textEditingController = TextEditingController();

class _AddVideoScreenState extends State<AddVideoScreen> {
  AddMediaBloc addMediaBloc = AddMediaBloc();
  //ChewieController? _chewieController;
  FlickManager? _flickManager;
  //bool _isPlaying = false;

  @override
  void initState() {
    textEditingController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    addMediaBloc.close();
    _flickManager?.dispose();
    //_chewieController?.dispose();
  }

  Future<void> _initializeVideoPlayer(String videoPath) async {
    if (_flickManager != null) {
      await  Future.delayed(Duration(milliseconds: 100));
      _flickManager!.dispose();
    }

    //final videoPlayerController = VideoPlayerController.file(File(videoPath));
    //await videoPlayerController.initialize();

    _flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.file(File(videoPath)),
    );
    /*_chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      // Other ChewieController configurations...
    );*/

    /*setState(() {
      _isPlaying = true;
    });*/
  }


  /*void _togglePlayPause() {
    setState(() {
      //_isPlaying ? _chewieController!.pause() : _chewieController!.play();
      //_isPlaying ? _flickManager.p
      _isPlaying = !_isPlaying;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => addMediaBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Upload Video Resource')),
        body: BlocConsumer<AddMediaBloc, AddMediaInitial>(
          listener: (context, state) {
            if (state.apiState == ApiState.submitted) {
              context.loaderOverlay.hide();
              context.read<ResourcesBloc>().add(LoadResourcesEvent(rootId: widget.rootId, mediaType: ''));

              Navigator.pop(context);
              /*switch (state.wichResources) {
                case 0:
                  {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuickTypeScreen(),
                      ),
                    );
                  }
                  break;
                case 1:
                  {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllResourcesList(rootId: widget.rootId, mediaType: ''),
                      ),
                    );
                  }
                  break;
                case 2:
                  {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PromtsScreen(promtId: widget.rootId),
                      ),
                    );
                  }
                  break;
              }*/
            } else if (state.apiState == ApiState.submitting) {
              context.loaderOverlay.show();
              context.showSnackBar(const SnackBar(duration: Duration(seconds: 1), content: Text('Adding resources...')));
            } else if (state.apiState == ApiState.submitError) {
              context.loaderOverlay.hide();
              context.showSnackBar(const SnackBar(duration: Duration(seconds: 1), content: Text('Something went wrong.')));
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const Spacer(),
                Container(
                  padding: EdgeInsets.all(10),
                  height: context.screenHeight * 0.15,
                  width: context.screenWidth,
                  child: TextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(80),
                    ],
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.red),
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      hintText: 'Enter Title here...',
                      hintStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Container(
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.photo_library),
                                  title: Text('Photo Library'),
                                  onTap: () {
                                    ImagePickerHelper.pickVideo(imageSource: ImageSource.gallery).then((value) {
                                      if (value != null) {
                                        addMediaBloc.add(VideoPickEvent(video: value.path));
                                        _initializeVideoPlayer(value.path);
                                      }
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.camera_alt),
                                  title: Text('Camera'),
                                  onTap: () {
                                    ImagePickerHelper.pickVideo(imageSource: ImageSource.camera).then((value) {
                                      if (value != null) {
                                        addMediaBloc.add(VideoPickEvent(video: value.path));
                                        _initializeVideoPlayer(value.path);
                                      }
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('Choose File'),
                ),
                const Spacer(),

                if(state.selectedFilepath!.isNotEmpty) Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: FlickVideoPlayer(
                    flickVideoWithControls: FlickVideoWithControls(
                      videoFit: BoxFit.fitHeight,
                      controls: FlickPortraitControls(),
                    ),
                    flickManager: _flickManager!,
                  ),
                ),

                /*if(state.selectedFilepath!.isNotEmpty) Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: _chewieController?.videoPlayerController.value.aspectRatio ?? 1.0,
                      child: _chewieController != null
                          ? Chewie(controller: _chewieController!):const SizedBox.shrink(), // Return an empty widget if _chewieController is null
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: _togglePlayPause,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          addMediaBloc.add(RemoveMedia());
                        },
                      ),
                    ),
                  ],
                ),*/
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (state.selectedFilepath!.isEmpty) {
                      context.showSnackBar(const SnackBar(content: Text('Please attach a file'), duration: Duration(seconds: 1)));
                    } else {
                      addMediaBloc.add(
                        SubmitButtonEvent(
                          MediaType: 3,
                          whichResources: widget.whichResources,
                          rootId: widget.rootId,
                          title: textEditingController.text.isEmpty ? 'Untitled' : textEditingController.text,
                        ),
                      );
                    }
                  },
            child: const Text('Upload Resource')),
                const Spacer(flex: 3,),
              ],
            );
          },
        ),
      ),
    );
  }
}
