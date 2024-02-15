import 'package:flutter/material.dart';

import '../features/create_flow/create_flow_screen.dart';
import '../features/create_flow/flow_screen.dart';
import '../features/resources/maincategory_resources_screen.dart';
import 'add_resources_screen.dart';

class PopupMenuWidget extends StatefulWidget {
  String? categoryId;
  String? categoryName;
  PopupMenuWidget({required this.categoryId, required this.categoryName});
  @override
  _PopupMenuWidgetState createState() => _PopupMenuWidgetState();
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  String _selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        setState(() {
          _selectedOption = result;
        });
        // Handle the selected option here
        switch(result) {
          case 'add_resource':
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddResourceScreen(rootId: widget.categoryId!, whichResources: 1, categoryName: widget.categoryName!,)));
            break;
          case 'view_resource':
            Navigator.push(context, MaterialPageRoute(builder: (context) => MaincategoryResourcesList(rootId: widget.categoryId!, title: widget.categoryName! ,mediaType: "",)));
            break;
          case 'create_flow':
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFlowScreen(rootId: widget.categoryId!,categoryName: widget.categoryName!,)));
            break;
          case 'set_primary_flow':
            Navigator.push(context, MaterialPageRoute(builder: (context) => FlowScreen(rootId: widget.categoryName!,categoryname: widget.categoryId!,)));
            break;
          default:
          // Handle default case or do nothing
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'add_resource',
          child: Text('Add Resource'),
        ),
        PopupMenuItem<String>(
          value: 'view_resource',
          child: Text('View Resource'),
        ),
        PopupMenuItem<String>(
          value: 'create_flow',
          child: Text('Create Flow'),
        ),
        PopupMenuItem<String>(
          value: 'set_primary_flow',
          child: Text('Set Primary Flow'),
        ),
      ],
      child: Icon(Icons.more_vert),
    );
  }
}

