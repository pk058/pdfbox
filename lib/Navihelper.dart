import 'package:flutter/material.dart';
class Navi extends StatelessWidget {
  final String route;

  const Navi({Key key, this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        icon: Icon(Icons.blur_circular,),
        color: Colors.transparent,
        iconSize: 160,
        onPressed: (){
          Navigator.of(context).pushNamed(route);
        },
      ),
    );
  }
}