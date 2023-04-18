import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/category/bloc/category_bloc.dart';
import 'package:self_learning_app/features/category/bloc/category_state.dart';
import 'package:self_learning_app/features/search_category/bloc/search_cat_bloc.dart';
import 'package:self_learning_app/features/subcategory/sub_cate_screen.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../search_category/bloc/search_cate_event.dart';
import '../search_category/cate_search_delegate.dart';
import '../subcategory/bloc/sub_cate_bloc.dart';

class AllCateScreen extends StatefulWidget {
  const AllCateScreen({Key? key}) : super(key: key);

  @override
  State<AllCateScreen> createState() => _AllCateScreenState();
}

class _AllCateScreenState extends State<AllCateScreen> {
  int selectedIndex = 0;
  List<String> titles = ['All', 'Categories', 'Dialogs'];
  TextEditingController controller = TextEditingController(text: "  Search");

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CategoryLoaded) {
          if (state.cateList.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: context.screenHeight*0.06,
                    width: context.screenWidth,
                    child: CupertinoSearchTextField(
                      onChanged: (value) {
                        context.read<SearchCategoryBloc>().add(SearcCategoryLoadEvent(query: value));
                      },
                      onTap: () async{
                        await showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(),
                        );
                      },
                      controller: controller,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      style: const TextStyle(fontSize: 16,color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: context.screenHeight*0.05,
                      child: ListView.builder(

                        scrollDirection: Axis.horizontal,
                        itemCount: titles.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => print(index),
                            child: Text('   ${titles[index]}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: index == selectedIndex
                                        ? primaryColor:Colors.grey
                                )),
                          );
                        },
                      ),),
                  ),
                  Expanded(child: GridView.builder(

                    shrinkWrap: true,
                    // padding: EdgeInsets.all(15),
                    itemCount: state.cateList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        mainAxisExtent: context.screenHeight * 0.15,
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Container(
                          width: context.screenWidth / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,

                            border: Border.all(color: Colors.blueAccent,width: 3),),
                          child: Center(
                            child: Text(state.cateList[index].name.toString(),style: TextStyle(
                                color: primaryColor
                            )),
                          ),
                        ),
                        onTap: () {
                          context.read<SubCategoryBloc>().add(SubCategoryLoadEvent(rootId: state.cateList[index].sId));
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return SubCategoryScreen(
                                rootId: state.cateList[index].sId,
                                categoryName: state.cateList[index].name,
                              );
                            },
                          ));
                          print(state.cateList[index].sId);
                          print(state.cateList[index].createdAt);
                        },
                      );
                    },
                  ))
                ],
              ),
            );
          } else {
            return const Text('No Category Found');
          }
        } else {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
      },
    );
  }
}
