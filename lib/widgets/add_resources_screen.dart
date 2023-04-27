import 'package:flutter/material.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

class AddResourceScreen extends StatelessWidget {
   AddResourceScreen({Key? key}) : super(key: key);


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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight/2.8,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: mediaIcons.length,
        itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0,top: 10),
          child: Container(
            padding: const EdgeInsets.only(top: 5,bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue[50]
            ),
            child: ListTile(
              title: Text(mediaTitle[index]),
              leading: Icon(mediaIcons[index]),trailing: SizedBox(
              width: context.screenWidth/4,
                child: Row(
                children: [
                  Icon(Icons.add_card),
                  SizedBox(
                    width: context.screenWidth*0.035,
                  ),
                  Icon(Icons.add),
                  Text('   12')
                ],
            ),
              )),
          ),
        );
      },),
    );
  }
}
