import 'package:MyPet/Mypets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Payment.dart';
import 'package:intl/intl.dart';
import 'models/global.dart';
import 'models/data.dart';

class AppointmentDetails extends StatefulWidget {
final String? appointID,details;
  const AppointmentDetails({this.appointID,  this.details});

  @override
  AppointmentDetailsState createState() => AppointmentDetailsState();
}

class AppointmentDetailsState extends State<AppointmentDetails> {
  late List<String> details;
  String? appointID, detail;
  void initState() {
    super.initState();
    appointID = widget.appointID;
    detail = widget.details;
    details = detail!.split(",");
    print(details);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF4E3E3),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation:0,
          leading: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },

              child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
              style: backButton ),// <-- Button color// <-- Splash color

        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [


                  Container(
                    margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    height:  550,
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      color: Color(0xffF4F4F4),
                      borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child:
                    StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection("appointment")
    .where('appointmentID', isEqualTo: appointID )
        .snapshots(),
    builder: (context, snapshot) {

    if (!snapshot.hasData) return const Text('Something went wrong.');
    if (snapshot.data!.docs.isEmpty)
    return Padding(
    padding: EdgeInsets.all(20),
    child: const Text('Something went wrong.',
    style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.grey),
    textAlign: TextAlign.center));

    String petID = snapshot.data!.docs[0]['petID'];

    return SingleChildScrollView(

        child: Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(20, 30, 20, 10),

                                child: Text('Appointment Details',
                                  style: TextStyle(
                                      color: Color(0XFFFF6B81),
                                      fontSize: 20,

                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,

                                ),
                              ),

                            ],
                          ),
                        ),

                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                child: Text(
                                  'Service:',
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 18,

                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                             Expanded(
                               child: Container(
                               margin: const EdgeInsets.fromLTRB(10, 40, 20, 5),
                               child: Text(
                                 snapshot.data!.docs[0]['service'].toString(),
                                 maxLines: 3,
                                 overflow: TextOverflow.ellipsis,
                                 style: TextStyle(
                                     color: Color(0XFF52648B),
                                     fontSize: 18,
                                     fontWeight: FontWeight.w400),
                                 textAlign: TextAlign.left,
                               ),
                             ),),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                child: Text(
                                  'Employee: ',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 18,

                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                child: Text(
                               details[0].toString()+" "+ details[1].toString(),
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
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
                                margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                child: Text(
                                  'Pet Owner: ',
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                child: Text(
                                  details[2].toString(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
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
                                margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                child: Text(
                                  'Date:',
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                child: Text(
                                  details[3].toString(),
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
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
                                margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                child: Text(
                                  'Time:',
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                child: Text(
                                  details[4].toString()+"-"+ details[6].toString(),
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
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
                                margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                child: Text(
                                  'Total: ',
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 18,

                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                child: Text(
                                 snapshot.data!.docs[0]['totalPrice'].toString()+" SR",
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(20, 50, 20, 10),

                                  child: Text('Pet Information:',
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 20,

                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,

                                  ),
                              ),

                            ],
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("pets")
                                .where('petId', isEqualTo: petID )
                                .snapshots(),
                            builder: (context, s) {





                              if (!s.hasData) return const Text('Something went wrong.');
                              if (s.data!.docs.isEmpty)
                                return Padding(
                                    padding: EdgeInsets.all(20),
                                    child: const Text('Something went wrong.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.grey),
                                        textAlign: TextAlign.center));

                            return Column(children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                      child: Text(
                                        'Name: ',
                                        style: TextStyle(
                                            color: Color(0XFF52648B),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                      child: Text(
                                        s.data!.docs[0]['name'].toString(),
                                        style: TextStyle(
                                            color: Color(0XFF52648B),
                                            fontSize: 18,
),
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
                                      margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                      child: Text(
                                        'Date Of Birth: ',
                                        style: TextStyle(
                                            color: Color(0XFF52648B),
                                            fontSize: 18,

                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                      child: Text(
                                        s.data!.docs[0]['birthDate'].toString(),
                                        style: TextStyle(
                                            color: Color(0XFF52648B),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
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
                                      margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                      child: Text(
                                        'Gender: ',
                                        style: TextStyle(
                                            color: Color(0XFF52648B),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                      child: Text(
                                        s.data!.docs[0]['gender'].toString(),
                                        style: TextStyle(
                                            color: Color(0XFF52648B),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
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
                                      margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                      child: Text(
                                        'Species: ',
                                        style: TextStyle(
                                            color: Color(0XFF52648B),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(10, 10, 20, 5),
                                      child: Text(
                                        s.data!.docs[0]['species'].toString(),
                                        style: TextStyle(
                                            color: Color(0XFF52648B),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),





                            ],)



                            ;

                            })



                        ,
                      ],




    ));



    })
                  ),


                ]))));
  }



 Widget getPet(String petOwnerID) {

    return   Container(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 40, 20, 30),
            child: Text(
              'Date:',
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
              details[3],
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
    );


 }

}