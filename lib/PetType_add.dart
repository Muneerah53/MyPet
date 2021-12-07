
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/global.dart';
import 'package:image_picker/image_picker.dart';
import 'package:MyPet/storage/storage.dart';
import 'dart:io';
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
  static final RegExp nameRegExp = RegExp('^[a-zA-Z ]+\$');
  final _picker = ImagePicker();
  final Storage _storage = Storage();
  late File _img;

  String? imgName, imgPath;


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
                      Container(
                          padding: const EdgeInsets.fromLTRB(44, 5, 44, 45),
                          child: const Text('Add New Pet Type',
                              style: TextStyle(
                                  color: Color(0xffe57285),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold))),

                     // SizedBox(height: 200),
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
                            if (value!.trim().isEmpty) {
                      return "Please enter Pet type name";
                      }
                            else if(value.length>25){
                              return 'Pet type must be less then 25 characters';
                            }
                            else if(!nameRegExp.hasMatch(value)){
                              return "Pet type name must contain only letters";
                            }

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
    if (_dformKey.currentState!.validate()) {


      if(imgName==null || imgPath==null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You need to add a pet icon'),
                backgroundColor: Colors.orange)
        );
        return;
      }

      final ext = imgName!.lastIndexOf('.');
      String _imgname  = imgName!.replaceRange(0, ext, Name);

      _storage.uploadImg(imgPath!, _imgname);


      DocumentReference doc = await PetTypes.add({
        'petTypeID': '',
        'petTypeName': Name,
       // 'petTypeIcon': _imgname

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