//import 'package:MyPet/Mypets.dart';
import 'package:MyPet/paymentscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Payment.dart';
import 'package:intl/intl.dart';
import 'appointment_object.dart';
import 'models/global.dart';
import 'models/data.dart';

class OrderList extends StatefulWidget {
  final appointment? appoint;

  const OrderList(
      {this.appoint,
      });

  @override
  OrderListState createState() => OrderListState();
}

class OrderListState extends State<OrderList> {
  fbHelper fb = fbHelper();

  appointment? _appointment;
  String? TotalPrice;
  String img="";


  void initState() {
    super.initState();
    _appointment = widget.appoint;//here var is call and set to
    if (_appointment!.type == "Grooming"){
      img ='images/PBGroomingStepThree.png';

    }
    else
      img ='images/PBCheckUpStepTwo.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF4E3E3),
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
            child: Center(
                child: Column(children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text(
                      'Appointment Details',
                      style: TextStyle(
                          color: Color(0XFFFF6B81),
                          fontSize: 34,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          height: 40,
                          fit: BoxFit.fill,
                          image: new AssetImage(img))
                    ],
                  ),
                  SizedBox(height: 10),
                  /*  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 0, 30),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Appointment Details:',
                      style: TextStyle(
                          color: Color(0XFF52648B),
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ), */
                  Container(
                    margin: const EdgeInsets.fromLTRB(25, 10, 25, 70),
                    height: 500,
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
                                margin: const EdgeInsets.fromLTRB(20, 40, 0, 30),
                                child: Text(
                                  'Service: ',
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ),

                              Expanded(
                                child:  Container(
                                  margin: const EdgeInsets.fromLTRB(5, 40, 20, 30),
                                  child: Text(
                                    _appointment!.type == 'Boarding'? _appointment!.type! :_appointment!.desc!,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Color(0XFF52648B),
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold),
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
                                margin: const EdgeInsets.fromLTRB(20, 0, 0, 30),
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
                                margin: const EdgeInsets.fromLTRB(5, 0, 20, 30),
                                child: Text(
                                  _appointment!.petName.toString(),
                                  style: TextStyle(
                                      color: Color(0XFF52648B),
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _appointment!.type!='Boarding',
                          child:  Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 30),
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
                                  margin: const EdgeInsets.fromLTRB(5, 0, 20, 30),
                                  child: Text(
                                    _appointment!.time.toString(),
                                    style: TextStyle(
                                        color: Color(0XFF52648B),
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold),
                                    //  textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),)   ,
                        Visibility(
                          visible: _appointment!.type!='Boarding',
                          child:Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 30),
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
                                Expanded(
                                  child:Container(
                                    margin: const EdgeInsets.fromLTRB(5, 0, 20, 30),
                                    child: Text(
                                      _appointment!.date.toString(),
                                      style: TextStyle(
                                          color: Color(0XFF52648B),
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold),
                                      // textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _appointment!.type=='Boarding',
                          child:Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 30),
                                  child: Text(
                                    'Start Date: ',
                                    style: TextStyle(
                                        color: Color(0XFF52648B),
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Expanded(
                                  child:Container(
                                    margin: const EdgeInsets.fromLTRB(5, 0, 20, 30),
                                    child: Text(
                                      _appointment!.date.toString(),
                                      //maxLines:10,
                                      style: TextStyle(
                                          color: Color(0XFF52648B),
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold),
                                      // textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _appointment!.type=='Boarding',
                          child:Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 30),
                                  child: Text(
                                    'End Date: ',
                                    style: TextStyle(
                                        color: Color(0XFF52648B),
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Expanded(
                                  child:Container(
                                    margin: const EdgeInsets.fromLTRB(5, 0, 20, 30),
                                    child: Text(
                                      _appointment!.time.toString(),
                                      //maxLines:10,
                                      style: TextStyle(
                                          color: Color(0XFF52648B),
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold),
                                      //  textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
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
                                margin: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                                child: Text(
                                  CountTotalPrice(_appointment!.type)! + 'SAR',
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
                            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            width: 193,
                            height: 73,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => Paymentscreen(appoint: _appointment)),
                                );
                              }, minWidth: 200,
                              height: 60,
                              padding: const EdgeInsets.all(20),
                              color: greenColor,
                              textColor: primaryColor,
                              child: const Text('Pay', style:
                              TextStyle( fontSize: 18),),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),


                            )),

                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            width: 193,
                            height: 73,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              minWidth: 200,
                              height: 60,
                              padding: const EdgeInsets.all(20),
                              color: redColor,
                              textColor: primaryColor,
                              child: const Text('Cancel',style: TextStyle( fontSize: 18),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),


                            )),
                      ],
                    ),
                  ),



                ]))));
  }
//CountTotalPrice
  //TotalPrice

  String? CountTotalPrice(String? ServiceType) {
    if (ServiceType == "Check-Up") {
      _appointment!.total =50.0;
      TotalPrice = "50";
    } else {
      TotalPrice = _appointment!.total.toString();
    }
    return TotalPrice;
  }


}

