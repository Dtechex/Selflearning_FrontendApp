
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import '../add_category/data/model/add_cate_model.dart';
import '../subcate1.1/sub_category_1.1_screen.dart';
import '../subcate1.2/final_resources_screen.dart';
import '../subcate1.2/sub_category_1.2_screen.dart';
import '../subcategory/sub_cate_screen.dart';

class MyNode {
  final String sId;
  final String userId;
  final String name;
  final List<String> keywords;
  final List<Styles> styles;
  final List<MyNode> children;

  const MyNode({
    required this.sId,
    required this.userId,
    required this.name,
    required this.keywords,
    required this.styles,
    this.children = const <MyNode>[],
  });
}

class MyTreeView extends StatefulWidget {
  final List<MyNode> root;


  const MyTreeView({
    required this.root,

});

  @override
  State<MyTreeView> createState() => _MyTreeViewState();
}

class _MyTreeViewState extends State<MyTreeView> {
  // In this example a static nested tree is used, but your hierarchical data
  // can be composed and stored in many different ways.





  // This controller is responsible for both providing your hierarchical data
  // to tree views and also manipulate the states of your tree nodes.
  late final TreeController<MyNode> treeController;

  @override
  void initState() {
    print("my nodedata=>${widget.root[0].name}");
    super.initState();
    treeController = TreeController<MyNode>(
      // Provide the root nodes that will be used as a starting point when
      // traversing your hierarchical data.
      roots: widget.root,
      // Provide a callback for the controller to get the children of a
      // given node when traversing your hierarchical data. Avoid doing
      // heavy computations in this method, it should behave like a getter.
      childrenProvider: (MyNode node) => node.children,
    );
  }

  @override
  void dispose() {
    // Remember to dispose your tree controller to release resources.
    treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This package provides some different tree views to customize how
    // your hierarchical data is incorporated into your app. In this example,
    // a TreeView is used which has no custom behaviors, if you wanted your
    // tree nodes to animate in and out when the parent node is expanded
    // and collapsed, the AnimatedTreeView could be used instead.
    //
    // The tree view widgets also have a Sliver variant to make it easy
    // to incorporate your hierarchical data in sophisticated scrolling
    // experiences.
    return TreeView<MyNode>(
      // This controller is used by tree views to build a flat representation
      // of a tree structure so it can be lazy rendered by a SliverList.
      // It is also used to store and manipulate the different states of the
      // tree nodes.
      treeController: treeController,
      // Provide a widget builder callback to map your tree nodes into widgets.
      nodeBuilder: (BuildContext context, TreeEntry<MyNode> entry) {
        // Provide a widget to display your tree nodes in the tree view.
        //
        // Can be any widget, just make sure to include a [TreeIndentation]
        // within its widget subtree to properly indent your tree nodes.
        return MyTreeTile(
          // Add a key to your tiles to avoid syncing descendant animations.
          key: ValueKey(entry.node),
          // Your tree nodes are wrapped in TreeEntry instances when traversing
          // the tree, these objects hold important details about its node
          // relative to the tree, like: expansion state, level, parent, etc.
          //
          // TreeEntrys are short lived, each time TreeController.rebuild is
          // called, a new TreeEntry is created for each node so its properties
          // are always up to date.
          entry: entry,


          // Add a callback to toggle the expansion state of this node.
          onTap: () => treeController.toggleExpansion(entry.node),
        );
      },
    );
  }
}

// Create a widget to display the data held by your tree nodes.
class MyTreeTile extends StatelessWidget {
   MyTreeTile({
    super.key,
    required this.entry, required this.onTap,
      });

  final TreeEntry<MyNode> entry;
  final VoidCallback onTap;
  void navigate({required BuildContext context}){
    if (entry.level == 0) {
Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return SubCategory1Screen(
            keyWords: entry.node.keywords,
            color: Colors.red,
            rootId: entry.node.sId,
            subCateTitle: entry.node.name,
          );
        },
      ));      // Navigate to the first screen
    } else if (entry.level == 1) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return SubCategory2Screen(
            keyWords: entry.node.keywords,
            color: Colors.red,
            rootId: entry.node.sId,
            subCateTitle: entry.node.name,
          );
        },
      ));    } else if (entry.level == 2) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return FinalResourceScreen(
            keyWords: entry.node.keywords,
            color: Colors.red,
            rootId: entry.node.sId,
            categoryName: entry.node.name,
          );
        },
      ));    }
  }


  @override
  Widget build(BuildContext context) {
    print("-------------..,.,.,.>>${entry.node.name}");
    // Define colors for card gradients
    Color cardColor = Colors.red.shade50; // Light red color for the root card
    if (entry.level == 0) {
      cardColor = Colors.cyan.shade100;
    } else if (entry.level == 1) {
      cardColor = Colors.cyan.shade50;
    } else if (entry.level == 2) {
      // Darker red color for the second level
      cardColor = Colors.cyan.shade100;
    }

    // Calculate and format the child count
    String childCount = entry.node.children.length.toString();

    // Display the index of the entry, starting from 1
    int index = entry.index != null ? entry.index + 1 : 0;
    String indexString = index != 0 ? index.toString() : "";

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: TreeIndentation(
          entry: entry,
          guide: const IndentGuide.connectingLines(indent: 48),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cardColor, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  // Display the index and folder icon for root level
                  if (entry.level == 0)
                    GestureDetector(
                      onTap: (){

                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) {
                        //     return SubCategoryScreen(
                        //       tags: tags,
                        //       color: color,
                        //       rootId: rootId,
                        //       categoryName: categoryName,
                        //     );
                        //   },
                        // ));

                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 12),
                        child: Row(
                          children: [
                            Text(
                              indexString,
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.folder,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (entry.level > 0) // Display only one folder icon for non-root levels
                    Container(
                      margin: EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.folder,
                        color: Colors.red,
                      ),
                    ),
                  FolderButton(
                    isOpen: entry.hasChildren ? entry.isExpanded : null,
                    onPressed: entry.hasChildren ? onTap : null,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${entry.node.name}',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 12,),
                  Text(
                    "(${childCount})",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // Display the count
                  Spacer(),
                  Container(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        navigate(context: context);
                        // Handle navigation logic here
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(entry.node.name, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),),
                          Icon(Icons.navigate_next_outlined, color: Colors.black87,)
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade300, // Set your desired color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0), // Set the border radius
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ),
        ),
      ),
    );
  }
}