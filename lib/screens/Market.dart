import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfbox/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pdfbox/screens/pdfviewer.dart';

class Market extends StatefulWidget {
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String imageName;
  String fileName;
  bool isupLoading = false;
  String url;
  Map<String, String> _paths;
  String urlPDFPath = "";
  bool isLoading = false;
  String uid;
  String username;

  @override
  void initState() {
    super.initState();
    currentuseruid();
  }

  void currentuseruid() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser().then((value) => value);
    setState(() {
      uid = user.uid;
      username = user.displayName;
    });
  }

  void openFileExplorer() async {
    try {
        _paths = await FilePicker.getMultiFilePath(type: FileType.custom,
                allowedExtensions: ['pdf']);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    uploadToFirebase();
    setState(() {
      isupLoading = true;
    });
    uploadingshowSnackbar(isupLoading);
  }
  uploadToFirebase() {
      _paths.forEach((fileName, filePath) => {upload(fileName, filePath)});
  }

  Future upload(fileName, filePath) async {
    if (File(filePath) != null) {
      StorageReference ref = FirebaseStorage.instance.ref();
      StorageTaskSnapshot addFile =
          await ref.child("marketing/$username/$fileName").putFile(File(filePath)).onComplete;
      if (addFile.error == null) {
        print("added to Firebase Storage");
      }
      if (addFile.error == null){
        url =
            await addFile.ref.getDownloadURL();
        await Firestore.instance
            .collection("/users").document('$uid').collection('marketing')
            .add({"url": url, "name": fileName});
        setState(() {
         isupLoading = false;
        });
      } else {
        print(
            'Error from image repo ${addFile.error.toString()}');
        throw ('This file is not an pdf');
      }

    }

  }




  deleteItem(String name){
    Firestore.instance
        .collection("users").document('$uid').collection('marketing')
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




  Widget listBulider(){
    return StreamBuilder(
        stream: Firestore.instance.collection("users").document('$uid').collection('marketing').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot){
          if(querySnapshot.hasError){
            return Text("Some Error");
          } else if(querySnapshot.data == null){
            return Center(child: CircularProgressIndicator());
          }
          else{
            final list = querySnapshot.data.documents;
            return list.isEmpty ? Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('I am Empty..',style: kSubtitleTextSyule,),
                SizedBox(height: 20,),
                SvgPicture.asset('assets/icons/empty.svg',
                  height: 80, width: 80,),
              ],
            )):
              ListView.builder(
              itemBuilder: (context, index){
                return
                  Column(
                  children: <Widget>[
                    ListTile(
                      leading: Container(
                          child: SvgPicture.asset('assets/icons/pdf.svg',
                            height: 50, width: 50,)),
                      title: Text(list[index]['name']),
                      subtitle: Text(index.toString()),
                      onTap: (){
                        downloadAlterDialog(context, list[index]['url']);
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


  deleteAlterDialog(BuildContext context, String name,
      AsyncSnapshot<QuerySnapshot> querySnapshot, int index){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Delete?', style: TextStyle(color: Colors.red),),
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


  downloadAlterDialog(BuildContext context, String url){
    return showDialog(context: _scaffoldKey.currentContext, builder: (context){
      return AlertDialog(
        title: Text('Load Pdf!', style: kTitleTextStyle),
        actions: <Widget>[
          MaterialButton(
            color: kPinkColor,
            child: Text('Confirm', style: TextStyle(color: Colors.white),),
            onPressed: ()async{
             await getFileFromUrl(url).then((f) {
                setState(() {
                  urlPDFPath = f.path;
                });
              });
             Navigator.pop(context);
              if (urlPDFPath != null) {
                await Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) =>
                PdfViewPage(path: urlPDFPath)));
                }
            },
          )
        ],
      );
    });
  }

 uploadingshowSnackbar(bool value){
 value ?   _scaffoldKey.currentState.showSnackBar(
  SnackBar(
    elevation: 0.0,
    backgroundColor: Colors.white,
    content: Row(
  children: <Widget>[
  Container(height: 30,
      width: 30,
      child: CircularProgressIndicator()),
  SizedBox(width: 20,),
  Text("upLoading...", style: kSubtitleTextSyule,)
  ],
  ),
  )): _scaffoldKey.currentState.hideCurrentSnackBar();
}

  loadingshowSnackbar(bool value){
    value ?   _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          content: Row(
            children: <Widget>[
              Container(height: 30,
                  width: 30,
                  child: CircularProgressIndicator()),
              SizedBox(width: 30,),
              Text("Loading Pdf...", style: kSubtitleTextSyule,)
            ],
          ),
        )):  _scaffoldKey.currentState.hideCurrentSnackBar();
  }
  Future<File> getFileFromUrl(String url) async {
    setState(() {
      isLoading = true;
    });
    loadingshowSnackbar(isLoading);
    try {
      var data = await http.get(url);
      print('ddddddddddddddddddddddddddddddddddddddddddd');
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdfonline.pdf");
      File urlFile = await file.writeAsBytes(bytes);
      setState(() {
        isLoading = false;
      });
      loadingshowSnackbar(isLoading);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white,),
          elevation: 0.0,
          tooltip: 'Add pdf',
          onPressed: (){
            openFileExplorer();

          }),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF3F3F3),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 50),
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


