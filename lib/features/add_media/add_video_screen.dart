import 'dart:io';

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
  ChewieController? _chewieController;
  bool _isPlaying = false;

  @override
  void initState() {
    textEditingController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    addMediaBloc.close();
    _chewieController?.dispose();
  }

  Future<void> _initializeVideoPlayer(String videoPath) async {
    if (_chewieController != null) {
      await  Future.delayed(Duration(milliseconds: 100));
      _chewieController!.dispose();
    }

    final videoPlayerController = VideoPlayerController.file(File(videoPath));
    await videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      // Other ChewieController configurations...
    );

    setState(() {
      _isPlaying = true;
    });
  }


  void _togglePlayPause() {
    setState(() {
      _isPlaying ? _chewieController!.pause() : _chewieController!.play();
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => addMediaBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Video')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: BlocConsumer<AddMediaBloc, AddMediaInitial>(
            listener: (context, state) {
              if (state.apiState == ApiState.submitted) {
                context.loaderOverlay.hide();
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
                  Container(
                    padding: const EdgeInsets.all(10),
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
                  state.selectedFilepath!.isEmpty
                      ? GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: context.screenHeight * 0.24,
                      width: context.screenWidth,
                      child: Center(
                        child: Row(
                          children: [
                            Icon(Icons.video_call_outlined, size: context.screenWidth / 2.5),
                            const Text('Upload'),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
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
                  )
                      : Stack(
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
                  ),
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
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
