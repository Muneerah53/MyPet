import 'package:MyPet/petProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class inHouse extends StatefulWidget {
  const inHouse({Key? key}) : super(key: key);

  @override
  _inHouseState createState() => _inHouseState();
}



class _inHouseState extends State<inHouse> {
  Map<String, String > PetAppList = {};
  Map<String, String > PetsList = {};
  List<String> pets = <String>[];
  List<String> petsid = <String>[];



  //CollectionReference stream1 = FirebaseFirestore.instance.collection('appointment');

  // late DocumentSnapshot document ;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
          ), // <-- Button color// <-- Splash color
        ),
      backgroundColor: const Color(0xFFF4E3E3),
      body: SingleChildScrollView(
      child: Center(
        child: Column(
          children: [

            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Text(
                'Pets In House',
                style: TextStyle(
                    color: Color(0xffe57285),
                    fontSize: 34,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
              ),
            ),
          Container(




          ),
          ]))));
}


}
