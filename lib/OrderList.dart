import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Payment.dart';
import 'package:intl/intl.dart';

class OrderList extends StatefulWidget {
  final int? type;
  final String? date;
  final String? pet;
  final String? time;
  final double? total;
  final String? appointID;

  const OrderList({this.type, this.date, this.pet, this.time, this.total,this.appointID});

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  int? t = 0;
  String title = '';
  String? p;
  String? d;
  String? tt;
  double? to;
  String? appointID;
  String? aa;
  void initState() {
    super.initState();
    t = widget.type;
    d = widget.date;
    tt = widget.time;
    p = widget.pet;
    to = widget.total;
    appointID = widget.appointID;
    title = (t == 0) ? "Check-Up" : "Grooming"; //here var is call and set to
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF4E3E3),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 80, 330, 0),
            padding: EdgeInsets.only(left: 10.0),
            width: 50,
            height: 50,
            child: BackButton(
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color: Colors.lightBlueAccent, shape: (BoxShape.circle)),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text(
              'Order List',
              style: TextStyle(
                  color: Color(0XFFFF6B81),
                  fontSize: 34,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 0, 30),
            alignment: Alignment.topLeft,
            child: Text(
              'Appointments',
              style: TextStyle(
                  color: Color(0XFF52648B),
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(25, 10, 25, 70),
            height: 350,
            width: double.infinity,
            decoration: new BoxDecoration(
              color: Color(0xffF4F4F4),
              borderRadius: new BorderRadius.all(Radius.circular(25.0)),
            ),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                        child: Text(
                          'Servise: ',
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 40, 20, 30),
                        child: Text(
                          title,
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(
                          'Pet: ',
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(35, 0, 20, 0),
                        child: Text(
                          p.toString(),
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                        child: Text(
                          'Time: ',
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                        child: Text(
                          tt.toString(),
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                        child: Text(
                          'Date: ',
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                        child: Text(
                          d.toString(),
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(
                          'Total: ',
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(
                          totalss(t.toString())! + '\$',
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 80),
            width: 193,
            height: 73,
            child: ElevatedButton(
                onPressed: () {
                  saveData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Payment()),
                  );
                },
                child: Text('Confirm',
                    style:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 25)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0XFF2F3542)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
                )),
          ),
        ]))));
  }

  String? totalss(String m) {
    if (m == "0") {
      aa = "50";
    } else {
      aa = to.toString();
    }
    return aa;
  }

  Future<void> saveData() async {
    FirebaseFirestore.instance.collection('orderService').add({
      'appointmentID': appointID,
      'service': title,
      'pet': p,
      'time': tt,
      'date': d,
      'totalPrice': totalss(t.toString())
    });

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('appointment ')
        .where('appointmentID', isEqualTo: appointID)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;
    for (var doc in docs) {
      if (doc.data() != null) {
        doc.reference.update({
          "state": "Booked"
        });
      }
    }

  }
}
