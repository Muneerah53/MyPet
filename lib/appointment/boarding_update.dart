import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/appointment_object.dart';
import 'package:MyPet/models/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//import 'appointment_boardingModel.dart';

class Boarding_Update extends StatefulWidget {
  final AppointmentModel model;
  const Boarding_Update(this.model, {Key? key}) : super(key: key);

  @override
  _AppointmentUpdateState createState() => _AppointmentUpdateState();
}

class _AppointmentUpdateState extends State<Boarding_Update> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();
  int? selectedStartDate;
  String? selectedEndDate;
  String? selectedboardingUID;
  int isSelected1 = 0;
  int isSelected2 = 0;
  String? date1, _id, date2;
  appointment a = appointment();
  @override
  void initState() {
    super.initState();
    _id = widget.model.appointmentUID;

    date1 = widget.model.date;
    date2 = widget.model.time;
  }

  DateTime selected1Date = DateTime.now().add(Duration(days: 1));
  DateTime selected2Date = DateTime.now().add(Duration(days: 2));

  TextEditingController _date1 = new TextEditingController();
  TextEditingController _date2 = new TextEditingController();

  show1stDialog() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selected1Date,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)); //from db
    if (picked != null &&
        picked != selected1Date &&
        (_date2.text.isEmpty ||
            (picked.isBefore(selected1Date)) &&
                !(picked.isAfter(selected1Date)))) {
      setState(() {
        selected1Date = picked;
        _date1.value = TextEditingValue(
            text: DateFormat('EEE, MMM dd yyyy').format(selected1Date));
        if (_date2.text.isEmpty) {
          setState(() {
            selected2Date = picked.add(Duration(days: 1));
            _date2.value = TextEditingValue(
                text: DateFormat('EEE, MMM dd yyyy').format(selected2Date));
            isSelected2 = 1;
          });
        }
      });
      isSelected1 = 1;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("drop-off date must be before pick-up date "),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  show2ndDialog() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selected1Date.add(Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)); //from db
    if (picked != null &&
        picked != selected2Date &&
        !(picked.isBefore(selected1Date)) &&
        (picked.isAfter(selected1Date))) {
      setState(() {
        selected2Date = picked;
        _date2.value = TextEditingValue(
            text: DateFormat('EEE, MMM dd yyyy').format(selected2Date));
      });
      isSelected2 = 1;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("pick-up date must be after drop-off date "),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        'Pet:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 10),
                      child: Text(
                        '${widget.model.pet}',
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Text(
                        'Service:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        'Boarding',
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    /*Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        'Service:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        '${widget.model.type}',
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold),
                      ),
                    ),*/
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
                      child: Text(
                        'Select Drop-Off Date:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                        child: GestureDetector(
                            onTap: () {
                              show1stDialog();
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                controller: _date1,
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 16,
                                  height: 1.0,
                                  fontStyle: FontStyle.italic,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Enter Drop-Off Date",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )),
                                ),
                              ),
                            ))),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Text(
                        'Select Pick-Up Date:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: GestureDetector(
                            onTap: () {
                              if (isSelected1 == 0)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "You Must Select Drop-Off Date First"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              else
                                show2ndDialog();
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                controller: _date2,
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 16,
                                  height: 1.0,
                                  fontStyle: FontStyle.italic,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Enter Pick-Up Date",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )),
                                ),
                              ),
                            ))),

                    /*Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        'Select Time:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),*/
                    Container(
                        height: 120,
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('boarding')
                                .where('date',
                                isEqualTo: DateFormat('dd/MM/yyyy')
                                    .format(selectedDate))
                                .where('type', isEqualTo: widget.model.type)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Text('loading');

                              int i = 0;
                              return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    var t = DateTime.now().hour.toString();

                                    return OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.all(0),
                                            side: BorderSide(
                                                color: Colors.transparent)),
                                        onPressed: () {
                                          setState(() {
                                            //  selectedTimeIndex = index;
                                            //   selectedTime = stime;
                                            selectedboardingUID =
                                                (snapshot.data!).docs[index].id;
                                          });
                                        },
                                        child: Card(
                                          //color: selectedTimeIndex == index
                                          //   ? Color(0XFFFF6B81)
                                          //    : Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    20.0)),
                                            child: Container(
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                margin: EdgeInsets.only(
                                                    left: 20, right: 20),
                                                width: 145,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      50.0),
                                                ),
                                                child: Container(
                                                  child: ListTile(),
                                                ))));
                                  });
                            })),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 30, 0, 5),
                        width: 193,
                        height: 73,
                        child: ElevatedButton(
                            onPressed: () async {
                              await saveData(
                                startDate: selected1Date,
                                endDate: selected2Date,
                              );
                              if ((isSelected1 == 0) || (isSelected2 == 0)) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Please fill out all fields."),
                                  backgroundColor: Theme.of(context).errorColor,
                                ));
                              } else {
                                a.time = DateFormat('EEE, MMM dd yyyy')
                                    .format(selected2Date);
                                a.date = DateFormat('EEE, MMM dd yyyy')
                                    .format(selected1Date);
                              }
                            },
                            child: const Text(
                              'Edit',
                              style:
                              TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xFFE7F2EC)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                            )),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                        width: 193,
                        height: 73,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style:
                              TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xFFF3BFBD)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  datePicker() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)); //from db
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _date.value = TextEditingValue(
            text: DateFormat('EEE, MMM dd yyyy').format(selectedDate));
      });
    }
  }

  saveData({DateTime? startDate, DateTime? endDate}) async {
    if (_id == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("please enter all required information"),
        backgroundColor: Colors.red,
      ));
    } else {
/*remove old appointment
      await FirebaseFirestore.instance
          .collection('Work Shift')
          .doc(widget.model.workshiftID)
          .update({"status": "Available"});
//set new ppointment
      await FirebaseFirestore.instance
          .collection('Work Shift')
          .doc(selectedShiftID)
          .update({
        "status": "Booked",
        // "appointmentID": "${widget.model.appointmentUID}"
      });*/

      // Calculate total price
      final double totalPrice =
          75.0 * selected2Date.difference(selected1Date).inDays;

      await FirebaseFirestore.instance
          .collection('boarding')
          .doc(widget.model.appointmentUID)
          .update(
        {
          'endDate': DateFormat('EEE, MMM dd yyyy').format(endDate!),
          'startDate': DateFormat("EEE, MMM dd yyyy").format(startDate!),
          'totalPrice': totalPrice,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("appointment has been updated successfully"),
        backgroundColor: Colors.green,
      ));
      await Future.delayed(
          Duration(seconds: 2),
              () => Navigator.of(
            context,
          ).pop());
    }
  }
}

