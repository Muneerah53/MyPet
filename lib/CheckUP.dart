import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app3/OrderList.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app3/main.dart';

class CheckUP extends StatefulWidget {
  const CheckUP({Key? key}) : super(key: key);

  @override
  _CheckUPState createState() => _CheckUPState();
}

class _CheckUPState extends State<CheckUP> {
  String dropdownvalue = 'Assiri';
  var items = ['Assiri', 'Al-qhtani', 'Ah-sunadi'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4E3E3),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
            margin: const EdgeInsets.fromLTRB(30, 40, 30, 40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding:
                          (EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: new DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: dropdownvalue,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                                value: items, child: Text(items));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue as String;
                            });
                          },
                          hint: Text("Select The Doctor ..."),
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 16,
                            height: 1.0,
                            fontStyle: FontStyle.italic,
                          ),
                          focusColor: Colors.white,
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ))
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => OrderList()),
                  );
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

//
//   Future getDoctors() async {
//     try {
//       await
//     }catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
}
