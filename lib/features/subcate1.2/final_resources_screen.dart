

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/subcate1.2/update_subcate1.2.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../../utilities/colors.dart';
import '../../widgets/add_resources_screen.dart';
import '../create_flow/bloc/create_flow_screen_bloc.dart';
import '../create_flow/create_flow_screen.dart';
import '../create_flow/flow_screen.dart';
import '../resources/subcategory_resources_screen.dart';
import '../subcategory/primaryflow/primaryflow.dart';

class FinalResourceScreen extends StatefulWidget {
  final String categoryName;
  final List<String> keyWords;
  final String rootId;
  final Color? color;
  const FinalResourceScreen({super.key, required this.categoryName,
  required this.rootId,
  this.color, required this.keyWords,});

  @override
  State<FinalResourceScreen> createState() => _FinalResourceScreenState();
}

class _FinalResourceScreenState extends State<FinalResourceScreen> {

  CreateFlowBloc _flowBloc = CreateFlowBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _flowBloc.add(LoadAllFlowEvent(catID: widget.rootId));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: SizedBox(height: context.screenHeight*0.1,
        child: FittedBox(
          child: ElevatedButton(
            onPressed: () {
              /*Navigator.push(context, MaterialPageRoute(
                builder: (context) =>
                    Subcategory2ResourcesList(rootId: widget.rootId,
                        mediaType: '',
                        title: widget.subCateTitle),));
*/
            },
            child: Row(
              children: [
                Text(
                  'View All',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9),),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
/*
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider<CreateFlowBloc>.value(value: _flowBloc, child: CreateFlowScreen(rootId: widget.rootId!)),));
              },),
*/
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PrimaryFlow(CatId: widget.rootId.toString(),flowId: "0",)));
                },
                icon: Icon(Icons.play_circle)
            ),

            PopupMenuButton(
              icon: Icon(Icons.more_vert,color: Colors.white,),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                      value: 'viewResources',
                      child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.add_circle_rounded, color: primaryColor,),
                              SizedBox(width: 8.0,),
                              Text("View Resources"),
                            ],
                          ))
                  ),
                  const PopupMenuItem(
                      value: 'createFlow',
                      child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.add_circle_rounded, color: primaryColor,),
                              SizedBox(width: 8.0,),
                              Text("Create New Flow"),
                            ],
                          ))
                  ),

                  const PopupMenuItem(
                      value: 'startFlow',
                      child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.play_circle, color: primaryColor,),
                              SizedBox(width: 8.0,),
                              Text("Start Flow"),
                            ],
                          ))
                  ),
                  const PopupMenuItem(
                      value: 'edit',
                      child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.edit, color: primaryColor,),
                              SizedBox(width: 8.0,),
                              Text("Edit Category"),
                            ],
                          ))
                  )
                ];
              },
              onSelected: (String value) {
                switch(value){
                  case 'viewResources':
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          SubcategoryResourcesList(rootId: widget.rootId,
                              mediaType: '',
                              title: widget.categoryName),));
                    break;
                  case 'edit':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return UpdateSubCate2Screen(
                              rootId: widget.rootId,
                              selectedColor: widget.color!,
                              categoryTitle: widget.categoryName,
                              keyWords: widget.keyWords,);
                          },));
                    break;
                  case 'schedule':

                    break;
                  case 'startFlow':
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return FlowScreen(
                          rootId: widget.rootId!,
                        );
                      },
                    ));
                    break;
                  case 'createFlow':
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return CreateFlowScreen(
                              rootId: widget.rootId!
                          );
                        }));
                    break;
                }
              },
            ),
          ]

      ),
      body: AddResourceScreen(rootId: widget.rootId??'',whichResources: 1, categoryName: widget.categoryName??"Subcategory"),
    );
  }
}
