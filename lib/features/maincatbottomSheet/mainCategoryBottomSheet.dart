import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/maincatbottomSheet/treeViewBottomSheet.dart';

import 'bottomSheetCubit/main_bottom_sheet_cubit.dart';

class MainCatBottomSheet extends StatefulWidget {
  String CatName;
  final List<String>? tags;
  final Color? color;
  final String? rootId;

  MainCatBottomSheet({Key?key, required this.CatName,
    this.rootId,
    this.color,
    this.tags,
  }) :super(key: key);

  @override
  State<MainCatBottomSheet> createState() => _MainCatBottomSheetState();
}

class _MainCatBottomSheetState extends State<MainCatBottomSheet> {
  @override
  void initState() {
    context.read<MainBottomSheetCubit>().onGetSubCategoryList(
        rootId: widget.rootId.toString());
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.CatName, // Replace with your actual category name
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BlocBuilder<MainBottomSheetCubit, MainBottomSheetState>(
              builder: (context, state) {
                if(state is MainBottomSheetLoading){
                  return Center(
                    child: Container(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (state is MainBottomSheetLoaded) {
                  return Expanded(
                    child: MyTreeView(
                      root: state.cateList.map((item) {
                        print("xyz response ${item.catlist}");
                        // Map each item in catlist to a MyNode
                        MyNode myNode = MyNode(
                          sId: item.sId ?? "",
                          userId: item.userId ?? "",
                          name: item.name ?? "",
                          keywords: item.keywords ?? [],
                          styles: [], // You may need to populate styles based on your actual data
                          children: item.catlist.map((subItem) {
                            // Map each subcategory in catlist to a MyNode
                            MyNode subNode = MyNode(
                              sId: subItem.sId ?? "",
                              userId: subItem.userId ?? "",
                              name: subItem.name ?? "",
                              keywords: subItem.keywords ?? [],
                              styles: [], // You may need to populate styles based on your actual data
                              children: subItem.catlist.map((subItem2) {
                                // Map each subcategory in the third level to a MyNode
                                return MyNode(
                                  sId: subItem2.sId ?? "",
                                  userId: subItem2.userId ?? "",
                                  name: subItem2.name ?? "",
                                  keywords: subItem2.keywords ?? [],
                                  styles: [], // You may need to populate styles based on your actual data
                                  children: [], // This is an empty list because we are considering only three levels of subcategories
                                );
                              }).toList(),
                            );
                            return subNode;
                          }).toList(),
                        );

                        return myNode;
                      }).toList(),
                    ),
                  );
                }

                return Text("Somethings wents wrong");
              },
            )
          ],
        ),
      ),
    );
  }
}
