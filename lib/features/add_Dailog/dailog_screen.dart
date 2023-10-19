import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dailog_category/dailog_cate_screen.dart';
import 'create_dailog_screen.dart';

class DailogScreen extends StatefulWidget {
  const DailogScreen({super.key});

  @override
  State<DailogScreen> createState() => _DailogScreenState();
}

class _DailogScreenState extends State<DailogScreen> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton:FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddDailogScreen()));
      },child: Icon(Icons.add)),
      body:
      CustomScrollView(
        slivers: <Widget>[
/*
          SliverAppBar(
            expandedHeight: 0, // Set the height of the header when expanded
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[


                  Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                  // Add the title with scaling and fading effect
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 16),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 1.0, end: 0.0),
                        duration: Duration(milliseconds: 500),
                        builder: (BuildContext context, double value,
                            Widget? child) {
                          return Transform.scale(
                            scale: 1 + value, // Scale factor for the title
                            child: Opacity(
                              opacity:
                              1 - value, // Opacity factor for the title
                              child: Text(
                                'Dailogs',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Other properties like pinned, floating, elevation, etc.
            // can be customized as needed
          ),
*/
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
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                // Calculate the container height and width based on screen size
                double containerHeight = MediaQuery.of(context).size.width < 600
                    ? 150.0
                    : MediaQuery.of(context).size.width < 600
                    ? 150.0
                    : 300.0;
                double containerWidth = containerHeight;

                // Build the list of items with fixed height and width
                return
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: containerHeight,
                        width: containerWidth,
                        child: GestureDetector(
                          onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>DailogCategoryScreen()));
                          },
                          child: Card(
                            elevation: 2.0,
                            child: ListTile(
                              title: Center(child: Text('Item $index')),
                              trailing:PopupMenuButton(
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: 'update',
                                      child: Text('Update'),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  if (value == 'update') {
                                    // Handle update action
                                  } else if (value == 'delete') {
                                    // Handle delete action
                                  }
                                },
                              ),

                            ),
                          ),
                        ),
                      ),
                    ],
                  );              },
              childCount: 20, // Number of items in the list
            ),
          ),
        ],
      )

    );
  }
}
