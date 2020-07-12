import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdfbox/screens/MainDrawer.dart';
import '../Navihelper.dart';
import '../Searchbar.dart';
import '../categories.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  dynamic data;

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
  initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
        extendBodyBehindAppBar: true,
        drawer: MainDrawer(),
        body: Padding(padding: EdgeInsets.only(top: 50, right: 20, left: 20),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SvgPicture.asset('assets/icons/menu.svg'),
                    CircularProfileAvatar(
                      data != null ? "${data['url']}" : " ",
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      radius: 20,
                    ),
                  ],
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    margin: EdgeInsets.symmetric(vertical: 20),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kPinkColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset('assets/icons/search.svg'),
                        SizedBox(width: 16,),
                        Text("Search of anything", style: TextStyle(fontSize: 18,
                            color: Color(0xFF9398B0)),)
                      ],
                    ),
                  ),
                  onTap: (){
                    showSearch(context: context, delegate: SearchBar(),);
                  },
                ),
                data != null ? Text("Hey ${data['displayName']} !!", style: kHeadingextStyle,)
                    : Text("Loading....!!", style: kHeadingextStyle,),
                Text("Find the Subject You Want", style: kSubheadingextStyle,),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Category", style: kTitleTextStyle,),
//                    Text("See all", style: kSubtitleTextSyule.copyWith(color: kBlueColor),)
                  ],
                ),
                SizedBox(height: 30,),
                Expanded(child: StaggeredGridView.countBuilder(
                  padding: EdgeInsets.all(0.5),
                  crossAxisCount: 2,
                  itemCount: categories.length,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  itemBuilder: (context, index){
                    return Container(
                      padding: EdgeInsets.all(5),
                      height: index.isEven ? 200 : 240,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
//                color: kBlueColor,
                          image: DecorationImage(
                              image: AssetImage(categories[index].image),
                              fit: BoxFit.fill
                          )),
                      child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(categories[index].name, style: kTitleTextStyle,),
                          Text("${categories[index].numofCourses} Courses",
                            style: TextStyle(color: kTextColor.withOpacity(0.5)),),
                          Navi(route: categories[index].route),
                        ],
                      ),
                    );
                  },
                  staggeredTileBuilder: (index) => StaggeredTile.fit(1),)
                )
              ],
            ),
          ),
        )
    );}
}
