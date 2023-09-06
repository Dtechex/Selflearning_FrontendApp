

import 'package:flutter/material.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../../widgets/add_resources_screen.dart';

class FinalResourceScreen extends StatefulWidget {
  final String categoryName;
  //final List<String> keyWords;
  final String rootId;
  final Color? color;
  const FinalResourceScreen({super.key, required this.categoryName,
  required this.rootId,
  this.color,});

  @override
  State<FinalResourceScreen> createState() => _FinalResourceScreenState();
}

class _FinalResourceScreenState extends State<FinalResourceScreen> {
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
                  'Show All',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9),),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
          title: Text(widget.categoryName),
          ),
      body: AddResourceScreen(rootId: widget.rootId??'',whichResources: 1, categoryName: widget.categoryName??"Subcategory"),
    );
  }
}
