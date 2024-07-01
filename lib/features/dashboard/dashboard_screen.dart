import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:self_learning_app/features/login/login_screen.dart';
import 'package:self_learning_app/schedule/schedule.dart';
import 'package:self_learning_app/schedule/scheduleFlowsbook/scheduleFlowsBook.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';
import '../../widgets/pushnotification.dart';
import '../add_Dailog/dailog_screen.dart';
import '../add_Dailog/newDialog.dart';
import '../add_category/add_cate_screen.dart';
import '../category/category_screen.dart';
import 'bloc/dashboard_bloc.dart';
@pragma("vm:entry-point")

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print("Handling background message: ${message.messageId}");


  // Do something with the notification
}
void _handleNotificationClick({required BuildContext context, bool checkmsg = false}) {
  if (checkmsg==true) {
    print("context is not null");
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ScheduleFlowBook()));

    // await Navigator.of(FCMProvider._context!).push(...);

  } else if(context == null) {
    print("context is  null");
    debugPrint('Context is null, cannot navigate');
  }
}

Future<void> requestNotificationPermission() async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}
class DashBoardScreen extends StatefulWidget {
  bool msgstatus;
   DashBoardScreen({required this.msgstatus}) ;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    AllCateScreen(),
    AddCateScreen(),
    NewDialog(),
    // DailogScreen(),
    Schedule(),
  ];

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override

  firebaseFun({BuildContext? context}) async{
    print("This is th build context--$context");

    requestNotificationPermission();


    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    String? token = await _firebaseMessaging.getToken();

    print("fcm token is ${token}  break here");

    FirebaseMessaging.onMessage.listen((RemoteMessage message){


      print("Recieved message : ${message.notification?.body}");
      showSimpleNotification(Text(message.notification?.title??""),
          subtitle: (Text(message.notification?.body??"")),
          background: Colors.red.shade700,
          duration: Duration(seconds: 2)
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print("Recieved message : ${message.notification?.body}");
      showSimpleNotification(Text(message.notification?.title??""),
          subtitle: (Text(message.notification?.body??"")),
          background: Colors.red.shade700,
          duration: Duration(seconds: 4)
      );
      _handleNotificationClick(checkmsg: true, context: context!);

    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("tomessage $message");
        _handleNotificationClick(checkmsg: true, context: context!);
      }
    });



  }
  Future<void> requestNotificationPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }
  @override
  void initState() {
    // firebaseFun(context: context);
    super.initState();
    if(widget.msgstatus==true){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ScheduleFlowBook()));
      widget.msgstatus = false;
    }
    else{
      print("thanku");
    }

  }

  Widget build(BuildContext context) {

    return WillPopScope(
      child: BlocBuilder<DashboardBloc, int>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white70,

            appBar: AppBar(

              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset('assets/savant.png',),
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
                                print("hello logout");
                                await SharedPref().sClear();
                                await SharedPref().clear().then((value) {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const LoginScreen();
                                        },
                                      ), (route) => false);
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
              child: DashBoardScreen._widgetOptions.elementAt(state),
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
