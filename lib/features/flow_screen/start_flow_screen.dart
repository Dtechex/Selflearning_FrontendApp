import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flippy/flipper/dragFlipper.dart';
import 'package:flippy/flippy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';
import 'package:self_learning_app/promt/bloc/promt_bloc.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/widgets/play_music.dart';
import 'package:video_player/video_player.dart';

class StartFlowScreen extends StatefulWidget {
  final String? mediaType;
  final String promtId;
  final String? content;

  const StartFlowScreen({Key? key, required this.promtId, this.mediaType, this.content})
      : super(key: key);

  @override
  State<StartFlowScreen> createState() => _StartFlowScreenState();
}

class _StartFlowScreenState extends State<StartFlowScreen> {
  final PromtBloc promtBloc = PromtBloc();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _promtModelLength = 0;
  ChewieController? _chewieController;

  @override
  void initState() {
    promtBloc.add(LoadPromtEvent(promtId: widget.promtId));
    super.initState();
  }

  FlipperController controller= FlipperController(
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
    return _currentPage == _promtModelLength - 1;
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    print("http://3.110.219.9:8000/public/${widget.mediaType}/${widget.content}");
    return BlocProvider(
      create: (context) => promtBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Prompts')),
        body: Scaffold(
          body: BlocConsumer<PromtBloc, PromtState>(
            listener: (context, state) {
              if(state is  PromtLoaded){
                setState(() {
                  _promtModelLength= state.promtModel!.length;
                });
              }
            },
            builder: (context, state) {
              print(state);
              if (state is PromtLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PromtError) {
                return Center(
                  child: Text(state.error!),
                );
              } else if (state is PromtLoaded) {
                if (state.promtModel!.isEmpty) {
                  return const Center(
                    child: Text('No prompts found'),
                  );
                } else {
                  _promtModelLength = state.promtModel!.length;
                  return
                    Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DragFlipper(

                        /// Card 1 front
                        front:  Card(
                          margin: EdgeInsets.all(10),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            child:  SizedBox(
                              height: context.screenHeight/2,
                              child: PageView.builder(

                                allowImplicitScrolling: false,
                                controller: _pageController,
                                itemCount: _promtModelLength,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Text(state.promtModel![index].name.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19)),
                                      SizedBox(
                                        width: w,
                                        height: h * 0.3,
                                        child: state.promtModel![index].side1!.content == 'image'
                                            ? Center(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            "http://3.110.219.9:8000/public/image/${widget.content}",
                                            fit: BoxFit.fill,
                                            height: h * 0.2,
                                            width: w / 1.5,
                                            progressIndicatorBuilder:
                                                (context, url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                  value: downloadProgress.progress,
                                                ),
                                            errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                          ),
                                        )
                                            : state.promtModel![index].side1!.content == 'audio'
                                            ? AudioPlayerPage(
                                          audioUrl:
                                          "http://3.110.219.9:8000/public/${widget.mediaType}/${state.promtModel![index].side1!.content}",
                                        )
                                            : widget.mediaType == 'video'
                                            ? Chewie(
                                          controller: _createChewieController(
                                            "http://3.110.219.9:8000/public/${widget.mediaType}/${state.promtModel![index].side1!.content}",
                                          ),
                                        )
                                            : Text(state.promtModel![index].side1!.content!),
                                      ),
                                      Row(

                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [
                                          SizedBox(
                                              width: context.screenWidth*0.2,
                                              child: TextButton(


                                                  onPressed: () {
                                                    controller.flipLeft();
                                                  } , child: Text('View side 2',style: TextStyle(
                                                  fontSize: 12,color: Colors.white
                                              )),style: ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll(Colors.blueAccent)
                                              ))),
                                          SizedBox(
                                            width:context.screenWidth*0.2,
                                              child: ElevatedButton(

                                              onPressed: () {
                                                if (isLastPage()) {
                                                  // Handle Finish button press
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(builder: (context) {
                                                      return const DashBoardScreen();
                                                    }),
                                                        (route) => false,
                                                  );
                                                } else {
                                                  _pageController.nextPage(
                                                    duration: const Duration(milliseconds: 300),
                                                    curve: Curves.ease,
                                                  );
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
                                              } ,style: const ButtonStyle(
                                              backgroundColor: MaterialStatePropertyAll(Colors.greenAccent)
                                          ), child: const Text("   Next \n Prompt",style: TextStyle(
                                              fontSize: 12
                                          )))),
                                          SizedBox(
                                              width: context.screenWidth*0.2,
                                              child: TextButton(


                                            onPressed: () {
                                              promtBloc.add(ViewResourceEvent(showResource: true));
                                              controller.flipRight();
                                            } ,style: const ButtonStyle(
                                              backgroundColor: MaterialStatePropertyAll(Colors.blueAccent)
                                          ), child: const Text("     View\n  resource",style: TextStyle(
                                              fontSize: 12,color: Colors.white
                                          )))),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),

                          ),
                        ), //required
       ///card 2 back
                        back: Card(
                          margin: EdgeInsets.all(10),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            child:  SizedBox(
                              height: context.screenHeight/2,
                              child: PageView.builder(

                                allowImplicitScrolling: false,
                                controller: _pageController,
                                itemCount: _promtModelLength,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Text(state.promtModel![index].name.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19)),
                                      SizedBox(
                                        width: w,
                                        height: h * 0.3,
                                        child: state.promtModel![index].side2!.content == 'image'
                                            ? Center(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            "http://3.110.219.9:8000/public/image/${state.promtModel![index].side2!.content}",
                                            fit: BoxFit.fill,
                                            height: h * 0.2,
                                            width: w / 1.5,
                                            progressIndicatorBuilder:
                                                (context, url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                  value: downloadProgress.progress,
                                                ),
                                            errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                          ),
                                        )
                                            : widget.mediaType == 'audio'
                                            ? AudioPlayerPage(
                                          audioUrl:
                                          "http://3.110.219.9:8000/public/${widget.mediaType}/${state.promtModel![index].side2!.content}",
                                        )
                                            : widget.mediaType == 'video'
                                            ? Chewie(
                                          controller: _createChewieController(
                                            "http://3.110.219.9:8000/public/${widget.mediaType}/${state.promtModel![index].side2!.content}",
                                          ),
                                        )
                                            : Text(state.promtModel![index].side2!.content!),
                                      ),
                                      Row(

                                        mainAxisAlignment: MainAxisAlignment.center,

                                        children: [
                                          ElevatedButton(onPressed: () {
                                            controller.flipLeft();
                                          } , child: Text('View side 1'),style: ButtonStyle(
                                              backgroundColor: MaterialStatePropertyAll(Colors.blueAccent)
                                          )),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),

                          ),
                        ),  //required
                        controller: controller,  //required
                        height: context.screenHeight/2,
                        width: context.screenWidth,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        backgroundColor: Colors.white,
                      )
                      ,

                    ],
                  );
                }
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  ChewieController _createChewieController(String videoUrl) {
    final videoPlayerController = VideoPlayerController.network(videoUrl);
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
    return _chewieController!;
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
