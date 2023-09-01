import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/resources/subcategory_resources_screen.dart';
import 'package:self_learning_app/features/subcate1.2/bloc/sub_cate2_bloc.dart';
import 'package:self_learning_app/features/subcategory/create_subcate_screen.dart';
import 'package:self_learning_app/features/subcategory/update_subcategory.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../../utilities/colors.dart';
import '../../widgets/add_resources_screen.dart';
import '../subcate1.2/sub_category_1.2_screen.dart';
import 'bloc/sub_cate1_bloc.dart';
import 'bloc/sub_cate1_event.dart';
import 'bloc/sub_cate1_state.dart';
import 'create_subcate1_screen.dart';


class SubCategory1Screen extends StatefulWidget {
  final String subCateTitle;
  final List<String>  keyWords;
  final String rootId;
  final Color? color;

  const SubCategory1Screen({Key? key, required this.subCateTitle, required this.rootId, this.color, required this.keyWords}) : super(key: key);

  @override
  State<SubCategory1Screen> createState() => _SubCategory1ScreenState();
}

class _SubCategory1ScreenState extends State<SubCategory1Screen> {
  List<String> mediaTitle = [
    'Take Picture',
    'Record Video',
    'Record Audio',
    'Enter Text'
  ];

  List<IconData> mediaIcons = [
    Icons.camera,
    Icons.video_call_outlined,
    Icons.audio_file_outlined,
    Icons.text_increase
  ];
  int _tabIndex = 0;


  @override
  void initState() {
    context.read<SubCategory1Bloc>().add(SubCategory1LoadEvent(rootId: widget.rootId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 2,
      child: Scaffold(
          floatingActionButton: SizedBox(height: context.screenHeight*0.1,
            child: FittedBox(
              child: ElevatedButton(
                onPressed: () {

                  if(_tabIndex == 0) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          SubcategoryResourcesList(rootId: widget.rootId,
                              mediaType: '',
                              title: widget.subCateTitle),));
                  }else {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) {
                      return CreateSubCate1Screen(rootId: widget.rootId,);
                    },));
                  }

                },
                child: Row(
                  children: [
                    Text(
                      _tabIndex==0?'Create Flow':'Create\n Category',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 9),),
                  ],
                ),
              ),
            ),
          ),
          appBar: AppBar(
              bottom:  TabBar(
                tabs: [
                  Column(
                    children: const [
                      Tab(icon: Icon(Icons.perm_media,)),
                      Text('Resources')
                    ],
                  ),
                  Column(
                    children: const [
                      Tab(icon: Icon(Icons.list_alt,)),
                      Text('Subcategory list')
                    ],
                  ),
                ],
                onTap: (value) {
                  setState(() {
                    _tabIndex = value;
                  });
                },
                isScrollable: false,
              ),
              title: Text(widget.subCateTitle),actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UpdateSubCateScreen(rootId: widget.rootId,selectedColor: widget.color!,categoryTitle: widget.subCateTitle,keyWords: widget.keyWords,);
                  },));

                }, icon: Row(
              children: const [
                Text('Edit',style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),

              ],
            ))
          ]),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              //tab1
              AddResourceScreen(rootId: widget.rootId??'',whichResources: 1, categoryName: widget.subCateTitle,),

              //tab2
              Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: context.screenWidth,
                    height: context.screenHeight*0.08,
                    child:  CupertinoSearchTextField(
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      placeholder: 'Search',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<SubCategory1Bloc,SubCategory1State>(
                    builder: (context, state) {
                      if(state is SubCategory1Loading){
                        return const CircularProgressIndicator();
                      }else if( state is SubCategory1Loaded){
                        return
                          state.cateList.isEmpty?  SizedBox(
                            height: context.screenHeight/2,
                            child: const Center(child: Text('No Subcategory added',style: TextStyle(
                                fontSize: 19,fontWeight: FontWeight.bold
                            ),),),):
                          ListView.builder(
                            itemCount: state.cateList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return SubCategory2Screen(subCateTitle: state.cateList[index].name!,rootId: state.cateList[index].sId!,color: widget.color,keyWords: state.cateList[index].keywords!,);
                                  },));
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Color(int.parse(state.cateList[index].styles![1].value!)),width: 3),
                                          color: Colors.transparent
                                      ),
                                      padding: const EdgeInsets.only(left: 10),
                                      child: ListTile(title: Text(state.cateList[index].name.toString(),style: const TextStyle(
                                          color: primaryColor
                                      ),)),
                                    )),

                              );
                            },);
                      }
                      return const SizedBox();
                    },),
                ],),
              ),
            ],
          )
      ),
    );
  }
}
