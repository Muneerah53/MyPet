
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/global.dart';
import 'ownerProfile.dart';
final  validCharacters = RegExp(r'^[a-zA-Z]');

class editPet extends StatefulWidget {
  final DocumentSnapshot petID;

  editPet(this.petID);
  @override
  State<editPet> createState() => _editPet(petID);
}

class _editPet extends State<editPet> {
  final DocumentSnapshot pet;
  _editPet(this.pet);

  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final speciesController = TextEditingController();
  final genderController = TextEditingController();
  var primaryColor = const Color(0xff313540);

  String petName = '';
  String petBirthDate = '';



  var backColor = const Color(0xfff3e3e3);

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
                    child: _buildPetCard(context,pet)))));
}

Widget _buildPetCard(BuildContext context, DocumentSnapshot document) {
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    margin: EdgeInsets.only(left: 20, top: 20),

    child: Container(

      padding: EdgeInsets.only(left: 10, top: 10),

  width: 380,
  height: 700,

  //i dont know why this cammand does not work
  decoration: BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(40)),

  color: Colors.white,
  ),
  child:
  Column(
  children: <Widget>[
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,

  ),
          Column(children: [
            Container(
                padding: const EdgeInsets.all(15),

                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          child: const Text('Edit My Pet Information',
                              style: TextStyle(
                                  color: Color(0xffe57285),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold))),

                      //first name
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: ListTile(
                          title: Text("Name:  "
                              , style: petCardTitleStyle),

                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),

                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: TextFormField(controller: nameController,
                          decoration: InputDecoration(
                              fillColor: Color(0xffe57285),
                              hintStyle: TextStyle(fontSize: 17),
                              hintText: pet['name']
                          ),),),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: ListTile(
                          title: Text("Birthdate:"
                              , style: petCardTitleStyle),

                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextFormField(
                          validator: (Value) {
                            if (Value!.isEmpty) {
                              return "Please enter your pet's birthdate";
                            }
                          },
                          readOnly: true,
                          controller: dateController,
                          decoration:  InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: pet['birthDate'],
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

                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: ListTile(
                          title: Text("Species:"
                              , style: petCardTitleStyle),

                        ),
                      ),
                      Container(
                          height: 58.0,
                          decoration: const BoxDecoration(
                              color: Colors.transparent,
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
                                        child: Text('$val',style: TextStyle (color: Colors.black54)),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        currentValuesp = val!;
                                      });
                                    },
                                    style: const TextStyle(color: Colors.black)),
                              ))),

                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: ListTile(
                          title: Text("Gender:"
                              , style: petCardTitleStyle),

                        ),
                      ),
                      Container(
                          height: 58.0,
                          decoration: const BoxDecoration(
                              color: Colors.transparent,
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
                                        child: Text('$val',style: TextStyle (color: Colors.black54)),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        currentValuegn = val!;
                                      });
                                    },
                                    style: const TextStyle(color: Colors.black)),
                              ))),


                      FlatButton(
                          minWidth: 250,
                          height: 60,
                          padding: const EdgeInsets.all(10),
                          color: greenColor,
                          textColor: primaryColor,
                          child: const Text('Edit My Pet Information',style: TextStyle( fontSize: 18),
                          ),
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
                      FlatButton(

                        minWidth: 250,
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

          ],),],),),);



}
}