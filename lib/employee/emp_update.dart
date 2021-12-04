
import 'package:MyPet/appointment/appointment_model.dart';
import 'package:MyPet/models/global.dart';
import 'package:MyPet/PetType_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:MyPet/admin_calender.dart' as cal;

import 'emp_model.dart';


class empUpdate extends StatefulWidget {
  final EmployeeModel empModel;
  const empUpdate(this.empModel, {Key? key}) : super(key: key);

  @override
  empUpdateState createState() => empUpdateState();
}

class empUpdateState extends State<empUpdate> {
  final _eformKey = GlobalKey<FormState>();
  CollectionReference Employee =
  FirebaseFirestore.instance.collection('Employee');
  String? _name,_id,_job,_s;
  var _types = ['Cats', 'Dogs','Both'];
  var selectedType;
  static final RegExp nameRegExp = RegExp('^[a-zA-Z ]+\$');


  @override
  void initState() {
    super.initState();
    _id =widget.empModel.empID;
    _name = widget.empModel.empName;
    _job = widget.empModel.job;
    _s = widget.empModel.speciality;
    selectedType = _s!='Cats And Dogs' ? _s : 'Both';
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
            child:  Form(
              key: _eformKey,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Center(
                    child:
                    Container(
                            padding: const EdgeInsets.fromLTRB(44, 0, 44, 45),
                            child: const Text('Edit Employee',
                                style: TextStyle(
                                    color: Color(0xffe57285),
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)))
                        ),

                        //SizedBox(height: 100),
                        Container(
                          padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                          child: Text(
                            'Employee ID:',
                            style: TextStyle(
                                color: const Color(0xFF552648B),
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                          child:  TextFormField(

                            enabled: false,
                            keyboardType: TextInputType.number,
                            //inputFormatters:[FilteringTextInputFormatter.digitsOnly],
                            controller: TextEditingController(text: _id),
                            style: TextStyle(
                              fontSize: 18, color: Colors.grey,fontStyle: FontStyle.italic,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Enter ID",
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
                                ? 'Enter ID'
                                : value.length != 3
                                ? 'ID must be 3 digits'
                                : null,

                            onChanged: (String value) {
                              _id = value;
                            },

                          ),),

                        Container(
                          padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                          child: Text(
                            'Employee Name:',
                            style: TextStyle(
                                color: const Color(0xFF552648B),
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                            child: TextFormField(
                              controller: TextEditingController(text: _name),
                              style: TextStyle(
                                fontSize: 18, color: Colors.blueGrey,
                              ),
                              onChanged: (value) {

                                setState(() {
                                  _name = value;
                                });
                                // _firstName = value;
                              },
                              validator: (value) =>
                              value!.trim().isEmpty
                                  ? 'Enter Name'
                                  : value.length  < 3
                                  ? 'Name must be 3 letters or more'
                                  : value.length  > 20
                                  ? 'Name must be at most 20 letters'
                                  : !(nameRegExp.hasMatch(value))
                                  ? 'Enter a Valid Name'
                                  : null
                              ,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Enter Name",
                                hintStyle: TextStyle(color:Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )),
                              ),
                            )),


                        Container(

                          padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                          child: Text(
                            'Job:',
                            style: TextStyle(
                                color: const Color(0xFF552648B),
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                            child: TextFormField(
                              enabled: false,
                              controller: TextEditingController(text: _job),
                              style: TextStyle(
                                fontSize: 18, color:Colors.grey,fontStyle: FontStyle.italic,
                              ),
                              onChanged: (value) {


                                // _firstName = value;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Enter Name",
                                hintStyle: TextStyle(color:Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )),
                              ),
                            )),


                        Container(

                          padding: const EdgeInsets.fromLTRB(30, 15, 0, 10),
                          child: Text(
                            'Speciality:',
                            style: TextStyle(
                                color: const Color(0xFF552648B),
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Container(
                                padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white),
                                child:
                                DropdownButtonFormField<String>(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please choose speciality';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.pets, color:Color(0xFF7B8E97)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent))),

                                  style: TextStyle(
                                    fontSize: 18, color: Colors.blueGrey,
                                  ),
                                  isExpanded: true,
                                  value: selectedType,
                                  iconSize: 20,
                                  elevation: 8,
                                  onChanged: ( newValue) {
                                    setState(() {
                                      selectedType = newValue!;
                                    });
                                  },
                                  hint: Text(
                                    "Choose Speciality",
                                    style: TextStyle(

                                        color: Colors.grey),
                                  ),
                                  items: List.generate(
                                    _types.length,
                                        (index) => DropdownMenuItem(

                                      child: Text(
                                        _types[index],
                                        style:  TextStyle(
                                            color: Colors.blueGrey),
                                      ),
                                      value: _types[index],

                                    ),
                                  ),
                                ))),


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
                    )
                ),
              ),
            )





    );
  }


  saveData() async {
    if(!_eformKey.currentState!.validate()) return;

    String speciality;
    if(selectedType.toString()=="Both")
      speciality="Cats And Dogs";
    else speciality=selectedType.toString();

    await Employee
        .doc(widget.empModel.refID)
        .update({
      "empName": _name,
      "specialty": speciality,

    });
    cal.updateName(_id!,_name!);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Employee updated successfully"),
      backgroundColor: Colors.green,
    ));
    await Future.delayed(
        Duration(seconds: 0),
            () => Navigator.of(
          context,
        ).pop());
  }
}

