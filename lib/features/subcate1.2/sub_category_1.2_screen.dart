import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:self_learning_app/features/create_flow/bloc/create_flow_screen_bloc.dart';
import 'package:self_learning_app/features/subcate1.2/final_resources_screen.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/widgets/add_resources_screen.dart';
import '../../utilities/colors.dart';
import '../create_flow/create_flow_screen.dart';
import '../create_flow/flow_screen.dart';
import '../resources/subcategory2_resources_screen.dart';
import '../subcate1.1/update_subcate1.1_screen.dart';
import 'bloc/sub_cate2_bloc.dart';
import 'bloc/sub_cate2_event.dart';
import 'bloc/sub_cate2_state.dart';
import 'create_subcate1.2_screen.dart';

class SubCategory2Screen extends StatefulWidget {
  final String subCateTitle;
  final List<String> keyWords;
  final String rootId;
  final Color? color;

  const SubCategory2Screen(
      {Key? key,
      required this.subCateTitle,
      required this.rootId,
      this.color,
      required this.keyWords})
      : super(key: key);

  @override
  State<SubCategory2Screen> createState() => _SubCategory2ScreenState();
}

class _SubCategory2ScreenState extends State<SubCategory2Screen> {
  List<String> mediaTitle = [
    'Take Picture',
    'Record Video',
    'Record Audio',
    'Enter Text'
  ];

  List<IconData> mediaIcons = [
    Icons.camera,
    Icons.video_call_outlined,
    Icons.audio_file_outlined,
    Icons.text_increase
  ];

  int _tabIndex = 0;
  CreateFlowBloc _flowBloc = CreateFlowBloc();

  @override
  void initState() {
    context.read<SubCategory2Bloc>().add(SubCategory2LoadEvent(rootId: widget.rootId));
    _flowBloc.add(LoadAllFlowEvent(catID: widget.rootId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          floatingActionButton: SizedBox(height: context.screenHeight*0.1,
            child: FittedBox(
              child: ElevatedButton(
                onPressed: () {

                  if(_tabIndex == 0) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          Subcategory2ResourcesList(rootId: widget.rootId,
                              mediaType: '',
                              title: widget.subCateTitle),));
                  }else {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) {
                      return CreateSubCate2Screen(rootId: widget.rootId,);
                    },));
                  }

                },
                child: Row(
                  children: [
                    Text(
                      _tabIndex==0?'View All':'Create\n Category',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 9),),
                  ],
                ),
              ),
            ),
          ),
          appBar: AppBar(
              bottom:  TabBar(
                tabs: [
                  Column(
                    children: const [
                      Tab(icon: Icon(Icons.perm_media,)),
                      Text('Resources')
                    ],
                  ),
                  Column(
                    children: const [
                      Tab(icon: Icon(Icons.list_alt,)),
                      Text('Subcategory list')
                    ],
                  ),
                ],
                onTap: (value) {
                  setState(() {
                    _tabIndex = value;
                  });
                },
                isScrollable: false,
              ),
              title: Text(widget.subCateTitle),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider<CreateFlowBloc>.value(value: _flowBloc, child: CreateFlowScreen(rootId: widget.rootId!)),));
                  },),
                IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return BlocProvider<CreateFlowBloc>.value(value: _flowBloc, child: FlowScreen(
                            rootId: widget.rootId!,
                          ));
                        },
                      ));
                    },
                    icon: Icon(Icons.play_circle)
                ),

                PopupMenuButton(
                  icon: Icon(Icons.more_vert,color: Colors.white,),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                          value: 'createFlow',
                          child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.add_circle_rounded, color: primaryColor,),
                                  SizedBox(width: 8.0,),
                                  Text("Create New Flow"),
                                ],
                              ))
                      ),

                      const PopupMenuItem(
                          value: 'startFlow',
                          child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.play_circle, color: primaryColor,),
                                  SizedBox(width: 8.0,),
                                  Text("Start Flow"),
                                ],
                              ))
                      ),
                      const PopupMenuItem(
                          value: 'edit',
                          child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.edit, color: primaryColor,),
                                  SizedBox(width: 8.0,),
                                  Text("Edit Category"),
                                ],
                              ))
                      )
                    ];
                  },
                  onSelected: (String value) {
                    switch(value){
                      case 'edit':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return UpdateSubCate1Screen(
                                  rootId: widget.rootId,
                                  selectedColor: widget.color!,
                                  categoryTitle: widget.subCateTitle,
                                  keyWords: widget.keyWords,
                                );
                              },));
                        break;
                      case 'schedule':

                        break;
                      case 'startFlow':
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return FlowScreen(
                              rootId: widget.rootId!,
                            );
                          },
                        ));
                        break;
                      case 'createFlow':
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return CreateFlowScreen(
                                  rootId: widget.rootId!
                              );
                            }));
                        break;
                    }
                  },
                ),
              ]
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              //tab1
              AddResourceScreen(rootId: widget.rootId??'',whichResources: 1, categoryName: widget.subCateTitle,),

              //tab2
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: context.screenWidth,
                    height: context.screenHeight * 0.08,
                    child: CupertinoSearchTextField(
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      placeholder: 'Search',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<SubCategory2Bloc, SubCategory2State>(
                    builder: (context, state) {
                      if (state is SubCategory2Loading) {
                        return const CircularProgressIndicator();
                      } else if (state is SubCategory2Loaded) {
                        return state.cateList.isEmpty
                            ? SizedBox(
                          height: context.screenHeight / 2,
                          child: const Center(
                            child: Text(
                              'No Subcategory added',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                            : Expanded(
                          child: ListView.builder(
                            itemCount: state.cateList.length,
                            shrinkWrap: true,

                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => FinalResourceScreen(
                                        rootId: state.cateList[index].sId??'',
                                        //whichResources: 1,
                                        categoryName: state.cateList[index].name!, keyWords: widget.keyWords,),));
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Color(int.parse(state
                                                  .cateList[index]
                                                  .styles![1]
                                                  .value!)),
                                              width: 3),
                                          color: Colors.transparent),
                                      padding: const EdgeInsets.only(left: 20),
                                      child: ListTile(
                                          title: Text(
                                            state.cateList[index].name.toString(),
                                            style: const TextStyle(
                                                color: primaryColor),
                                          )),
                                    )),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
