import 'package:flutter/material.dart';
import 'package:pdfbox/categories.dart';
import 'package:pdfbox/constants.dart';

class SearchBar extends SearchDelegate<Categories> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        primaryColor: kPinkColor.withOpacity(0.15),
        primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey[800]),
        primaryColorBrightness: theme.primaryColorBrightness,
        textTheme: theme.textTheme.copyWith(
            headline6: theme.textTheme.headline6
                .copyWith(
                color: Colors.black, fontSize: 20,
                fontWeight: FontWeight.w400))
    );
  }
@override

  String get searchFieldLabel => 'Search of anything';
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query='';
        })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.keyboard_arrow_left),
        onPressed: (){
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('Results');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final mylist = query.isEmpty ? categories
    : categories.where((element) => element.name.startsWith(query)).toList();
    return mylist.isEmpty? Center(child: Text('No Result Found...',
      style: kTitleTextStyle.copyWith(color: Colors.grey),))
        : ListView.builder(
      itemCount: mylist.length,
        itemBuilder: (context, index){
        final Categories listitem = mylist[index];
        return ListTile(
          contentPadding: EdgeInsets.only(top: 10, left: 20, right: 20),
          trailing: IconButton(icon: Icon(Icons.arrow_back, size: 20,),
              onPressed: (){
                query = listitem.name;
              }),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(listitem.name, style: TextStyle(fontSize: 20),),
              Text('${listitem.numofCourses} Courses', style: TextStyle(color: Colors.grey),),
              Divider()
            ],
          ),
          onTap: (){
            Navigator.pushNamed(context, listitem.Route);
          },
        );
        });
  }
}