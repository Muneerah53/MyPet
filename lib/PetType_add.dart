import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/global.dart';
String Name ='';
final _dformKey = GlobalKey<FormState>();

CollectionReference PetTypes =
FirebaseFirestore.instance.collection('PetTypes');

GlobalKey _globalKey = navKeys.globalKey;

class addPetType extends StatefulWidget {
  @override
  State<addPetType> createState() => _addPetType();
}

class _addPetType extends State<addPetType> {

  final _formKey = GlobalKey<FormState>();
  static final RegExp nameRegExp = RegExp('[a-zA-Z]');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFF4E3E3),
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
            child:  Form(
              key: _dformKey,
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 200),


                      Padding(
                        padding: EdgeInsets.fromLTRB(8,20,8,8),
                        child:  TextFormField(
                          keyboardType: TextInputType.text,
                          inputFormatters:[FilteringTextInputFormatter.singleLineFormatter],

                          controller: TextEditingController(          ),


                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
                          ),
                          decoration: InputDecoration(

                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Name ",
                            hintStyle: TextStyle(color:Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )
                            ),
                          ),

                          validator: (value) => value!.isEmpty
                              ? 'Enter Name'
                              : value.length < 3
                              ? 'Name must more than 3 digits'
                              : null,

                          onChanged: (String value) {
                            Name = value;
                          },

                        ),

                      ),




                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                ElevatedButton(
                                    child: Text("Add",
                                        style:
                                        TextStyle(
                                            color: primaryColor,
                                            fontSize: 18)),
                                    style: ButtonStyle(
                                      elevation:   MaterialStateProperty.all(0),
                                      backgroundColor:
                                      MaterialStateProperty.all(greenColor),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0))),
                                    ),
                                    onPressed: () async {
                                      addPetType(Name);


                                    }
                                )),


                          ]
                      )

                    ],
                  )
              ),
            ),
        )
    );


  }
  dialog() {

    return  showDialog(

        useRootNavigator: false,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFE3D9D9),
            elevation: 0,
            content: Stack(
              children: <Widget>[
                //   Positioned(top: -15,  right: -15, child: null),
                Form(
                  key: _dformKey,
                  child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(width:20),
                                Text("Add new pet type", style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,)),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        iconSize:34,
                                        alignment: Alignment.topRight,
                                        // padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }
                                    ) )
                              ]),

                          Padding(
                            padding: EdgeInsets.fromLTRB(8,20,8,8),
                            child:  TextFormField(
                              keyboardType: TextInputType.text,
                              inputFormatters:[FilteringTextInputFormatter.singleLineFormatter],

                              controller: TextEditingController(          ),


                              style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
                              ),
                              decoration: InputDecoration(

                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Name ",
                                hintStyle: TextStyle(color:Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )
                                ),
                              ),

                              validator: (value) => value!.isEmpty
                                  ? 'Enter Name'
                                  : value.length < 3
                                  ? 'Name must more than 3 digits'
                                  : null,

                              onChanged: (String value) {
                                Name = value;
                              },

                            ),

                          ),




                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget> [
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                    ElevatedButton(
                                        child: Text("Add",
                                            style:
                                            TextStyle(
                                                color: primaryColor,
                                                fontSize: 18)),
                                        style: ButtonStyle(
                                          elevation:   MaterialStateProperty.all(0),
                                          backgroundColor:
                                          MaterialStateProperty.all(greenColor),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0))),
                                        ),
                                        onPressed: () async {
                                          addPetType(Name);
                                          Navigator.of(context).pop();


                                        }
                                    )),


                              ]
                          )

                        ],
                      )
                  ),
                ),
              ],
            ),
          );
        });

  }void _showSnack(String msg, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.red : Colors.green,),);
    reset();
  }
  void reset() {
    Name='';
  }
  addPetType(String name, ) async {
    if (_dformKey.currentState!.validate()) {
      DocumentReference doc = await PetTypes.add({
        'petTypeID': '',
        'petTypeName': Name,

      });
      String _id = doc.id;
      await PetTypes.doc(_id).update({"petTypeID": _id});


      _showSnack("Pet type is added successfully", false);
      Navigator.of(context).pop();

    }}
}