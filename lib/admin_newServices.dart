import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class services extends StatefulWidget {
  const services({Key? key}) : super(key: key);

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

      backgroundColor: const Color(0xFFF4E3E3),
body: SingleChildScrollView(
        child: Builder(
        builder: (context) => Form(
      key: _V,
      child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
SizedBox(height: 100),
         Container(
           child: Text(
             'Add Service',
             style: TextStyle(
                 color: Color(0XFFFF6B81),
                 fontSize: 34,
                 fontStyle: FontStyle.normal,
                 fontWeight: FontWeight.bold),
           ),
         ),
         SizedBox(height: 80),
         TextFormField(
           onChanged: (value) {

             setState(() {
               _serviceName = value;
             });
             // _firstName = value;
           },
           validator: (value) {
             if (value!.isEmpty) {
               return 'Please enter Service name';
             }
             else if(!RegExp('[a-zA-Z _]+').hasMatch(_serviceName)){
               return 'Service name must contain only letters';
             }
           },
           decoration: InputDecoration(
             filled: true,
             fillColor: Colors.white,
             hintText: "Enter the service name",
             border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(30.0),
                 borderSide: BorderSide(
                   width: 0,
                   style: BorderStyle.none,
                 )),
           ),
         ),
         SizedBox(height: 30),
         TextFormField(
           onChanged: (value) {
             _priceService = value;
           },
           validator: (value) {
             if (value!.isEmpty) {
               return 'Enter the Service Price';
             } else if (!isNumeric(value)) {
               return 'price must be numeric';
             } else if (value.length != 2) {
               return 'price must be at most 2 digits';
             }
           },
           decoration: InputDecoration(
             filled: true,
             fillColor: Colors.white,
             hintText: "Enter the Service Price",
             border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(25.0),
                 borderSide: BorderSide(
                   width: 0,
                   style: BorderStyle.none,
                 )),
           ),
         ),
         SizedBox(height: 130),

         Container(
height: 70,
             width: 180,

             child :
             RaisedButton(
                 color: Color(0xff313540),
                 shape:RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                 ),
                 onPressed: () async {
                   if (_V.currentState!.validate()) {
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
                 }
                   },
                 child: Text("Add Service", style: new TextStyle(
                   fontSize: 18.0,color: Colors.white,)
                 )
             )

         ),
       ],
      ),

    ))
));
  }
}
