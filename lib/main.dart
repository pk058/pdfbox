import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdfbox/authServices.dart';
import 'package:pdfbox/constants.dart';
import 'package:pdfbox/screens/Bussiness.dart';
import 'package:pdfbox/screens/Login.dart';
import 'package:pdfbox/screens/Market.dart';
import 'package:pdfbox/screens/WelCome.dart';
import 'package:pdfbox/screens/About.dart';
import 'package:pdfbox/screens/HomeScreen.dart';
import 'package:pdfbox/screens/MainDrawer.dart';
import 'package:pdfbox/screens/DesignThinking.dart';
import 'package:pdfbox/screens/Photography.dart';
import 'package:pdfbox/screens/Signup.dart';
import 'package:pdfbox/screens/pdfviewer.dart';
import 'package:pdfbox/screens/wrapper.dart';
import 'package:provider/provider.dart';

//This is pdfbox. Nice project!
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthServices().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PdfBox',
        theme: ThemeData(
          highlightColor: kPinkColor,
          hoverColor: kPinkColor,
          appBarTheme: AppBarTheme(elevation: 0.0),
          accentColor: kPinkColor,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/Welcome': (context) => WelCome(),
          '/Signup': (context) => SignupUser(),
          '/Login': (context) => LoginUser(),
          '/MainDrawer': (context) => MainDrawer(),
          '/HomeScreen': (context) => HomeScreen(),
          '/DesignThinking': (context) => DesignThinking(),
          '/Marketing': (context) => Market(),
          '/Photography': (context) => Photography(),
          '/Bussiness': (conext) => Bussiness(),
          '/About': (context) => About(),
          '/pfdviewer': (context) => PdfViewPage(),
        },
      ),
    );
  }
}


//Ending
