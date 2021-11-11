// import 'dart:developer';
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/models/notifaction_service.dart';
import 'appointment_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class previousTileAppt extends StatefulWidget {
  final AppointmentModel appointmentModel;
  Function initData;
  previousTileAppt(this.appointmentModel, this.initData);

  @override
  _previousTileApptState createState() => _previousTileApptState();
}

class _previousTileApptState extends State<previousTileAppt> {
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
                    Text('Pet : ${widget.appointmentModel.pet}'),
                    Text(
                        'Service : ${widget.appointmentModel.service.split(':')[0]}'),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date : ${widget.appointmentModel.date} '),
                    Text('Time : ${widget.appointmentModel.time}')
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