import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mypet/admin_calender.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mypet/add_dr.dart';
import 'package:mypet/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomePage extends StatefulWidget {
  AdminHomePage();


  State<AdminHomePage> createState() => _adminHomePageState();
}

class _adminHomePageState extends State<AdminHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: const Color(0xFFF4E3E3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              alignment: Alignment.topLeft,
                onPressed: () async {
                await FirebaseAuth.instance.signOut().catchError((error){
                  print(error.toString());
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));},
                icon: Icon(Icons.logout)),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: Text(
                'Admin',
                style: TextStyle(
                    color: Color(0XFFFF6B81),
                    fontSize: 34,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 50),
            CircleAvatar(
              radius: 70,
              backgroundImage:AssetImage('images/logo.jpeg'),
            ),
            SizedBox(height: 50),
            Container(
              width: 344,
              height: 153,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => appointCalendar()),
                    );
                  },
                  child: Text('Manage Schedule',
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
            SizedBox(height: 50),
            Container(
              width: 344,
              height: 153,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => docList()),
                    );
                  },
                  child: Text('Manage Employees',
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
          ],
        ),
      ),
    );
  }
}