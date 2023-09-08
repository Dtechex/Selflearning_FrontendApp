

import 'package:flutter/material.dart';

class ShowPromptsScreen extends StatefulWidget {
  const ShowPromptsScreen({super.key});

  @override
  State<ShowPromptsScreen> createState() => _ShowPromptsScreenState();
}

class _ShowPromptsScreenState extends State<ShowPromptsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Show Prompts'),),
      //body: ReorderableListView(children: children, onReorder: onReorder),
    );
  }
}
