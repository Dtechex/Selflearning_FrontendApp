import 'dart:async';
import 'dart:math';

import 'package:fade_out_particle/fade_out_particle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';

import '../features/login/login_screen.dart';
import '../utilities/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      SharedPref().getToken().then((token) {
        if (token != null) {
          print(token);
          setState(() {
            // Navigate to DashboardScreen if token exists
            // You need to have a navigator to navigate to different screens
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashBoardScreen()),
            );
          });
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
                child: Text('Self Learning', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
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
