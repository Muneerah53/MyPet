import 'dart:developer';

import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/models/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentUpdate extends StatefulWidget {
  final AppointmentModel model;
  const AppointmentUpdate(this.model, {Key? key}) : super(key: key);

  @override
  _AppointmentUpdateState createState() => _AppointmentUpdateState();
}

class _AppointmentUpdateState extends State<AppointmentUpdate> {
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
                        'Pet:',
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
                        '${widget.model.pet}',
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
                        'Service:',
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
                        '${widget.model.type}',
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
                        'Select Day:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                        child: GestureDetector(
                            onTap: () {
                              datePicker();
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                controller: _date,
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 16,
                                  height: 1.0,
                                  fontStyle: FontStyle.italic,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Enter Date",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )),
                                ),
                              ),
                            ))),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        'Select Time:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        height: 120,
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Work Shift')
                                .where('date',
                                    isEqualTo: DateFormat('dd/MM/yyyy')
                                        .format(selectedDate))
                                .where('type', isEqualTo: widget.model.type)
                                .where('status', isEqualTo: "Available")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Text('loading');
                              if (snapshot.data!.docs.isEmpty)
                                return Padding(
                                    padding: EdgeInsets.all(20),
                                    child: const Text('No Available Times',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.grey),
                                        textAlign: TextAlign.center));
                              return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    String? stime = ((snapshot.data!)
                                            .docs[index]['startTime'] +
                                        ' - ' +
                                        (snapshot.data!).docs[index]
                                            ['endTime']);

                                    return OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.all(0),
                                            side: BorderSide(
                                                color: Colors.transparent)),
                                        onPressed: () {
                                          setState(() {
                                            selectedTimeIndex = index;
                                            selectedTime = stime;
                                            selectedShiftID =
                                                (snapshot.data!).docs[index].id;
                                          });
                                        },
                                        child: Card(
                                            color: selectedTimeIndex == index
                                                ? Color(0XFFFF6B81)
                                                : Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              width: 145,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              child: Container(
                                                child: ListTile(
                                                  title: Text(
                                                      ((snapshot.data!)
                                                                  .docs[index]
                                                              ['startTime'] +
                                                          ' - ' +
                                                          (snapshot.data!)
                                                                  .docs[index][
                                                              'endTime']) //,style: statusStyles[document['species']]
                                                      ,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color: selectedTimeIndex ==
                                                                  index
                                                              ? Colors.white
                                                              : Color(
                                                                  0XFF2F3542))),
                                                ),
                                              ),
                                            )));
                                  });
                            })),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 30, 0, 5),
                        width: 193,
                        height: 73,
                        child: ElevatedButton(
                            onPressed: () async {
                              await saveData();
                            },
                            child: Text('Edit My Appointment',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue[100]),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
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
                            child: Text('Cancel',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red[100]),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
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

  datePicker() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)); //from db
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _date.value = TextEditingValue(
            text: DateFormat('EEE, MMM dd yyyy').format(selectedDate));
      });
    }
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
          .doc(widget.model.workshiftID)
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
          .doc(widget.model.appointmentUID)
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
