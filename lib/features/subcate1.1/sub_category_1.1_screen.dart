import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:self_learning_app/features/create_flow/bloc/create_flow_screen_bloc.dart';
import 'package:self_learning_app/features/resources/subcategory_resources_screen.dart';
import 'package:self_learning_app/features/subcate1.2/bloc/sub_cate2_bloc.dart';
import 'package:self_learning_app/features/subcategory/create_subcate_screen.dart';
import 'package:self_learning_app/features/subcategory/update_subcategory.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../../utilities/colors.dart';
import '../../widgets/SubCategoryWidget.dart';
import '../../widgets/add_resources_screen.dart';
import '../create_flow/create_flow_screen.dart';
import '../create_flow/flow_screen.dart';
import '../resources/maincategory_resources_screen.dart';
import '../search_subcategory/search_sub_cat.dart';
import '../subcate1.2/sub_category_1.2_screen.dart';
import '../subcategory/bloc/sub_cate_bloc.dart';
import '../subcategory/bloc/sub_cate_state.dart';
import '../subcategory/primaryflow/primaryflow.dart';
import '../update_category/update_cate_screen.dart';
import 'bloc/sub_cate1_bloc.dart';
import 'bloc/sub_cate1_event.dart';
import 'bloc/sub_cate1_state.dart';
import 'create_subcate1_screen.dart';


class SubCategory1Screen extends StatefulWidget {
  final String subCateTitle;
  final List<String>  keyWords;
  final String rootId;
  final Color? color;


  const SubCategory1Screen({Key? key, required this.subCateTitle, required this.rootId, this.color, required this.keyWords}) : super(key: key);

  @override
  State<SubCategory1Screen> createState() => _SubCategory1ScreenState();
}

class _SubCategory1ScreenState extends State<SubCategory1Screen> {
  List<String> mediaTitle = [
    'Take Picture',
    'Record Video',
    'Record Audio',
    'Enter Text'
  ];
  bool value = false;
  final TextEditingController _flowSearchController = TextEditingController();


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
    context.read<SubCategory1Bloc>().add(SubCategory1LoadEvent(rootId: widget.rootId));
    context.read<CreateFlowBloc>().add(LoadAllFlowEvent(catID: widget.rootId!));

    super.initState();
    _flowBloc.add(LoadAllFlowEvent(catID: widget.rootId));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 3,
      child: Scaffold(

          appBar: AppBar(
            leading: IconButton(onPressed: (){
              if(value==true){
                Navigator.pop(context, true);

              }
              if(value == false){
                Navigator.pop(context, false);

              }
            }, icon: Icon(Icons.arrow_back),),
              title: Text(widget.subCateTitle),
              actions: [

                IconButton(
                    onPressed: () {
/*
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return BlocProvider<CreateFlowBloc>.value(value: _flowBloc, child: FlowScreen(
                            rootId: widget.rootId!,
                          ));
                        },
                      ));
*/
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PrimaryFlow(
                        categoryName: widget.subCateTitle,
                        CatId: widget.rootId.toString(),flowId: "0",)));

                    },
                    icon: Icon(Icons.play_circle)
                ),

                PopupMenuButton(
                  icon: Icon(Icons.more_vert,color: Colors.white,),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                          value: 'addResources',
                          child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.add_circle_rounded, color: primaryColor,),
                                  SizedBox(width: 8.0,),
                                  Text("Add Resources"),
                                ],
                              ))
                      ),
                      const PopupMenuItem(
                          value: 'viewResources',
                          child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.add_circle_rounded, color: primaryColor,),
                                  SizedBox(width: 8.0,),
                                  Text("View Resources"),
                                ],
                              ))
                      ),

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
                                  Text("Select Primary Flow"),
                                ],
                              ))
                      ),
                      const PopupMenuItem(
                          value: 'schedule',
                          child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.schedule, color: primaryColor,),
                                  SizedBox(width: 8.0,),
                                  Text("schedule"),
                                ],
                              ))
                      ),

                    ];
                  },
                  onSelected: (String value) {
                    switch(value){
                      case 'addResources':
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddResourceScreen(rootId: widget.rootId??'',whichResources: 1, categoryName: widget.subCateTitle,)
                        ));

                        break;

                      case 'viewResources':
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              MaincategoryResourcesList(rootId: widget.rootId,
                                  level: "Level 2",
                                  mediaType: '',
                                  title: widget.subCateTitle),));
                        break;
                      case 'edit':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return UpdateSubCateScreen(
                                  rootId: widget.rootId,
                                  selectedColor: widget.color!,
                                  categoryTitle: widget.subCateTitle,
                                  keyWords: widget.keyWords,);
                        },));
                        break;
                      case 'schedule':

                        break;
                      case 'startFlow':
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return FlowScreen(
                              rootId: widget.rootId!,
                              categoryname: widget.subCateTitle,
                            );
                          },
                        ));
                        break;
                      case 'createFlow':
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return CreateFlowScreen(
                                  rootId: widget.rootId!,
                                categoryName: widget.subCateTitle,
                              );
                            }));
                        break;
                    }
                  },
                ),
              ]
          ),
          body:
          Column(
            children: [

              Container(
                height: 50,
                color: Color(0xffFF8080),
                child: TabBar(
                  labelColor: Colors.blueAccent,
                  unselectedLabelColor: Colors.white,
                  indicatorColor: Colors.red,
                  indicatorWeight: 4,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
                  labelPadding: EdgeInsets.zero,
                  automaticIndicatorColorAdjustment: true,
                  tabs: [
                    Text("Subcategory"),
                    Text("Resource"),
                    Text("Flows"),

                  ],
                ),
              ),
              Expanded(child: TabBarView(
                children: <Widget> [
                  Column(
                    children: [
                      SizedBox(
                        width: context.screenWidth,
                        height: context.screenHeight * 0.08,
                        child: BlocBuilder<SubCategoryBloc, SubCategoryState>(
                          builder: (context, state) {
                            if (state is SubCategoryLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            else if (state is SubCategoryLoaded) {
                              List<Map<String, dynamic>> searchList = state.cateList.map((
                                  item) {
                                return {
                                  'title': item.name.toString(),
                                  'sId': item.sId.toString(),
                                  'keywords': item.keywords.toString(),
                                };
                              }).toList();
                              print("-=-=-===-==$searchList");
                              return Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                          child: GestureDetector(

                                            onTap: () async {
                                              await showSearch(
                                                context: context,
                                                delegate: CustomSubCatSearchDelegate(
                                                    rootId: widget.rootId.toString()),
                                              );
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 15),
                                              height: context.screenHeight * 0.058,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  borderRadius: BorderRadius.circular(10)
                                              ),

                                              child: Padding(
                                                padding: EdgeInsets.only(left: 20,bottom: 10, top: 10),
                                                child: Text('Search..', style: TextStyle(
                                                    color: Colors.black.withOpacity(0.5)
                                                ),),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),

                                  ],
                                ),
                              );
                            }

                            return SizedBox();
                          },

                        ),
                      ),
                      Expanded(
                          child:SubCategoryWidget(color: widget.color,categoryName: widget.subCateTitle,rootId: widget.rootId,level: 2,)
                      ),
                    ],
                  ),
                  // resource column is this
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey.shade300,width: 1.5),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      Expanded(
                        child: MaincategoryResourcesList(rootId: widget.rootId!,
                            level: "Level 1",
                            mediaType: '',
                            title: widget.subCateTitle!),
                      )

                    ],
                  ),

                  // Flows column is that
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey.shade300,width: 1.5),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child:  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: _flowSearchController,
                              onChanged: (value) {
                                print("Text changed: $value");
                                context.read<CreateFlowBloc>().add(LoadAllFlowEvent(catID: widget.rootId!,keyword: value));

                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search flow...',
                              ),
                            )
                        ),
                      ),

                      Expanded(
                        child: FlowScreen(
                          rootId: widget.rootId!,
                          categoryname: widget.subCateTitle??"",
                        ),
                      ),
                    ],
                  )


                ],
              ))


            ],
          ),


      ),
    );
  }
}
