import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app3/Payment.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
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
}
