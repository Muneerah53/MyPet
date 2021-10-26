import 'package:MyPet/appointment_main.dart';
import 'package:flutter/material.dart';
import 'Appointment.dart';
import 'models/global.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  GlobalKey _globalKey = navKeys.globalKey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF4E3E3),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
              style: backButton), // <-- Button color// <-- Splash color
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(children: [
            Container(
              padding: EdgeInsets.only(top: 280.0, left: 30, bottom: 20),
              child: Center(
                child: Text(
                  'your Appointment is Confirmed :),'
                  '\nsee you soon',
                  style: TextStyle(
                      color: Color(0XFF52648B),
                      fontSize: 34,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),],),),),);
  }}
