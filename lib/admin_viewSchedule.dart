import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'admin_viewappts.dart';
import 'models/global.dart';
import 'admin_main.dart';
class viewSChPage extends StatefulWidget {
  const viewSChPage({Key? key}) : super(key: key);

  @override
  _viewSChPageState createState() => _viewSChPageState();
}

class _viewSChPageState extends State<viewSChPage> {
  GlobalKey _globalKey = navKeys.globalKeyAdmin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation:0,
          shadowColor: Colors.transparent,
          leading: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },

              child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
              style: backButton ),// <-- Button color// <-- Splash color

        ),

        backgroundColor: const Color(0xFFF4E3E3),
    body:Center(
    child: SingleChildScrollView(
    child:Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 70),
          child: Text(
            'Manage Schedule',
            style: TextStyle(
                color: Color(0XFFFF6B81),
                fontSize: 34,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
        ),
    SizedBox(height: 30),
    Container(
      width: 344,
      height: 120,
      child: ElevatedButton(
          onPressed: () {
            BottomNavigationBar navigationBar =  _globalKey.currentWidget as BottomNavigationBar;
            navigationBar.onTap!(1);
            /*   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => appointCalendar()),
                    ); */
          },
          child: Text('View Schedule',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all(Color(0XFF2F3542)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0))),
          )),







  ),
  SizedBox(height: 30),
  Container(
    width: 344,
    height: 120,
    child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => new AdminAppointments()),
          );
        },
        child: Text('View Appointments',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(Color(0XFFFF6B81)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0))),
        )),






  ),
        SizedBox(height: 120)
],

      )


    )));
  }
}
