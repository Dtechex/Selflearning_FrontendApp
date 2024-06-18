import 'dart:async';
import 'dart:math';

import 'package:fade_out_particle/fade_out_particle.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';

import '../features/login/login_screen.dart';
import '../utilities/shared_pref.dart';
import '../widgets/localNotification.dart';
import '../widgets/pushnotification.dart';
@pragma("vm:entry-point")

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print("Handling background message: ${message.messageId}");


    // Do something with the notification
  }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  bool msg = false;
  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    final notificationData = message.data;
    if (context != null) {
      print("context is not null");
      // await Navigator.of(FCMProvider._context!).push(...);

      Navigator.pushNamed(context, '/second');
    } else if(context == null) {
      print("context is  null");
      debugPrint('Context is null, cannot navigate');
    }
  }

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
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("tomessage $message");
        msg = true;
        _handleNotificationClick(context!, message);
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

  void methodcheck() async{
   // await firebaseFun(context: context);
    // _messagingService
    //     .init(context);
    Future.delayed(Duration(seconds: 3), () {
      SharedPref().getToken().then((token) {
        if (token != null) {
          print(token);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashBoardScreen(msgstatus: msg,)),
          );

        } else {
          setState(() {
            // Navigate to LoginScreen if token does not exist
            // You need to have a navigator to navigate to different screens
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    methodcheck();
  }

  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(255, 100, 90, 1), // Mixture of pink and red
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300, // Adjust width of the container
            height: 300, // Adjust height of the container
            child: Image.asset(
              "assets/icons/splash_logo.png",
              fit: BoxFit.contain,
            ),
          ),
          
          SizedBox(height: 20), // Adjust spacing between text and image
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeOutParticle(
                disappear: true,
                child: Text('Savant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                  fontSize: 24
                ),),
                duration: Duration(seconds: 5),
              ),
              SizedBox(width: 20,),
              SpinKitWaveSpinner(
                color: Colors.greenAccent,
                size: 50.0,
                waveColor: Colors.greenAccent,
                trackColor: Colors.white12,
              ),
            ],
          ),

        ],
      ),
    );
  }
}
