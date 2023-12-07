import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';
import 'package:self_learning_app/features/quick_add/data/bloc/quick_add_bloc.dart';
import 'package:self_learning_app/features/quick_add/data/repo/quick_add_repo.dart';
import 'package:self_learning_app/features/quick_import/quick_add_import_screen.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import 'PromptBloc/quick_prompt_bloc.dart';


class QuickTypeScreen extends StatefulWidget {
  const QuickTypeScreen({Key? key}) : super(key: key);

  @override
  State<QuickTypeScreen> createState() => _QuickTypeScreenState();
}

class _QuickTypeScreenState extends State<QuickTypeScreen> {

  // final QuickAddBloc quickAddBloc=QuickAddBloc();
  @override
  // Future<void> triggerEvent() async {
  //
  //   quickAddBloc.add(LoadQuickTypeEvent());
  //   await Future.delayed(Duration(seconds: 10));
  //   quickAddBloc.add(LoadQuickPromptEvent());
  //
  //
  // }
  void initState() {


    // triggerEvent();

    super.initState();
    context.read<QuickAddBloc>().add(LoadQuickTypeEvent());
    context.read<QuickPromptBloc>().add(QuickAddPromptEvent());


  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('Quick Adds'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Resource List'),
                Tab(text: 'Prompt List'),
              ],
            ),
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return const DashBoardScreen();
          },));
        },)),
        body: TabBarView(
          children: [
            BlocConsumer<QuickAddBloc, QuickAddState>(
              builder: (context, state) {
                print(state);
                if (state is QuickAddLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is QuickAddLoadedState) {
                  var list = state.list!.data!.record!.records!.reversed.toList();
                 if(list.isEmpty){
                   return const Center(child: Text('No quick adds found.'),);
                 }else {
                   return ListView.builder(
                     padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
                     shrinkWrap: true,
                     itemCount: list.length,
                     itemBuilder: (context, index) {
                       return Slidable(
                         key: const ValueKey(0),
                         startActionPane: ActionPane(
                           motion: const ScrollMotion(),
                           dismissible: DismissiblePane(onDismissed: () {
                             QuickAddRepo.deletequickAdd(
                                 id: list[index].sId!, context: context);
                             context.read<QuickAddBloc>().add(LoadQuickTypeEvent());
                           }),
                           children: [
                             SlidableAction(
                               onPressed: (context) {
                                 QuickAddRepo.deletequickAdd(
                                     id: list[index].sId!, context: context);
                                 context
                                     .read<QuickAddBloc>()
                                     .add(LoadQuickTypeEvent());},
                               backgroundColor: Color(0xFFFE4A49),
                               foregroundColor: Colors.white,
                               icon: Icons.delete,
                               label: 'Delete',
                             ),
                           ],
                         ),
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Container(
                             padding: const EdgeInsets.only(top: 7, bottom: 7),
                             decoration: BoxDecoration(
                                 color: Colors.blue[50],
                                 borderRadius: BorderRadius.circular(10)),
                             //height: context.screenHeight*0.08,
                             child: Center(
                               child: ListTile(
                                 leading: getType(list[index].type.toString())=='image'?const Icon(Icons.image):getType(list[index].type.toString())=='video'?const Icon(Icons.video_camera_back_outlined):getType(list[index].type.toString())=='audio'?const Icon(Icons.audiotrack):Icon(Icons.text_format),
                                   title: Text(list[index].title??'Untitled'),
                                   trailing: SizedBox(
                                     width: context.screenWidth / 3.5,
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.spaceBetween,
                                       children: [
                                         IconButton(
                                           onPressed: () {
                                             print(list[index].sId!);
                                             Navigator.push(context,
                                                 CupertinoPageRoute(
                                                   builder: (context) {
                                                     return QuickAddImportScreen(
                                                       mediaType: getType(list[index].type.toString()),
                                                       quickAddId: list[index].sId!,
                                                       title: list[index].title ?? 'Image Type',
                                                       resourcecontent: list[index].content??"resource content",
                                                     );
                                                   },
                                                 ));
                                           },
                                           icon: Icon(Icons.add),
                                         ),
                                         Column(
                                           children: const [
                                             Icon(Icons.arrow_right_alt),
                                             Icon(Icons.delete),
                                           ],
                                         ),
                                       ],
                                     ),
                                   )),
                             ),
                           ),
                         ),
                       );
                     },
                   );
                 }
                }
                return const Center(
                  child: Text('Something Went Wrong'),
                );
              },
              listener: (BuildContext context, Object? state) {},
            ),
            // Quick add prompt start
            BlocConsumer<QuickPromptBloc, QuickPromptState>(
          /*   buildWhen: (previous, current) {
          if(previous!=current){
            print("ui rebuild");
            return true;
          }
          else{
            print("ui not build");
          }
          print("build when not working");
          return false;

        }*/
              builder: (context, state) {
                print(state);
                if (state is QuickAddLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is QuickPromptAddLoadedState) {
                  if (state.list!.isEmpty) {
                    return const Center(child: Text('No quick prompts found.'));
                  }
                  if(state is QuickAddErrorState){
                   return Center(child: Text('Error'));
                  }
                  else {
                    return ListView.builder(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
                      shrinkWrap: true,
                      itemCount: state.list?.length,
                      itemBuilder: (context, index) {
                        print("prompt list name ${state.list?.length}");

                        return Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () async {
                              context.read<QuickPromptBloc>().add(DeleteQuickPromptEvent(promptId: state.list![index].promptid,
                                  promptName:state.list![index].promptname, index: index));

                            }),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                              /*    QuickAddRepo.deletequickAdd(
                                      id: list[index].sId!, context: context);
                                  context
                                      .read<QuickAddBloc>()
                                      .add(LoadQuickTypeEvent());*/},
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.only(top: 7, bottom: 7),
                              decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(10)),
                              //height: context.screenHeight*0.08,
                              child: Center(
                                child: ListTile(
                                    leading: Text("P"),
                                    title: Text(state.list![index].promptname??"Untitle"),
                                    trailing: SizedBox(
                                      width: context.screenWidth / 3.5,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              // print(list[index].sId!);
/*
                                              Navigator.push(context,
                                                  CupertinoPageRoute(
                                                    builder: (context) {
                                                      return QuickAddImportScreen(
                                                        mediaType: getType(list[index].type.toString()),
                                                        quickAddId: list[index].sId!,
                                                        title: list[index].title ?? 'Image Type',
                                                        resourcecontent: list[index].content??"resource content",
                                                      );
                                                    },
                                                  ));
*/
                                            },
                                            icon: Icon(Icons.add),
                                          ),
                                          Column(
                                            children: const [
                                              Icon(Icons.arrow_right_alt),
                                              Icon(Icons.delete),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
                return const Center(
                  child: Text('Something Went Wrong'),
                );
              },

              listener: (BuildContext context, Object? state) {},
            ),
          ],
        )),
    );
  }
}



String getType(String type) {
  switch (type) {
    case 'QUICKADD-image':
      return 'image';
    case 'QUICKADD-video':
      return 'video';
    case 'QUICKADD-audio':
      return 'audio';
    case 'QUICKADD-text':
      return 'text';
    default:
      return 'unknown'; // Handle unknown types or provide a default value
  }
}

//#ggggggggggggggg