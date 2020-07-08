import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdfbox/authServices.dart';
import 'package:pdfbox/screens/HomeScreen.dart';
import 'package:pdfbox/constants.dart';

class LoginUser extends StatefulWidget {
  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  var _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final _passController = TextEditingController();

  AuthServices _auth = AuthServices();

//  String error = '';
//
//  Future<FirebaseUser> login(String email, String pass) async {
//    FirebaseAuth _auth = FirebaseAuth.instance;
//    try{
//      AuthResult _result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
//      FirebaseUser _user = _result.user;
//      return _user;
//    } catch(e){
//      setState(() {
//        error = e.massage;
//      });
//      print(e.message);
//      return null;
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 50, right: 50, top: 50),
                  child: Image(image: AssetImage('assets/images/Login.png',),
                  height: 256,
                  width: 300,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 32, left: 32),
                  child: Form(
                    key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(child: Text("LogIn!", style:
                          kTitleTextStyle.copyWith(fontSize: 40,
                              fontWeight: FontWeight.w400,color: Color(0xFF2A454E)))),
                          SizedBox(height: 20,),
                          TextFormField(
                            validator: EmailValidator.validate,
                            cursorColor: kPinkColor,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(color: kPinkColor)
                                ),
                                prefixIcon: Icon(Icons.person),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(color: kPinkColor)
                                ),
                                labelText: 'Email', labelStyle: TextStyle(color: Colors.grey)),
                            controller: _emailController,
                          ),
                          SizedBox(height: 30,),
                          TextFormField(
                            obscureText: true,
                            cursorColor: kPinkColor,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(color: kPinkColor)
                                ),
                                hoverColor: kPinkColor,
                                focusColor: kPinkColor,
                                prefixIcon: Icon(Icons.enhanced_encryption),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(color: kPinkColor)
                                ),
                                labelText: 'Password',labelStyle: TextStyle(color: Colors.grey)),
                            controller: _passController,
                            validator: PassValidator.validate,
                          ),
                          SizedBox(height: 20,),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 50, right:50 ),
                            child: FlatButton(
                              onPressed: ()async {
                                if(_formkey.currentState.validate()){
                                final email = _emailController.text.toString().trim();
                                final pass = _passController.text.toString().trim();
                                FirebaseUser result = await _auth.login(email, pass);
                                if(result != null){
                                  Navigator.of(context).pushReplacementNamed('/HomeScreen');
                                  print(result.uid);
                                } else {
                                  print('Error');
                                }}
                              },
                              child: Text('Login', style: TextStyle(color: Colors.white),),
                              color: kPinkColor,
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50, left: 15),
            child: IconButton(icon: Icon(Icons.arrow_back),
                onPressed: (){
              Navigator.pushReplacementNamed(context, '/');
//              Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }
}
class EmailValidator{
  static String validate(String value){
    if(value.isEmpty)
    {
      return 'Email cannot be empty!!';
    }else {return null;}
  }
}

class PassValidator{
  static String validate(String value){
    if(value.isEmpty)
    {
      return 'Password cannot be empty!!';
    }
    else {return null;}

  }
}