import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utilities/colors.dart';

class DailogCategoryScreen extends StatefulWidget {
  const DailogCategoryScreen({super.key});

  @override
  State<DailogCategoryScreen> createState() => _DailogCategoryScreenState();
}

class _DailogCategoryScreenState extends State<DailogCategoryScreen> {
  @override

  List<dynamic> mixList = ["amit", 40, 60,"vipin", 30, 20, "abhi" ];
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(

        title: Text("Dailog Category Screen"),
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
                    // Navigator.push(context, MaterialPageRoute(
                    //     builder: (context) =>
                    //         PrimaryFlow(
                    //           CatId: widget.rootId.toString(), flowId: "1",
                    //           categoryName: widget.categoryName??"",
                    //         )));
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
/*
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return
                            AddResourceScreen(rootId: widget.rootId ?? '',
                                whichResources: 1,
                                categoryName: widget.categoryName ??
                                    "Subcategory");
                        },
                      ));
*/
                      break;

                    case 'viewResource':
/*
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            MaincategoryResourcesList(rootId: widget.rootId!,
                                mediaType: '',
                                title: widget.categoryName!),));
*/
                      break;
                    case 'edit':
/*
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
*/
                      break;
                    case 'schedule':
                      break;
                    case 'startFlow':
/*
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return FlowScreen(
                            rootId: widget.rootId!,
                            categoryname: widget.categoryName??"",
                          );
                        },
                      ));
*/
                      break;
                    case 'createFlow':
/*
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return CreateFlowScreen(
                              rootId: widget.rootId!, categoryName: widget.categoryName.toString(),
                            );
                          }));
*/
                      break;
                  }
                },
              ),
            ]

        ),
      body:
      CustomScrollView(
        slivers: <Widget>[

          SliverToBoxAdapter(child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            height: 100, color: Colors.red,
          child: BlurryContainer(
            height: 50,
            color: Colors.white,
            elevation: 5,
            borderRadius: BorderRadius.circular(20),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Search"),
                Icon(Icons.search)
              ],
            ),
          ),

          )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                final item = mixList[index];
                Icon leadingIcon = Icon(Icons.add);
                Color iconColor = Colors.transparent; // Provide a default value
                String? leadingText;

                if (item is String) {
                  iconColor = Colors.green;
                  leadingText = "R";
                } else if (item is int) {
                  leadingText = "P";
                  iconColor = Colors.orange;
                }

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: ListTile(
                    key: Key('UniqueString'),

                    leading: CircleAvatar(
                      backgroundColor: iconColor,
                      child: Text(leadingText!, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    ),
                    title: Text('Item $index'),
                  ),
                );
              },
              childCount: mixList.length,
            ),
          ),


        ],


      )
    );
  }
}
