
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/models/global.dart';
import 'package:MyPet/PetType_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum SingingCharacter { companion, exotic }
SingingCharacter? _character = SingingCharacter.companion;

class PetTypeUpdate extends StatefulWidget {
  final PetType model;
  const PetTypeUpdate(this.model, {Key? key}) : super(key: key);

  @override
  _PetTypeUpdate createState() => _PetTypeUpdate();
}

class _PetTypeUpdate extends State<PetTypeUpdate> {
  final _formKey = GlobalKey<FormState>();

  String? _name,_id,_Type;
  static final RegExp nameRegExp = RegExp('^[a-zA-Z ]+\$');


  @override
  void initState() {
    super.initState();
    _id = widget.model.petTypeID;
    _name = widget.model.petTypeName;
    _Type = widget.model.Type;
    if(_Type=='exotic')
      _character = SingingCharacter.exotic;
    else
      _character = SingingCharacter.companion;

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
                        child: const Text('Update Pet Type',
                            style: TextStyle(
                                color: Color(0xffe57285),
                                fontSize: 30,
                                fontWeight: FontWeight.bold))),


                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child:  Text('Pet Type Name:',
                            style: TextStyle(
                              color: Color(0xffe57285),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,))),
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

                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Please enter Pet type name";
                            }
                            else if(value.length>25){
                              return 'Pet type must be less then 25 characters';
                            }
    else if(!nameRegExp.hasMatch(value)){
    return "Pet type name must contain only letters";
    }

                          }

                      ),
                    ),

                    SizedBox(height: 50),

                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child:  Text('Pet Type:',
                            style: TextStyle(
                              color: Color(0xffe57285),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,))),
                    ListTile(
                      title: const Text('Companion animal'),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.companion,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Exotic animal'),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.exotic,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 50),


                    Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 30, 0, 5),
                        width: 193,
                        height: 73,
                        child: ElevatedButton(
                            onPressed: () async {
                              await saveData();
                            },
                            child: const Text('Save',
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
    if (!_formKey.currentState!.validate()) return;

    String _fname = _name![0].toUpperCase() + _name!.substring(1).toLowerCase().trim();
    QuerySnapshot<Object?> snapshot =
    await FirebaseFirestore.instance
        .collection('PetTypes')
        .where('petTypeName', isEqualTo: _fname)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;


    if (docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Pet type is already exists'),
              backgroundColor: Colors.red)
      );
    }
    else {
      await FirebaseFirestore.instance
          .collection('PetTypes')
          .doc(_id)
          .update({"petTypeName": _fname, 'petType': _character
          .toString()
          .split('.')
          .last,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Pet type has been updated successfully"),
        backgroundColor: Colors.green,
      ));
      await Future.delayed(
          Duration(seconds: 0),
              () =>
              Navigator.of(
                context,
              ).pop());
    }
  }
}

