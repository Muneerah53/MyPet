import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
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
                'Payment',
                style: TextStyle(
                    color: Color(0XFFFF6B81),
                    fontSize: 34,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 280.0),
              child: Center(
                child: Text(
                  ':)',
                  style: TextStyle(
                      color: Color(0XFF52648B),
                      fontSize: 34,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]),
        )));
  }
}
