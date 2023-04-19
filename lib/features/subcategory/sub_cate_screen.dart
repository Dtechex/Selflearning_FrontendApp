import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/category/bloc/category_bloc.dart';
import 'package:self_learning_app/features/category/bloc/category_state.dart';
import 'package:self_learning_app/features/subcategory/create_subcate_screen.dart';
import 'package:self_learning_app/features/subcategory/sub_category_1.1_screen.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../update_category/update_cate_screen.dart';
import 'bloc/sub_cate_bloc.dart';
import 'bloc/sub_cate_state.dart';

class SubCategoryScreen extends StatefulWidget {
  final Color? color;
  final String? categoryName;
  final String? rootId;


  const SubCategoryScreen({Key? key, this.categoryName, this.rootId, this.color,}) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreateSubCateScreen(rootId: widget.rootId,);
          },));

        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
          title: Text(widget.categoryName!),actions: [
        IconButton(
            onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UpdateCateScreen(rootId: widget.rootId,selectedColor: widget.color,categoryTitle: widget.categoryName,);
          },));

        }, icon: Icon(Icons.edit))
      ]),
      body: Container(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: context.screenWidth,
              height: context.screenHeight*0.08,
              child:  CupertinoSearchTextField(
                backgroundColor: Colors.grey.withOpacity(0.2),
                placeholder: 'Search',
                style: TextStyle(),

              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<SubCategoryBloc,SubCategoryState>(
              builder: (context, state) {
             if(state is CategoryLoading){
               return const CircularProgressIndicator();
             }else if( state is SubCategoryLoaded){
               return
               state.cateList.isEmpty? Center(child: Text('No Subcategory added'),):
               Expanded(child: ListView.builder(
                 itemCount: state.cateList.length,
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   return GestureDetector(
                     onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) {
                         return SubCategory1(subCateTitle: state.cateList[index].name,);
                       },));
                     },
                     child: Padding(
                         padding: EdgeInsets.all(10),
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
                 },));
             }
             return SizedBox();
            },)
          ],
        ),
      )
    );
  }
}
