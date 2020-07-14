import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdfbox/authServices.dart';
import 'package:pdfbox/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class MainDrawer extends StatefulWidget {

  @override
  MainDrawerState createState() => MainDrawerState();
}

class MainDrawerState extends State<MainDrawer> {
  final AuthServices _authServices = AuthServices();
  dynamic data;

  File _image;
  String imageName;
  String url;
  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
    uploadtoStorage();
  }

  Future uploadtoStorage() async{
    if (_image != null) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser().then((value) => value);
      StorageReference ref = FirebaseStorage.instance.ref();
      StorageTaskSnapshot addImg =
      await ref.child("userprofile/${user.displayName}/${user.uid}").putFile(_image).onComplete;
      if (addImg.error == null) {
        print("added to Firebase Storage");
      }
      if (addImg.error == null) {
        url =
        await addImg.ref.getDownloadURL();
        await Firestore.instance
            .collection("/users").document(user.uid)
            .updateData({"url": url});
      } else {
        print(
            'Error from image repo ${addImg.error.toString()}');
        throw ('This file is not an image');
      }
    }
  }

  Future<dynamic> getData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final DocumentReference document =  Firestore.instance.collection("/users").document(user.uid);

    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        data =snapshot.data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  _launchURL() async {
    const url = 'https://wa.me/+919110910481';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onShareTap() async{
    await FlutterShare.share(
        title: 'Share',
        text: 'PdfBox'
            'can be used to store your Pdf in Different Sections according to your subject',
        linkUrl: 'https://appdistribution.firebase.dev/i/4e56468cbe07dfca',
        chooserTitle: 'Share with');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: kPinkColor.withOpacity(0.15)),
                    accountName: data != null ? Text("${data['displayName']}", style: kSubtitleTextSyule,):
                  Text('Loading...', style: kSubtitleTextSyule,),
                    accountEmail: data != null? Text("${data['email']}",
                      style: TextStyle(color: kTextColor.withOpacity(0.5)),): Text("Loading...",
                      style: TextStyle(color: kTextColor.withOpacity(0.5)),),
                      currentAccountPicture: CircularProfileAvatar(
                        data != null ? "${data['url']}" : 'null',
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        onTap: ()async{
                            await getImage();
                        },
                      ),
//                currentAccountPicture: CircleAvatar(
//                  backgroundColor: Color(0xFFFFF9F9),
//                  backgroundImage: AssetImage('assets/images/user.png'),
//                ),
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
              _onShareTap();
            },
          ),
          Divider(),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.only(left: 70,right: 70),
            child: FlatButton(
                onPressed: ()async{
                  await _authServices.signOut();
                  Navigator.pushReplacementNamed(context, '/Welcome');
                },
                child: Text('Log Out'),
            color: kPinkColor.withOpacity(0.75),),
          )
        ],
      ) ,
    );
  }
}