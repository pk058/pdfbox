import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdfbox/constants.dart';

class Photography extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF9F9F9),
//          image: DecorationImage(image: AssetImage('assets/images/photography.png'),
//          alignment: Alignment.topRight,
//          )
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 120, top: 80),
                  child: Image.asset("assets/images/photography_big.png")),
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
                  Text('Mobile Photography', style: kHeadingextStyle),
                  SizedBox(height: 16,),
                  Row(
                    children: <Widget>[
                      SvgPicture.asset('assets/icons/person.svg'),
                      SizedBox(width: 5,),
                      Text('13k'),
                      SizedBox(width: 20,),
                      SvgPicture.asset('assets/icons/star.svg'),
                      SizedBox(width: 5,),
                      Text('4.5'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("\$60", style: kSubheadingextStyle.copyWith(fontSize: 32),),
                      Text("\$70", style: TextStyle(color: kTextColor.withOpacity(0.5),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Course Content', style: kTitleTextStyle),
                                  SizedBox(height: 30,),
                                  CourseContent(number: '01',
                                    duration: 5.35,
                                    title: "Welcome to the Course", isDone: true),
                                  CourseContent(number: '02',
                                      duration: 10.35,
                                      title: "Photography - Intro", isDone: true),
                                  CourseContent(number: '03',
                                      duration: 11.00,
                                      title: 'PRO Methods', isDone: false),
                                ],
                              ),
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
                                    SizedBox(width: 20,),
                                    Expanded(
                                      child: Container(
                                        height: 56,
                                        width: 160,
                                        alignment: Alignment.center,
                                        child: Text("Add to Cart",
                                          style: kSubtitleTextSyule.copyWith(
                                              color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                        ),
                                        decoration: BoxDecoration(
                                          color: kBlueColor,
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseContent extends StatelessWidget {
  final String number;
  final double duration;
  final String title;
  final bool isDone;
  const CourseContent({
    Key key, this.number, this.duration, this.title, this.isDone = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            number, style: kHeadingextStyle.copyWith(
            color: kTextColor.withOpacity(0.15),
            fontSize: 32,
          ),
          ),
          SizedBox(width: 10,),
          RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: '$duration \n',
                      style: TextStyle(
                          color: kTextColor.withOpacity(0.5),
                      fontSize: 18,)),
                  TextSpan(text: title,
                  style: kSubtitleTextSyule.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  )),]
              )),
          Spacer(),
          Container(
            margin: EdgeInsets.only(left: 20),
            width: 35,
            height: 35,
            decoration: BoxDecoration(shape: BoxShape.circle,
            color: isDone ? kGreenColor: kGreenColor.withOpacity(0.5)),
            child: Icon(Icons.play_arrow, color: Colors.white,),
          )
        ],
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


