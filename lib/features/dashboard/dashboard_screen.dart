import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/login/login_screen.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';

import '../category/category_screen.dart';
import '../login/bloc/login_event.dart';
import 'bloc/dashboard_bloc.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    AllCateScreen(),
    Text(
      'Index 1: Create Categ',
      style: optionStyle,
    ),
    Text(
      'Index 2: Create SubCategory',
      style: optionStyle,
    ),
    Text(
      'Index 3: Create Flow',
      style: optionStyle,
    ),
    Text(
      'Index 3: Schedule',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, int>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () async {
                    await SharedPref().clear().then((value) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) {
                          return const LoginScreen();
                        },
                      ), (route) => true);
                    });
                  },
                  icon: const Icon(Icons.logout))
            ],
            centerTitle: true,
            title: Text('DashBoard'),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            enableFeedback: true,
            showUnselectedLabels: true,
            selectedItemColor: Colors.white,
            elevation: 0,
            currentIndex: state,
            onTap: (value) {
              context.read<DashboardBloc>().ChangeIndex(value);
            },
            unselectedItemColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.format_indent_decrease, color: Colors.white),
                  label: '     Create \n   Categories',
                  backgroundColor: primaryColor),
              BottomNavigationBarItem(
                  icon: Icon(Icons.create),
                  label: '       Create \n   Subcategories',
                  backgroundColor: primaryColor),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: 'Create Dailogs',
                  backgroundColor: primaryColor),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Create Flow',
                  backgroundColor: primaryColor),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_sharp),
                  label: 'Schedule',
                  backgroundColor: primaryColor),
            ],
          ),
          body: Center(
            child: _widgetOptions.elementAt(state),
          ),
        );
      },
    );
  }
}
