import 'package:MyPet/models/global.dart';
import 'package:MyPet/service_model.dart';
import 'package:intl/intl.dart';
import 'package:MyPet/employee/emp_model.dart';
import 'package:MyPet/service_tile.dart';
import 'package:MyPet/appointment/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'emp_add.dart';
import 'emp_tile.dart';



class EmployeeList extends StatefulWidget {

  EmployeeList();

  @override
  EmployeeListState createState() => EmployeeListState();
}

class EmployeeListState extends State<EmployeeList> {
  GlobalKey _globalKey = navKeys.globalKeyAdmin;

  List<EmployeeModel> _empList = [];
  bool isLoading = true;
  bool hasEmps = true;
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    setState(() {
      _empList = [];
      isLoading = true;
    }); }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: Color(0xFFF4E3E3),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading:ElevatedButton(
                onPressed: () {
                  BottomNavigationBar navigationBar = _globalKey.currentWidget as BottomNavigationBar;
                  navigationBar.onTap!(0);
                },
                child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
                style: backButton ), // <-- Button color// <-- Splash color
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),


             Center(
               child: Text(
                 'Employees',
                  style: TextStyle(
                      color: Color(0xffe57285),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
               )  ),
                SizedBox(
                  height: 20.0,
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ( context) => new addEmp(initData)),
                    );
                  },
                  child:Padding(
                      padding: EdgeInsets.only(left: 50,right:50,top: 35,bottom: 35),

                      child:
                      Text("+ Add New Employee", style:
                      TextStyle(fontSize: 25))),
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Color(0XFFFF6B81)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)))


                  ),
                ),

                // doc name to be turned into a select dropdown


                SizedBox(height: 10.0,),


                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Employee')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const
                      Center(heightFactor: 10,child:
                      CircularProgressIndicator(color: Colors.pink));
                      if (snapshot.data!.docs.isEmpty) return Padding(
                          padding: EdgeInsets.all(20),
                          child: const Text(
                              'No Added Employees', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey),
                              textAlign: TextAlign.center));

                      _empList.clear();
                      return

                        ListView.builder(
                          shrinkWrap: true, scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            String _name = (snapshot.data!)
                                .docs[index]['empName'];
                            String _id = (snapshot.data!).docs[index]['empID'];
                            String _selectedEmp = (snapshot.data!).docs[index]
                                .reference.id;
                            String selectedWork = (snapshot.data!)
                                .docs[index]['job'];
                            String speciality = (snapshot.data!)
                                .docs[index]['specialty'];

                            EmployeeModel empModel = new EmployeeModel(
                              refID: '$_selectedEmp',
                              empID: '$_id',
                              empName: '$_name',
                              job: '$selectedWork',
                              speciality: '$speciality',
                            );

                             _empList.add(empModel);
                           /* setState(() {
                              _empList.add(empModel);
                            }); */

                            return Container(
                              child:
                              EmployeeTile(_empList[index], initData),
                            );
                          }

                      );
                    }),

              ],

            ),
          )


      );
    }
  }
