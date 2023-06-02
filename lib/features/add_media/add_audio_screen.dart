import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import '../../promt/promts_screen.dart';
import '../../utilities/image_picker_helper.dart';
import '../quick_add/quick_add_screen.dart';
import 'package:flutter/material.dart';

import '../resources/resources_screen.dart';
import 'bloc/add_media_bloc.dart';

class AddAudioScreen extends StatefulWidget {
  final int whichResources;
  final String rootId;
  final String? resourceId;
  const AddAudioScreen({Key? key, required this.rootId,this.resourceId,required this.whichResources}) : super(key: key);

  @override
  State<AddAudioScreen> createState() => _AddAudioScreenState();
}

final TextEditingController textEditingController = TextEditingController();

class _AddAudioScreenState extends State<AddAudioScreen> {
  AddMediaBloc addMediaBloc = AddMediaBloc();
  AudioPlayer audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    super.dispose();

    audioPlayer.dispose();
    addMediaBloc.close();
  }

  Future<void> _togglePlayPause(String audioPath) async {
    if (_isPlaying) {
      await audioPlayer.pause();
    } else {
      if (audioPlayer.playerState.processingState ==
          ProcessingState.completed) {
        await audioPlayer.seek(Duration.zero);
      }
      await audioPlayer.setFilePath(audioPath);
      await audioPlayer.play();
    }
  }

  void _playerStateChanged() {
    audioPlayer.playerStateStream.listen((playerState) {
      setState(() {
        _isPlaying = playerState.playing;
      });
    });
  }



  @override
  void initState() {
    textEditingController.text='';
    super.initState();
    _playerStateChanged();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => addMediaBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Audio')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: BlocConsumer<AddMediaBloc, AddMediaInitial>(
            listener: (context, state) {
              if (state.apiState==ApiState.submitted ) {
                context.loaderOverlay.hide();
                switch(state.wichResources){
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
                }
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
                    padding: const EdgeInsets.all(10),
                    height: context.screenHeight * 0.15,
                    width: context.screenWidth,
                    child: TextFormField(
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
                            Icon(
                              Icons.audiotrack_outlined,
                              size: context.screenWidth / 2.5,
                            ),
                            const Text('Upload'),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      ImagePickerHelper.pickFile().then((value) {
                        if (value != null) {
                          addMediaBloc.add(AudioPickEvent(audio: value));
                          _togglePlayPause(value);
                        }
                      });
                    },
                  )
                      : Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: context.screenHeight * 0.24,
                        width: context.screenWidth,
                        child: IconButton(
                          icon: Icon(_isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                          onPressed: () {
                            _togglePlayPause(state.selectedFilepath!);
                          },
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            audioPlayer.stop();
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
                      if(state.selectedFilepath!.isEmpty){
                        context.showSnackBar(const SnackBar(content: Text('Please attach file'),duration: Duration(seconds: 1),));

                      }else {
                        addMediaBloc.add(
                          SubmitButtonEvent(
                            MediaType: 2,
                            //resourcesId: widget.resourceId,
                            rootId: widget.rootId,
                            whichResources: widget.whichResources,
                            title: textEditingController.text.isEmpty
                                ? 'Untitled'
                                : textEditingController.text,
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
