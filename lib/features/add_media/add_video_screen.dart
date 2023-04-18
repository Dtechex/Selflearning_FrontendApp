import 'package:flutter/material.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

class AddVideo extends StatefulWidget {
  const AddVideo({Key? key}) : super(key: key);

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Record video')),
      body: Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: context.screenHeight * 0.2,
              width: context.screenWidth,
              child: TextField(
                decoration: InputDecoration(hintText: 'title'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                borderRadius: BorderRadius.circular(10)
              ),
              height: context.screenHeight*0.25,
              width: context.screenWidth,
              child: Center(
                child: Icon(Icons.video_call_outlined,size: context.screenWidth/2.5),
              ),
            )
          ],
        ),
      )
    );
  }
}
