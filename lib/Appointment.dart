import 'package:MyPet/appointment/appointment_list.dart';
import 'package:flutter/material.dart';
//import 'package:MyPet/admin_calender.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'petOwner_main.dart';
import 'appointment_main.dart';
import 'package:MyPet/models/global.dart';

class appointmentPage extends StatefulWidget {
  const appointmentPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<appointmentPage> createState() => _AppointPageState();
}

class _AppointPageState extends State<appointmentPage> {
  GlobalKey _globalKey = navKeys.globalKey;
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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: ElevatedButton(
              onPressed: () {
                BottomNavigationBar navigationBar =  _globalKey.currentWidget as BottomNavigationBar;
                navigationBar.onTap!(0);

              },
              child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
              style: backButton), // <-- Button color// <-- Splash color
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: (CrossAxisAlignment.center),
              children: [
                // Container(
                //   margin: const EdgeInsets.fromLTRB(0, 80, 330, 0),
                //   padding: EdgeInsets.only(left: 10.0),
                //   width: 50,
                //   height: 50,
                //   child: BackButton(
                //     color: Colors.white,
                //   ),
                //   decoration: BoxDecoration(
                //       color: Colors.lightBlueAccent, shape: (BoxShape.circle)),
                // ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                  child: Text(
                    'Appointment',
                    style: TextStyle(
                        color:Color(0xffe57285),
                        fontSize: 34,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: 344,
                  height: 120,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => AppoinMain()),
                        );
                      },
                      child: Text('Appointment Booking',
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
                SizedBox(height: 40),
                Container(
                  width: 344,
                  height: 120,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AppointmentList(
                                      title: 'Upcoming Appointment', type: 0)),
                        );
                      },
                      child: Text('Upcoming Appointment',
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
                SizedBox(height: 40),
                Container(
                  width: 344,
                  height: 120,
                  child: ElevatedButton(
                      onPressed: () {

                      },
                      child: Text('Previous Appointment',
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
              ],
            ),
          ),
        ));
  }
}
