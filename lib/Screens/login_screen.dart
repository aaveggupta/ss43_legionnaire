import 'file:///E:/Projects/Projects/arcyon_healthbot/lib/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';
import 'package:arcyon_healthbot/widgets/bezierContainer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:arcyon_healthbot/nav_controller.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Password must have at least one special character')
  ]);

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Required'),
    EmailValidator(errorText: 'Enter a valid email address')
  ]);

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  void validate() async {
    if (formkey.currentState.validate()) {
      setState(() {
        showSpinner = true;
      });
      try {
        final user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        if (user != null) {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: BottomNavBar(),
            ),
          );
        }

        setState(() {
          showSpinner = false;
        });
      } catch (e) {
        print(e);

        setState(() {
          showSpinner = false;
        });
        print(e);
        Fluttertoast.showToast(
            msg: 'Email/Password is incorrect',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0Xffbbe1fa),
            textColor: Color(0Xff1b262c),
            fontSize: 16.0);
      }
    } else
      print("not validated");
  }

  String email;
  String password;

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 4,
          ),
          TextFormField(
              onChanged: (value) {
                if (title == "Email id")
                  email = value;
                else if (title == "Password") password = value;
              },
              validator: isPassword ? passwordValidator : emailValidator,
              obscureText: isPassword,
              decoration: InputDecoration(
                  fillColor: Color(0xfff3f3f4),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: const Color(0xff3282B8),
      textColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      onPressed: validate,
      child: Text(
        "Login",
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: SignUpPage(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xff1b262c),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Arc',
          style: TextStyle(
            fontFamily: 'Raleway-Regular',
            fontSize: 40,
            color: const Color(0xff1b262c),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          height: 40,
          child: Image(
            image: AssetImage('assets/logo@3x.png'),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          'on',
          style: TextStyle(
            fontFamily: 'Raleway-Regular',
            fontSize: 40,
            color: const Color(0xff1b262c),
          ),
        ),
      ],
    );
  }

  Widget _emailPasswordWidget() {
    return Form(
      key: formkey,
      child: Column(
        children: <Widget>[
          _entryField("Email id"),
          _entryField("Password", isPassword: true),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
          body: SafeArea(
        child: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .20,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .15),
                      _title(),
                      SizedBox(height: 40),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                      SizedBox(height: height * .01),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
              Positioned(top: 20, left: 0, child: _backButton()),
            ],
          ),
        ),
      )),
    );
  }
}
