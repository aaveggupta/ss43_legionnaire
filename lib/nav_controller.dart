import 'package:arcyon_healthbot/pages/chat_screen.dart';
import 'package:arcyon_healthbot/pages/ehr_formation.dart';
import 'package:arcyon_healthbot/pages/health_news.dart';
import 'package:arcyon_healthbot/pages/reminders.dart';
import 'package:arcyon_healthbot/pages/timeline.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int pageIndex = 2;

  final HealthNews _healthNews = HealthNews();
  final ChatScreen _chatScreen = ChatScreen();
  final EhrFormation _ehrFormation = EhrFormation();
  final Reminder _reminder = Reminder();
  final Timeline _timeline = Timeline();

  Widget _showPage = ChatScreen();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _reminder;
        break;
      case 1:
        return _timeline;
        break;
      case 2:
        return _chatScreen;
        break;
      case 3:
        return _healthNews;
        break;
      case 4:
        return _ehrFormation;
        break;
      default:
        return Container(
          child: Center(
            child: Text(
              'No Page found by pagechooser',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: pageIndex,
        height: 50.0,
        items: <Widget>[
          Icon(Feather.bell, size: 30, color: Color(0xff0f4c75)),
          Icon(Icons.timeline, size: 30, color: Color(0xff0f4c75)),
          Icon(Icons.chat, size: 30, color: Color(0xff0f4c75)),
          Icon(Icons.import_contacts, size: 30, color: Color(0xff0f4c75)),
          Icon(Icons.perm_identity, size: 30, color: Color(0xff0f4c75)),
        ],
        color: Color(0xffbbe1fa),
        buttonBackgroundColor: Color(0xffbbe1fa),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 250),
        onTap: (int tappedIndex) {
          setState(() {
            _showPage = _pageChooser(tappedIndex);
          });
        },
      ),
      body: Container(
        color: Colors.white,
        child: _showPage,
      ),
    );
  }
}
