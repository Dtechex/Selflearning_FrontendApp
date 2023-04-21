import 'package:flutter/material.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import '../features/add_media/add_video_screen.dart';
import '../features/subcategory/update_subcategory.dart';

class SubCategory1 extends StatefulWidget {
  final String subCateTitle;
  final List<String>  keyWords;
  final String rootId;
  final Color? color;

  const SubCategory1({Key? key, required this.subCateTitle, required this.rootId, this.color, required this.keyWords}) : super(key: key);

  @override
  State<SubCategory1> createState() => _SubCategory1State();
}

class _SubCategory1State extends State<SubCategory1> {
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
    return Scaffold(
        appBar: AppBar(title: Text(widget.subCateTitle),actions: [

          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UpdateSubCateScreen(rootId: widget.rootId,categoryTitle: widget.subCateTitle!,selectedColor: widget.color!,keyWords: widget.keyWords,);
            },));
          },icon: const Text('Edit'))
        ]),
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
                        return AddVideo(rootId: widget.rootId,);
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
                      children: const [
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
