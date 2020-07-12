import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class UserManagement{
  storeNewUser(FirebaseUser user, context)async{
    await Firestore.instance.collection('/users').document(user.uid).setData({
      'email': user.email,
      'uid': user.uid,
      'displayName': user.displayName,
      'url': user.photoUrl
    }).then((value) => {
    if(user != null){
        Navigator.pop(context),
        Navigator.of(context).pushReplacementNamed('/Login')
    }
    }).catchError((e){
      print(e);
    });
  }
}

