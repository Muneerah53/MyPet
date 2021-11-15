import 'package:MyPet/models/global.dart';
import 'package:MyPet/PetType_model.dart';
import 'package:intl/intl.dart';
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/PetType_tile.dart';
import 'package:MyPet/appointment/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PetTypeList extends StatefulWidget {
  String title;
  int type;
  PetTypeList({required this.title, required this.type, Key? key})
      : super(key: key);

  @override
  _PetTypeList createState() => _PetTypeList();
}

class _PetTypeList extends State<PetTypeList> {
  List<PetType> _petTypeList = [];
  bool isLoading = true;
  bool hasPetType = true;
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    setState(() {
      _petTypeList = [];
      isLoading = true;
    });

    final waitList = <Future<void>>[];


    CollectionReference services =
    FirebaseFirestore.instance.collection('PetTypes');
    List<PetType> serviceList = [];

    await services.get()
        .then((value) async {
      if (value.docs.isEmpty) {
        setState(() {
          hasPetType= false;
        });
      }

      for (var element in value.docs) {
        Map<String, dynamic>? map = element.data() as Map<String, dynamic>?;

        String? petTypeID = map!['petTypeID'];
        String? petTypeName = map['petTypeName'];

        PetType petModel = new PetType(
          petTypeID: '$petTypeID',
          petTypeName: '$petTypeName',
        );

        serviceList.add(petModel);
        setState(() {
          _petTypeList.add(petModel);
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
              child: !isLoading && _petTypeList.isEmpty
                  ? Center(
                child: Text("You have no services"),
              )
                  : ListView.builder(
                  itemCount: _petTypeList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child:
                      PetTypeTile(_petTypeList[index], initData),
                    );
                  }),
            ),
          ],
        ));
  }
}
