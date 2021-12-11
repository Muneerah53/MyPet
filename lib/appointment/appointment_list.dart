import 'dart:developer';

import 'package:MyPet/models/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/appointment/appointment_tile.dart';
import 'package:MyPet/appointment/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'appointment_tile_bording.dart';


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
  bool isLoadingAppointment = true;
  bool isLoadingBording = true;
  bool hasAppointment = true;
  bool hasBording = true;
  String? userUID;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    userUID = user?.uid;
    initData();
  }

  initData() async {
    setState(() {
      _appList = [];
      hasAppointment = true;
      hasBording = true;
      isLoadingAppointment = true;
      isLoadingBording = true;
    });
    await getAppointment();
    await getBording();
  }
  getAppointment() async {

    CollectionReference appointmentDB =
    FirebaseFirestore.instance.collection('appointment');

    CollectionReference WorkShiftDB =
    FirebaseFirestore.instance.collection('Work Shift');

    CollectionReference petsDB = FirebaseFirestore.instance.collection('pets');

    await appointmentDB
        .where("petOwnerID", isEqualTo: '$userUID')
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

          setState(() {
            _appList.add(appointmentModel);
          });
        }
      }
    }).then((value) {
      setState(() {
        isLoadingAppointment = false;
      });
    });
  }

  getBording() async {
    CollectionReference petsDB = FirebaseFirestore.instance.collection('pets');
    FirebaseFirestore.instance
        .collection("boarding")
        .where("petOwnerID", isEqualTo: '$userUID')
        .get()
        .then((QuerySnapshot data) async {
      if (data.docs.isEmpty) {
        setState(() {
          hasBording = false;
        });
      }

      for (var doc in data.docs) {
        bool e = false;

        String petOwnerID = doc['petOwnerID'];
        String boardingID = doc['boardingID'];

        String petID = doc['petID'];
        String totalPrice = doc['totalPrice'].toString();
        DateTime startDate =
        DateFormat("EEE, MMM dd yyyy").parse("${doc['startDate']}");
        DateTime endDate =
        DateFormat("EEE, MMM dd yyyy").parse("${doc['endDate']}");
        late String petOnerFullName, type, empId, petName, petSpecies;

        await FirebaseFirestore.instance
            .collection("pet owners")
            .where('ownerID', isEqualTo: petOwnerID)
            .get()
            .then((QuerySnapshot pwdata) async {
          try {
            var docPetOwner = pwdata.docs.single;
            if (docPetOwner.exists) {
              petOnerFullName = docPetOwner['fname'].toString() +
                  " " +
                  docPetOwner['lname'].toString();
              //geting the pet information
              var petsData = await petsDB.doc(petID).get();

              Map<String, dynamic>? petMap =
              petsData.data() as Map<String, dynamic>?;

              petName = petMap!['name'];
              petSpecies = petMap['species'];
            }
          } catch (StateError) {
            e = true;
            print(petOwnerID + 'not found');
          }

          if (!e) {
            bool test;
            var toDay = DateTime.now();
            var deff = startDate.difference(toDay).inMinutes;
            if (widget.type == 0) {
              test = deff >= 1 ? true : false;
            } else {
              test = deff < 1 ? true : false;
            }
            if (test) {
              AppointmentModel dropOff = AppointmentModel(
                  appointmentUID: '$boardingID',
                  pet: '$petName',
                  service: 'boarding',
                  species: '$petSpecies',
                  workshiftID: 'workshiftID',
                  type: 'type',
                  date: '${startDate.day}-${startDate.month}-${startDate.year}',
                  time: '${endDate.day}-${endDate.month}-${endDate.year}');

              setState(() {
                _appList.add(dropOff);
              });
            }
          }
        });
      }
    }).then((value) {
      setState(() {
        isLoadingBording = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 0) {
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
        body: isLoadingBording || isLoadingAppointment
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
              child: !isLoadingBording &&
                  !isLoadingAppointment &&
                  _appList.isEmpty
                  ? Center(
                child: Text("You have no upcoming appointments",
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey),),
                          )
                  : ListView.builder(
                  itemCount: _appList.length,
                  itemBuilder: (context, index) {
                   // if (widget.type == 0) {
                      return _appList[index].service == "boarding"
                          ? Container(
                        child:AppointmentTileBording(
                            _appList[index],
                            widget.type,
                            initData),
                      )
                          : Container(
                        child: AppointmentTile(
                            _appList[index],
                            widget.type,
                            initData),
                      );
                     }))])); }
                      else {
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
          body: isLoadingBording || isLoadingAppointment
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
                    child: !isLoadingBording &&
                        !isLoadingAppointment &&
                        _appList.isEmpty
                        ? Center(
                      child: Text("You have no previous appointments",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey),),
                    )
                        : ListView.builder(
                        itemCount: _appList.length,
                        itemBuilder: (context, index) {
                          return _appList[index].service == "boarding"
                              ? Container(
                            child: AppointmentTileBording(
                                _appList[index],
                                widget.type,
                                initData),
                          )
                              : Container(
                            child:  AppointmentTile(
                                _appList[index],
                                widget.type,
                                initData),
                          );
                        })
                       )
                     ])
                   );
                  }

  }
}
