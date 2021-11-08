
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/models/global.dart';
import 'package:MyPet/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceUpdate extends StatefulWidget {
  final ServiceModel model;
  const ServiceUpdate(this.model, {Key? key}) : super(key: key);

  @override
  _ServiceUpdateState createState() => _ServiceUpdateState();
}

class _ServiceUpdateState extends State<ServiceUpdate> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();
  int? selectedTimeIndex;
  String? selectedTime;
  String? selectedShiftID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFF4E3E3),
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
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        'Service Name:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        '${widget.model.serviceName}',
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        'Service Price:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        '${widget.model.servicePrice}',
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 30, 0, 5),
                        width: 193,
                        height: 73,
                        child: ElevatedButton(
                            onPressed: () async {
                              await saveData();
                            },
                            child: const Text('Edit',
                              style: TextStyle( color:Colors.black,
                                  fontSize: 18),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xFFE7F2EC)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12))),
                            )),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                        width: 193,
                        height: 73,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel',
                              style: TextStyle( color:Colors.black,
                                  fontSize: 18),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xFFF3BFBD)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12))),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }


  saveData() async {
    if (selectedShiftID == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("please enter all required information"),
        backgroundColor: Colors.red,
      ));
    } else {
//remove old appointment
      await FirebaseFirestore.instance
          .collection('Work Shift')
          .doc(widget.model.serviceID)
          .update({"status": "Available"});
//set new ppointment
      await FirebaseFirestore.instance
          .collection('Work Shift')
          .doc(selectedShiftID)
          .update({
        "status": "Booked",
        // "appointmentID": "${widget.model.appointmentUID}"
      });

      await FirebaseFirestore.instance
          .collection('appointment')
          .doc(widget.model.serviceID)
          .update({"workshiftID": "$selectedShiftID"});

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("appointment has been updated successfully"),
        backgroundColor: Colors.green,
      ));
      await Future.delayed(
          Duration(seconds: 2),
              () => Navigator.of(
            context,
          ).pop());
    }
  }
}
