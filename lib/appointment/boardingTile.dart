
import 'package:MyPet/appointment/appointment_boardingModel.dart';
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/models/notifaction_service.dart';

import 'appointment_boardingModel.dart';
import 'appointment_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class boardingTile extends StatefulWidget {
  late final BoardingModel boardingModel;
  late Function initData;

  boardingTile(this.boardingModel, this.initData);

  @override
  _boardigTileState createState() => _boardigTileState();
}

class _boardigTileState extends State<boardingTile> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pet : ${widget.boardingModel.pet}'),
                    Text(
                        'Service : ${widget.boardingModel.service.split(':')[0]}'),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Drop-off Date : ${widget.boardingModel.startDate} '),
                    Text('Pick-up Date : ${widget.boardingModel.endDate}')
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}