import 'package:arcyon_healthbot/Screens/login_screen.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreInstance = Firestore.instance;
  String uName = "Hey";
  final _firestore = Firestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _onPressed();
  }

  void _onPressed() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    String uId = firebaseUser.uid;
    uName = await firestoreInstance
        .collection('users')
        .document(uId)
        .get()
        .then((value) {
      return value.data['name'];
    });

    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message":
            "Hey $uName! I am Arcyon, your personal health advisor.\nLet me show you what you can ask me:\n1. Calculate BMI (body mass index) by providing weight and height.\nEg. Calculate bmi, my height is 1.65 m and weight is 50 kg.\n\n2. You can ask for emergency assistance.\nEg. What can I do in cardiac arrest?\n\n3. Prediction of top 3 diseases based on your given symptoms\nEg. I am having cough and shivering.\n\nI hope you will love my company."
      });
    });
  }

  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credential_file.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    String s2 = aiResponse.getListMessage()[0]["text"]["text"][0].toString();

    if (s2.isEmpty) {
      setState(() {
        messsages.insert(0, {"data": 0, "message": "Can you say that again?"});
      });
    } else {
      setState(() {
        messsages.insert(0, {"data": 0, "message": s2});
      });
    }

    String s1 = "You have shown the symptoms of";

    int f = 0;
    for (int i = 0; i < s1.length; i++) {
      if (s1[i] != s2[i]) {
        f = 1;
        break;
      }
    }

    if (f == 0) {
      String s3 = "";
      int i;
      for (i = 0; i < s2.length; i++) {
        if (s2[i] == '.') {
          break;
        }
      }
      s3 = s3 + s2.substring(0, i);
      print(s3);
      var firebaseUser = await FirebaseAuth.instance.currentUser();
      final DateTime now = DateTime.now();
      final DateFormat formatterD = DateFormat.yMMMMd('en_US');
      final String formattedD = formatterD.format(now);

      final DateFormat formatterT = DateFormat.jm();
      final String formattedT = formatterT.format(now);

      String uId = firebaseUser.uid;
      _firestore
          .collection('timeline')
          .document(uId)
          .collection('messages')
          .document()
          .setData({
        'infor': s3,
        "timeStamp": Timestamp.now(),
        'date': formattedD,
        'time': formattedT,
      });
    }
  }

  final messageInsert = TextEditingController();
  List<Map> messsages = List();

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
        title: Center(
          child: Text(
            "Arcyon",
            style: TextStyle(
              color: Color(0xff0f4c75),
            ),
          ),
        ),
        backgroundColor: Color(0xffbbe1fa),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messsages.length,
                    itemBuilder: (context, index) => chat(
                        messsages[index]["message"].toString(),
                        messsages[index]["data"]))),
            Divider(
              height: 5.0,
              color: Color(0xff0f4c75),
            ),
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: TextField(
                    controller: messageInsert,
                    decoration: InputDecoration.collapsed(
                        hintText: "Send your message",
                        hintStyle: TextStyle(fontSize: 18.0)),
                  )),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: .05),
                    child: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 30.0,
                          color: Color(0xff0f4c75),
                        ),
                        onPressed: () {
                          if (messageInsert.text.isEmpty) {
                            print("empty message");
                          } else {
                            setState(() {
                              messsages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                            });
                            response(messageInsert.text);
                            messageInsert.clear();
                          }
                        }),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  //for better one i have use the bubble package check out the pubspec.yaml

  Widget chat(String message, int data) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Bubble(
          radius: Radius.circular(15.0),
          color: data == 0 ? Color(0xff3282b8) : Color(0xffbbe1fa),
          elevation: 0.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Flexible(
                    child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                    color: data == 0 ? Colors.white : Color(0xff1b262c),
                  ),
                ))
              ],
            ),
          )),
    );
  }
}
