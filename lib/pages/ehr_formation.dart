import 'package:arcyon_healthbot/Screens/login_screen.dart';
import 'package:arcyon_healthbot/Screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';

class EhrFormation extends StatefulWidget {
  @override
  _EhrFormationState createState() => _EhrFormationState();
}

class _EhrFormationState extends State<EhrFormation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesome.sign_out,
              color: Color(0xff0f4c75),
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: LoginPage(),
                ),
              );
            },
          )
        ],
        title: Text(
          "Elctronic Health Record",
          style: TextStyle(
            color: Color(0xff0f4c75),
          ),
        ),
        backgroundColor: Color(0xffbbe1fa),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Text(
            'EHR',
          ),
        ),
      ),
    );
  }
}
