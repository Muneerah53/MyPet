import 'package:MyPet/appointment/boardingTile.dart';
import 'package:MyPet/models/global.dart';
import 'package:intl/intl.dart';
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/appointment/appointment_tile.dart';
import 'package:MyPet/appointment/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appointment_boardingModel.dart';
import 'previouseTileAppt.dart';

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
  List<BoardingModel> _bordingList = [];
  bool isLoading = true;
  bool hasAppointment = true;
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    setState(() {
      _appList = [];
      isLoading = true;
    });


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usrUID = await prefs.getString('uid');

    CollectionReference appointmentDB =
    FirebaseFirestore.instance.collection('appointment');

    CollectionReference WorkShiftDB =
    FirebaseFirestore.instance.collection('Work Shift');

    CollectionReference petsDB = FirebaseFirestore.instance.collection('pets');
    List<AppointmentModel> appList = [];
    List<BoardingModel> boardingList = [];
    await appointmentDB
        .where("petOwnerID", isEqualTo: '$usrUID')
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        setState(() {
          hasAppointment = false;
        });
      }
      for (var element in value.docs) {
        Map<String, dynamic>? map = element.data() as Map<String, dynamic>?;

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
        String? date = workShiftMap!['date'];
        String? startTime = workShiftMap['startTime'];
        String? endTime = workShiftMap['endTime'];
        String? status = workShiftMap['status'];
        String? type = workShiftMap['type'];
        bool test;
        var oppDate = DateFormat('dd/MM/yyyy').parse(date.toString());
        var toDay = DateTime.now();

        var deff = oppDate.difference(toDay).inMinutes;

        if (widget.type == 0) {
          test = deff >= 0 ? true : false;
        } else {
          test = deff < 0 ? true : false;
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
          });
        }
      }
    }).then((value) {
      setState(() {
        isLoading = false;
      });
    });

    CollectionReference boardingDB =
    FirebaseFirestore.instance.collection('boarding');

    await boardingDB
        .where("petOwnerID", isEqualTo: '$usrUID')
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        setState(() {
          hasAppointment = false;
        });
      }
      for (var element in value.docs) {
        Map<String, dynamic>? map = element.data() as Map<String, dynamic>?;

        String? boardingID = map!['boardingID'];
        String? petID = map['petID'];
        String? service = "Boarding";
        String? startDate = map['startDate'];
        String? endDate = map['endDate'];
        // DateTime startDateg =
        // DateFormat("EEE, MMM dd yyyy") as DateTime;
        //geting the pet information
        var petsData = await petsDB.doc(petID).get();
        Map<String, dynamic>? petMap = petsData.data() as Map<String, dynamic>?;

        String? petName = petMap!['name'];
        String? petSpecies = petMap['species'];

        bool test= true;
        // var s =  {startDateg.month}-{startDateg.year}-{startDateg.day};
        // var oppDate = DateFormat('dd/MM/yyyy').parse(s.toString());
        // var toDay = DateTime.now();
        //
        // var deff = oppDate.difference(toDay).inDays;
        //
        // if (widget.type == 0) {
        //   test = deff >= 0 ? true : false;
        // } else {
        //   test = deff < 0 ? true : false;
        // }
        if (test) {
          BoardingModel boardingModel = new BoardingModel(
            boardingUID: '$boardingID',
            pet: '$petName',
            service: '$service',
            species: '$petSpecies',
            startDate: '$startDate',
            endDate: '$endDate',
          );

          boardingList.add(boardingModel);
          setState(() {
            _bordingList.add(boardingModel);
            print("nnnnnnnnnn");
            print(_bordingList);
            print("tttttttttt");
          });
        }
      }
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
          elevation: 0,
          leading: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
              style: backButton), // <-- Button color// <-- Splash color
        ),
        body: isLoading
            ? Loading()
            : Column(
          children: [
            SizedBox(
              height: 40.0,
            ),

            Text(
              widget.title,
              style: TextStyle(
                  color: Color(0xffe57285),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: !isLoading && _appList.isEmpty && _bordingList.isEmpty
                  ? Center(
                  child: Text("You have no upcoming appointments",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.grey),)
              )
                  : ListView.builder(
                  itemCount: _bordingList.length,
                  itemBuilder: (context, index) {

                    if (widget.type == 0) {
                      return Container(
                        child:
                        boardingTile(_bordingList[index], initData),
                      );
                    }

                    else{
                      return Container(
                        child:
                        previousTileAppt(_appList[index], initData),
                      );
                    }
                  }),
            ),
          ],
        ));
  }
}
