import 'dart:developer';
import 'appointment_tile.dart';
// import 'package:MyPet/petOwner_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Appointment.dart';

class AppointmentList extends StatefulWidget {
  String title;
  AppointmentList({required this.title, Key? key}) : super(key: key);

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
        String? petID = map!['petID'];
        String? service = map['service'];
        String? workshiftID = map['workshiftID'];

        //geting the pet information

        var petsData = await petsDB.doc(petID).get();
        Map<String, dynamic>? petMap = petsData.data() as Map<String, dynamic>?;
        String? petName = petMap!['name'];
        String? petSpecies = petMap['species'];
        if (true) {
          AppointmentModel appointmentModel = new AppointmentModel(
            pet: '$petName',
            service: '$service',
            species: '$petSpecies',

          );

          appList.add(appointmentModel);
          setState(() {
            _appList.add(appointmentModel);
            log("---setState--- ${_appList.length}");
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
        body: isLoading
            ? Loading()
            : Column(
          children: [
            SizedBox(
              height: 60.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              appointmentPage()),
                    );
                  },
                  elevation: 0.0,
                  fillColor: Colors.blue[100],
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 42.0,
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.all(2.0),
                  shape: CircleBorder(),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 26.0,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: _appList.isEmpty
                  ? Center(
                child: Text("no appointment has been booked yet "),
              )
                  : ListView.builder(
                  itemCount: _appList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: AppointmentTile(_appList[index]),
                    );
                  }),
            ),
          ],
        ));
  }
}
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[100],
      child: Center(
        child: Text('Loading ...'),
      ),
    );
  }
}
