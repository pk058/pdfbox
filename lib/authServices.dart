import 'package:firebase_auth/firebase_auth.dart';

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

  Future<FirebaseUser> signup(String email, String pass, String name) async {
    try{
      AuthResult _result = await
      _auth.createUserWithEmailAndPassword(email: email, password: pass);
      FirebaseUser _user = _result.user;
      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = name;
      _user.updateProfile(info);
      return _user;
    } catch(e){
      print(e.message);
      return null;
    }
  }
  //Signout

  Future Signout() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.message);
      return null;
    }
  }

  //auth change user Stream
   Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
   }
}