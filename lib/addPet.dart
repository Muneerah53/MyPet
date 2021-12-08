import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MyPet/MyPets.dart';
import 'package:image_picker/image_picker.dart';
import 'models/global.dart';
import 'package:MyPet/storage/storage.dart';
import 'dart:io';


GlobalKey _globalKey = navKeys.globalKey;
var selectedType = 'Dog';
FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

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

  String petName = '';
  String petBirthDate = '';
  //late DateTime _dateTime;
  final dateController = TextEditingController();
  var backColor = const Color(0xfff3e3e3);
  var primaryColor = const Color(0xff313540);

  String currentValuesp = 'Cat';
  String val = '';
  String currentValuegn = 'Male';
  List<String> specieses = ['Cat', 'Dog','Bird','Hamster','Rabbit','Snake','Turtle'];
  List<String> genders = ['Male', 'Female'];

  //image
  final _picker = ImagePicker();
  final Storage _storage = Storage();
  late File _img;

  String? imgName, imgPath;




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
                            GestureDetector(
                                onTap: () async {
                                  final icon = await _picker.pickImage(source: ImageSource.gallery);

                                  if(icon == null){ print('No'); return;}

                                  imgPath = icon.path;
                                  imgName = icon.name;

                                  setState(() {
                                    if(imgPath!=null)
                                      _img = File(imgPath!);
                                  });
                                },
                                child:  CircleAvatar(
                                  radius: 58,
                                  backgroundImage:  imgPath == null || imgName ==null ?
                                  AssetImage("images/logo4.png")
                                      :
                                  Image.file(_img).image,
                                  child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Color(0xffe57285).withOpacity(0.7),
                                            child: Icon(CupertinoIcons.add, color: Colors.white),
                                          ),
                                        ),
                                      ]
                                  ),
                                ) ),
                            SizedBox(height: 28),
                            Container(
                                child: TextFormField(
                                  validator: (Value) {
                                    if (Value!.isEmpty) {
                                      return "Please enter your pet's name";
                                    }  else if ( Value.length>14) {
                                      return "Pet name must be less than 14 character";
                                    }
                                    else if (nameRegExp.allMatches(Value).length !=
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

                Visibility(
                    visible: true,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: firestoreInstance.collection("PetTypes")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            const Text("Loading...");
                          if (snapshot.data == null)
                            return Padding(
                                padding: EdgeInsets.all(20),
                                child: const Text(
                                    'You haven\'t added Any Types!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.grey),
                                    textAlign: TextAlign.center));
                          else {
                            List<DropdownMenuItem<dynamic>> drNames = [];
                            Map<String,String> types = {};
                            drNames.clear();
                            for (int i = 0; i <
                                snapshot.data!.docs.length; i++) {
                              DocumentSnapshot snap = snapshot.data!.docs[i];
                              types[snap['petTypeID']] =  snap['petTypeName'];
                              drNames.add(
                                DropdownMenuItem(
                                  child: Text(
                                      " "+ snap['petTypeName'],
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  value: snap['petTypeName'],
                                ),
                              );
                            }
                            return Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white),
                              child: DropdownButtonFormField<dynamic>(
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white))),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                                elevation: 8,
                                items: drNames,
                                onChanged: (drValue) {

                                  setState(() {
                                    currentValuesp = drValue;
                                  });
                                },
                                value: null,
                                validator: (value) =>
                                value == null
                                    ? 'Please Choose '
                                    : null,
                                isExpanded: true,
                                hint:  Text(
                                  " Type",
                                style: TextStyle(color: Colors.grey,  fontWeight: FontWeight.normal,
                                  fontSize: 18,),
                                ),
                              ),
                            );
                          }
                        }),
                    replacement: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          elevation: 8,
                          items: const <DropdownMenuItem<dynamic>>[],
                          onChanged: null,
                          value: val,
                          isExpanded: true,
                          hint: new Text(
                            "Type",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    )),

                            SizedBox(height: 20),

                            Container(
                                height: 58.0,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                                              child: Text('$val'  ,style: TextStyle(color: Colors.black87),),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              currentValuegn = val!;
                                            });
                                          },
                                          style: const TextStyle(color: Colors.grey,  fontWeight: FontWeight.normal,
                                            fontSize: 18,),),
                                    ))),

                            SizedBox(height: 85),

                            FlatButton(
                                minWidth: 200,
                                height: 60,
                                padding: const EdgeInsets.all(10),
                                color: greenColor,
                                textColor: primaryColor,
                                child: const Text('Add pet',style: TextStyle( fontSize: 18),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    DocumentReference doc = await pets.add({
                                      'petId': '',
                                      'name': petName[0].toUpperCase()+petName.substring(1),
                                      'birthDate': dateController.text,
                                      'gender': currentValuegn,
                                      'species': currentValuesp,
                                      'ownerId': '',
                                    });
                                    String _id = doc.id;
                                    await pets.doc(_id).update({"petId": _id});

                                   await  _storage.uploadImg(imgPath!, imgName!);
                                    String url = await _storage.downloadURL(imgName!);
                                    await pets.doc(_id).update(
                                        {
                                          'img' : {
                                          'imgName': imgName!,
                                          'imgURL': url
                                        }
                                        });

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
                   FlatButton(

                      minWidth: 200,
                      height: 60,
                      padding: const EdgeInsets.all(20),
                      color: redColor,
                      textColor: primaryColor,
                      child: const Text('Cancel',style: TextStyle( fontSize: 18),
                      ),
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