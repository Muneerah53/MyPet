import 'package:flutter/material.dart';
TextStyle petCardTitleStyle = new TextStyle( fontSize: 20 , color: Colors.black45,height:1.6,);
TextStyle petCardSubTitleStyle = new TextStyle(fontFamily: 'Gotham', fontSize: 25, color: Colors.black45,);
ButtonStyle buttons = ElevatedButton.styleFrom( primary: Colors.pinkAccent,
//padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
    textStyle: TextStyle(fontSize: 18,));
TextStyle statusCatStyle = new TextStyle(fontFamily: 'Gotham', fontSize: 25, color: Colors.lightBlue);
TextStyle statusDogStyle = new TextStyle(fontFamily: 'Gotham',  fontSize: 25, color: Colors.green);

class navKeys {
  static final globalKey = GlobalKey();
  static final globalKeyAdmin = GlobalKey();
}