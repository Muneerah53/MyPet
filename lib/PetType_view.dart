import 'package:MyPet/models/global.dart';
import 'package:MyPet/PetType_model.dart';
import 'package:flutter/services.dart';

import 'package:MyPet/PetType_tile.dart';
import 'package:MyPet/appointment/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
String Name ='';
final _dformKey = GlobalKey<FormState>();
GlobalKey _globalKey = navKeys.globalKeyAdmin;

CollectionReference PetTypes =
FirebaseFirestore.instance.collection('PetTypes');

class PetTypeList extends StatefulWidget {

  String title;
  int type;
  PetTypeList({required this.title, required this.type, Key? key})
      : super(key: key);

  @override
  _PetTypeList createState() => _PetTypeList();
}

class _PetTypeList extends State<PetTypeList> {
  List<PetType> _petTypeList = [];
  bool isLoading = true;
  bool hasPetType = true;
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    setState(() {
      _petTypeList = [];
      isLoading = true;
    });

    final waitList = <Future<void>>[];


    List<PetType> serviceList = [];

    await PetTypes.get()
        .then((value) async {
      if (value.docs.isEmpty) {
        setState(() {
          hasPetType= false;
        });
      }

      for (var element in value.docs) {
        Map<String, dynamic>? map = element.data() as Map<String, dynamic>?;

        String? petTypeID = map!['petTypeID'];
        String? petTypeName = map['petTypeName'];

        PetType petModel = new PetType(
          petTypeID: '$petTypeID',
          petTypeName: '$petTypeName',
        );

        serviceList.add(petModel);
        setState(() {
          _petTypeList.add(petModel);
        });

      }
    }).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: isLoading
            ? Loading()
            : Column(
          children: [
            SizedBox(
              height: 40.0,
            ),


            Text(
              widget.title,
              style: TextStyle(
                  color: Color(0xffe57285),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
               dialog();
              },
              child:Padding(
                  padding: EdgeInsets.only(left: 40,right:40,top: 35,bottom: 35),

                  child:
                  Text("+ Add New Pet Type", style:
                  TextStyle(fontSize: 25))),
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Color(0XFFFF6B81)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)))


              ),
            ),
            Expanded(
              child: !isLoading && _petTypeList.isEmpty
                  ? Center(
                child: Text("You have no services"),
              )
                  : ListView.builder(
                  itemCount: _petTypeList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: PetTypeTile(_petTypeList[index], initData),);  }
                    ),
            ),
          ],
        ));
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

                                        //     BottomNavigationBar navigationBar = _globalKey.currentWidget as BottomNavigationBar;
                                  //   navigationBar.onTap!(0);



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

      _showSnack("Pet type is updated successfully", false);
    }}
}
