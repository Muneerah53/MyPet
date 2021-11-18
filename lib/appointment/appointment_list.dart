
import 'package:MyPet/models/global.dart';
import 'package:intl/intl.dart';
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/appointment/appointment_tile.dart';
import 'package:MyPet/appointment/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    final waitList = <Future<void>>[];

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
        /*
        if (widget.type == 0) {
          test = oppDate.difference(toDay).inDays == 0
              ? true
              : !oppDate.difference(toDay).isNegative;
        } else {
          test = oppDate.difference(toDay).inDays == 0
              ? false
              : oppDate.difference(toDay).isNegative;
        }*/
        var deff = oppDate
            .difference(toDay)
            .inMinutes;
        // if(deff >= 0){
        //   test= true ;
        // }
        // else{
        //   test= false ;
        // }

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
                child: !isLoading && _appList.isEmpty
                    ? Center(
                    child: Text("You have no upcoming appointments",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey),
                    )
                )
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
                child: !isLoading && _appList.isEmpty
                    ? Center(
                    child: Text("You have no previous appointments",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey),
                    )
                )
                    : ListView.builder(
                    itemCount: _appList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child:
                        previousTileAppt(_appList[index], initData),);
                    }),
              ),
            ],
          ));
    }
  }
}
