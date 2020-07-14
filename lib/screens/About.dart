import 'package:flutter/material.dart';
import 'package:pdfbox/constants.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About PdfBox"),
        elevation: 0.0,
        backgroundColor: kPinkColor.withOpacity(0.70),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: Center(
          child: Text("I can Change the way of handling the Pdfs", style: kSubtitleTextSyule,)
      ),
    );
  }
}
