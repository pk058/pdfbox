import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdfbox/authServices.dart';
import 'package:pdfbox/constants.dart';

class SignupUser extends StatefulWidget {
  @override
  _SignupUserState createState() => _SignupUserState();
}

class _SignupUserState extends State<SignupUser> {

  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final _passController = TextEditingController();

  final _nameController = TextEditingController();

  AuthServices _auth = AuthServices();

//  final String error = '';
//
//  Future<FirebaseUser> signup(String email, String pass, String name) async {
//    FirebaseAuth _auth = FirebaseAuth.instance;
//    try{
//      AuthResult _result = await
//      _auth.createUserWithEmailAndPassword(email: email, password: pass);
//      FirebaseUser _user = _result.user;
//      UserUpdateInfo info = UserUpdateInfo();
//      info.displayName = name;
//      _user.updateProfile(info);
//      return _user;
//    } catch(e){
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
                  child: Image(image: AssetImage('assets/images/signup.png'),
                    height: 256,
                    width: 300,),
                ),
                Container(
                  padding: EdgeInsets.only(right: 32, left: 32),
                  child: Form(
                    key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(child: Text("SignUp!", style:
                          kTitleTextStyle.copyWith(fontSize: 40,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF2A454E)))),
                          SizedBox(height: 20,),
                          TextFormField(
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
                                labelText: 'Name', labelStyle: TextStyle(color: Colors.grey)),
                            controller: _nameController,
                            validator: NameValidator.validate,
                          ),
                          SizedBox(height: 30,),
                          TextFormField(
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
                            validator: EmailValidator.validate,
                            controller: _emailController,
                          ),
                          SizedBox(height: 30,),
                          TextFormField(
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
                                final name = _nameController.text.toString().trim();
                                await _auth.signup(email, pass, name, context);
                                }
                              },
                              child: Text('Sign up', style: TextStyle(color: Colors.white),),
                              color: kPinkColor,
                            ),
                          ),

                        ],
                      )
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Already Registered?'),
                    SizedBox(width: 10,),
                    GestureDetector(
                      child: Text('Login', style:
                      TextStyle(color: Colors.lightBlue),),
                      onTap: (){
                        Navigator.pushReplacementNamed(context, '/Login');
                      },
                    )
                  ],
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
    else if(value.length<6){
      return 'Password is too Short!!';
    }
    else {return null;}

  }
}

class NameValidator{
  static String validate(String value){
    if(value.isEmpty){
      return 'Name cannot be empty!!';
    }
    else if(value.length < 2)
    {
      return 'Name is too Short!!';
    }else if(value.length>50){
      return 'Name is too Long!!';
    }
    else {return null;}
  }
}


