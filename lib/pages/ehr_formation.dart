import 'package:arcyon_healthbot/Screens/login_screen.dart';
import 'package:arcyon_healthbot/Screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class EhrFormation extends StatefulWidget {
  @override
  _EhrFormationState createState() => _EhrFormationState();
}

class _EhrFormationState extends State<EhrFormation> {
  String confirmed_total;
  String recoverd_total = "not";
  String deceased_total = "not";
  var state = new List(38);
  var state_confirmed = new List(38);
  var state_recovered = new List(38);
  var state_deceased = new List(38);

  Future getData() async {
    http.Response response =
        await http.get("https://api.covid19india.org/data.json");

    String data = response.body;

    var decodedData = jsonDecode(data);

    setState(() {
      confirmed_total = decodedData['statewise'][0]['confirmed'];
      recoverd_total = decodedData['statewise'][0]['recovered'];
      deceased_total = decodedData['statewise'][0]['deaths'];
    });

    for (int i = 1; i <= 38; i++) {
      setState(() {
        state[i] = decodedData['statewise'][i]['state'];
        state_confirmed[i] = decodedData['statewise'][i]['confirmed'];
        state_recovered[i] = decodedData['statewise'][i]['recovered'];
        state_deceased[i] = decodedData['statewise'][i]['deaths'];
      });
    }

    print(confirmed_total);
    print("**********************************************************");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
          "Covid-19 Stats India",
          style: TextStyle(
            color: Color(0xff0f4c75),
          ),
        ),
        backgroundColor: Color(0xffbbe1fa),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(207, 0, 205, 30),
                  color: Color(0xff3282b8),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: screenHeight * 0.135),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 9, 16, 0),
                  margin: const EdgeInsets.fromLTRB(14, 15, 14, 0),
                  height: screenHeight * 0.31,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey[700],
                        blurRadius: 4.0,
                        spreadRadius: 0.0,
                      )
                    ],
                    color: Color(0xffbbe1fa),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Haryana',
                          style: TextStyle(
                            fontFamily: 'Monterrsat',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Confirmed',
                              style: TextStyle(
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Recovered',
                              style: TextStyle(
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              'Deceased',
                              style: TextStyle(
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding:
                                EdgeInsets.only(top: 10, left: 10, bottom: 10),
                            child: Text(
                              '${state_confirmed[12]}',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              '${state_confirmed[12]}',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 10, right: 30, bottom: 10),
                            child: Text(
                              '${state_deceased[12]}',
                              style: TextStyle(
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 0),
                        child: Text(
                          'Across India',
                          style: TextStyle(
                            fontFamily: 'Monterrsat',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Confirmed',
                              style: TextStyle(
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Recovered',
                              style: TextStyle(
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Deceased',
                              style: TextStyle(
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding:
                                EdgeInsets.only(top: 10, left: 0, bottom: 0),
                            child: Text(
                              '${confirmed_total}',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 10, bottom: 0, right: 3),
                            child: Text(
                              '${recoverd_total}',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 10, right: 4, bottom: 0),
                            child: Text(
                              '${deceased_total}',
                              style: TextStyle(
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                child: Text(
                  'State/UT',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, left: 10, bottom: 10),
                child: Text(
                  'Confirmed',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  'Recovered',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, right: 10, bottom: 10),
                child: Text(
                  'Deaths',
                  style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: 37,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(1, 10, 10, 10),
                      child: Container(
                        margin: EdgeInsets.only(left: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              constraints:
                                  BoxConstraints(minWidth: 90, maxWidth: 90),
                              child: Text(
                                '${state[index + 1]}',
                                style: TextStyle(
                                  color: Color(0xff1b262c),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              constraints:
                                  BoxConstraints(minWidth: 90, maxWidth: 90),
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                '${state_confirmed[index + 1]}',
                                style: TextStyle(
                                  color: Colors.blueGrey[700],
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 5),
                              constraints:
                                  BoxConstraints(minWidth: 90, maxWidth: 90),
                              child: Text(
                                '${state_recovered[index + 1]}',
                                style: TextStyle(
                                  color: Colors.blueGrey[700],
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              constraints:
                                  BoxConstraints(minWidth: 40, maxWidth: 50),
                              child: Text(
                                '${state_deceased[index + 1]}',
                                style: TextStyle(
                                  color: Colors.blueGrey[700],
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
