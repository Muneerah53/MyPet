
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/models/global.dart';
import 'package:MyPet/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ServiceUpdate extends StatefulWidget {
  final ServiceModel model;
  const ServiceUpdate(this.model, {Key? key}) : super(key: key);

  @override
  _ServiceUpdateState createState() => _ServiceUpdateState();
}

class _ServiceUpdateState extends State<ServiceUpdate> {
  final _formKey = GlobalKey<FormState>();

  String? _name,_id, _price;
  static final RegExp nameRegExp = RegExp('[a-zA-Z]');


  @override
  void initState() {
    super.initState();
    _id = widget.model.serviceID;
_name = widget.model.serviceName;
_price = widget.model.servicePrice;
  }


  @override
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
            padding: EdgeInsets.all(15.0),
            //margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
             // color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                        padding: const EdgeInsets.fromLTRB(44, 5, 44, 45),
                        child: const Text('Update Service',
                            style: TextStyle(
                                color: Color(0xffe57285),
                                fontSize: 30,
                                fontWeight: FontWeight.bold))),


                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        'Service Name:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                        child:TextFormField(
                          controller: TextEditingController(text: _name),
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color:Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )
                            ),
                          ),


                          onChanged: (value) {
                            _name = value;
                          },

                            validator: (Value) {
                              if (Value!.isEmpty) {
                                return "Please enter service's name";
                              } else if (nameRegExp.allMatches(Value).length !=
                                  Value.length) {
                                return "Please enter valid service name";
                              }
                            }




                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        'Service Price in SAR:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child:TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters:[FilteringTextInputFormatter.digitsOnly],
                        controller: TextEditingController(text: _price),
                        style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(color:Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              )
                          ),
                        ),


                        onChanged: (value) {
                          _price = value;
                        },

                        validator: (value) => value!.isEmpty ? 'Enter Price in SAR': null,



                      ),

                    ),

                    Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 30, 0, 5),
                        width: 193,
                        height: 73,
                        child: ElevatedButton(
                            onPressed: () async {
                              await saveData();
                            },
                            child: const Text('Edit',
                              style: TextStyle( color:Colors.black,
                                  fontSize: 18),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xFFE7F2EC)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12))),
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
                            child: const Text('Cancel',
                              style: TextStyle( color:Colors.black,
                                  fontSize: 18),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xFFF3BFBD)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12))),
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


  saveData() async {

      await FirebaseFirestore.instance
          .collection('service')
          .doc(_id)
          .update({"serviceName":_name, "servicePrice": _price});
//set new ppointment

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Service has been updated successfully"),
        backgroundColor: Colors.green,
      ));
      await Future.delayed(
          Duration(seconds: 2),
              () => Navigator.of(
            context,
          ).pop());
    }
  }

