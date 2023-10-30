import 'package:flippy/constants/parameters.dart';
import 'package:flippy/controllers/flipperController.dart';
import 'package:flippy/flipper/dragFlipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DailogPrompt extends StatefulWidget {
  String promptTitle;
  String side1contentTitle;
  String side2contentTitle;

  DailogPrompt({Key? key, required this.promptTitle, required this.side1contentTitle, required this.side2contentTitle}) : super(key: key);

  @override
  State<DailogPrompt> createState() => _DailogPromptState();
}

class _DailogPromptState extends State<DailogPrompt> {
  late FlipperController controller;

  @override
  void initState() {
    controller = FlipperController(
      dragAxis: DragAxis.both,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flippy Example"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DragFlipper(
              front:  FrontWidget(title:widget.promptTitle, side1Content: widget.side1contentTitle, ),
              back:  BackWidget(side2Title: widget.side2contentTitle),
              controller: controller,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              gradient: const LinearGradient(colors: [
                Color(0xffD2E0FB),
                Color(0xffD0E7D2),
              ]),
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              height: 210,
            ),

          ],
        ),
      ),
    );
  }
}

class FrontWidget extends StatelessWidget {
  String title;
  String side1Content;
   FrontWidget({Key? key, required this.title, required this.side1Content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, color: Colors.red,fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20,),
          Container(
            width: double.infinity,
            height: 100,
            alignment: Alignment.center,
            child: Text(
              side1Content,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class BackWidget extends StatelessWidget {
  String side2Title;
   BackWidget({Key? key, required this.side2Title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        side2Title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );

  }
}