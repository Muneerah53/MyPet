import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/models/notifaction_service.dart';
import 'appointment_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentTileBording extends StatefulWidget {
  final AppointmentModel appointmentModel;
  int type;
  Function initData;
  AppointmentTileBording(this.appointmentModel, this.type, this.initData);

  @override

  _AppointmentTileBordingState createState() => _AppointmentTileBordingState();
}

class _AppointmentTileBordingState extends State<AppointmentTileBording> {
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
        .collection("boarding")
        .doc(widget.appointmentModel.appointmentUID)
        .delete()
        .then((value) async {
      NotificationService.cancel(
          widget.appointmentModel.appointmentUID.hashCode);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Appointment has been deleted."),
        backgroundColor: Colors.green,
      ));
      widget.initData();
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
                    Text('From : ${widget.appointmentModel.date} '),
                    Text('To : ${widget.appointmentModel.time}')
                  ],
                ),
              ),
              widget.type == 0
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                        height: 36, //height of button
                        width: 113,
                        child: ElevatedButton(
                          onPressed: () {
                            updateAppoitment();
                          },
                          child: Text('Reschedule'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(
                                0xFFE7F2EC), //change background color of button
                            onPrimary: Colors
                                .black, //change text color of button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SizedBox(
                        height: 36, //height of button
                        width: 106, //width of button
                        child: ElevatedButton(
                          onPressed: () {
                            delAppoitment();
                          },
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(
                                0xFFF3BFBD), //change background color of button
                            onPrimary: Colors
                                .black, //change text color of button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                          ),
                        )),
                  )
                ],
              )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
