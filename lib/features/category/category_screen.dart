import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:self_learning_app/features/category/bloc/category_bloc.dart';
import 'package:self_learning_app/features/category/bloc/category_state.dart';
import 'package:self_learning_app/features/quick_add/data/bloc/quick_add_bloc.dart';
import 'package:self_learning_app/features/search_category/bloc/search_cat_bloc.dart';
import 'package:self_learning_app/features/subcategory/sub_cate_screen.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/widgets/add_resources_screen.dart';
import '../../utilities/shared_pref.dart';
import '../add_Dailog/bloc/get_dailog_bloc/get_dailog_bloc.dart';
import '../add_Dailog/create_dailog_screen.dart';
import '../add_Dailog/newDialog.dart';
import '../add_category/add_cate_screen.dart';
import '../dailog_category/dailog_cate_screen.dart';
import '../maincatbottomSheet/mainCategoryBottomSheet.dart';
import '../maincatbottomSheet/treeViewBottomSheet.dart';
import '../quick_add/quick_add_screen.dart';
import '../search_category/bloc/search_cate_event.dart';
import '../search_category/cate_search_delegate.dart';
import '../subcategory/bloc/sub_cate_bloc.dart';
import '../update_category/update_cate_screen.dart';

class AllCateScreen extends StatefulWidget {
  const AllCateScreen({Key? key}) : super(key: key);

  @override
  State<AllCateScreen> createState() => _AllCateScreenState();
}

class _AllCateScreenState extends State<AllCateScreen> {



  int selectedIndex = 0;
  List<String> titles = ['All Categories', 'Dialogs','QuickAdd List ', 'Create Folder'];
  TextEditingController controller = TextEditingController(text: "  Search");
  TextEditingController quickaddcontroller = TextEditingController();
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isLoading = true;
  void _showCustomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double dialogWidth = 0.5; // Set the desired width as a fraction of the screen width
        double dailogHight = 0.3;
        if (MediaQuery.of(context).size.width >= 600) {
          // If the screen width is at least 600, consider it as a tablet
          dialogWidth = 0.7; // Set the width to 50% for tablets
           dailogHight = 0.3;
        }
        if(MediaQuery.of(context).size.width<=600){
          dailogHight= 0.2;
          dialogWidth = 0.5;

        }
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * dialogWidth, // Set the dialog width based on the screen size
            height: MediaQuery.of(context).size.height * dailogHight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      String token =  SharedPref.getUserToken();
                      print("my token${token}");
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AddResourceScreen2(resourceId: '',whichResources: 0,number: true,);
                      },));                  // Add your resource handling logic here
                    },
                    child: Text("Add Resource"),
                  ),
                SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: () {
                      // Handle "Add Prompt" button click
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AddResourceScreen2(resourceId: '',whichResources: 0,number: false,);
                      },));

                    },
                    child: Text("Add Prompt"),
                  ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        );
      },
    );
  }
  static const List<Widget> _widgetOptions = <Widget>[
    AllCateScreen(),
    AddCateScreen(),
    NewDialog(),
    // DailogScreen(),
    Text(
      'Create Flow',
    ),
    Text(
      'Schedule',
    ),
  ];


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
  Color lightenRandomColor(Color color, double factor) {
    assert(factor >= 0 && factor <= 1.0);
    final int red = (color.red + (255 - color.red) * factor).round();
    final int green = (color.green + (255 - color.green) * factor).round();
    final int blue = (color.blue + (255 - color.blue) * factor).round();
    return Color.fromARGB(255, red, green, blue);
  }

  bool showCatOrDialog = false;

  Color generateRandomColor() {
    final Random random = Random();
    final int red = random.nextInt(256); // 0-255 for the red channel
    final int green = random.nextInt(256); // 0-255 for the green channel
    final int blue = random.nextInt(256); // 0-255 for the blue channel
    final originalColor = Color.fromARGB(255, red, green, blue);
    final pastelColor = lightenRandomColor(originalColor, 0.8); // 30% lighter

    return pastelColor;
  }  @override
  void initState() {
    context.read<CategoryBloc>().add(CategoryLoadEvent());
    super.initState();
  }
  AwesomeDialog showDeleteDailog(
      {required String dailogName,
        required String dailogId,
        required int index,
        required BuildContext context}) {
    return AwesomeDialog(
        context: context,
        animType: AnimType.BOTTOMSLIDE,
        dialogType: DialogType.QUESTION,
        body: Center(
          child: Text(
            'Are you sure\nYou want to delete\n$dailogName',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkOnPress: () {
          context.read<GetDailogBloc>().add(DeleteDailogEvent(
              dailogId: dailogId, index: index, dailogName: dailogName));
        },
        btnOkColor: Colors.red,
        closeIcon: Icon(Icons.close),
        btnCancelOnPress: () {},
        btnOkText: "Delete",
        btnOkIcon: Icons.delete)
      ..show();
  }
  @override
  Widget build(BuildContext context) {
    print("Category Screen");
    return Column(
      children: [
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlurryContainer(
                      elevation: 1,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      height:   context.screenHeight * 0.058,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Search..',style: TextStyle(
                              color: Colors.black
                          ),),
                          Icon(Icons.search)
                        ],
                      ),
                    ),
                  ),
                )
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(8.0), //<-- SEE HERE
            ),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddResourceScreen2(resourceId: '',whichResources: 0,number: true,);
                  },));
                  // _showCustomDialog();

                  //_displayTextInputDialog(context);
                },
                icon: const Icon(Icons.add)),
          ),
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
                    if(index ==0){
                      showCatOrDialog = false;
                    }
                    if(index == 1){
                      showCatOrDialog = true;
                   /*   Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const NewDialog();
                      },));*/
                    }
                    if(index==2) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const QuickTypeScreen();
                      },));
                    }
                    if(index == 3){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddDailogScreen()));

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
      showCatOrDialog?
      BlocProvider(
        create: (context) => GetDailogBloc()..add(HitGetDailogEvent()),
        child: BlocListener<GetDailogBloc, GetDailogState>(
          listener: (context, state) {
            if (state is DailogDeleteSuccessfully) {
              context.read<GetDailogBloc>().add(HitGetDailogEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  duration: Duration(seconds: 5),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: state.dailogname,
                    message: 'Successfully deleted!',

                    /// change contentType to ContentType.success, ContentType.warning, or ContentType.help for variants
                    contentType: ContentType.success,
                  ),
                ),
              );
            }

            // TODO: implement listener
          },
          child: BlocBuilder<GetDailogBloc,
              GetDailogState>(
            builder: (context, state) {
              print(state);

              print("Checking condion");
              if (state is GetDailogLoadingState) {
                print("Checking condion 2");

                return Container(
                  alignment: Alignment.center,

                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.6,
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                        color: Colors.black),
                  ),
                );
              }
              if (state is GetDailogSuccessState) {
                if (state.dailogList!.length == 0) {
                  print("Checking condion 3");

                  return Container(
                      height: MediaQuery.of(context)
                          .size
                          .height *
                          0.7,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        "Dailog is empty\nCreate Dailog",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ));
                } else {
                  print("Checking condion 4");

                  return Expanded(
                    child: CustomScrollView(
                      slivers : [
                        SliverToBoxAdapter(
                          child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context)
                              .size
                              .height *
                              0.8,
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 2.0),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                              MediaQuery.of(context)
                                  .size
                                  .width <
                                  600
                                  ? 2
                                  : MediaQuery.of(context)
                                  .size
                                  .width <
                                  1200
                                  ? 3
                                  : 6,
                              childAspectRatio: 3 / 2,
                            ),
                            itemCount:
                            state.dailogList!.length,
                            itemBuilder: (context, index) {
                              double containerHeight =
                              MediaQuery.of(context)
                                  .size
                                  .width <
                                  600
                                  ? 140.0
                                  : MediaQuery.of(context)
                                  .size
                                  .width <
                                  1200
                                  ? 200.0
                                  : 300.0;
                              double containerWidth =
                              MediaQuery.of(context)
                                  .size
                                  .width <
                                  600
                                  ? 150.0
                                  : MediaQuery.of(context)
                                  .size
                                  .width <
                                  1200
                                  ? 300.0
                                  : 300.0;
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10),
                                padding: EdgeInsets.zero,
                                height: 200,
                                width: 200,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DailogCategoryScreen(
                                                  promptList:
                                                  state
                                                      .promptList!,
                                                  resourceList:
                                                  state
                                                      .resourceList!,
                                                  dailoId: state
                                                      .dailogList![
                                                  index]
                                                      .dailogId,
                                                )));
                                  },
                                  child: Card(
                                      elevation: 2.0,
                                      color:
                                      generateRandomColor(),
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Text(state
                                                .dailogList![
                                            index]
                                                .dailogName),
                                          ),
                                          Align(
                                            alignment:
                                            Alignment
                                                .topRight,
                                            child:
                                            PopupMenuButton(
                                              icon: Icon(
                                                Icons
                                                    .more_vert,
                                                color: Colors
                                                    .red,
                                              ),
                                              itemBuilder:
                                                  (context) {
                                                return [
                                                  const PopupMenuItem(
                                                      value:
                                                      'update',
                                                      child: InkWell(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                            children: [
                                                              Icon(
                                                                Icons.update,
                                                                color: primaryColor,
                                                              ),
                                                              SizedBox(
                                                                width: 8.0,
                                                              ),
                                                              Text("Update"),
                                                            ],
                                                          ))),
                                                  const PopupMenuItem(
                                                      value:
                                                      'delete',
                                                      child: InkWell(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                            children: [
                                                              Icon(
                                                                Icons.delete,
                                                                color: primaryColor,
                                                              ),
                                                              SizedBox(
                                                                width: 8.0,
                                                              ),
                                                              Text("Delete"),
                                                            ],
                                                          )))
                                                ];
                                              },
                                              onSelected:
                                                  (String
                                              value) {
                                                switch (
                                                value) {
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
                                                    showDeleteDailog(
                                                        dailogName: state
                                                            .dailogList![
                                                        index]
                                                            .dailogName,
                                                        index:
                                                        index,
                                                        dailogId: state
                                                            .dailogList![
                                                        index]
                                                            .dailogId,
                                                        context:
                                                        context);

                                                    break;
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              );
                            },
                          ),
                      ),
                        ),

                        SliverToBoxAdapter(
                          child: SizedBox(height: 20,),
                        )
              ]
                    ),
                  );
                }
              }

              if (state is GetDailogErrorState) {
                print("Checking condion 5");

                return Center(
                  child: Text("Something went wrong"),
                );
              }
              print(state);
              print("Checking condion 6");

              return Center(
                child: Text("Something went wrong"),
              );
            },
          ),
        ),
      ):
      BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CategoryLoaded) {
            if (state.cateList.isNotEmpty) {
              return Expanded(
                child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: GridView.builder(
                  physics: ScrollPhysics(),
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
                            state.cateList[index].styles![1].value!))??primaryColor;
                      }
                    }

                    return GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(10.0), //<-- SEE HERE
                        ),
                        color: generateRandomColor(),
                        //padding: const EdgeInsets.all(8),
                        // decoration: BoxDecoration(
                        //
                        //   borderRadius: BorderRadius.circular(10),
                        //   color: generateRandomColor(),
                        //   border: Border.all(color: currentColor, width: 3),
                        //
                        // ),
                        elevation: 2,
                        child: Stack(
                          children: [
                            Center(
                              child: Text(state.cateList[index].name.toString(),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style:  TextStyle(color: primaryColor, fontWeight: FontWeight.w500,letterSpacing: 1)),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child:
                              PopupMenuButton(

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
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return UpdateCateScreen(
                                            rootId: state.cateList[index].sId,
                                            selectedColor: currentColor,
                                            categoryTitle: state.cateList[index].name,
                                            tags: state.cateList[index].keywords,
                                          );
                                        },
                                      ));
                                      break;
                                    case 'delete':
                                      context.read<CategoryBloc>().add(CategoryDeleteEvent(
                                        rootId: state.cateList[index].sId??'',
                                        context: context,
                                        catList: state.cateList,
                                        deleteIndex: index,
                                      ));
                                      break;
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true, // Set to true for a full-height bottom sheet

                          builder: (BuildContext context) {
                            return Container(
                              height: MediaQuery.of(context).size.height*0.7,
                              child: MainCatBottomSheet(categoryName: state.cateList[index].name.toString(),
                              rootId: state.cateList[index].sId,
                                color: Colors.red,
                                tags: state.cateList[index].keywords,
                              ),
                            );

                              // MainCatBottomSheet();
                          },
                        );

/*
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
*/
                      },
                      onLongPress: () {

                      },
                    );
                  },
                ),
              ),);
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
//// 5 april