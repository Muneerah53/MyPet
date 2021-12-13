import 'package:MyPet/models/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


final _eformKey = GlobalKey<FormState>();

CollectionReference Employee =
FirebaseFirestore.instance.collection('Employee');


class addEmp extends StatefulWidget {
  Function initData;
  addEmp(this.initData) ;
  @override
  State<addEmp> createState() => addEmpState();
}

class addEmpState extends State<addEmp> {
  String _name ='';
  String _id ='';
  var _work = ['Doctor', 'Groomer'];
  var selectedWork;
  var _types = ['Exotic', 'Companion','Both'];

  static final RegExp nameRegExp = RegExp('^[a-zA-Z ]+\$');
  static final RegExp idRegExp = RegExp(r'^[0-9]*$)');

  var selectedType;
  String _selectedEmp='';
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
            key: _eformKey,

                child: Padding(
                padding: const EdgeInsets.all(8.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [
                 Center(
    child: Container(
                        padding: const EdgeInsets.fromLTRB(44, 5, 44, 45),
                        child: const Text('Add New Employee',
                            style: TextStyle(
                                color: Color(0xffe57285),
                                fontSize: 30,
                                fontWeight: FontWeight.bold))
    )),

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
                          keyboardType: TextInputType.number,
                          inputFormatters:[FilteringTextInputFormatter.digitsOnly],
                          controller: TextEditingController(text: _id),
                          style: TextStyle(
                          fontSize: 18, color: Colors.blueGrey,
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

                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 10),
                      child: Text(
                        'Job:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child:
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white),
                        child:
                        DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please choose job';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              icon: Icon(Icons.work, color:Color(0xFF7B8E97) ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent))),
                          style: TextStyle(
                             fontSize: 18, color: Colors.blueGrey,
                          ),
                          isExpanded: true,
                          value: selectedWork,
                          elevation: 8,
                          onChanged: ( newValue) {
                            setState(() {
                              selectedWork = newValue!;
                            });
                          },
                          hint: Text(
                            "Choose Job",
                            style: TextStyle(color: Colors.grey),
                          ),
                          items: List.generate(
                            _work.length,
                                (index) => DropdownMenuItem(

                              child: Text(
                                _work[index],
                                style:  TextStyle(
                                    color: Colors.blueGrey),
                              ),
                              value: _work[index],

                            ),
                          ),
                        ))),


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
                    SizedBox(height: 30),




                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          Container(
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              width: 193,
                              height: 73,
                              child:
                              ElevatedButton(
                                  child: Text("Add",
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
                                  ),
                                  onPressed: () async {


                                    if (_eformKey.currentState!.validate()) {




    QuerySnapshot<Object?> snapshot = await Employee
        .where('empID', isEqualTo: _id)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;


    if(docs.isNotEmpty)                                        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee with the same id already exists'),
            backgroundColor: Colors.red)
    );

                                   else{   String speciality;
                                      if(selectedType.toString()=="Both")
                                        speciality="Both";
                                      else speciality=selectedType.toString();

    DocumentReference doc = await Employee.add(
                                          {
                                            'empID': _id,
                                            "empName": _name,
                                            "job": selectedWork.toString(),
                                            "specialty": speciality
                                          }
                                      );
    String refid = doc.id;
    await Employee.doc(refid).update({"refID": refid});
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Employee is added successfully'),
                                              backgroundColor: Colors.green)
                                      );


                                      widget.initData();
                                      Navigator.of(context).pop();
                                      }
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