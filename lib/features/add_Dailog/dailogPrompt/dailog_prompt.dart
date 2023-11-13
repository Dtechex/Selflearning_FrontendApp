import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flippy/constants/parameters.dart';
import 'package:flippy/controllers/flipperController.dart';
import 'package:flippy/flipper/dragFlipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:video_player/video_player.dart';

import '../../create_flow/slide_show_screen.dart';
import '../../resources/maincategory_resources_screen.dart';
import 'package:rxdart/rxdart.dart';



class DailogPrompt extends StatefulWidget {

  String promptTitle;
  String side1contentTitle;
  String side2contentTitle;
  String side1type, side2type;

  DailogPrompt({Key? key, required this.promptTitle,
    required this.side1contentTitle,
    required this.side2contentTitle,
    required this.side1type,
    required this.side2type
  }) : super(key: key);

  @override
  State<DailogPrompt> createState() => _DailogPromptState();
}

class _DailogPromptState extends State<DailogPrompt> {
  late FlipperController controller;
  FlickManager? flickManager;


  @override
  void initState() {
    controller = FlipperController(
      dragAxis: DragAxis.both,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flippy Example"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DragFlipper(
              front:  FrontWidget(title:widget.promptTitle, side1Content: widget.side1contentTitle,side1Type: widget.side1type, ),
              back:  BackWidget(side2Title: widget.side2contentTitle),
              controller: controller,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              gradient: const LinearGradient(colors: [
                Color(0xffD2E0FB),
                Color(0xffD0E7D2),
              ]),
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              height: 210,
            ),

          ],
        ),
      ),
    );
  }
}

class FrontWidget extends StatefulWidget {
  String title;
  String side1Content;
  String side1Type;
   FrontWidget({Key? key, required this.title, required this.side1Content, required this.side1Type}) : super(key: key);

  @override
  State<FrontWidget> createState() => _FrontWidgetState();
}

class _FrontWidgetState extends State<FrontWidget> {
  bool _isLoading = true;
   FlickManager? flickManager;
  AudioPlayer _audioPlayer = AudioPlayer();

  void initState() {
    // TODO: implement initState
    print('try');
    if(getMediaType(widget.side1Type) == 'video'){
      print('try1');
      //_chewieController = _createChewieController('https://selflearning.dtechex.com/public/video/${widget.promtModel![widget.index].side2!.content!}');
      initVideo();
    }else if(getMediaType(widget.side1Type) == 'audio'){
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
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _audioPlayer?.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      print("audio me try bloc");
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await _audioPlayer?.setAudioSource(AudioSource.uri(Uri.parse("https://selflearning.dtechex.com/public/audio/${widget.side1Content}")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
    if(mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> initVideo() async{
    print('https://selflearning.dtechex.com/public/video/${widget.side1Content}');
     flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network('https://selflearning.dtechex.com/public/video/${widget.side1Content}'),
    );
    setState(() { _isLoading = false;});
  }

  @override
  Widget build(BuildContext context) {
    if(widget.side1Type=="audio"){
      initAudio();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 24, color: Colors.red,fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: _isLoading?
            Center(child: CircularProgressIndicator(),):
                widget.side1Content.contains("jpg")||
                    widget.side1Content.contains("png")||
                    widget.side1Content.contains("jpeg")
            ?Center(
                  child: CachedNetworkImage(imageUrl: "https://selflearning.dtechex.com/public/image/${widget.side1Content}",
                    fit: BoxFit.fitHeight,
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width/ 1.5,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress
                                .progress,
                          ),
                        ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),)
                )
                    : widget.side1Type == 'video'
                    ? Column(
                  children: [
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4.0)
                      ),
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: FlickVideoPlayer(
                        flickVideoWithControls: FlickVideoWithControls(
                          videoFit: BoxFit.fitHeight,
                          controls: FlickPortraitControls(),
                        ),
                        flickManager: FlickManager(
                          videoPlayerController: VideoPlayerController.network('https://selflearning.dtechex.com/public/video/${widget.side1Content}'),
                        ),
                      ),// Return an empty widget if _chewieController is null
                    ),
                    Spacer(),
                  ],
                )
                    : widget.side1Type == 'audio'
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
                    Flexible(child: Text(widget.side1Content, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),)),
                  ],
                ),



          ),
        ],
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

}

class BackWidget extends StatelessWidget {
  String side2Title;
   BackWidget({Key? key, required this.side2Title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        side2Title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );

  }
}