import 'package:flutter/material.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/widgets/add_media_widget.dart';

import '../add_media/add_video_screen.dart';

class SubCategory1 extends StatefulWidget {
  final String? subCateTitle;

  const SubCategory1({Key? key, this.subCateTitle}) : super(key: key);

  @override
  State<SubCategory1> createState() => _SubCategory1State();
}

class _SubCategory1State extends State<SubCategory1> {
  List<String> mediaTitle = [
    'Record Video',
    'Record Audio',
    'Take Picture',
    'Enter Text'
  ];

  List<IconData> mediaIcons = [
    Icons.video_call_outlined,
    Icons.audio_file_outlined,
    Icons.camera,
    Icons.text_increase
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.subCateTitle!)),
        body: ListView.builder(
          itemCount: mediaTitle.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                int index = 0;
                switch (index) {
                  case 0:
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AddVideo();
                      },));

                    }
                    break;

                  case 1:
                    {
                      print("Good");
                    }
                    break;

                  case 2:
                    {
                      print("Fair");
                    }
                    break;

                  case 3:
                    {
                      print("Poor");
                    }
                    break;

                  default:
                    {
                      print("Invalid choice");
                    }
                    break;
                }
              },
              child: Card(
                elevation: 0.3,
                child: ListTile(
                  leading: Icon(mediaIcons[index]),
                  trailing: SizedBox(
                    width: context.screenWidth / 3.5,
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.add_card),
                        SizedBox(
                          width: 20,
                        ),
                        Text('12')
                      ],
                    ),
                  ),
                  title: Text(mediaTitle[index]),
                ),
              ),
            );
          },
        ));
  }
}
