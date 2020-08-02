import 'package:arcyon_healthbot/Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:arcyon_healthbot/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Reminder extends StatefulWidget {
  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  bool morning = false;
  bool afternoon = false;
  bool night = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
          "Reminder",
          style: TextStyle(
            color: Color(0xff0f4c75),
          ),
        ),
        backgroundColor: Color(0xffbbe1fa),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                'Medicine name',
                style: TextStyle(
                  color: Color(0xff1b262c),
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 7),
            TextField(
              onChanged: (value) {},
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter medicine name'),
            ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                'When to take?',
                style: TextStyle(
                  color: Color(0xff1b262c),
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      morning = !morning;
                    });
                  },
                  child: TimeCard(
                    icon: Feather.sunrise,
                    time: 'Morning',
                    isSelected: morning,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      afternoon = !afternoon;
                    });
                  },
                  child: TimeCard(
                    icon: Feather.sun,
                    time: 'Afternoon',
                    isSelected: afternoon,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      night = !night;
                    });
                  },
                  child: TimeCard(
                    icon: Feather.moon,
                    time: 'Night',
                    isSelected: night,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlueAccent),
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                style: TextStyle(
                  color: Colors.black87,
                ),
                maxLines: 2,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Additional notes...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: const Color(0xff3282B8),
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Feather.bell,
                          color: kTextPrimary,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Set Reminder',
                          style: TextStyle(
                            color: kTextPrimary,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimeCard extends StatelessWidget {
  const TimeCard({
    Key key,
    this.icon,
    this.time,
    this.isSelected,
  }) : super(key: key);
  final IconData icon;
  final String time;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      width: 95,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xff3282b8) : Color(0xffbbe1fa),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Color(0xffffffff) : Color(0xff1b262c),
            size: 35,
          ),
          SizedBox(height: 5),
          Text(
            time,
            style: TextStyle(
              color: isSelected ? Color(0xffffffff) : Color(0xff1b262c),
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
