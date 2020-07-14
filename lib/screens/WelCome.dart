import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdfbox/constants.dart';

class WelCome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Column(
        children: <Widget>[
          SizedBox(height: 150,),
          Text("Welcome to PdfBox", style: kSubtitleTextSyule,),
          SizedBox(height: 10,),
          Text('Made with Love by Prabhat', style: kSubtitleTextSyule,),
          SizedBox(height: 30,),
          Image.asset('assets/images/BackGround.png'),
          SizedBox(height: 30,),
          Container(
            height: 80,
            padding: EdgeInsets.only(right: 30, left: 30),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(onPressed: (){
                    Navigator.of(context).pushNamed('/Login');
                  },
                      color: kPinkColor,
                      child: Text('LogIn',
                        style: TextStyle(color: Colors.white),)),
                ),
                SizedBox(width: 20,),
                Expanded(child:
                FlatButton(onPressed: (){
                  Navigator.of(context).pushNamed('/Signup');
                },
                    color: kPinkColor,
                    child: Text('SignUp',
                        style: TextStyle(color: Colors.white)))
                )],
            ),
          )
        ],
      ),
    );
  }
}
