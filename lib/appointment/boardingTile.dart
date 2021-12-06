
import 'package:MyPet/appointment/appointment_boardingModel.dart';
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/models/notifaction_service.dart';


import 'appointment_boardingModel.dart';
import 'appointment_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'appointment_update.dart';
import 'boarding_update.dart';


class boardingTile extends StatefulWidget {
  late final BoardingModel boardingModel;
  late Function initData;

  boardingTile(this.boardingModel, this.initData);

  @override
  _boardigTileState createState() => _boardigTileState();
}

class _boardigTileState extends State<boardingTile> {
  bool isLoading = true;

  updateAppoitment() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => Boarding_Update(widget.boardingModel)))
        .then((value) => widget.initData());

    /*Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AppointmentUpdate(widget.appointmentModel)),
    );*/
  }

  deleteAppoitment() async {
    await FirebaseFirestore.instance
        .collection("boarding")
        .doc(widget.boardingModel.boardingUID)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Appointment has been deleted."),
      backgroundColor: Colors.green,
    ));
    widget.initData();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                        height:36, //height of button
                        width:106,
                        child: ElevatedButton(
                          onPressed: () {
                            updateAppoitment();
                          },
                          child: Text('Reschedule'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFE7F2EC),//change background color of button
                            onPrimary: Colors.black,//change text color of button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),

                            ),
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                          ),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SizedBox(
                        height:36, //height of button
                        width:106, //width of button
                        child: ElevatedButton(
                          onPressed: () {
                            deleteAppoitment();
                          },
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF3BFBD),//change background color of button
                            onPrimary: Colors.black,//change text color of button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                          ),)

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
