import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdfbox/UserManagement.dart';

class AuthServices  {
  FirebaseAuth _auth = FirebaseAuth.instance;
   // Login with email and password
  Future<FirebaseUser> login(String email, String pass) async {
    try{
      AuthResult _result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      FirebaseUser _user = _result.user;
      return _user;
    } catch(e){
      print(e.message);
      return null;
    }
  }

  //Signup with email and password

  Future<FirebaseUser> signup(String email, String pass, String name,  BuildContext context) async {
    try{
      AuthResult _result = await
      _auth.createUserWithEmailAndPassword(email: email, password: pass);
      FirebaseUser _user = _result.user;
      UserUpdateInfo info = UserUpdateInfo();
//      print(name);
      info.displayName = name;
      info.photoUrl = "https://pixy.org/src/30/302909.png";
     await _user.updateProfile(info);
     print(_user.displayName);
      await _auth.currentUser().then((user) => UserManagement().storeNewUser(user, context));
      return _user;
    } catch(e){
      print(e.message);
      return null;
    }
  }
  //Signout

  Future signOut() async{
    try{
      return  _auth.signOut();
    }catch(e){
      print(e.message);
      return null;
    }
  }

  //auth change user Stream
   Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
   }

   // Current user data
  Future<String> useruid() async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return firebaseUser.uid;
}

  String name;
  String email;
  String uid;
  userdata() async{
    final firestoreInstance = Firestore.instance;
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    await firestoreInstance.collection("users").document(firebaseUser.uid).get().then((user) {
      name = user.data['displayName'];
      email = user.data['email'];
      uid = user.data['uid'];
    });
  }
}