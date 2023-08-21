import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/subcate1.2/bloc/sub_cate2_bloc.dart';
import 'package:self_learning_app/features/subcate1.2/bloc/sub_cate2_event.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../category/bloc/category_bloc.dart';
import '../dashboard/dashboard_screen.dart';
import '../subcate1.1/bloc/sub_cate1_bloc.dart';
import '../subcate1.1/bloc/sub_cate1_event.dart';
import '../subcate1.1/bloc/sub_cate1_state.dart';
import '../subcategory/bloc/sub_cate_bloc.dart';
import '../subcategory/bloc/sub_cate_event.dart';
import '../subcategory/bloc/sub_cate_state.dart';
import 'bloc/quick_add_bloc.dart';

class QuickAddImportScreen extends StatefulWidget {
  final String title;
  final String quickAddId;
  final String  mediaType;
  const QuickAddImportScreen(
      {Key? key, required this.title, required this.quickAddId,required this.mediaType})
      : super(key: key);

  @override
  State<QuickAddImportScreen> createState() => _QuickAddImportScreenState();
}

class _QuickAddImportScreenState extends State<QuickAddImportScreen> {
  @override
  void initState() {
    context.read<QuickImportBloc>().add(LoadQuickTypeEvent());
    context.read<SubCategory1Bloc>().add(SubCategory1LoadEmptyEvent());
    super.initState();
  }

  String ddvalue = '';
  String subCateId = '';
  bool isFirstTime=true;



  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox( height: 20,),
            const Text(
              'Save as Category',
              style: TextStyle(
                  fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () {
                    context.showNewDialog(AlertDialog(title: const Text('Are you sure you want to save as category.'),actions: [
                      ElevatedButton(onPressed: () {
                        context.read<QuickImportBloc>().add(
                            ButtonPressedEvent(
                              mediaType: widget.mediaType,
                                title: widget.title,
                                quickAddId: widget.quickAddId));
                        context.read<CategoryBloc>().add(CategoryLoadEvent());
                      }, child: const Text('Save')),
                      ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Cancel'))
                    ],));

                  },
                  child: const Text('Save as Category')),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocConsumer<QuickImportBloc, QuickImportState>(
              listener: (context, state) {
                if (state is QuickImportSuccessfullyState) {
                  context.showSnackBar(
                      const SnackBar(content: Text("added succesfuuly")));
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return const DashBoardScreen();
                    },
                  ), (route) => false);
                }
              },
              builder: (context, state) {
                if (state is QuickImportLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is QuickImportLoadedState) {
                  if (state.list!.isNotEmpty) {
                    if(isFirstTime) {
                      context.read<SubCategoryBloc>().add(SubCategoryLoadEvent(rootId: state.list!.first.sId));
                    }
                    print(state.list!.first.sId);
                    return Container(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Save as Subcategory.',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField2(
                                  hint: const Text(
                                    'Choose Category',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey,
                                    contentPadding: const EdgeInsets.only(
                                        left: 0, top: 15, bottom: 15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  key: UniqueKey(),
                                  value: state.value,
                                  items: state.list!.map<DropdownMenuItem<String?>>((e) {

                                    return DropdownMenuItem<String>(
                                      value: e.sId,
                                      child: SizedBox(
                                          width: context.screenWidth/1.5,
                                          child: Text(e.name!,overflow: TextOverflow.ellipsis,)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    isFirstTime=false;
                                    context.read<QuickImportBloc>().add(ChangeDropValue(
                                        title: value, list: state.list));
                                    context.read<SubCategoryBloc>().add(SubCategoryLoadEvent(rootId: value));
                                  },
                                ),
                              ),
                              GestureDetector(child: Icon(Icons.add_circle,size: 30,),onTap: () {
                                print(state.value??state.list!.first.sId??'');
                                context.showNewDialog(AlertDialog(title: const Text('Are you sure you want to save as Subcategory.'),actions: [
                                  ElevatedButton(onPressed: () {

                                    context.read<QuickImportBloc>().add(
                                        ButtonPressedEvent(
                                            quickAddId: widget.quickAddId,
                                          mediaType: widget.mediaType,
                                            title: widget.title,
                                            rootId: state.value??state.list!.first.sId??''));
                                    context.read<CategoryBloc>()
                                        .add(CategoryLoadEvent());
                                  }, child: const Text('Save')),
                                  ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Cancel'))
                                ],));
                              },)

                            ],
                          ),

                          SizedBox(
                            height: context.screenHeight * 0.1,
                          ),
                          /// sub category Bloc start here
                          BlocBuilder<SubCategoryBloc, SubCategoryState>(
                            builder: (context, Subcatestate) {

                              print(Subcatestate);
                              if (Subcatestate is SubCategoryLoaded) {

                                if(Subcatestate.cateList.isNotEmpty){
                                  // if(isFirstTime) {
                                  //   context.read<SubCategory1Bloc>().add(SubCategory1LoadEvent(rootId: state.list!.first.sId));
                                  // }
                                }
                                return Subcatestate.cateList.isEmpty
                                    ? const SizedBox()
                                    : Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: DropdownButtonFormField2(
                                                  value:Subcatestate.ddValue,
                                                  hint: const Text(
                                                    'Choose SubCategory',
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                  decoration: InputDecoration(
                                                    fillColor: Colors.grey,
                                                    contentPadding: const EdgeInsets.only(
                                                        left: 0, top: 15, bottom: 15),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(15),
                                                    ),
                                                  ),
                                                  key: UniqueKey(),
                                                  items: Subcatestate.cateList
                                                      .map<DropdownMenuItem<String?>>(
                                                          (e) {
                                                    return DropdownMenuItem<String>(
                                                      value: e.sId,
                                                      child: SizedBox(
                                                        width: context.screenWidth/1.5,
                                                          child: Text(e.name!,overflow: TextOverflow.ellipsis,)),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    print(value);
                                                   context.read<SubCategoryBloc>().add(SubCateChangeDropValueEvent(subCateId: value,list: Subcatestate.cateList));
                                                    context.read<SubCategory1Bloc>().add(SubCategory1LoadEvent(rootId: value));
                                                  },
                                                ),
                                              ),
                                              GestureDetector(child: Icon(Icons.add_circle,size: 30),onTap: () {
                                                print(Subcatestate.ddValue??state.list!.first.sId);
                                                context.showNewDialog(AlertDialog(title: Text('Are you sure you want to save as Subcategory.'),actions: [
                                                  ElevatedButton(onPressed: () {
                                                    context.read<QuickImportBloc>().add(
                                                        ButtonPressedEvent(
                                                            quickAddId: widget.quickAddId,
                                                            mediaType: widget.mediaType,
                                                            title: widget.title,
                                                            rootId: Subcatestate.ddValue??state.list!.first.sId));
                                                    context.read<CategoryBloc>()
                                                        .add(CategoryLoadEvent());
                                                  }, child: const Text('Save')),
                                                  ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Cancel'))
                                                ],));



                                              },)
                                            ],
                                          ),
                                        ],
                                      );
                              }
                              return const SizedBox();
                            },
                          ),

                          SizedBox(
                            height: context.screenHeight * 0.1,
                          ),

                          ///sub Category 1 DropDown
                          BlocBuilder<SubCategory1Bloc,SubCategory1State>(
                            builder: (context, subState1) {
                              print(subState1);
                              print('subState1');
                              if( subState1 is SubCategory1Loaded){
                                return subState1.cateList.isEmpty? const SizedBox():
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: DropdownButtonFormField2(
                                              value:subState1.ddValue,
                                              hint: const Text(
                                                'Choose SubCategory',
                                                style: TextStyle(color: Colors.black),
                                              ),
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey,
                                                contentPadding: const EdgeInsets.only(
                                                    left: 0, top: 15, bottom: 15),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(15),
                                                ),
                                              ),
                                              key: UniqueKey(),
                                              items: subState1.cateList
                                                  .map<DropdownMenuItem<String?>>(
                                                      (e) {
                                                    return DropdownMenuItem<String>(
                                                      value: e.sId,
                                                      child: SizedBox(
                                                          width: context.screenWidth/1.5,
                                                          child: Text(e.name!,overflow: TextOverflow.ellipsis,)),
                                                    );
                                                  }).toList(),
                                              onChanged: (value) {
                                                print(value);
                                                context.read<SubCategory1Bloc>().add(DDValueSubCategoryChanged(ddValue: value,cateList: subState1.cateList));
                                                context.read<SubCategory2Bloc>().add(SubCategory2LoadEvent(rootId: value));
                                              },
                                            ),
                                          ),
                                          GestureDetector(child: Icon(Icons.add_circle,size: 30),onTap: () {
                                          print( subState1.ddValue??state.list!.first.sId);
                                            context.showNewDialog(AlertDialog(title: Text('Are you sure you want to save as Subcategory.'),actions: [
                                              ElevatedButton(onPressed: () {
                                                context.read<QuickImportBloc>().add(
                                                    ButtonPressedEvent(
                                                        quickAddId: widget.quickAddId,
                                                        mediaType: widget.mediaType,
                                                        title: widget.title,
                                                        rootId: subState1.ddValue??state.list!.first.sId));
                                                context.read<CategoryBloc>()
                                                    .add(CategoryLoadEvent());
                                              }, child: const Text('Save')),
                                              ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Cancel'))
                                            ],));



                                          },)
                                        ],
                                      ),
                                    ],
                                  );

                              }
                              return const SizedBox();
                            },),
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
            ),
          ],
        ));
  }
}
