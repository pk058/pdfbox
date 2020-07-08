import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdfbox/screens/HomeScreen.dart';
import 'package:pdfbox/screens/Login.dart';
import 'package:pdfbox/screens/WelCome.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    if(user== null){

      return WelCome();
    }else{
      return HomeScreen();
    }
  }
}
