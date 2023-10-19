import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/login/login_screen.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';
import '../add_Dailog/dailog_screen.dart';
import '../add_category/add_cate_screen.dart';
import '../category/category_screen.dart';
import 'bloc/dashboard_bloc.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    AllCateScreen(),
    AddCateScreen(),
    DailogScreen(),
    Text(
      'Create Flow',
      style: optionStyle,
    ),
    Text(
      'Schedule',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: BlocBuilder<DashboardBloc, int>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset('assets/icon.png',),
                  ),
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      context.showNewDialog(AlertDialog(
                        title: const Text(
                          'Are you sure you want to logout?',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        actions: [
                          MaterialButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              shape: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor)
                              ),
                              color: Colors.white,
                              textColor: primaryColor,
                              child: Text('Cancel')),
                          ElevatedButton(
                              onPressed: () async {
                                await SharedPref().clear().then((value) {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const LoginScreen();
                                        },
                                      ), (route) => true);
                                });
                              },
                              child: Text('Logout')),
                        ],
                      ));
                    },
                    icon: const Icon(Icons.logout))
              ],
              centerTitle: true,
              title: const Text('DashBoard'),
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
                    icon: Icon(Icons.home),
                    label: 'Home',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(Icons.create),
                    label: '   Create \n Category',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    label: '  Create \n Dailogs',
                    backgroundColor: primaryColor),
                /*BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: 'Create \n Flow',
                    backgroundColor: primaryColor),*/
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
      ),
      onWillPop: () {
        return Future.value(true);
      },
    );
  }
}
