import 'package:MyPet/models/global.dart';
import 'package:MyPet/service_model.dart';
import 'package:intl/intl.dart';
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/service_tile.dart';
import 'package:MyPet/appointment/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_newServices.dart';

class ServiceList extends StatefulWidget {

  ServiceList();

  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  GlobalKey _globalKey = navKeys.globalKeyAdmin;

  List<ServiceModel> _serviceList = [];
  bool isLoading = true;
  bool hasServices = true;
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    setState(() {
      _serviceList = [];
      isLoading = true;
    });

    final waitList = <Future<void>>[];


    CollectionReference services =
    FirebaseFirestore.instance.collection('service');
    List<ServiceModel> serviceList = [];

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

        ServiceModel serviceModel = new ServiceModel(
          serviceID: '$serviceID',
          serviceName: '$serviceName',
          servicePrice: '$servicePrice',
        );

        serviceList.add(serviceModel);
        setState(() {
          _serviceList.add(serviceModel);
        });

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



            Text(
              "Service",
              style: TextStyle(
                  color: Color(0xffe57285),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new services(initData)),
                );
              },

              child:Padding(
                  padding: EdgeInsets.only(left: 50,right:50,top: 35,bottom: 35),

                  child:
                  Text("+ Add New Service", style:
                  TextStyle(fontSize: 25))),
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Color(0XFFFF6B81)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)))


              ),
            ),

            Expanded(
              child: !isLoading && _serviceList.isEmpty
                  ? Center(
                child: Text("You have no services"),
              )
                  : ListView.builder(
                  itemCount: _serviceList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child:
                      ServiceTile(_serviceList[index], initData),
                    );
                  }),
            ),
          ],
        ));
  }
}