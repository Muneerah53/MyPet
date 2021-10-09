import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:MyPet/MyPets.dart';
import 'models/global.dart';
GlobalKey _globalKey = navKeys.globalKey;

// Future AddPetAsync(petName, gender, disease, specie) async {
//
//   var firestore = FirebaseFirestore.instance;
//   var col = firestore.collection('pets');
//
//   await col.add({'name': petName, 'gender': gender, 'specie': specie,});
// }
class addPet extends StatefulWidget {

  final String ownerID;
  addPet(this.ownerID);
  @override
  State<addPet> createState() => _addPet(ownerID);
}

class _addPet extends State<addPet> {
  final String ownerID;
  _addPet(this.ownerID);

  // String currentSpecie = 'Cat';
  // String currentGender = 'Male';
  // String currentDisease = 'No Disease';
  String petName = '';
  String petBirthDate = '';
  //late DateTime _dateTime;
  final dateController = TextEditingController();
  var backColor = const Color(0xfff3e3e3);
  var primaryColor = const Color(0xff313540);

  String currentValuesp = 'Cat';
  String val = '';
  String currentValuegn = 'Male';
  List<String> specieses = ['Cat', 'Dog'];
  List<String> genders = ['Male', 'Female'];

  //this is use to check the status of the form
  final _formKey = GlobalKey<FormState>();

  //regx for pet name validation
  static final RegExp nameRegExp = RegExp('[a-zA-Z]');

  var added = false;
  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    //super.dispose();
  }

  CollectionReference pets = FirebaseFirestore.instance.collection('pets');
//  final FirebaseAuth auth = FirebaseAuth.instance;

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
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      color: Color(0xFFF4E3E3),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                padding: const EdgeInsets.fromLTRB(44, 5, 44, 45),
                                child: const Text('Add New Pet',
                                    style: TextStyle(
                                        color: Color(0xffe57285),
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold))),
                            SizedBox(height: 10),
                            Container(
                                child: TextFormField(
                                  validator: (Value) {
                                    if (Value!.isEmpty) {
                                      return "Please enter your pet's name";
                                    } else if (nameRegExp.allMatches(Value).length !=
                                        Value.length) {
                                      return "Please enter valid pet name";
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Enter your pet\'s name',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(9)),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ))),
                                  onChanged: (newVal) {
                                    setState(() {
                                      petName = newVal;
                                    });
                                  },
                                  onSaved: (Value) => petName = Value!,
                                )),
                            SizedBox(height: 28),

                            Container(
                              child: TextFormField(
                                validator: (Value) {
                                  if (Value!.isEmpty) {
                                    return "Please enter your pet's birthdate";
                                  }
                                },
                                readOnly: true,
                                controller: dateController,
                                decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Enter your pet\'s Birthdate',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(9)),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ))),
                                onTap: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now());
                                  dateController.text =
                                      date.toString().substring(0, 10);
                                },
                                onSaved: (Value) => dateController.text = Value!,
                                onChanged: (Val) {
                                  // setState(() {
                                  dateController.text = Val;
                                  //    });
                                },
                              ),
                            ),

                            SizedBox(height: 20),
                            Container(
                                height: 58.0,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: currentValuesp,
                                          items: specieses
                                              .map<DropdownMenuItem<String>>((val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text('$val'),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              currentValuesp = val!;
                                            });
                                          },
                                          style: const TextStyle(color: Colors.black)),
                                    ))),

                            SizedBox(height: 20),

                            Container(
                                height: 58.0,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: currentValuegn,
                                          items: genders
                                              .map<DropdownMenuItem<String>>((val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text('$val'),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              currentValuegn = val!;
                                            });
                                          },
                                          style: const TextStyle(color: Colors.black)),
                                    ))),

                            SizedBox(height: 85),

                            MaterialButton(
                                minWidth: 200,
                                height: 60,
                                padding: const EdgeInsets.all(20),
                                color: primaryColor,
                                textColor: Colors.white,
                                child: const Text('Add pet'),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    DocumentReference doc = await pets.add({
                                      'petId': '',
                                      'name': petName,
                                      'birthDate': dateController.text,
                                      'gender': currentValuegn,
                                      'species': currentValuesp,
                                      'ownerId': '',
                                    });
                                    String _id = doc.id;
                                    await pets.doc(_id).update({"petId": _id});

                                    // String ownerId= await FirebaseFirestore.instance.collection('pet owners').doc().id ;
                                    // await pets.doc(_id).update({"ownerId":ownerId});

                                    User? user = FirebaseAuth.instance.currentUser;
                                    DocumentReference ref = FirebaseFirestore
                                        .instance
                                        .collection('pet owners')
                                        .doc(user?.uid);
                                    await pets.doc(_id).update({"ownerId": ref.id});

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("New pet is added successfully "),
                              backgroundColor:Colors.green,),);
                            //Put your code here which you want to execute on Cancel button click.
                            Navigator.of(context).pop();

                           // Navigator.push(context,MaterialPageRoute(builder: (_) =>MyPets())) .catchError((error) => print('Delete failed: $error'));;

                                  }
                                }),
                            Container(
                              margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 20),
                            ),

                    //Edit button
                    MaterialButton(

                      minWidth: 200,
                      height: 60,
                      padding: const EdgeInsets.all(20),
                      color: primaryColor,
                      textColor: Colors.white,
                      child: const Text('Cancel'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed:( ){
                        _formKey.currentState!.reset();
                        Navigator.of(context).pop();
                    //    Navigator.push(context,MaterialPageRoute(builder: (_) =>MyPets())) .catchError((error) => print('update failed: $error'));;

                      },
                    ),])

          ),

        ])

      )
    )
        )
    );


  }
}