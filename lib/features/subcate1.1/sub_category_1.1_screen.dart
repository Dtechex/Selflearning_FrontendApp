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
import '../../widgets/add_resources_screen.dart';
import '../create_flow/create_flow_screen.dart';
import '../create_flow/flow_screen.dart';
import '../resources/maincategory_resources_screen.dart';
import '../search_subcategory/search_sub_cat.dart';
import '../subcate1.2/sub_category_1.2_screen.dart';
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

      length: 2,
      child: Scaffold(

          floatingActionButton: SizedBox(height: context.screenHeight*0.1,
            child: FittedBox(
              child: ElevatedButton(
                onPressed: () {

                /*  if(_tabIndex == 0) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          SubcategoryResourcesList(rootId: widget.rootId,
                              mediaType: '',
                              title: widget.subCateTitle),));
                  }*/
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) {
                      return CreateSubCate1Screen(rootId: widget.rootId,);
                    },));


                },
                child: Row(
                  children: [
                    Text(
                      /*_tabIndex==0?'View All':*/'Create\n Category',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 9),),
                  ],
                ),
              ),
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
              onPressed: (){
                if(value==true){
                  Navigator.pop(context,true);
                }
                if(value ==false){
                  Navigator.pop(context, false);
                }
              },
              icon: Icon(Icons.arrow_back),
            ),
/*
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
*/
              title: Text(widget.subCateTitle),
              actions: [
/*
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider<CreateFlowBloc>.value(value: _flowBloc, child: CreateFlowScreen(rootId: widget.rootId!)),));
                  },),
*/
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
                                  mediaType: '',
                                  title: widget.subCateTitle,
                                  level: "2"),));
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
          body:               Container(
            padding: EdgeInsets.only(left: 10,right: 10),
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              Row(
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
                              padding: EdgeInsets.only(left: 20,top: 10,bottom: 10),
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
            SizedBox(height: 20,),

            /*  SizedBox(
                width: context.screenWidth,
                height: context.screenHeight*0.08,
                child:  CupertinoSearchTextField(
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  placeholder: 'Search',
                ),
              ),
              const SizedBox(
                height: 20,
              ),*/
              BlocConsumer<SubCategory1Bloc, SubCategory1State>(
  listener: (context, state) {
    if(state is SubCategory1Loaded){
      if(state.value==true){
        value = true;
      }
      else{
        value = false;
      }

    }
    // TODO: implement listener
  },
  builder: (context, state) {
    return BlocBuilder<SubCategory1Bloc,SubCategory1State>(
                builder: (context, state) {
                  if(state is SubCategory1Loading){
                    return const CircularProgressIndicator();
                  }else if( state is SubCategory1Loaded){
                    return
                      state.cateList.isEmpty?  SizedBox(
                        height: context.screenHeight/2,
                        child: const Center(child: Text('No Subcategory added',style: TextStyle(
                            fontSize: 19,fontWeight: FontWeight.bold
                        ),),),):
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.cateList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return SubCategory2Screen(subCateTitle: state.cateList[index].name!,rootId: state.cateList[index].sId!,color: widget.color,keyWords: state.cateList[index].keywords!,);
                                },));
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 1,
                                child: Slidable(
                                  key: const ValueKey(0),
                                  startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    // dismissible: DismissiblePane(onDismissed: (){},),
                                    children: [
                                      SlidableAction(onPressed: (BuildContext context){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddResourceScreen(rootId: state.cateList[index].sId!,whichResources: 1, categoryName: state.cateList[index].name!,)
                                        ));
                                      },
                                      backgroundColor: Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.folder,
                                        label: "Add Resources",
                                      ),
                                      SlidableAction(onPressed:  (BuildContext context){
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              MaincategoryResourcesList(rootId: state.cateList[index].sId!,
                                                  mediaType: '',
                                                  title: state.cateList[index].name!,
                                              level: "2"),));
                                      },
                                        backgroundColor: Colors.teal.shade300,
                                        foregroundColor: Colors.white,
                                        icon: Icons.view_agenda,
                                        label: "View Resources",
                                      )
                                    ],
                                  ),
                                  endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed:  (BuildContext context){
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return CreateFlowScreen(
                                                    rootId: state.cateList[index].sId!,
                                                  categoryName: widget.subCateTitle,
                                                );
                                              }));
                                        },
                                        backgroundColor: Colors.orangeAccent,
                                        foregroundColor: Colors.white,
                                        icon: Icons.create,
                                        label: 'Create',
                                      ),
                                      SlidableAction(
                                          onPressed:  (BuildContext context){
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return FlowScreen(categoryname: widget.subCateTitle,
                                                  rootId: state.cateList[index].sId!,
                                                );
                                              },
                                            ));
                                          },
                                      backgroundColor: Color(0xff0392cf),
                                        foregroundColor: Colors.white,
                                        icon: Icons.view_array,
                                        label: 'View flow',
                                      )
                                    ],
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: ListTile(title: Text(state.cateList[index].name.toString(),style: const TextStyle(
                                        color: primaryColor,

                                    ),),
                                      trailing:                 PopupMenuButton(
                                        icon: Icon(Icons.arrow_drop_down,color: Colors.red,),
                                        itemBuilder: (context) {
                                          return [
                                            const PopupMenuItem(
                                                value: 'update',
                                                child: InkWell(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Icon(Icons.update, color: primaryColor,),
                                                        SizedBox(width: 8.0,),
                                                        Text("update"),
                                                      ],
                                                    ))
                                            ),
                                            const PopupMenuItem(
                                                value: 'delete',
                                                child: InkWell(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Icon(Icons.delete, color: primaryColor,),
                                                        SizedBox(width: 8.0,),
                                                        Text("delete"),
                                                      ],
                                                    ))
                                            ),
                                          ];
                                        },
                                        onSelected: (String value) {
                                          switch(value){
                                            case 'update':
                                              Navigator.push(context, MaterialPageRoute(
                                                builder: (context) {
                                                  return UpdateCateScreen(
                                                    rootId: state.cateList[index].sId,
                                                    selectedColor: widget.color,
                                                    categoryTitle: state.cateList[index].name,
                                                    tags: state.cateList[index].keywords,
                                                  );
                                                },
                                              ));

                                              break;
                                            case 'delete':
                                              context.read<SubCategory1Bloc>().add(SubCategory1DeleteEvent(
                                                rootId: state.cateList[index].sId??'',
                                                context: context,
                                                catList: state.cateList,
                                                deleteIndex: index,
                                              ));
                                              break;

                                          }
                                        },
                                      ),

                                    ),
                                  ),
                                ),
                              ),

                            );
                          },),
                      );
                  }
                  return const SizedBox();
                },);
  },
),
            ],),
          ),

        /*TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              //tab1
              AddResourceScreen(rootId: widget.rootId??'',whichResources: 1, categoryName: widget.subCateTitle,),

              //tab2
              Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: context.screenWidth,
                    height: context.screenHeight*0.08,
                    child:  CupertinoSearchTextField(
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      placeholder: 'Search',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<SubCategory1Bloc,SubCategory1State>(
                    builder: (context, state) {
                      if(state is SubCategory1Loading){
                        return const CircularProgressIndicator();
                      }else if( state is SubCategory1Loaded){
                        return
                          state.cateList.isEmpty?  SizedBox(
                            height: context.screenHeight/2,
                            child: const Center(child: Text('No Subcategory added',style: TextStyle(
                                fontSize: 19,fontWeight: FontWeight.bold
                            ),),),):
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.cateList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return SubCategory2Screen(subCateTitle: state.cateList[index].name!,rootId: state.cateList[index].sId!,color: widget.color,keyWords: state.cateList[index].keywords!,);
                                    },));
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Color(int.parse(state.cateList[index].styles![1].value!)),width: 3),
                                            color: Colors.transparent
                                        ),
                                        padding: const EdgeInsets.only(left: 10),
                                        child: ListTile(title: Text(state.cateList[index].name.toString(),style: const TextStyle(
                                            color: primaryColor
                                        ),)),
                                      )),

                                );
                              },),
                          );
                      }
                      return const SizedBox();
                    },),
                ],),
              ),
            ],
          )*/
      ),
    );
  }
}
