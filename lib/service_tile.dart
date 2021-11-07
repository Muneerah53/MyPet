// import 'dart:developer';
import 'package:MyPet/service_model.dart';
import 'package:MyPet/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceTile extends StatefulWidget {
  final serviceModel serviceModel;
  Function initData;
  ServiceTile(this.serviceModel, this.initData);

  @override
  _ServiceTile createState() => _ServiceTile();
}

class _ServiceTile extends State<ServiceTile> {
  bool isLoading = true;
  updateAppoitment() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => serviceUpdate(widget.serviceModel)))
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
        .doc(widget.serviceModel.appointmentUID)
        .delete();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Appointment has been deleted."),
          backgroundColor: Colors.green,
        ));
        // log("init data from child");
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
                    Text('Pet : ${widget.serviceModel.pet}'),
                    Text(
                        'Service : ${widget.serviceModel.service.split(':')[0]}'),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date : ${widget.serviceModel.date} '),
                    Text('Time : ${widget.serviceModel.time}')
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
                            delAppoitment();
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