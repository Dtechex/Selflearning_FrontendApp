import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/category/bloc/category_state.dart';
import 'package:self_learning_app/features/subcategory/create_subcate_screen.dart';
import 'package:self_learning_app/subcate1.1/sub_category_1.1_screen.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';
import 'package:self_learning_app/widgets/add_resources_screen.dart';
import '../../subcate1.1/bloc/sub_cate1_bloc.dart';
import '../../subcate1.1/bloc/sub_cate1_event.dart';
import '../../subcate1.1/bloc/sub_cate1_state.dart';
import '../category/bloc/category_bloc.dart';
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


  @override
  void initState() {
    context.read<SubCategoryBloc>().add(SubCategoryLoadEvent(rootId: widget.rootId));
    super.initState();
  }

  Future<void>savecatid()async{
    SharedPref().savesubcateId(widget.rootId!);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          floatingActionButton: SizedBox(
            height: context.screenHeight * 0.1,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return CreateSubCateScreen(
                        rootId: widget.rootId,
                      );
                    },
                  ));
                },
                child: Row(
                  children: const [
                    Text(
                      '    Create\n Subcatgory',
                      style: TextStyle(fontSize: 7),
                    ),
                  ],
                ),
              ),
            ),
          ),
          appBar: AppBar(
              bottom:  TabBar(
                tabs: [
                Column(
                  children: [
                    Tab(icon: Icon(Icons.list_alt,)),
                    Text('Subcategory list')
                  ],
                ),
                  Column(
                    children: [
                      Tab(icon: Icon(Icons.perm_media,)),
                      Text('Resources')
                    ],
                  ),
                ],
              ),
              title: Text(widget.categoryName??"Subcategory"), actions: [
            IconButton(
                onPressed: () {
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
                },
                icon: Row(
                  children: const [
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ))
          ]),
          body: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TabBarView(
              children: [
                Column(
                  children: [  const SizedBox(
                    height: 20,
                  ),
                    SizedBox(
                      width: context.screenWidth,
                      height: context.screenHeight * 0.08,
                      child: CupertinoSearchTextField(
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        placeholder: 'Search',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                    ),],
                ),
                AddResourceScreen(rootId: '',),

              ],
            ),
          )),
    );
  }
}
