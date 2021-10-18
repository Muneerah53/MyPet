import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'OrderList.dart';
import 'package:firebase_core/firebase_core.dart';
import 'appointment_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckUP extends StatefulWidget {
  CheckUP({this.date, this.pet, this.time,this.appointID});
  final String? date;
  final String? pet;
  final String? time;
  final String? appointID;

  _CheckUPState createState() => _CheckUPState();
}

class _CheckUPState extends State<CheckUP> {
  var selectedCurrency, selectedType;
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  int? t = 1;
  String? d;
  String? p;
  String? ti;
  String? id;
  void initState() {
    super.initState();
    d = widget.date;
    p = widget.pet;
    ti = widget.time;
    id= widget.appointID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4E3E3),
      body: SingleChildScrollView(
        child:
        Column(crossAxisAlignment: (CrossAxisAlignment.center), children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 80, 330, 0),
            padding: EdgeInsets.only(left: 10.0),
            width: 50,
            height: 50,
            child: BackButton(
                color: Color(0xFF2F3542)),


            decoration: BoxDecoration(
                color: Colors.lightBlueAccent, shape: (BoxShape.circle)),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 30),
            child: Text(
              'Check Up',
              style: TextStyle(
                  color: Color(0XFFFF6B81),
                  fontSize: 34,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
            child: Form(
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Employee").where("job", isEqualTo: "Doctor")
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<DropdownMenuItem> currencyItems = [];

                        if (!snapshot.hasData)
                          const Text("Loading.....");
                        else {
                          for (int i = 0;
                          i < (snapshot.data!).docs.length;
                          i++) {
                            DocumentSnapshot snap = (snapshot.data!).docs[i];
                            currencyItems.add(
                              DropdownMenuItem(
                                  child: Text(
                                    snap.get("name"),
                                    style: TextStyle(color: Colors.black38),
                                  ),
                                  value: ("${snap.get("name")}")),
                            );
                          }
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: new EdgeInsets.symmetric(vertical: 8.0, horizontal:  MediaQuery.of(context).size.width * 0.189,),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton<dynamic>(
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  items: currencyItems,
                                  hint: new Text("Select The Doctor ..."),
                                  onChanged: (currencyValue) {
                                    setState(() {
                                      selectedCurrency = currencyValue;
                                    });
                                  },
                                  value: selectedCurrency,
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 16,
                                    height: 1.0,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  focusColor: Colors.white,
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              style: TextStyle(
                  fontSize: 16,
                  height: 1.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.black38),
              decoration: InputDecoration(
                hintText: ('Reason...'),
                contentPadding:
                new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
                hintStyle: TextStyle(color: Colors.black38),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 80),
            width: 193,
            height: 73,
            child: ElevatedButton(
                onPressed: () {
                  if (selectedCurrency == null) {
                    showAlertDialog(context);
                  } else {
                    t = 0;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => OrderList(
                            type: t,
                            date: d,
                            pet: p,
                            time: ti,
                            appointID: id,
                          )),
                    );
                  }
                },
                child: Text('Next',
                    style:
                    TextStyle(fontStyle: FontStyle.italic, fontSize: 25)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0XFF2F3542)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
                )),
          ),
        ]),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Missing Input Feild"),
      content: Text("You Must Select a Doctor "),
      actions: [
        okButton,
      ],
    );
// show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}