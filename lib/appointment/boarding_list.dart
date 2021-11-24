
import 'package:MyPet/models/global.dart';
import 'package:intl/intl.dart';
//import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/appointment/appointment_tile.dart';
import 'package:MyPet/appointment/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appointment_boardingModel.dart';
import 'appointment_boardingModel.dart';
import 'boardingTile.dart';

class boardingList extends StatefulWidget {
  String title;
  int type;
  boardingList({required this.title, required this.type, Key? key})
      : super(key: key);

  @override
  _boardingListState createState() => _boardingListState();
}

class _boardingListState extends State<boardingList> {
  List<BoardingModel> _boardingList = [];
  bool isLoading = true;
  bool hasAppointment = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    setState(() {
      _boardingList = [];
      isLoading = true;
    });

    final waitList = <Future<void>>[];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usrUID = await prefs.getString('uid');

    CollectionReference boardingDB =
    FirebaseFirestore.instance.collection('boarding');

    CollectionReference petsDB = FirebaseFirestore.instance.collection('pets');

    List<BoardingModel> boardingList = [];

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

        //geting the pet information
        var petsData = await petsDB.doc(petID).get();
        Map<String, dynamic>? petMap = petsData.data() as Map<String, dynamic>?;

        String? petName = petMap!['name'];
        String? petSpecies = petMap['species'];

        bool test;
        var oppDate = DateFormat('dd/MM/yyyy').parse(startDate.toString());
        var toDay = DateTime.now();

        var deff = oppDate.difference(toDay).inMinutes;

        if (widget.type == 0) {
          test = deff >= 0 ? true : false;
        } else {
          test = deff < 0 ? true : false;
        }
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
            _boardingList.add(boardingModel);
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
                child: !isLoading && _boardingList.isEmpty
                    ? Center(
                    child: Text("You have no upcoming appointments",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey),
                    )
                )
                    : ListView.builder(
                    itemCount: _boardingList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child:
                        boardingTile(_boardingList[index], initData),
                      );
                    }),
              ),

     ])
      );
    }

  }
