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

CollectionReference Employees =
FirebaseFirestore.instance.collection('Employee');

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
    });

    List<EmployeeModel> empList = [];

    await Employees.get()
        .then((value) async {
      if (value.docs.isEmpty) {
        setState(() {
          hasEmps= false;
        });
      }

      for (var element in value.docs) {
        Map<String, dynamic>? map = element.data() as Map<String, dynamic>?;

        String? _id = map!['empID'];
        String? _selectedEmp = map!['refID'];
        String? _name = map['empName'];
        String? selectedWork = map['job'];
        String? speciality = map['specialty'];
        EmployeeModel empModel = new EmployeeModel(
          refID: '$_selectedEmp',
          empID: '$_id',
          empName: '$_name',
          job: '$selectedWork',
          speciality: '$speciality',
        );


        empList.add(empModel);
        setState(() {
          _empList.add(empModel);
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
            leading:ElevatedButton(
                onPressed: () {
                  BottomNavigationBar navigationBar = _globalKey.currentWidget as BottomNavigationBar;
                  navigationBar.onTap!(0);
                },
                child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
                style: backButton ), // <-- Button color// <-- Splash color
          ),
          body:  isLoading
              ? Loading()
              : Column(
            children: [
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
                      padding: EdgeInsets.only(left: 40,right:40,top: 35,bottom: 35),

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

                Expanded(
                  child: !isLoading && _empList.isEmpty
                      ? Center(
                    child: Text("You have no employees"),
                  )
                      : ListView.builder(
                      itemCount: _empList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(left: 20,right:20,top: 0,bottom: 0),
                          child: EmployeeTile(_empList[index], initData),);
                      }
                  ),
                ),
              ],

            ),
          );


    }
  }
