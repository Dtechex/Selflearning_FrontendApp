import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:self_learning_app/features/category/bloc/category_state.dart';
import 'package:self_learning_app/features/create_flow/bloc/create_flow_screen_bloc.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';
import 'package:self_learning_app/features/flow_screen/start_flow_screen.dart';
import 'package:self_learning_app/features/subcategory/create_subcate_screen.dart';
import 'package:self_learning_app/features/subcategory/primaryflow/data/repo/primaryflowRepo.dart';
import 'package:self_learning_app/features/subcategory/primaryflow/primaryflow.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';
import 'package:self_learning_app/widgets/add_resources_screen.dart';

import '../category/bloc/category_bloc.dart';
import '../create_flow/create_flow_screen.dart';
import '../create_flow/flow_screen.dart';
import '../promt/promts_screen.dart';
import '../resources/maincategory_resources_screen.dart';
import '../resources/subcategory_resources_screen.dart';
import '../search_category/cate_search_delegate.dart';
import '../search_subcategory/search_sub_cat.dart';
import '../subcate1.1/sub_category_1.1_screen.dart';
import '../update_category/update_cate_screen.dart';
import 'bloc/sub_cate_bloc.dart';
import 'bloc/sub_cate_event.dart';
import 'bloc/sub_cate_state.dart';

class SubCategoryScreen extends StatefulWidget {
  final List<String>? tags;
  final Color? color;
  final String? categoryName;
  final String? rootId;

  const SubCategoryScreen({
    Key? key,
    this.categoryName,
    this.rootId,
    this.color,
    this.tags,
  }) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    context.read<SubCategoryBloc>().add(
        SubCategoryLoadEvent(rootId: widget.rootId));
    context.read<CreateFlowBloc>().add(LoadAllFlowEvent(catID: widget.rootId!));
    super.initState();
    _searchController.addListener(() {
      // Filter the category list based on the search query.

      // Update the state to re-render the list view.
      setState(() {});
    });
  }

  int _tabIndex = 0;

  Future<void> savecatid() async {
    SharedPref().savesubcateId(widget.rootId!);
  }
bool value = false;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold);
  List<String> searchList = []; // Define searchList at the top of your widget
  List<String> resultList = []; // Results of the search


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          centerTitle: false,
          title: Text(widget.categoryName ?? "Subcategory",
            overflow: TextOverflow.ellipsis,),
          actions: [
/*
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFlowScreen(rootId: widget.rootId!),));
                },),
*/
            IconButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (context) {
                  //     return FlowScreen(
                  //       rootId: widget.rootId!,
                  //     );
                  //   },
                  // ));
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          PrimaryFlow(
                            CatId: widget.rootId.toString(), flowId: "1",
                          categoryName: widget.categoryName??"",
                          )));
                  // AddPromptsToPrimaryFlowRepo.getData(mainCatId: widget.rootId.toString());

                },
                icon: Icon(Icons.play_circle)
            ),



            PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Colors.white,),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                      value: 'createResource',
                      child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.create_new_folder, color: primaryColor,),
                              SizedBox(width: 8.0,),
                              Text("Add Resource"),
                            ],
                          ))
                  ),
                  const PopupMenuItem(
                      value: 'viewResource',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.view_array, color: primaryColor,),
                          SizedBox(width: 8.0,),
                          Text("View Resource"),
                        ],
                      )
                  ),


                  const PopupMenuItem(
                      value: 'createFlow',
                      child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.add_circle_rounded, color: primaryColor,),
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
                switch (value) {
                  case 'createResource':
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return
                          AddResourceScreen(rootId: widget.rootId ?? '',
                              whichResources: 1,
                              categoryName: widget.categoryName ??
                                  "Subcategory");
                      },
                    ));
                    break;

                  case 'viewResource':
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          MaincategoryResourcesList(rootId: widget.rootId!,
                              mediaType: '',
                              title: widget.categoryName!,
                              level: "1"

                          ),));
                    break;
                  case 'edit':
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return UpdateCateScreen(
                          rootId: widget.rootId,
                          selectedColor: widget.color,
                          categoryTitle: widget.categoryName,
                          tags: widget.tags,
                        );
                      },
                    ));
                    break;
                  case 'schedule':
                    break;
                  case 'startFlow':
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return FlowScreen(
                          rootId: widget.rootId!,
                          categoryname: widget.categoryName??"",
                        );
                      },
                    ));
                    break;
                  case 'createFlow':
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return CreateFlowScreen(
                              rootId: widget.rootId!, categoryName: widget.categoryName.toString(),
                          );
                        }));
                    break;
                }
              },
            ),
          ]
      ),
      floatingActionButton: SizedBox(height: context.screenHeight * 0.1,
        child: FittedBox(
          child: ElevatedButton(
            onPressed: () {

/*
                if(_tabIndex == 0) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        MaincategoryResourcesList(rootId: widget.rootId!,
                            mediaType: '',
                            title: widget.categoryName!),));
                }
*/
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CreateSubCateScreen(
                    rootId: widget.rootId,
                  );
                },
              ));
            },
            child: Row(
              children: [
                Text(
                  /* _tabIndex==0?'View All':*/
                  'Create\n SubCategory',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9),),
              ],
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: context.screenWidth,
            height: context.screenHeight * 0.08,
            child: BlocConsumer<SubCategoryBloc, SubCategoryState>(
  listener: (context, state) {
    if(state is SubCategoryLoaded){
      if(state.value == true){
        value = true;
      }
      else{
        value = false;
      }
    }
  },
  builder: (context, state) {
    return BlocBuilder<SubCategoryBloc, SubCategoryState>(
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

            );
  },
),
          ),
          const SizedBox(
            height: 20,
          ),

          BlocBuilder<SubCategoryBloc, SubCategoryState>(
            builder: (context, state) {
               if(state is SubCategoryLoaded){
                return state.cateList.isEmpty?SizedBox():Text("Subcategory of ${widget.categoryName}",
                  style: TextStyle(fontWeight: FontWeight.w500),);
              }
               return SizedBox();
            },
          ),
          SizedBox(height: 10,),

          if(_searchController.text.isEmpty)
            BlocBuilder<SubCategoryBloc, SubCategoryState>(
              builder: (context, state) {
                if (state is SubCategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SubCategoryLoaded) {
                  return state.cateList.isEmpty
                      ? SizedBox(
                    height: context.screenHeight / 2,
                    child: const Center(
                      child: Text(
                        'No Subcategory added',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount: state.cateList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          //   await SharedPref().savesubcateId(state.cateList[index].sId!);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return SubCategory1Screen(
                                subCateTitle:
                                state.cateList[index].name!,
                                rootId: state.cateList[index].sId!,
                                color: widget.color,
                                keyWords:
                                state.cateList[index].keywords!,
                              );
                            },
                          ));
                        },
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          shadowColor: Colors.grey.shade50,
                          child:
                          Slidable(
                            enabled: true,
                            key: const ValueKey(0),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),


                              // dismissible: DismissiblePane(onDismissed: () {}),
                              children: [
                                // A SlidableAction can have an icon and/or a label.
                                SlidableAction(
                                  onPressed: (BuildContext context) {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            AddResourceScreen(
                                              rootId: state.cateList[index]
                                                  .sId!,
                                              whichResources: 1,
                                              categoryName: state
                                                  .cateList[index].name!,)
                                    ));
                                  },
                                  autoClose: false,
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.folder,
                                  label: 'Add Resource',
                                ),
                                SlidableAction(
                                  onPressed: (BuildContext context) {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          MaincategoryResourcesList(
                                              rootId: state.cateList[index]
                                                  .sId!,
                                              mediaType: '',
                                              title: state.cateList[index]
                                                  .name!,
                                              level: "1"
                                          ),));
                                  },
                                  backgroundColor: Color(0xFF21B7CA),
                                  autoClose: false,

                                  foregroundColor: Colors.white,
                                  icon: Icons.view_array,
                                  label: 'View Resource',
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              // dismissible: DismissiblePane(onDismissed: () {}),
                              children: [
                                SlidableAction(
                                  // An action can be bigger than the others.
                                  flex: 2,
                                  onPressed: (BuildContext context) {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return CreateFlowScreen(
                                              rootId: state.cateList[index].sId!, categoryName: widget.categoryName??"",
                                          );
                                        }));
                                  },
                                  backgroundColor: Color(0xFF7BC043),
                                  autoClose: false,
                                  foregroundColor: Colors.white,
                                  icon: Icons.create,
                                  label: 'Create flow',
                                ),
                                SlidableAction(
                                  onPressed: (BuildContext context) {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return FlowScreen(
                                          rootId: state.cateList[index].sId!,
                                          categoryname: widget.categoryName??"",
                                        );
                                      },
                                    ));
                                  },
                                  backgroundColor: Color(0xFF0392CF),
                                  autoClose: false,
                                  foregroundColor: Colors.white,
                                  icon: Icons.view_agenda,
                                  label: 'View Flow',
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                state.cateList[index].name.toString(),
                                style: const TextStyle(
                                    color: primaryColor),
                              ),
                              trailing: PopupMenuButton(
                                icon: Icon(
                                  Icons.arrow_drop_down, color: Colors.red,),
                                itemBuilder: (context) {
                                  return [
                                    const PopupMenuItem(
                                        value: 'update',
                                        child: InkWell(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              children: [
                                                Icon(Icons.update,
                                                  color: primaryColor,),
                                                SizedBox(width: 8.0,),
                                                Text("update"),
                                              ],
                                            ))
                                    ),
                                    const PopupMenuItem(
                                        value: 'delete',
                                        child: InkWell(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              children: [
                                                Icon(Icons.delete,
                                                  color: primaryColor,),
                                                SizedBox(width: 8.0,),
                                                Text("delete"),
                                              ],
                                            ))
                                    ),
                                  ];
                                },
                                onSelected: (String value) {
                                  switch (value) {
                                    case 'update':
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return UpdateCateScreen(
                                            rootId: state.cateList[index].sId,
                                            selectedColor: widget.color,
                                            categoryTitle: state.cateList[index]
                                                .name,
                                            tags: state.cateList[index]
                                                .keywords,
                                          );
                                        },
                                      ));

                                      break;
                                    case 'delete':
                                      context.read<SubCategoryBloc>().add(
                                          SubCategoryDeleteEvent(
                                            rootId: state.cateList[index].sId ??
                                                '',
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
                      );
                    },
                  );
                }
                return const SizedBox(child: Text('Something went wrong'),);
              },
            ),
          if(_searchController.text.isNotEmpty) Column(
            children: resultList
                .map(
                  (item) =>
                  GestureDetector(
                    onTap: () {

                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      color: Colors.redAccent,
                      elevation: 5,
                      child: ListTile(
                        title: Text(item, style: TextStyle(color: Colors
                            .white),),
                      ),
                    ),
                  ),
            )
                .toList(),
          ),


        ],
      ),

/*
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              // tab 1
              AddResourceScreen(rootId: widget.rootId??'',whichResources: 1, categoryName: widget.categoryName??"Subcategory"),
              // tab 2
              Column(
                children: [
                  const SizedBox(
                  height: 20,
                ),
                  SizedBox(
                    width: context.screenWidth,
                    height: context.screenHeight * 0.08,
                    child: BlocBuilder<SubCategoryBloc, SubCategoryState>(
                  builder: (context, state) {

                    if(state is SubCategoryLoading){
                      return const Center(child: CircularProgressIndicator());
                    }
                    else if( state is SubCategoryLoaded) {
                      searchList = state.cateList.map((item) => item.name.toString()).toList();
                      return Column(
                        children: [
                          CupertinoSearchTextField(
                            backgroundColor: Colors.grey.withOpacity(0.2),
                            placeholder: 'Search',
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                // Call the search function with the user's input
                                search(value);
                              });
                            },
                          ),

                        ],
                      );
                    }

                    return SizedBox();
                       },

        ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

              if(_searchController.text.isEmpty)
                BlocBuilder<SubCategoryBloc, SubCategoryState>(
                  builder: (context, state) {
                    if (state is SubCategoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SubCategoryLoaded) {
                      return state.cateList.isEmpty
                          ? SizedBox(
                        height: context.screenHeight / 2,
                        child: const Center(
                          child: Text(
                            'No Subcategory added',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                          : ListView.builder(
                        itemCount: state.cateList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async{
                              //   await SharedPref().savesubcateId(state.cateList[index].sId!);
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return SubCategory1Screen(
                                    subCateTitle:
                                    state.cateList[index].name!,
                                    rootId: state.cateList[index].sId!,
                                    color: widget.color,
                                    keyWords:
                                    state.cateList[index].keywords!,
                                  );
                                },
                              ));
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
                                  padding: const EdgeInsets.only(left: 10),
                                  child: ListTile(
                                      title: Text(
                                        state.cateList[index].name.toString(),
                                        style: const TextStyle(
                                            color: primaryColor),
                                      )),
                                )),
                          );
                        },
                      );
                    }
                    return const SizedBox(child: Text('Something went wrong'),);
                  },
                ),
                  if(_searchController.text.isNotEmpty)  Column(
                    children: resultList
                        .map(
                          (item) => Card(
                            margin: EdgeInsets.symmetric(vertical: 5),
                             color: Colors.redAccent,
                            elevation: 5,
                            child: ListTile(
                        title: Text(item, style: TextStyle(color: Colors.white),),
                      ),
                          ),
                    )
                        .toList(),
                  ),


                ],
              ),

            ],
          ),
        )),
*/
    );
  }
}


