import 'package:MyPet/models/global.dart';
import 'package:MyPet/service_model.dart';
import 'package:MyPet/service_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:MyPet/admin_calender.dart' as cal;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'emp_model.dart';
import 'emp_update.dart';


class EmployeeTile extends StatefulWidget {
  final EmployeeModel empModel;
  Function initData;
  EmployeeTile(this.empModel, this.initData);

  @override
  EmployeeTileState createState() => EmployeeTileState();
}

class EmployeeTileState extends State<EmployeeTile> {



  bool isLoading = true;
 /* updateService() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ServiceUpdate(widget.serviceModel)))
        .then((value) => widget.initData());

  } */


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
       // margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('${widget.empModel.empID}',style: petCardSubTitleStyle,),
                    SizedBox(width: 15,),
                    Text('${widget.empModel.empName}',style: petCardSubTitleStyle,),

                  ],
                ),
                subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Text('${widget.empModel.job}',
                      style:TextStyle(
                          fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: widget.empModel.job=='Doctor' ? Colors.lightBlue
                            : Colors.pinkAccent[100] as Color,

                      )




                  ),

                ]),

              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                        height:36, //height of button
                        width:106,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => empUpdate(widget.empModel)))
                                .then((value) => widget.initData());
                          },
                          child: Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFE7F2EC),//change background color of button
                            onPrimary: Colors.black,//change text color of button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),

                            ),
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                          ),)),
                  ),  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                        height:36, //height of button
                        width:90,
                        child: ElevatedButton(
                          onPressed: () {

                          },
                          child: Text(''),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,//change background color of button
                            onPrimary: Colors.black,//change text color of button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),

                            ),
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                          ),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SizedBox(
                        height:36, //height of button
                        width:106, //width of button
                        child: ElevatedButton(
                          onPressed: () {
                            showAlert(context,"Delete Employee?");
                          },
                          child: Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF3BFBD),//change background color of button
                            onPrimary: Colors.black,//change text color of button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                          ),)

                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  showAlert(BuildContext context,String message) {
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
                child: Text("YES"),
                onPressed: () async {

                  if(await deleteEmp()==true)
                  Navigator.pop(context, true);
else
                    Navigator.pop(context, false);



                  widget.initData();
                }),


            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {

                //Put your code here which you want to execute on Cancel button click.
                Navigator.pop(context, false);

              },
            ),
          ],
        );
      },
    ).then((exit) {
      if (exit == null) return;

      if (exit) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Employee deleted successfully"),
          backgroundColor:Colors.green,),);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Employee has not been deleted "),
          backgroundColor:Colors.orange,),);
      }
    },
    );
  }

  Future<bool> deleteEmp() async {


    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('Work Shift')
        .where('empID', isEqualTo: widget.empModel.empID)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;
    for (var doc in docs) {
      if (doc.data() != null) {
        if(doc['status']=='Booked'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Employee has booked appointments and cannot be deleted."),
            backgroundColor:Colors.orange,),);
          return Future<bool>.value(false);
        }

        doc.reference.delete();
      }

    }
    await FirebaseFirestore.instance
        .collection("Employee")
        .doc(widget.empModel.refID)
        .delete();

    var appoints = cal.events.appointments!.where((element) {return element.docID== widget.empModel.empID;}).toList();
    for (var i in appoints) {
      cal.events.appointments!.remove(i);
    }

    cal.events.notifyListeners(CalendarDataSourceAction.reset,cal.events.appointments!);

    return Future<bool>.value(true);
  }
}
