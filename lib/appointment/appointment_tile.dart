// import 'dart:developer';
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/models/notifaction_service.dart';
import 'appointment_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentTile extends StatefulWidget {
  final AppointmentModel appointmentModel;
  Function initData;
  AppointmentTile(this.appointmentModel, this.initData);

  @override
  _AppointmentTileState createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  bool isLoading = true;
  updateAppoitment() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AppointmentUpdate(widget.appointmentModel)))
        .then((value) => widget.initData());

    /*Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AppointmentUpdate(widget.appointmentModel)),
    );*/
  }
  delAppoitment() async {
    await FirebaseFirestore.instance
        .collection("appointment")
        .doc(widget.appointmentModel.appointmentUID)
        .delete()
        .then((value) async {
      // log("delete");
      NotificationService.cancel(widget.appointmentModel.appointmentUID.hashCode);
      await FirebaseFirestore.instance
          .collection('Work Shift')
          .doc(widget.appointmentModel.workshiftID)
          .update({"status": "Available"}).then((value) {
        // log("update");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Appointment has been deleted."),
          backgroundColor: Colors.green,
        ));
        // log("init data from child");
        widget.initData();
      });
    });
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        updateAppoitment();
                      },
                      child: Text('Update'),
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          primary:Color(0xff313540),
                          textStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        delAppoitment();
                      },
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          primary: Color(0xff313540),
                          textStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}