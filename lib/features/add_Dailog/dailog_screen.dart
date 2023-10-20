import 'dart:math';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utilities/colors.dart';
import '../dailog_category/dailog_cate_screen.dart';
import 'create_dailog_screen.dart';

class DailogScreen extends StatefulWidget {
  const DailogScreen({super.key});

  @override
  State<DailogScreen> createState() => _DailogScreenState();
}
Color lightenRandomColor(Color color, double factor) {
  assert(factor >= 0 && factor <= 1.0);
  final int red = (color.red + (255 - color.red) * factor).round();
  final int green = (color.green + (255 - color.green) * factor).round();
  final int blue = (color.blue + (255 - color.blue) * factor).round();
  return Color.fromARGB(255, red, green, blue);
}
class _DailogScreenState extends State<DailogScreen> {
  Color generateRandomColor() {
    final Random random = Random();
    final int red = random.nextInt(256); // 0-255 for the red channel
    final int green = random.nextInt(256); // 0-255 for the green channel
    final int blue = random.nextInt(256); // 0-255 for the blue channel
    final originalColor = Color.fromARGB(255, red, green, blue);
    final pastelColor = lightenRandomColor(originalColor, 0.8); // 30% lighter

    return pastelColor;
  }
  @override
  Widget build(BuildContext context) {
    double searchwidth = MediaQuery.of(context).size.width < 600
        ? double.infinity
        : MediaQuery.of(context).size.width < 1200
        ? MediaQuery.of(context).size.width*0.6
        : MediaQuery.of(context).size.width/3;
    return  Scaffold(
      floatingActionButton:
      FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddDailogScreen()));
      },child: Icon(Icons.add)),
      body:
      CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            height: 100, color: Colors.red,
            child: BlurryContainer(
              width: searchwidth,
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
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : MediaQuery.of(context).size.width < 1200 ? 3 : 6,
              childAspectRatio: 3/2,

            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                // Calculate the container height and width based on screen size
                double containerHeight = MediaQuery.of(context).size.width < 600
                    ? 140.0
                    : MediaQuery.of(context).size.width < 1200
                    ? 200.0
                    : 300.0;
                double containerWidth = MediaQuery.of(context).size.width < 600
                    ? 150.0
                    : MediaQuery.of(context).size.width < 1200
                    ? 300.0
                    : 300.0;

                // Build the list of items with fixed height and width
                return
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    padding: EdgeInsets.zero,
                    height: containerHeight,
                    width: containerWidth,
                    child: GestureDetector(
                      onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>DailogCategoryScreen()));
                      },
                      child: Card(
                        elevation: 2.0,
                          color: generateRandomColor(),

                          child: Stack(
                          children: [
                            Center(
                              child: Text("Item$index"),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: PopupMenuButton(

                                icon: Icon(Icons.more_vert,color: Colors.red,),
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
                                                Text("Update"),
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
                                                Text("Delete"),
                                              ],
                                            ))
                                    )
                                  ];
                                },
                                onSelected: (String value) {
                                  switch(value){
                                    case 'update':
                                      /*Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return UpdateCateScreen(
                                            rootId: state.cateList[index].sId,
                                            selectedColor: currentColor,
                                            categoryTitle: state.cateList[index].name,
                                            tags: state.cateList[index].keywords,
                                          );
                                        },
                                      ));*/
                                      break;
                                    case 'delete':
                                      /*context.read<CategoryBloc>().add(CategoryDeleteEvent(
                                        rootId: state.cateList[index].sId??'',
                                        context: context,
                                        catList: state.cateList,
                                        deleteIndex: index,
                                      ));*/
                                      break;
                                  }
                                },
                              ),
                            )

                          ],
                        )
                      ),
                    ),
                  );              },
              childCount: 20, // Number of items in the list
            ),
          ),
        ],
      )

    );
  }
}
