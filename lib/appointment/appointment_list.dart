// import 'dart:developer';
import 'package:MyPet/models/global.dart';
import 'package:intl/intl.dart';
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/appointment/appointment_tile.dart';
import 'package:MyPet/appointment/loading.dart';
import 'package:MyPet/petOwner_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Appointment.dart';

class AppointmentList extends StatefulWidget {
  String title;
  int type;
  AppointmentList({required this.title, required this.type, Key? key})
      : super(key: key);

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  List<AppointmentModel> _appList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    setState(() {
      _appList = [];
    });
    // log("init data from parent");
    //String usrUID = "FwwC3ijCi6ULQpiK8stDe9yv5Yp2";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usrUID = await prefs.getString('uid');

    CollectionReference appointmentDB =
    FirebaseFirestore.instance.collection('appointment');
    CollectionReference WorkShiftDB =
    FirebaseFirestore.instance.collection('Work Shift');
    CollectionReference petsDB = FirebaseFirestore.instance.collection('pets');
    List<AppointmentModel> appList = [];

    await appointmentDB
        .where("petOwnerID", isEqualTo: '$usrUID')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        Map<String, dynamic>? map = element.data() as Map<String, dynamic>?;
        //log("appointment: ${map}");

        String? appointmentID = map!['appointmentID'];
        String? petID = map['petID'];
        String? service = map['service'];
        String? workshiftID = map['workshiftID'];
        //geting the pet information
        var petsData = await petsDB.doc(petID).get();
        Map<String, dynamic>? petMap = petsData.data() as Map<String, dynamic>?;
        String? petName = petMap!['name'];
        String? petSpecies = petMap['species'];
        //geting pet date and time
        var workShiftData = await WorkShiftDB.doc(workshiftID).get();
        Map<String, dynamic>? workShiftMap =
        workShiftData.data() as Map<String, dynamic>?;
        //log("workShiftMap: $workShiftMap");
        String? date = workShiftMap!['date'];
        String? startTime = workShiftMap['startTime'];
        String? endTime = workShiftMap['endTime'];
        String? status = workShiftMap['status'];
        String? type = workShiftMap['type'];
        //we can test for the status here
        var oppDate = DateFormat('dd/MM/yyyy').parse(date.toString());
        var toDay = DateTime.now();
        bool test;
        if (widget.type == 0) {
          test = oppDate.difference(toDay).inDays == 0
              ? true
              : !oppDate.difference(toDay).isNegative;
        } else {
          test = oppDate.difference(toDay).inDays == 0
              ? false
              : oppDate.difference(toDay).isNegative;
        }
        if (test) {
          AppointmentModel appointmentModel = new AppointmentModel(
              appointmentUID: '$appointmentID',
              pet: '$petName',
              service: '$service',
              species: '$petSpecies',
              workshiftID: '$workshiftID',
              type: '$type',
              date: '$date',
              time: '$startTime - $endTime');

          appList.add(appointmentModel);
          setState(() {
            _appList.add(appointmentModel);
            // log("---setState--- ${_appList.length}");
          });
        }
      });

      /*setState(() {
        isLoading = false;
        _appList = [];
        _appList.addAll(appList);
        log("---setState--- ${_appList.length}");
      });*/
    }).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF4E3E3),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation:0,
          leading: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },

              child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
              style: backButton ),// <-- Button color// <-- Splash color

        ),
        body: isLoading
            ? Loading()
            : Column(
          children: [
            SizedBox(
              height: 40.0,
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     RawMaterialButton(
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (BuildContext context) =>
            //                   appointmentPage()),
            //         );
            //       },
            //       elevation: 0.0,
            //       fillColor: Colors.blue[100],
            //       child: Padding(
            //         padding: const EdgeInsets.all(2.0),
            //         child: Icon(
            //           Icons.arrow_back_ios,
            //           size: 42.0,
            //           color: Colors.white,
            //         ),
            //       ),
            //       padding: EdgeInsets.all(2.0),
            //       shape: CircleBorder(),
            //     ),
            //   ],
            // ),

            Text(
              widget.title,
              style: TextStyle(
                  color: Color(0xffe57285),
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: _appList.isEmpty ? Center( child: Text("no appointment has been booked yet "),)
                  : ListView.builder(
                  itemCount: _appList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child:
                      AppointmentTile(_appList[index], initData),
                    );
                  }),
            ),
          ],
        ));
  }
}