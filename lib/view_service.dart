import 'package:MyPet/models/global.dart';
import 'package:intl/intl.dart';
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/service_tile.dart';
import 'package:MyPet/appointment/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentList extends StatefulWidget {
  String title;
  int type;
  AppointmentList({required this.title, required this.type, Key? key})
      : super(key: key);

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  List<AppointmentModel> serviceList = [];
  bool isLoading = true;
  bool hasServices = true;
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    setState(() {
      serviceList = [];
      isLoading = true;
    });

    final waitList = <Future<void>>[];


    CollectionReference services =
    FirebaseFirestore.instance.collection('service');
    List<AppointmentModel> servicesList = [];

    await services.get()
        .then((value) async {
      if (value.docs.isEmpty) {
        setState(() {
          hasServices = false;
        });
      }

      for (var element in value.docs) {
        Map<String, dynamic>? map = element.data() as Map<String, dynamic>?;

        String? serviceID = map!['serviceID'];
        String? serviceName = map['serviceName'];
        String? servicePrice = map['servicePrice'];


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
              child: !isLoading && serviceList.isEmpty
                  ? Center(
                child: Text("You have no services"),
              )
                  : ListView.builder(
                  itemCount: serviceList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child:
                      ServiceTile(serviceList[index], initData),
                    );
                  }),
            ),
          ],
        ));
  }
}
