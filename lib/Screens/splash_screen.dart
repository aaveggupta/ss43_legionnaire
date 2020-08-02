import 'dart:async';

import 'package:arcyon_healthbot/Screens/signup_screen.dart';
import 'package:arcyon_healthbot/pages/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:arcyon_healthbot/nav_controller.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 5);
    return Timer(duration, route);
  }

  route() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: SignUpPage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: BottomNavBar(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/upperd@3x.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Arc',
                  style: TextStyle(
                    fontFamily: 'Raleway-Regular',
                    fontSize: 60,
                    color: const Color(0xff1b262c),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 60,
                  child: Image(
                    image: AssetImage('assets/logo@3x.png'),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                Text(
                  'on',
                  style: TextStyle(
                    fontFamily: 'Raleway-Regular',
                    fontSize: 60,
                    color: const Color(0xff1b262c),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TypewriterAnimatedTextKit(
              speed: const Duration(milliseconds: 150),
              text: ['Your Personal Health Advisor'],
              textStyle: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 20,
                color: const Color(0xff1b262c),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            JumpingDotsProgressIndicator(
              fontSize: 50.0,
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  height: 170,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/lowerd@3x.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
