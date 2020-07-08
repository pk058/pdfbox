import 'package:flutter/material.dart';
import 'package:pdfbox/authServices.dart';
import 'package:pdfbox/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {

 final AuthServices _auth = AuthServices();

  _launchURL() async {
    const url = 'https://wa.me/+919110910481';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: kPinkColor.withOpacity(0.15)),
              accountName: Text('Helix', style: kSubtitleTextSyule,),
              accountEmail: Text('Kumarprabhat058@gmail.com',
                style: TextStyle(color: kTextColor.withOpacity(0.5)),),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Color(0xFFFFF9F9),
            backgroundImage: AssetImage('assets/images/user.png'),
          ),
          ),
          ListTile(
            title: Text('About',
              style: kSubtitleTextSyule.copyWith(fontWeight: FontWeight.w400),),
            trailing: Icon(Icons.add_circle_outline),
            onTap: (){
              Navigator.pop(context);
                Navigator.of(context).pushNamed('/About');
            },
          ),
          Divider(),
          ListTile(
            title: Text('Send us feedback/suggestion',
                style: kSubtitleTextSyule.copyWith(fontWeight: FontWeight.w400)),
            trailing: Icon(Icons.feedback),
            onTap: (){
              Navigator.pop(context);
              _launchURL();
            },
          ),
          Divider(),
          ListTile(
            title: Text('Rate Us',
              style: kSubtitleTextSyule.copyWith(fontWeight: FontWeight.w400),),
            trailing: Icon(Icons.star, color: Colors.amber,),
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/About');
            },
          ),
          Divider(),
          ListTile(
            title: Text('Share it',
              style: kSubtitleTextSyule.copyWith(fontWeight: FontWeight.w400),),
            trailing: Icon(Icons.share),
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/About');
            },
          ),
          Divider(),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.only(left: 70,right: 70),
            child: FlatButton(
                onPressed: ()async{
                  return await _auth.Signout();
                },
                child: Text('Log Out'),
            color: kPinkColor.withOpacity(0.75),),
          )
        ],
      ) ,
    );
  }
}
