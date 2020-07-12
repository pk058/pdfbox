import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdfbox/constants.dart';

class PdfViewPage extends StatefulWidget {
  final String path;

  const PdfViewPage({Key key, this.path}) : super(key: key);
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  int _currentPage = 0;
  int _totalPages = 0;
  PDFViewController _pdfViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pdf Viewer"),
        elevation: 0.0,
        backgroundColor: kPinkColor.withOpacity(0.70),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      extendBodyBehindAppBar: true,

      body: widget.path != null
          ? PDFView(
        filePath: widget.path,
        swipeHorizontal: true,
        autoSpacing: true,
        fitEachPage: true,
        onViewCreated: (PDFViewController vc) {
          _pdfViewController = vc;
        },
        onRender: (_pages) {
          setState(() {
            _totalPages = _pages;
          });
        },
        onPageChanged: (int page, int total) {
              setState(() {});
            },
      )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _currentPage > 0
              ? FloatingActionButton(
            elevation: 0.0,
            backgroundColor: kPinkColor,
            child: Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              _currentPage -= 1;
              _pdfViewController.setPage(_currentPage);
            },
          )
              : Offstage(),
          SizedBox(width: 250,),
          _currentPage+1 < _totalPages
              ? FloatingActionButton(
            elevation: 0.0,
            backgroundColor: kPinkColor,
            child: Icon(Icons.keyboard_arrow_right),
            onPressed: () {
              _currentPage += 1;
              _pdfViewController.setPage(_currentPage);
            },
          ) : Offstage(),
        ],
      ),

//      floatingActionButton: Row(
//        mainAxisAlignment: MainAxisAlignment.end,
//        children: <Widget>[
//          _currentPage > 0
//              ? FloatingActionButton.extended(
//            backgroundColor: Colors.red,
//            label: Text("Go to ${_currentPage - 1}"),
//            onPressed: () {
//              _currentPage -= 1;
//              _pdfViewController.setPage(_currentPage);
//            },
//          )
//              : Offstage(),
//          _currentPage+1 < _totalPages
//              ? FloatingActionButton.extended(
//            backgroundColor: Colors.green,
//            label: Text("Go to ${_currentPage + 1}"),
//            onPressed: () {
//              _currentPage += 1;
//              _pdfViewController.setPage(_currentPage);
//            },
//          )
//              : Offstage(),
//        ],
//      ),
    );
  }
}