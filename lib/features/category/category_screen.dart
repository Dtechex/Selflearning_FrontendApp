import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/category/bloc/category_bloc.dart';
import 'package:self_learning_app/features/category/bloc/category_state.dart';
import 'package:self_learning_app/features/quick_add/data/bloc/quick_add_bloc.dart';
import 'package:self_learning_app/features/search_category/bloc/search_cat_bloc.dart';
import 'package:self_learning_app/features/subcategory/sub_cate_screen.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/widgets/add_resources_screen.dart';
import '../quick_add/quick_add_screen.dart';
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
  List<String> titles = ['All', 'Categories', 'Dialogs','QuickAdd List '];
  TextEditingController controller = TextEditingController(text: "  Search");
  TextEditingController quickaddcontroller = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Create Quick Type'),
            content: TextField(
              controller: quickaddcontroller,
              decoration: const InputDecoration(hintText: "Title"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: BlocConsumer<QuickAddBloc, QuickAddState>(
                  builder: (context, state) {
                    if (state is QuickAddInitial) {
                      return const Text('Add');
                    } else if (state is QuickAddLoadingState) {
                      return const CircularProgressIndicator();
                    } else if (state is QuickAddLoadedState) {
                      return const Text('Add');
                    }
                    return const Text('Add');
                  },
                  listener: (context, state) {
                    if (state is QuickAddLoadedState) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(content: Text('Qick Type Added')),
                        );
                      quickaddcontroller.text='';
                      Navigator.pop(context);

                    } else if (state is QuickAddErrorState) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(content: Text('Oops something went wrong..')),
                        );
                    }
                  },
                ),
                onPressed: () {
                 // context.read<QuickAddBloc>().add(ButtonPressedEvent(title: quickaddcontroller.text));
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    context.read<CategoryBloc>().add(CategoryLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Expanded(
            child: SizedBox(
                child: GestureDetector(

                  onTap: () async{
                    await showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    height:   context.screenHeight * 0.058,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)
                    ),

                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('    Search..',style: TextStyle(
                          color: Colors.black.withOpacity(0.5)
                      ),),
                    ),
                  ),
                )
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddResourceScreen2(resourceId: '',whichResources: 0,);
                },));
                //_displayTextInputDialog(context);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          height: context.screenHeight * 0.05,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: titles.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  setState(() {
                    selectedIndex=index;
                    if(index==3) {

                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const QuickTypeScreen();
                      },));
                    }
                  });
                },
                child: Text('${titles[index]}    ',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: index == selectedIndex
                            ? primaryColor
                            : Colors.grey)),
              );
            },
          ),
        ),
      ),
      BlocBuilder<CategoryBloc, CategoryState>(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    GridView.builder(
                      shrinkWrap: true,
                      // padding: EdgeInsets.all(15),
                      itemCount: state.cateList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: context.screenHeight * 0.15,
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        Color currentColor = primaryColor;

                        if (state.cateList[index].styles!.isNotEmpty) {
                          if (state.cateList[index].styles![1].value!.length != 10) {
                            currentColor = primaryColor;
                          } else {
                            currentColor = Color(int.parse(
                                state.cateList[index].styles![1].value!));
                          }
                        }

                        return GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                              border: Border.all(color: currentColor, width: 3),
                            ),
                            child: Center(
                              child: Text(state.cateList[index].name.toString(),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(color: primaryColor)),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return SubCategoryScreen(
                                  tags: state.cateList[index].keywords,
                                  color: Color(
                                    int.parse(
                                        state.cateList[index].styles![1].value!),
                                  ),
                                  rootId: state.cateList[index].sId,
                                  categoryName: state.cateList[index].name,
                                );
                              },
                            ));
                          },
                        );
                      },
                    )
                  ],
                ),
              );
            } else {
              return SizedBox(height: context.screenHeight/2,child: const Center(child: Text('No Categories Found')),);
            }
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      )
    ],);
  }
}
