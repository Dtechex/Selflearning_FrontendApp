import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';
import 'package:self_learning_app/promt/bloc/promt_bloc.dart';
import 'package:self_learning_app/widgets/play_music.dart';

import '../widgets/video_from_url.dart';

class PromtsScreen extends StatefulWidget {
  final String? mediaType;
  final String promtId;
  final String? content;
  const PromtsScreen(
      {Key? key, required this.promtId, this.mediaType, this.content})
      : super(key: key);

  @override
  State<PromtsScreen> createState() => _PromtsScreenState();
}

class _PromtsScreenState extends State<PromtsScreen> {
  final PromtBloc promtBloc = PromtBloc();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _promtModelLength = 0;

  @override
  void initState() {
    promtBloc.add(LoadPromtEvent(promtId: widget.promtId));
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
    print(
        "http://3.110.219.9:8000/public/${widget.mediaType}/${widget.content}");
    return BlocProvider(
      create: (context) => promtBloc,
      child: Scaffold(
        appBar: AppBar(title: Text('Promts')),
        body: Scaffold(
          bottomSheet: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //  SizedBox(width: 30,),
                ElevatedButton(
                  onPressed: () {
                    if (isLastPage()) {
                      // Handle Finish button press
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) {
                          return const DashBoardScreen();
                        },
                      ), (route) => false);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text(isLastPage() ? 'Finish' : 'Next'),
                ),
                //  SizedBox(width: 30,),
              ],
            ),
          ),
          body: BlocConsumer<PromtBloc, PromtState>(
            listener: (context, state) {},
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
                if (state.promtModel.isEmpty) {
                  return const Center(
                    child: Text('No promts found'),
                  );
                } else {
                  _promtModelLength = state.promtModel.length;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(padding: EdgeInsets.only(left: 30,top: 30),child:  Align(
                      //   alignment: Alignment.topLeft,
                      //   child:  FloatingActionButton(onPressed: () {
                      //
                      //   },child: Text(_currentPage.toString()),),),),
                    SizedBox(
                      width: w,
                      height: h*0.3,
                      child:  widget.mediaType == 'image'
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
                                value: downloadProgress.progress),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                    )
                        : widget.mediaType == 'audio'
                        ? AudioPlayerPage(
                        audioUrl:
                        "http://3.110.219.9:8000/public/${widget.mediaType}/${widget.content}")
                        : widget.mediaType == 'video'
                        ? VideoPlayerScreen(
                        videoUrl:
                        "http://3.110.219.9:8000/public/${widget.mediaType}/${widget.content}")
                        : Text(widget.content.toString()),),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _promtModelLength,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Center(
                                child: Text(
                                    state.promtModel[index].name.toString()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_promtModelLength, (index) {
                            return buildSliderIndicator(index);
                          }),
                        ),
                      ),
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
