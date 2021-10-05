import 'package:flutter/material.dart';
import 'petOwner_main.dart';
var primaryColor = const Color(0xff313540);
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
              padding: EdgeInsets.only(top: 280.0,left: 30,bottom: 20),
              child: Center(
                child: Text(
                  'your Appointment is Confirmed :),'
                      '\nsee you soon',
                  style: TextStyle(
                      color: Color(0XFF52648B),
                      fontSize: 34,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            MaterialButton(
              minWidth: 200,
              height: 60,
              padding: const EdgeInsets.all(20),
              color: primaryColor,
              textColor: Colors.white,
              child: const Text('Done'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onPressed: () async {
                  Navigator.push(context,MaterialPageRoute(builder: (_) =>ownerPage())) .catchError((error) => print('Delete failed: $error'));;


              },),

          ]),
        )));
  }
}
