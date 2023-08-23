import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/promt/data/model/promt_model.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../flow_screen/start_flow_screen.dart';
import 'bloc/promt_bloc.dart';
import 'data/model/flow_model.dart';

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
  //final PromtBloc promtBloc = PromtBloc();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _promtModelLength = 0;
  ChewieController? _chewieController;

  late final ColorScheme colorScheme;

  @override
  void initState() {
    BlocProvider.of<PromtBloc>(context).add(LoadPromtEvent(promtId: widget.promtId));
    super.initState();
  }

  final List<int> _items = List<int>.generate(50, (int index) => index);

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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    print('Vipin');
    print(
        "https://selflearning.dtechex.com/public/${widget.mediaType}/${widget.content}");
    return Scaffold(
      appBar: AppBar(title: const Text('Prompts')),
      body: Scaffold(
        body: BlocConsumer<PromtBloc, PromtState>(
          listener: (context, state) {
            if (state is PromtLoaded) {
              if (state.apiState == ApiState.Success) {
                Navigator.pop(context);
                context.showSnackBar(SnackBar(content: Text('Flow added')));
              }
            }
          },
          builder: (context, state) {
            if (state is PromtLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PromtError) {
              return Center(
                child: Text(state.error!),
              );
            } else if (state is PromtLoaded) {
              if (state.addFlowModel!.flow!.isEmpty) {
                return const Center(
                  child: Text('No prompts found'),
                );
              } else {
                return Column(
                  children: [
                    Expanded(
                        child: ReorderableListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      children: <Widget>[
                        for (int index = 0;
                            index < state.addFlowModel!.flow!.length;
                            index += 1)
                          ListTile(
                            leading: CircleAvatar(
                                maxRadius: 17, child: Text("${index + 1}")),
                            trailing: Icon(Icons.menu),
                            key: Key('$index'),
                            tileColor:
                                index.isOdd ? oddItemColor : evenItemColor,
                            title: Row(
                              children: [
                                Text(
                                    'Item ${state.addFlowModel!.flow![index].name}')
                              ],
                            ),
                          ),
                      ],
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          //print(state.addFlowModel)
                          PromptFlow item = state.addFlowModel!.flow!.removeAt(oldIndex);
                          state.addFlowModel!.flow!.insert(newIndex, item);

                          PromtModel model = state.promtModel!.removeAt(oldIndex);
                          state.promtModel!.insert(newIndex, model);
                        });
                      },
                    )),
                    ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red)),
                        onPressed: () {

                          /*print(state.allResourcesModel.data!
                              .record!.records![index].content);*/

                          Navigator.push(context, MaterialPageRoute( builder: (context) { return StartFlowScreen(
                              content: widget.content,
                              mediaType: widget.mediaType,
                              promtId: widget.promtId,
                          );},));
                          /*print(state.addFlowModel!.flow![0].name);
                          context.read().add(AddPromptFlow(
                              addFlowModel: state.addFlowModel));*/
                        },
                        child: Text('Create Flow'))
                  ],
                );
              }
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

//   ChewieController _createChewieController(String videoUrl) {
//     final videoPlayerController = VideoPlayerController.network(videoUrl);
//     _chewieController = ChewieController(
//       videoPlayerController: videoPlayerController,
//       autoInitialize: true,
//       autoPlay: true,
//       looping: false,
//       errorBuilder: (context, errorMessage) {
//         return Center(
//           child: Text(
//             errorMessage,
//             style: const TextStyle(color: Colors.white),
//           ),
//         );
//       },
//     );
//     return _chewieController!;
//   }
// }
//
// class PromtMediaPlayScreen extends StatefulWidget {
//   const PromtMediaPlayScreen({Key? key}) : super(key: key);
//
//   @override
//   State<PromtMediaPlayScreen> createState() => _PromtMediaPlayScreenState();
// }
//
// class _PromtMediaPlayScreenState extends State<PromtMediaPlayScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
}
