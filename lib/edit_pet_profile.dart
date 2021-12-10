
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'models/global.dart';
import 'package:MyPet/storage/storage.dart';
import 'dart:io';
final  validCharacters = RegExp(r'^[a-zA-Z]');
FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
String val = '';

class editPet extends StatefulWidget {
  final DocumentSnapshot pet;

  editPet(this.pet);
  @override
  State<editPet> createState() => _editPet(pet);
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
  var currentValuesp;
  var currentValuegn;


  //image
  final _picker = ImagePicker();
  final Storage _storage = Storage();
  late File _img;

  String? imgName, imgPath;
  var backColor = const Color(0xfff3e3e3);


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

            child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Container(
                    //  padding: EdgeInsets.only(bottom: 380,),
                    child:_buildPicCard(context, pet),
                          ),],
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[

    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                          child: _buildPetCard(context,pet))
                  ),


                ])])));
}

Widget _buildPetCard(BuildContext context, DocumentSnapshot document) {

  String currentValuespHint = pet['species'].toString();
  String currentValuegnHint = pet['gender'].toString();
  List<String> specieses = ['Cat', 'Dog','Bird','Hamster','Rabbit','Snake','Turtle'];
  List<String> genders = ['Male', 'Female'];
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    margin: EdgeInsets.only(left: 20, top: 20,right: 20),

    child: Container(

      padding: EdgeInsets.only(left: 10, top: 10),

  width: 370,
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
                        child: TextFormField(

                          controller: nameController,
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
                                          speciesController.text = drValue;
                                        });
                                      },
                                      value: null,

                                      isExpanded: true,
                                      hint:  Text(
                                        currentValuespHint
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
                                onChanged: (val) {
                                  setState(() {
                                    currentValuesp = val!;
                                    speciesController.text = currentValuesp;
                                    print(currentValuesp);
                                  });
                                },
                                value: currentValuesp,
                                isExpanded: true,
                                hint: Text(currentValuespHint),
                                ),
                              ),
                            ),
                          ),

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
                                    hint: Text(currentValuegnHint),
                                    value:currentValuegn,
                                    onChanged: (val) {
                                      setState(() {
                                        currentValuegn = val!;
                                        genderController.text = currentValuegn;
                                        print(currentValuegn);
                                     });
                                    },
                                    items: genders
                                        .map<DropdownMenuItem<String>>((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text('$val',style: TextStyle (color: Colors.black54)),
                                      );
                                    }).toList(),

                                    style: const TextStyle(color: Colors.black)),
                              ))),


                      FlatButton(
                          minWidth: 250,
                          height: 60,
                          padding: const EdgeInsets.all(20),
                          color: greenColor,
                          textColor: primaryColor,
                          child: const Text('Edit My Pet Information',style: TextStyle( fontSize: 18),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onPressed: () async {
  int change = 0;
  int dateError = 0;
  int nameError = 0;
  int genderError = 0;
  int  speciesError = 0;

  if (!nameController.text.isEmpty) {
    if (nameController.text.length>14) {
      nameError++;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Pet name must be less than 14 character"),
        backgroundColor: Theme
            .of(context)
            .errorColor,
      ));
    }
  else if (!validCharacters.hasMatch(nameController.text)) {
  nameError++;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  content: Text("name must contain only characters"),
  backgroundColor: Theme
      .of(context)
      .errorColor,
  ));
  }
  else {
  document.reference.update({'name': nameController.text[0].toUpperCase()+nameController.text.substring(1)});
  change++;
  }}

  if (!dateController.text.isEmpty) {
  document.reference.update({'birthDate':   dateController.text});
  change++;
  }
  if (!speciesController.text.isEmpty) {
    document.reference.update({
  'species': speciesController.text
  });
  change++;
  }
  if (!genderController.text.isEmpty) {
  document.reference.update({'gender': genderController.text});
  change++;
  }
  if((!(imgPath==null || imgPath==null))&( nameError==0 )& (genderError ==
      0)&(dateError==0)&(speciesError==0)) {
    await _storage.uploadImg(
        imgPath!, imgName!);
    String url = await _storage.downloadURL(
        imgName!);
    await document.reference.update(
        {
          'img': {
            'imgName': imgName!,
            'imgURL': url
          }
        });
    change++;
  }

  if (change > 0) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  content: Text("your pet information is updated successfully "),
  backgroundColor: Colors.green,),);
  Navigator.of(context).pop();

  }
  else if ((nameError == 0) & (change == 0) & (genderError ==
  0)&(dateError==0)&(speciesError==0)) ScaffoldMessenger.of(
  context).showSnackBar(SnackBar(
  content: Text("Please fill any of the fields"),
  backgroundColor: Theme
      .of(context)
      .errorColor,
  )
  );
  },),],),),
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



          ],),),);



}

  Widget _buildPicCard(BuildContext context, DocumentSnapshot document) {
    String img = "";
    if (document['species'] == "Dog")
      img = "images/dog.png";
    else if (document['species'] == "Cat")
      img = "images/cat.png";
    else if (document['species'] == "Bird")
      img = "images/Bird.png";
    else if (document['species'] == "Rabbit")
      img = "images/Rabbit.png";
    else if (document['species'] == "Snake")
      img = "images/Snake.png";
    else if (document['species'] == "Turtle")
      img = "images/Turtle.png";
    else if (document['species'] == "Hamster")
      img = "images/Hamster.png";
    else
      img = "images/dog.png";

    String? url;
    Map<String, dynamic> dataMap = document.data() as Map<String, dynamic>;

    if(dataMap.containsKey('img'))
      url = document['img']['imgURL'];
    else
      url = null;

      return Column(

          children: <Widget>[

            Container(
              margin: EdgeInsets.only(top: 5),
              width: 120,
              height: 110,
              child:                                GestureDetector(
    onTap: () async {
    final icon = await _picker.pickImage(source: ImageSource.gallery);

    if(icon == null){ print('No'); return;}



    setState(() {
      imgPath = icon.path;
      imgName = icon.name;

    if(imgPath!=null)
    _img = File(imgPath!);
    });
    },
                child: CircleAvatar(
                backgroundImage:   imgPath == null || imgName ==null ? url == null ?
                new AssetImage(img)  : Image.network(url).image
                    :  Image.file(_img).image,

                child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xffe57285).withOpacity(0.8),
                          child: Icon(CupertinoIcons.add, color: Colors.white),
                        ),
                      ),
                    ]
                ),
              ),),

            )
          ]
      );
    }

}