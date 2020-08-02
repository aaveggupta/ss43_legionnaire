import 'package:arcyon_healthbot/Screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  String uId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageStream();
  }

  void messageStream() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      uId = firebaseUser.uid;
    });

    final _firestore = Firestore.instance;
  }

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
          "Timeline",
          style: TextStyle(
            color: Color(0xff0f4c75),
          ),
        ),
        backgroundColor: Color(0xffbbe1fa),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('timeline')
                  .document(uId)
                  .collection('messages')
                  .orderBy("timeStamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:
                      List.generate(snapshot.data.documents.length, (index) {
                    DocumentSnapshot timeLineData =
                        snapshot.data.documents[index];
                    if (index % 2 != 0) {
                      return TilesRight(
                        date: timeLineData['date'],
                        time: timeLineData['time'],
                        information: timeLineData['infor'],
                      );
                    } else {
                      return TilesLeft(
                        date: timeLineData['date'],
                        time: timeLineData['time'],
                        information: timeLineData['infor'],
                      );
                    }
                  }),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TilesRight extends StatelessWidget {
  TilesRight(
      {@required this.date, @required this.time, @required this.information});

  final String date;
  final String time;
  final String information;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.center,
      indicatorStyle: const IndicatorStyle(
        width: 20,
        color: Colors.blue,
        padding: EdgeInsets.all(8),
        indicatorY: 0.3,
      ),
      rightChild: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              time,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              information,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class TilesLeft extends StatelessWidget {
  TilesLeft(
      {@required this.date, @required this.time, @required this.information});

  final String date;
  final String time;
  final String information;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.center,
      indicatorStyle: const IndicatorStyle(
        width: 20,
        color: Color(0xff3282b8),
        padding: EdgeInsets.all(8),
        indicatorY: 0.3,
      ),
      leftChild: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff3282b8)),
          color: Color(0xff3282b8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              time,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              information,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
