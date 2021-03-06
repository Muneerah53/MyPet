import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'models/global.dart';
import 'package:flutter/services.dart';
CollectionReference service =
FirebaseFirestore.instance.collection('service');



class services extends StatefulWidget {
  Function initData;
  services(this.initData) ;

  @override
  _servicesState createState() => _servicesState();
}
final _V = GlobalKey<FormState>();

class _servicesState extends State<services> {
  String _serviceName = "";
  String _priceService = "";
  CollectionReference ser = FirebaseFirestore.instance.collection('service');


  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  CollectionReference service = FirebaseFirestore.instance.collection('service');

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
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

        backgroundColor: const Color(0xFFF4E3E3),
        body: SingleChildScrollView(

            child: Container(

                padding: EdgeInsets.all(15.0),
                //margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  // color: Colors.white,
                ),
                child:  Form(
                    key: _V,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Container(
                              padding: const EdgeInsets.fromLTRB(95, 5, 44, 45),
                              child: const Text('Add New Service',
                                  style: TextStyle(
                                      color: Color(0xffe57285),
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold))),

                          SizedBox(height: 15),
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
                              child: TextFormField(
                                onChanged: (value) {

                                  setState(() {
                                    _serviceName = value;
                                  });
                                  // _firstName = value;
                                },
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return 'Please enter Service name';
                                  }
                                  else if(!RegExp('[a-zA-Z _]+\$').hasMatch(_serviceName)){
                                    return 'Service name must contain only letters';
                                  }
                                  else if(value.length>15){
                                    return 'Service name must be less then 15 characters';
                                  }
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )),
                                ),
                              )),
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
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters:[FilteringTextInputFormatter.digitsOnly],
                                onChanged: (value) {
                                  _priceService = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter the Service Price';
                                  } else if (!isNumeric(value)) {
                                    return 'price must be numeric';
                                  } else if (int.parse(value)==0||value.length> 3) {
                                    return 'price must be at between 0 and 1000 ';
                                  }
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )),
                                ),
                              )),
                          SizedBox(height: 30),

//          Container(
// height: 70,
//              width: 180,
//
//              child :
//              RaisedButton(
//                  color: Color(0xff313540),
//                  shape:RoundedRectangleBorder(
//                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                  ),
//                  onPressed: () async {
//                    if (_V.currentState!.validate()) {
//                      DocumentReference doc = await ser.add({
//                        "serviceID":'',
//                        "serviceName": _serviceName ,
//                        "servicePrice": _priceService
//                      });
//                      String _id = doc.id;
//                      await ser.doc(_id).update({"serviceID": _id});
//
//                      ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(content: Text('Service added successfully'),backgroundColor:Colors.green)
//     );
//                  }
//                    },
//                  child: Text("Add Service", style: new TextStyle(
//                    fontSize: 18.0,color: Colors.white,)
//                  )
//              )
//
//          ),

                          Center(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 30, 0, 5),
                                width: 193,
                                height: 73,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      if (_V.currentState!.validate()) {
    QuerySnapshot<Object?> snapshot = await service
        .where('serviceName', isEqualTo: _serviceName)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;


    if (docs.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text('Service is already exists'),
    backgroundColor: Colors.red)
    );
    }
    else {
                                        DocumentReference doc = await ser.add({
                                          "serviceID":'',
                                          "serviceName": _serviceName ,
                                          "servicePrice": _priceService
                                        });
                                        String _id = doc.id;
                                        await ser.doc(_id).update({"serviceID": _id});

                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Service added successfully'),backgroundColor:Colors.green)
                                        );
                                        widget.initData();
                                        Navigator.of(context).pop();

                                      }}
                                    },
                                    child: const Text('Add ',
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
                              )),
                        ],
                      ),

                    ))
            )));
  }
}