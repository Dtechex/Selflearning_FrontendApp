import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flippy/flipper/dragFlipper.dart';
import 'package:flippy/flippy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio/just_audio.dart' as JA;
import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:self_learning_app/features/create_flow/data/model/flow_model.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/widgets/play_music.dart';
import 'package:video_player/video_player.dart';
import 'package:rxdart/rxdart.dart';

import '../promt/bloc/promt_bloc.dart';
import '../promt/data/model/promt_model.dart';
import '../resources/resources_screen.dart';

class SlideShowScreen extends StatefulWidget {
  final List<FlowDataModel> flowList;


  const SlideShowScreen({Key? key, required this.flowList}) : super(key: key);

  @override
  State<SlideShowScreen> createState() => _SlideShowScreenState();
}

class _SlideShowScreenState extends State<SlideShowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _promtModelLength = 0;
  ChewieController? _chewieController;
  bool _showResource = false;


  FlipperController controller = FlipperController(
    dragAxis: DragAxis.both,
  );

  @override
  void dispose() {
    _pageController.dispose();
    _chewieController?.dispose(); // Dispose the ChewieController
    super.dispose();
  }

  Widget buildSliderIndicator(int index) {
    return Container(
      width: 10,
      height: 10,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == _currentPage ? Colors.blue : Colors.grey,
      ),
    );
  }

  bool isLastPage() {
    return _currentPage == widget.flowList.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    //print("https://selflearning.dtechex.com/public/${widget.mediaType}/${widget.content}");
    return Scaffold(
      appBar: AppBar(title: const Text('Prompts')),
      body: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DragFlipper(
              /// Card 1 front
              front: FrontPageWidget(
                key: GlobalKey(),
                promtModel: widget.flowList,
                index: _currentPage,
                h: h,
                w: w,
                onView2sidePressed : (){
                  controller.flipLeft();
                },
                onNextButtonPressed: () {
                  if (isLastPage()) {
                    // Handle Finish button press
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      _currentPage += 1;
                    });
                  }
                  // Container(
                  //   height: 60,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       _promtModelLength!=0?   ElevatedButton(
                  //         onPressed: () {
                  //           if (isLastPage()) {
                  //             // Handle Finish button press
                  //             Navigator.pushAndRemoveUntil(
                  //               context,
                  //               MaterialPageRoute(builder: (context) {
                  //                 return const DashBoardScreen();
                  //               }),
                  //                   (route) => false,
                  //             );
                  //           } else {
                  //             _pageController.nextPage(
                  //               duration: const Duration(milliseconds: 300),
                  //               curve: Curves.ease,
                  //             );
                  //           }
                  //         },
                  //         child: Text(isLastPage() ? 'Finish' : 'Next'),
                  //       ):const SizedBox()
                  //     ],
                  //   ),
                  // )
                },
                onViewResourcePressed: () {
                  //BlocProvider.of<PromtBloc>(context).add(ViewResourceEvent(showResource: true));
                  controller.flipRight();
                  setState(() {
                    _showResource = true;
                  });
                },
              ), //required
              ///card 2 back
              back: !_showResource? BackPageWidget(
                key: GlobalKey(),
                promtModel: widget.flowList,
                index: _currentPage,
                onView1sidePressed: () {
                  controller.flipLeft();
                },
                h: h,
                w: h,
              ) : BackPage2Widget(
                content: widget.flowList[_currentPage].resourceContent,
                title: widget.flowList[_currentPage].resourceTitle,
                onView1sidePressed: () {
                  controller.flipLeft();
                  setState(() {
                    _showResource = false;
                  }); },
                mediaType: widget.flowList[_currentPage].resourceType,
                h: h,
                w: w,
              ), //required
              controller: controller, //required
              height: context.screenHeight / 2,
              width: context.screenWidth,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

}

class PromtMediaPlayScreen extends StatefulWidget {
  const PromtMediaPlayScreen({Key? key}) : super(key: key);

  @override
  State<PromtMediaPlayScreen> createState() => _PromtMediaPlayScreenState();
}

class _PromtMediaPlayScreenState extends State<PromtMediaPlayScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  // CachedVideoPlayerController? _controller;

  ChewieController? _chewieController;
  @override
  void initState() {
    super.initState();
    // _controller = CachedVideoPlayerController.network(widget.videoUrl)..initialize().then((value) {
    //   _controller!.play();
    //   setState(() {});
    // });
    // setState(() {
    //   _isInitialized = true;
    // });
    final videoPlayerController =
    VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _chewieController!);
  }

  @override
  void dispose() {
    _chewieController!.dispose();
    super.dispose();
  }
}



class FrontPageWidget extends StatefulWidget {

  final List<FlowDataModel> promtModel;
  final int index;
  final Function() onView2sidePressed;
  final double h;
  final double w;
  final Function() onNextButtonPressed;
  final Function() onViewResourcePressed;
  FrontPageWidget({super.key, required this.promtModel, required this.index, required this.h, required this.w, required this.onView2sidePressed, required this.onNextButtonPressed, required this.onViewResourcePressed,});

  @override
  State<FrontPageWidget> createState() => _FrontPageWidgetState();
}

class _FrontPageWidgetState extends State<FrontPageWidget> {
  //ChewieController? _chewieController;
  FlickManager? flickManager;

  AudioPlayer? _audioPlayer;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    print('try');
    if(getMediaType(widget.promtModel![widget.index].side1Content) == 'video'){
      print('try1');
      //_chewieController = _createChewieController('https://selflearning.dtechex.com/public/video/${widget.promtModel![widget.index].side2!.content!}');
      initVideo();
    }else if(getMediaType(widget.promtModel![widget.index].side1Content) == 'audio'){
      print('try2');
      initAudio();
    }else{
      print('try3');
      setState(() {
        _isLoading = false;
      });
    }
    super.initState();
  }
  Future<void> initAudio() async {
    _audioPlayer = AudioPlayer();
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _audioPlayer?.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await _audioPlayer?.setAudioSource(AudioSource.uri(Uri.parse("https://selflearning.dtechex.com/public/audio/${widget.promtModel![widget.index].side1Content}")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
    setState(() { _isLoading = false;});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.grey.shade200,
      margin: EdgeInsets.all(10),
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: SizedBox(
          //height: context.screenHeight / 2,
          child: Column(
            children: [
              Text(
                  widget.promtModel[widget.index].promptName.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19)),
              /*SizedBox(
                width: w,
                //height: h * 0.3,
                child: promtModel![index].side1!.content!.contains("jpg") ||
                    promtModel![index].side1!.content!
                        .contains("png") ||
                    promtModel![index].side1!.content!
                        .contains("jpeg")
                    ? Center(
                  child: CachedNetworkImage(
                    imageUrl:
                    "https://selflearning.dtechex.com/public/image/${promtModel![index].side1!.content}",
                    fit: BoxFit.fill,
                    height: h * 0.2,
                    width: w / 1.5,
                    progressIndicatorBuilder: (context,
                        url,
                        downloadProgress) =>
                        Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress
                                .progress,
                          ),
                        ),
                    errorWidget: (context, url,
                        error) =>
                    const Icon(Icons.error),
                  ),
                )
                    : promtModel![index].side1!.content!.contains("mp3") ||
                    promtModel![index].side1!.content!
                        .contains("wav") ||
                    promtModel![index].side1!.content!
                        .contains("aac") ||
                    promtModel![index]
                        .side1!.content!
                        .contains("ogg")
                    ? AudioPlayerPage(
                  audioUrl:
                  "https://selflearning.dtechex.com/public/audio/${promtModel![index].side1!.content}",
                )
                // : widget.mediaType == 'video'

                    : promtModel![index].side1!.content!.contains("mp4") ||
                    promtModel![index]
                        .side1!.content!
                        .contains("mkv") ||
                    promtModel![index]
                        .side1!.content!
                        .contains("mov") ||
                    promtModel![index]
                        .side1!.content!
                        .contains("avi")
                    ?
                // Chewie(
                //     controller:
                //         _createChewieController(
                //       "https://selflearning.dtechex.com/public/${widget.mediaType}/${state.promtModel![index].side1!.content}",
                //     ),
                //   )
                VideoPlayerWidget(videoUrl: "https://selflearning.dtechex.com/public/video/${promtModel![index].side1!.content}")

                // : Text(state.promtModel![index].side1!.content!),
                    : Text(promtModel![index].side1!.content.toString(), style: TextStyle(fontSize: 16),),
              ),*/
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator(),)
                    : widget.promtModel![widget.index].side1Content.contains("jpg") ||
                    widget.promtModel![widget.index].side1Content.contains("png") ||
                    widget.promtModel![widget.index].side1Content.contains("jpeg")
                    ? Center(child: CachedNetworkImage(
                  imageUrl: "https://selflearning.dtechex.com/public/image/${widget.promtModel![widget.index].side1Content}",
                  fit: BoxFit.fitHeight,
                  height: widget.h * 0.2,
                  width: widget.w / 1.5,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress
                              .progress,
                        ),
                      ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),),)
                    : getMediaType(widget.promtModel![widget.index].side1Content) == 'video'
                    ? Column(
                  children: [
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4.0)
                      ),
                      height: widget.h * 0.2,
                      child: FlickVideoPlayer(
                        flickVideoWithControls: FlickVideoWithControls(
                          videoFit: BoxFit.fitHeight,
                          controls: const FlickPortraitControls(),
                        ),
                        flickManager: flickManager!,
                      ),// Return an empty widget if _chewieController is null
                    ),
                    Spacer(),
                  ],
                )
                    : getMediaType(widget.promtModel![widget.index].side1Content) == 'audio'
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display play/pause button and volume/speed sliders.
                    ControlButtons(_audioPlayer!),
                    StreamBuilder<PositionData>(
                      stream: _positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 24.0),
                          child: ProgressBar(
                            total: positionData?.duration ?? Duration.zero,
                            progress: positionData?.position ?? Duration.zero,
                            buffered: positionData?.bufferedPosition ?? Duration.zero,
                            onSeek: (newPosition) {_audioPlayer?.seek(newPosition);},
                          ),
                        );
                      },
                    ),
                  ],
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Text(widget.promtModel![widget.index].side1Content, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),)),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: context.screenWidth * 0.2,
                    child: TextButton(
                      onPressed: widget.onView2sidePressed,
                      child: Text('View side 2',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white)),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(
                            Colors.blueAccent),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: context.screenWidth * 0.2,
                      child: ElevatedButton(
                          onPressed: widget.onNextButtonPressed,
                          style: const ButtonStyle(
                              backgroundColor:
                              MaterialStatePropertyAll(
                                  Colors
                                      .greenAccent)),
                          child: const Text(
                              "   Next \n Prompt",
                              style: TextStyle(
                                  fontSize: 12)))),
                  SizedBox(
                      width: context.screenWidth * 0.2,
                      child: TextButton(
                          onPressed: widget.onViewResourcePressed,
                          style: const ButtonStyle(
                              backgroundColor:
                              MaterialStatePropertyAll(
                                  Colors
                                      .blueAccent)),
                          child: const Text(
                              "     View\n  resource",
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                  Colors.white)))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer!.positionStream,
          _audioPlayer!.bufferedPositionStream,
          _audioPlayer!.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  ChewieController _createChewieController(String videoUrl) {
    final videoPlayerController = VideoPlayerController.network(videoUrl);
    ChewieController chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
    return chewieController!;
  }

  @override
  void dispose() {
    //_chewieController?.dispose();
    //flickManager?.dispose();
    //_audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> initVideo() async{
    print('https://selflearning.dtechex.com/public/video/${widget.promtModel![widget.index].side1Content}');
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network('https://selflearning.dtechex.com/public/video/${widget.promtModel![widget.index].side1Content}'),
    );
    setState(() { _isLoading = false;});
  }

}


class BackPageWidget extends StatefulWidget {

  final List<FlowDataModel> promtModel;
  final int index;
  final Function() onView1sidePressed;
  final double h;
  final double w;
  const BackPageWidget({super.key, required this.promtModel, required this.index, required this.onView1sidePressed, required this.h, required this.w});

  @override
  State<BackPageWidget> createState() => _BackPageWidgetState();
}

class _BackPageWidgetState extends State<BackPageWidget> {

  //ChewieController? _chewieController;
  FlickManager? flickManager;

  AudioPlayer? _audioPlayer;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    if(getMediaType(widget.promtModel![widget.index].side2Content) == 'video'){
      //_chewieController = _createChewieController('https://selflearning.dtechex.com/public/video/${widget.promtModel![widget.index].side2!.content!}');
      print('This: '+ 'https://selflearning.dtechex.com/public/video/${widget.promtModel![widget.index].side2Content}');
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network('https://selflearning.dtechex.com/public/video/${widget.promtModel![widget.index].side2Content}'),
      );
      setState(() {
        _isLoading = false;
      });
    }else if(getMediaType(widget.promtModel![widget.index].side2Content) == 'audio'){
      _audioPlayer = AudioPlayer();
      initAudio();
    }else{
      setState(() {
        _isLoading = false;
      });
    }
    super.initState();
  }
  Future<void> initAudio() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _audioPlayer?.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await _audioPlayer?.setAudioSource(AudioSource.uri(Uri.parse("https://selflearning.dtechex.com/public/audio/${widget.promtModel![widget.index].side2Content}")));
    } catch (e) {
      print("Error loading audio source: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.grey.shade200,
      margin: EdgeInsets.all(10),
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
                widget.promtModel![widget.index].promptName.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(),)
                  : widget.promtModel![widget.index].side2Content.contains("jpg") ||
                  widget.promtModel![widget.index].side2Content.contains("png") ||
                  widget.promtModel![widget.index].side2Content.contains("jpeg")
                  ? Center(child: CachedNetworkImage(
                imageUrl:
                "https://selflearning.dtechex.com/public/image/${widget.promtModel![widget.index].side2Content}",
                fit: BoxFit.fitHeight,
                height: widget.h * 0.2,
                width: widget.w / 1.5,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress
                            .progress,
                      ),
                    ),
                errorWidget: (context, url, error) => const Icon(Icons.error),),)
                  : getMediaType(widget.promtModel![widget.index].side2Content) == 'video'
                  ? Column(
                children: [
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4.0)
                    ),
                    height: widget.h * 0.2,
                    child: FlickVideoPlayer(
                      flickVideoWithControls: FlickVideoWithControls(
                        videoFit: BoxFit.fitHeight,
                        controls: FlickPortraitControls(),
                      ),
                      flickManager: flickManager!,
                    ),// Return an empty widget if _chewieController is null
                  ),
                  Spacer(),
                ],
              )
                  : getMediaType(widget.promtModel![widget.index].side2Content) == 'audio'
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display play/pause button and volume/speed sliders.
                  ControlButtons(_audioPlayer!),
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 24.0),
                        child: ProgressBar(
                          total: positionData?.duration ?? Duration.zero,
                          progress: positionData?.position ?? Duration.zero,
                          buffered: positionData?.bufferedPosition ?? Duration.zero,
                          onSeek: (newPosition) {_audioPlayer?.seek(newPosition);},
                        ),
                      );
                    },
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text(widget.promtModel![widget.index].side2Content, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: widget.onView1sidePressed,
                    child: Text('View side 1'),
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(
                            Colors.blueAccent))),
              ],
            )
          ],
        ),
      ),
    );
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer!.positionStream,
          _audioPlayer!.bufferedPositionStream,
          _audioPlayer!.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  ChewieController _createChewieController(String videoUrl) {
    final videoPlayerController = VideoPlayerController.network(videoUrl);
    ChewieController chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
    return chewieController!;
  }

  @override
  void dispose() {
    //_chewieController?.dispose();
    //flickManager?.dispose();
    //_audioPlayer?.dispose();
    super.dispose();
  }

}




class BackPage2Widget extends StatefulWidget {

  final String content;
  final Function() onView1sidePressed;
  final double h;
  final double w;
  final String mediaType;
  final String title;

  const BackPage2Widget({super.key, required this.content, required this.onView1sidePressed, required this.mediaType, required this.h, required this.w, required this.title});

  @override
  State<BackPage2Widget> createState() => _BackPage2WidgetState();
}

class _BackPage2WidgetState extends State<BackPage2Widget> {

  ChewieController? _chewieController;
  AudioPlayer? _audioPlayer;




  @override
  void initState() {
    // TODO: implement initState
    if(getMediaType(widget.content) == 'video'){
      _chewieController = _createChewieController('https://selflearning.dtechex.com/public/video/${widget.content}');
    }else if(getMediaType(widget.content) == 'audio'){
      _audioPlayer = AudioPlayer();
      initAudio();
    }
    super.initState();
  }


  Future<void> initAudio() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _audioPlayer?.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await _audioPlayer?.setAudioSource(AudioSource.uri(Uri.parse("https://selflearning.dtechex.com/public/audio/${widget.content}")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.grey.shade200,
      margin: EdgeInsets.all(10),
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: SizedBox(
          //height: context.screenHeight / 2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              if(_chewieController == null) Spacer(),
              widget.content.contains('.jpeg') ||
                  widget.content.contains('.jpg') ||
                  widget.content.contains('.png') ||
                  widget.content.contains('.gif')
                  ? Expanded(child: CachedNetworkImage(
                imageUrl:
                'https://selflearning.dtechex.com/public/image/${widget.content}',
                fit: BoxFit.fitHeight,
                //height: h * 0.,
                //width: 50,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(child: CircularProgressIndicator(value: downloadProgress.progress),),
                errorWidget: (context, url, error) => Icon(Icons.error),),)
                  : getMediaType(widget.content) == 'video'
                  ? Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4.0)
                  ),
                  height: widget.h * 0.3,
                  child: _chewieController != null
                      ? Chewie(controller: _chewieController! ):const SizedBox.shrink(), // Return an empty widget if _chewieController is null
                ),
              )
                  : getMediaType(widget.content) == 'audio'
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display play/pause button and volume/speed sliders.
                  ControlButtons(_audioPlayer!),
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 24.0),
                        child: ProgressBar(
                          total: positionData?.duration ?? Duration.zero,
                          progress: positionData?.position ?? Duration.zero,
                          buffered: positionData?.bufferedPosition ?? Duration.zero,
                          onSeek: (newPosition) {_audioPlayer?.seek(newPosition);},
                        ),
                      );
                    },
                  ),
                ],
              )
                  : Flexible(child: Text(widget.title, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),)),
              if(_chewieController == null) Spacer(),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: widget.onView1sidePressed,
                      child: Text('View Slide'),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStatePropertyAll(
                              Colors.blueAccent))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer!.positionStream,
          _audioPlayer!.bufferedPositionStream,
          _audioPlayer!.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  ChewieController _createChewieController(String videoUrl) {
    final videoPlayerController = VideoPlayerController.network(videoUrl);
    ChewieController chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
    return chewieController!;
  }

  @override
  void dispose() {
    //_chewieController?.dispose();
    //_audioPlayer?.dispose();
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _audioPlayer?.stop();
    }
  }
/*Future<void> _initializeVideoPlayer(String videoPath) async {
    if (_chewieController != null) {
      await  Future.delayed(Duration(milliseconds: 100));
      _chewieController!.dispose();
    }

    final videoPlayerController = VideoPlayerController.contentUri(Uri.parse('https://selflearning.dtechex.com/public/video/$content'));
    await videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      // Other ChewieController configurations...
    );

  }*/
}

class PositionData {
  Duration _position;
  Duration _bufferedPosition;
  Duration _duration;

  PositionData(this._position, this._bufferedPosition, this._duration);

  Duration get duration => _duration;

  Duration get bufferedPosition => _bufferedPosition;

  Duration get position => _position;
}


/// Displays the play/pause button and volume/speed sliders.

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /*IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),*/
        /*Spacer(flex: 2,),
        StreamBuilder<LoopMode>(
          stream: player.loopModeStream,
          builder: (context, snapshot) {
            final loopMode = snapshot.data ?? LoopMode.off;
            const icons = [
              Icon(Icons.repeat, color: Colors.grey),
              Icon(Icons.repeat, color: Colors.orange),
              Icon(Icons.repeat_one, color: Colors.orange),
            ];
            const cycleModes = [
              LoopMode.off,
              LoopMode.all,
              LoopMode.one,
            ];
            final index = cycleModes.indexOf(loopMode);
            return IconButton(
              icon: icons[index],
              onPressed: () {
                player.setLoopMode(cycleModes[
                (cycleModes.indexOf(loopMode) + 1) %
                    cycleModes.length]);
              },
            );
          },
        ),
        Spacer(flex: 1,),

        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        ///
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        Spacer(flex: 1,),
        StreamBuilder<bool>(
          stream: player.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            final shuffleModeEnabled = snapshot.data ?? false;
            return IconButton(
              icon: shuffleModeEnabled
                  ? const Icon(Icons.shuffle, color: Colors.orange)
                  : const Icon(Icons.shuffle, color: Colors.grey),
              onPressed: () async {
                final enable = !shuffleModeEnabled;
                if (enable) {
                  await player.shuffle();
                }
                await player.setShuffleModeEnabled(enable);
              },
            );
          },
        ),
        Spacer(flex: 2,),*/
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          child: StreamBuilder<JA.PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;

              if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 48.0,
                    height: 48.0,
                    child: const CircularProgressIndicator(),
                  ),
                );
              } else if (playing != true) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 40.0,
                  onPressed: player.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 40.0,
                  onPressed: player.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 40.0,
                  onPressed: () => player.seek(Duration.zero,
                      index: player.effectiveIndices!.first),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}