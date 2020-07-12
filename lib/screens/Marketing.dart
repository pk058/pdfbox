import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdfbox/constants.dart';

class Marketing extends StatefulWidget {
  @override
  _MarketingState createState() => _MarketingState();
}

class _MarketingState extends State<Marketing> {

  File _image;
  String imageName;
  String _extension;
  bool isLoading = false;
  String url;
  TextEditingController _nameController = TextEditingController();




  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
      _extension = path.basename(_image.path).split('.').last;
    });
    await nameAlterDialog(context);
    uploadtoStorage();
  }

  deleteItem(String name){
    Firestore.instance
        .collection("marketing")
        .where("name", isEqualTo: name)
        .getDocuments()
        .then((res) {
      res.documents.forEach((result) {
        FirebaseStorage.instance
            .getReferenceFromUrl(result.data["url"])
            .then((res) {
          res.delete().then((res) {
            print("Deleted!");
          });
        });
      });
    });
  }


  Future uploadtoStorage() async{
    setState(() {
      this.isLoading = true;
    });
    if (_image != null) {
      StorageReference ref = FirebaseStorage.instance.ref();
      StorageTaskSnapshot addImg =
      await ref.child("marketing/$imageName.$_extension").putFile(_image).onComplete;
      if (addImg.error == null) {
        print("added to Firebase Storage");
      }
      if (addImg.error == null) {
        url =
        await addImg.ref.getDownloadURL();
        await Firestore.instance
            .collection("marketing")
            .add({"url": url, "name": "$imageName.$_extension"});
        setState(() {
          isLoading = false;
        });
      } else {
        print(
            'Error from image repo ${addImg.error.toString()}');
        throw ('This file is not an image');
      }
    }
  }



  Widget listBulider(){
    return StreamBuilder(
        stream: Firestore.instance.collection('marketing').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot){
          if(querySnapshot.hasError){
            return Text("Some Error");
          }
          else if(querySnapshot.data == null){
            return Text("Loading...");
          }else{
            final list = querySnapshot.data.documents;
            return ListView.builder(
              itemBuilder: (context, index){
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.insert_drive_file),
                  title: Text(list[index]['name']),
                      subtitle: Text(index.toString()),
                      onTap: (){
                        downloadAlterDialog(context);
                      },
                      onLongPress: (){
                        deleteAlterDialog(context, list[index]['name'], querySnapshot, index);
                      },
                    ),
                Divider()
                  ],
                );
              },
              itemCount: list.length,
            );
          }
        }
    );
  }
  nameAlterDialog(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('File Name'),
        content: TextField(
          cursorColor: kPinkColor,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide(color: kPinkColor)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide(color: kPinkColor)
              ),
              labelText: 'Name', labelStyle: TextStyle(color: Colors.grey)),
          controller: _nameController,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 0.0,
            color: kPinkColor,
            child: Text('Submit'),
            onPressed: (){
              setState(() {
                imageName = _nameController.text;
              });
              Navigator.pop(context);
              _nameController.text = '';
            },
          )
        ],
      );
    });
  }

  deleteAlterDialog(BuildContext context, String name,
      AsyncSnapshot<QuerySnapshot> querySnapshot, int index){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Delete $imageName ?', style: TextStyle(color: Colors.red),),
        actions: <Widget>[
          MaterialButton(
            color: kPinkColor,
            child: Text('Confirm'),
            onPressed: ()async{
              Navigator.pop(context);
              deleteItem(name);
              await Firestore.instance.runTransaction((Transaction myTransaction) async {
                await myTransaction.delete(querySnapshot.data.documents[index].reference);
              });
            },
          )
        ],
      );
    });
  }

  downloadAlterDialog(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('DownLoad $imageName !', style: kTitleTextStyle),
        actions: <Widget>[
          MaterialButton(
            color: kPinkColor,
            child: Text('Confirm'),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF3F3F3),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top:80, left: 120),
                child: Image.asset('assets/images/Marketing_big.png')
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    },
                        icon: Icon(Icons.arrow_back_ios)),
                      SvgPicture.asset('assets/icons/more-vertical.svg'),
                    ],
                  ),
                  SizedBox(height: 30,),
                  ClipPath(
                    clipper: BestSellerClipper(),
                    child: Container(
                      color: kBestSellerColor,
                      padding: EdgeInsets.only(left: 10, top: 5, right: 20, bottom: 5),
                      child: Text("BestSeller".toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Text('Digital Marketing', style: kHeadingextStyle),
                  SizedBox(height: 16,),
                  Row(
                    children: <Widget>[
                      SvgPicture.asset('assets/icons/person.svg'),
                      SizedBox(width: 5,),
                      Text('12k'),
                      SizedBox(width: 20,),
                      SvgPicture.asset('assets/icons/star.svg'),
                      SizedBox(width: 5,),
                      Text('4.1'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("\$40", style: kSubheadingextStyle.copyWith(fontSize: 32),),
                      Text("\$90", style: TextStyle(color: kTextColor.withOpacity(0.5),
                      decoration: TextDecoration.lineThrough),),
                    ],
                  ),
                  SizedBox(height: 60,),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white
                      ),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(30),
                            child: listBulider(),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [BoxShadow(offset: Offset(0,4),
                                    blurRadius: 50,
                                    color: kTextColor.withOpacity(0.1)
                                )
                                ],
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(14),
                                    height: 56,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFFFEDEE),
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                    child: SvgPicture.asset('assets/icons/shopping-bag.svg'),
                                  ),
                                  SizedBox(width: 50,),
                                  GestureDetector(
                                    child: Container(
                                      height: 56,
                                      width: 160,
                                      alignment: Alignment.center,
                                      child: Text("Add to pdfbox",
                                        style: kSubtitleTextSyule.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      decoration: BoxDecoration(
                                        color: kBlueColor,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                    onTap: (){
                                      getImage();
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BestSellerClipper extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(size.width -20, 0);
    path.lineTo(size.width, size.height/2);
    path.lineTo(size.width -20, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }

}


