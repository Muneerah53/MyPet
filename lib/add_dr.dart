import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'admin_calender.dart' as cal;
import 'models/global.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class docList extends StatefulWidget {
  @override
  docListState createState() {
    return docListState();
  }
}
// Create a corresponding State class. This class holds data related to the form.
class docListState extends State<docList> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.

  GlobalKey _globalKey = navKeys.globalKeyAdmin;

  final _dformKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  //bool _value = false;
  FirebaseFirestore firestoreInstance= FirebaseFirestore.instance;
  String title = "Employees List";
String _name ='';
String _id ='';
var _work = ['Doctor', 'Groomer'];
var selectedWork;
var _types = ['Cats', 'Dogs','Both'];

static final RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
static final RegExp idRegExp = RegExp(r'^[0-9]*$)');

var selectedType;
String _selectedEmp='';

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset:false,
        backgroundColor: Color(0xFFF4E3E3),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation:0,
            title: Text('$title',textAlign: TextAlign.center,
                style: TextStyle(color:Color(0XFFFF6B81))),
            leading: ElevatedButton(
              onPressed: () {
                BottomNavigationBar navigationBar = _globalKey.currentWidget as BottomNavigationBar;
                navigationBar.onTap!(0);
              },
                child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
                style: backButton ),// <-- Button color// <-- Splash color

        ),
      body:  Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                   dialog();
                  },
                  child:Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                      Text("+ Add Employee", style:
                      TextStyle(fontSize: 18))),
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
              stream: FirebaseFirestore.instance.collection('Employee').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('loading');
                if (snapshot.data!.docs.isEmpty) return Padding(
                    padding: EdgeInsets.all(20),
                    child: const Text('No Added Employees', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey), textAlign: TextAlign.center));

                return ListView.builder(
                    shrinkWrap: true, scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              side: BorderSide(color: Colors.transparent)),
                          child: Card(
                              color: (snapshot.data!).docs[index]['job']=="Doctor" ? Color(0xFFC6D8FF) : Color(0xFFFFC6F4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Container(
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                margin: EdgeInsets.only(left: 20, right: 20),
                               // width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child:
                                Container(
                                  // margin: EdgeInsets.only(top: 10),
                                  child: ListTile(
                                    leading: Text((snapshot.data!).docs[index]['empID']
                                        //,style: statusStyles[document['species']]
                                        , style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Color(0XFF2F3542))),
                                    title: Text(
                                        (snapshot.data!).docs[index]['empName']
                                        //,style: statusStyles[document['species']]
                                        , style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color(0XFF2F3542))),

                                  ),),
                              )
                          ) // changeTimeSelected(index),
                          , onPressed: () {
                            String speciality;
                            _name =  (snapshot.data!).docs[index]['empName'];
                            _id =  (snapshot.data!).docs[index]['empID'];
                            _selectedEmp = (snapshot.data!).docs[index].reference.id;
                            selectedWork =  (snapshot.data!).docs[index]['job'];
                            if((snapshot.data!).docs[index]['specialty']=="Cats And Dogs")
                              speciality = "Both";
                            else speciality = (snapshot.data!).docs[index]['specialty'];
                            selectedType = speciality;

                        dialog();
                      }

                      );
                    }

                );
              } ),

 ],




            ),
          )




    );
  }

  dialog(){
    bool newDr = _selectedEmp == '';
    String btnTxt = newDr ? 'Add' : 'Update';
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
                      Text("Employee Info", style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,)),
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
                            reset();
                            Navigator.of(context).pop();
                          }
                     ) )
                   ]),
                     // SizedBox(height: 20.0,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8,20,8,8),
                        child:  TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters:[FilteringTextInputFormatter.digitsOnly],
                          enabled: newDr,
                            controller: TextEditingController(text: _id),
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
                          ),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.badge,
                            ),
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

                        ),

                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8,20,8,8),
                        child:  TextFormField(
                          controller: TextEditingController(text: _name),
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
                          ),
                          decoration: InputDecoration(
                            icon: Icon(Icons.person,),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter Name",
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
                              : value.length  <3
                              ? 'Name must be 3 letters or more'
                              : (nameRegExp.hasMatch(value)
                              ? 'Enter a Valid Name'
                              : null),

                          onChanged: (String value) {
                            _name = value;
                          },

                        ),

                      ),
                     Visibility(
                       visible: newDr,
                       child:
                      Padding(
                        padding: EdgeInsets.fromLTRB(8,20,8,8),
                        child: Container(
                            padding: EdgeInsets.all(10),
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
                                  icon: Icon(Icons.work),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white))),

                              style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
                              ),
                              isExpanded: true,
                              value: selectedWork,
                              iconSize: 20,
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
                            )),
                      )
                     ),


                      Padding(
                        padding: EdgeInsets.fromLTRB(8,20,8,8),
                        child: Container(
                          padding: EdgeInsets.all(10),
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
                                      icon: Icon(Icons.pets),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white))),

                                style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
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
                                  style: TextStyle(color: Colors.grey),
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
                              )),
                        ),




                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                      child:
                        ElevatedButton(
                          child: Text("$btnTxt",
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
                              String speciality;
                              if(selectedType.toString()=="Both")
                                speciality="Cats And Dogs";
                              else speciality=selectedType.toString();

                              if(newDr) {
                                if(saveDr(_name,speciality,selectedWork)==true);
                                //  _showSnack("New Employee is added successfully", false);


                              }
                              else if ((updateDr(_name, speciality))==true)
   _showSnack("Employee is updated successfully", false);

                              Navigator.of(context).pop();
                            }
                          },
                        )),



                       Visibility(
                            visible: !newDr,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              ElevatedButton(
                                child: Text("Delete",
                                    style:
                                    TextStyle(                                color: primaryColor, fontSize: 18)

                                ),
                                style: ButtonStyle(
                                  elevation:   MaterialStateProperty.all(0),
                                  backgroundColor:
                                  MaterialStateProperty.all(redColor),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0))),
                                ),
                                onPressed: () async {
                                  if (deleteDr()==false);


                                  Navigator.of(context).pop();
                                },
                              )),
                       )
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

  }





  Future<void> updateDr(String doc,String speciality) async {
firestoreInstance
        .collection('Employee')
        .doc(_selectedEmp)
        .update({
      "empName": _name,
  "specialty": speciality,

    });
cal.updateName(_id,_name);
reset();
_showSnack("Employee is updated successfully", false);
  }


  Future<bool> saveDr(String doc, var type,var work) async {

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestoreInstance
        .collection('Employee')
        .where('empID', isEqualTo: _id)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;


  if(docs.isNotEmpty)   {
    _showSnack("Employee with the same id already exists.", true);
  return Future<bool>.value(false);}

  await firestoreInstance.collection(
      "Employee").add(
      {
        'empID': _id,
        "empName": _name,
        "job": work.toString(),
        "specialty": type
      });
    reset();
    _showSnack("New Employee is added successfully", false);
    return Future<bool>.value(true);


  }

  Future<bool> deleteDr() async {
    print(_selectedEmp);
    firestoreInstance.collection("Employee").doc(_selectedEmp).delete();

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestoreInstance
        .collection('Work Shift')
        .where('empID', isEqualTo: _id)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;
    for (var doc in docs) {
      if (doc.data() != null) {
        if(doc['status']=='Booked'){
          _showSnack("Employee has booked appointments and cannot be deleted.", true);
          return Future<bool>.value(false);
        }

        doc.reference.delete();
      }

    }

    var appoints = cal.events.appointments!.where((element) {return element.docID==_id;}).toList();
    for (var i in appoints) {
      cal.events.appointments!.remove(i);
    }

    cal.events.notifyListeners(CalendarDataSourceAction.reset,cal.events.appointments!);

    reset();
 _showSnack("Employee is deleted successfully", false);
    return Future<bool>.value(true);
  }

  void reset() {
    _name=_selectedEmp=_id='';
    selectedWork=selectedType=null;
  }

  void _showSnack(String msg, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.red : Colors.green,),);
    reset();
  }




}
