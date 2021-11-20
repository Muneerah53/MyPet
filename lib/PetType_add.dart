import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/global.dart';
String Name ='';
final _dformKey = GlobalKey<FormState>();

CollectionReference PetTypes =
FirebaseFirestore.instance.collection('PetTypes');


class addPetType extends StatefulWidget {
  Function initData;
  addPetType(this.initData) ;
  @override
  State<addPetType> createState() => _addPetType();
}

class _addPetType extends State<addPetType> {
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
                          onChanged: (String value) {
                            Name = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                      return "Please enter Pet type name";
                      }
                          else if(!RegExp('[a-zA-Z _]+\$').hasMatch(value)){
            return "Pet type name must contain only letters";
            }},



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
    if (_dformKey.currentState!.validate()) {
      DocumentReference doc = await PetTypes.add({
        'petTypeID': '',
        'petTypeName': Name,

      });
      String _id = doc.id;
      await PetTypes.doc(_id).update({"petTypeID": _id});
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet type is added successfully'),
              backgroundColor: Colors.green)
      );


      widget.initData();
      Navigator.of(context).pop();
    }


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

}