import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:self_learning_app/features/subcate1.1/create_subcate1_screen.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../features/category/bloc/category_bloc.dart';
import '../features/create_flow/bloc/create_flow_screen_bloc.dart';
import '../features/create_flow/create_flow_screen.dart';
import '../features/create_flow/flow_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/resources/maincategory_resources_screen.dart';
import '../features/subcate1.1/sub_category_1.1_screen.dart';
import '../features/subcate1.2/final_resources_screen.dart';
import '../features/subcate1.2/sub_category_1.2_screen.dart';
import '../features/subcategory/bloc/sub_cate_bloc.dart';
import '../features/subcategory/bloc/sub_cate_event.dart';
import '../features/subcategory/bloc/sub_cate_state.dart';
import '../features/subcategory/sub_cate_screen.dart';
import '../features/update_category/update_cate_screen.dart';
import '../main.dart';
import '../utilities/colors.dart';
import '../utilities/shared_pref.dart';
import 'add_resources_screen.dart';

class SubCategoryWidget extends StatefulWidget {
  final String? rootId;
  final Color? color;
  final String? categoryName;
  final int ? level;

  const SubCategoryWidget({required this.rootId, required this.color, required this.categoryName, required this.level});

  @override
  State<SubCategoryWidget> createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> with TickerProviderStateMixin {
  TextEditingController summaryController = TextEditingController();
  AnimationController? _animationController; // Make the AnimationController nullable

  @override
  void initState() {
    context.read<SubCategoryBloc>().add(
        SubCategoryLoadEvent(rootId: widget.rootId));
    context.read<CreateFlowBloc>().add(LoadAllFlowEvent(catID: widget.rootId!));
    super.initState();
    _animationController = AnimationController(
      vsync: this, // Ensure that your StatefulWidget class mixes in TickerProviderStateMixin
      duration: Duration(milliseconds: 500), // Animation duration
      upperBound: 20,
      reverseDuration: Duration(seconds: 2)
    );

  }
  addCategory({required String summary}) async {
    print("_---rood id is ${widget.rootId}");
    final Dio _dio = Dio();
    var token = await SharedPref().getToken();
    Map<String, dynamic> headers = {
      'Authorization': 'bearer' + ' ' + token.toString(),
    };

      var res = await _dio.patch(
            'https://selflearning.dtechex.com/web/category/${widget.rootId}',
        data: {"summary": summary},
        options: Options(headers: headers),
      );
      print("main category update ${res.data}");
      if (res.statusCode == 200) {
        summaryController.clear();
        context.showSnackBar(
            SnackBar(content: Text('Summary added successfully')));
        context.read<CategoryBloc>().add(CategoryLoadEvent());
        setState(() {

        });
      } else {
        context.showSnackBar(
            const SnackBar(content: Text('opps something went worng')));
      }
      print('data');
    }
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    print("category id is ${widget.rootId}");
    return Scaffold(
      floatingActionButton: ElevatedButton(
        child: Text("Create SubCategory"),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateSubCate1Screen(rootId: widget.rootId,
          subCatName: widget.categoryName,
          ))).then((value) {
            if(value){
              setState(() {
                context.read<SubCategoryBloc>().add(
                    SubCategoryLoadEvent(rootId: widget.rootId));
              });
            }
          });
        },
      ),
      body:Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8 ,vertical: 5),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.1,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(3),
                    border: Border.all(width: 1.5, color: Colors.grey.shade200)
                  ),
                  child: TextField(
                    controller: summaryController ,
                      maxLines: 8,
                      style: TextStyle(letterSpacing: 2,color: Colors.black87),
                      decoration: InputDecoration(

                        hintText: 'Add Summary .....',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 8,bottom: 5),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.shade200,
                  borderRadius: BorderRadius.circular(45)
                ),
                child: IconButton(
                  onPressed: (){
                    if(summaryController.text.isNotEmpty) {
                      addCategory(summary: summaryController.text);
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Summary is empty'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating, // Optional: behavior
                          clipBehavior: Clip.antiAlias, // Optional: clip behavior
                            animation: _animationController!.view


                        ),
                      );                    }
                  },
                  icon: Icon(Icons.send, color: Colors.green,size: 20,),
                ),
              )

            ],
          ),
          Expanded(
            child: BlocBuilder<SubCategoryBloc, SubCategoryState>(
              builder: (context, state) {
                if(state is SubCategoryLoading){
                  return Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if(state is SubCategoryLoaded){

                  return  CustomScrollView(

                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(width: 0.2, color: Colors.black87),
                                ),
                                child: Text(state.cateList[index].summary![index],
                                style: TextStyle(fontWeight: FontWeight.w100, color: Colors.black87, fontSize: 13, letterSpacing: 1,decorationThickness: 0.5,wordSpacing: 1,
                                  height: 1.2
                                ),
                                )
                              );
                          },
                          childCount: 1,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () async {
                                //   await SharedPref().savesubcateId(state.cateList[index].sId!);
                                if(widget.level == 1) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return
                                        SubCategory1Screen(
                                          subCateTitle:
                                          state.cateList[index].name!,
                                          rootId: state.cateList[index].sId!,
                                          color: widget.color,
                                          keyWords:
                                          state.cateList[index].keywords!,
                                        );
                                    },
                                  ));
                                }
                                if(widget.level == 2){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return
                                        SubCategory2Screen(
                                          subCateTitle:
                                          state.cateList[index].name!,
                                          rootId: state.cateList[index].sId!,
                                          color: widget.color,
                                          keyWords:
                                          state.cateList[index].keywords!,
                                        );
                                    },
                                  ));
                                }
                                if(widget.level == 3){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return
                                        FinalResourceScreen(
                                        categoryName:
                                          state.cateList[index].name!,
                                          rootId: state.cateList[index].sId!,
                                          color: widget.color,
                                          keyWords:
                                          state.cateList[index].keywords!,
                                        );
                                    },
                                  ));
                                }

                              },
                              child: Card(
                                elevation: 1,
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
                                                    level: "Level 1",
                                                    rootId: state.cateList[index]
                                                        .sId!,
                                                    mediaType: '',
                                                    title: state.cateList[index]
                                                        .name!),));
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
                          childCount: state.cateList.length,
                        ),
                      ),

                    ],
                  );

                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),

    );
  }
}
