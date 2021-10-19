import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'models/global.dart';

class AdminAppointments extends StatefulWidget {
  @override
  AdminAppointmentsState createState() => AdminAppointmentsState();
}
 late DataSource _dataSource;
final List<Appointment> _allappointments = <Appointment>[];

class AdminAppointmentsState extends State<AdminAppointments> {
  GlobalKey _globalKey = navKeys.globalKeyAdmin;
  Map<String, bool> EmpList = {};

  void initState()  {
    _dataSource = getCalendarDataSource();

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation:0,
            leading: ElevatedButton(
                onPressed: () {
                  BottomNavigationBar navigationBar = _globalKey.currentWidget as BottomNavigationBar;
                  navigationBar.onTap!(0);
                },
                child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
                style: backButton ),// <-- Button color// <-- Splash color

          ),
          backgroundColor: Color(0xFFF4E3E3),
          body: Column(
            children: <Widget>[
              SafeArea(
                   child:  Container(
              child: OutlinedButton(
              child: Text('Employees'),
             onPressed: () => dialog(context),

              ),

              /*
                    Switch(
                      value: _isJoseph,
                      onChanged: (value) {

                        setState(() {
                          if (value) {
                          _updateJosephAppointments();
                          _dataSource.appointments!.addAll(_josephAppointments);
                            _dataSource.notifyListeners(
                                CalendarDataSourceAction.reset, _josephAppointments);
                          } else {
                            for (int i = 0; i < _josephAppointments.length; i++) {
                              _dataSource.appointments!.remove(_josephAppointments[i]);
                            }
                            _josephAppointments.clear();
                            _dataSource.notifyListeners(
                                CalendarDataSourceAction.reset, _josephAppointments);
                          }
                          _isJoseph = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                    Text('Dr.Joseph (Nephrologist)'),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Switch(
                    value: _isStephen,
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          _updateStephenAppointments();
                          _dataSource.appointments!.addAll(_stephenAppointments);
                          _dataSource.notifyListeners(
                              CalendarDataSourceAction.reset, _stephenAppointments);
                        } else {
                          for (int i = 0; i < _stephenAppointments.length; i++) {
                            _dataSource.appointments!.remove(_stephenAppointments[i]);
                          }
                          _stephenAppointments.clear();
                          _dataSource.notifyListeners(
                              CalendarDataSourceAction.reset, _stephenAppointments);
                        }
                        _isStephen = value;
                      });
                    },
                    activeTrackColor: Colors.lightBlue,
                    activeColor: Colors.blue,
                  ),
                  Text('Dr.Stephen (Cardiologist)'),
                ],
              ),
              Expanded(
                  child: SfCalendar(
                    view: CalendarView.week,
                    dataSource: _dataSource,
                  ))
              */


                   )

              ),

              SfCalendar(

                backgroundColor: Color(0xFFF4E3E3),
                view: CalendarView.month,
                showNavigationArrow: true,
                monthViewSettings: const MonthViewSettings(
                    showAgenda: true,
                    agendaViewHeight: 100,
                    numberOfWeeksInView: 1
                ),
                dataSource: _dataSource,
                initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day, 0, 0, 0),
                timeSlotViewSettings: const TimeSlotViewSettings(
                    minimumAppointmentDuration: Duration(minutes: 30)),
                appointmentTextStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )

   ]
    ));
  }





  void _updateAppointments(String empID, bool? add) {
  List<Appointment> app =  _allappointments.where((element){return element.id.toString() ==empID;} ).toList();
    if(add as bool) {
      _dataSource.appointments!.addAll(app);
      _dataSource.notifyListeners(
          CalendarDataSourceAction.reset, app);
    }

    else{
      for(Appointment a in app) {
        _dataSource.appointments!.remove(a);
        _dataSource.notifyListeners(
            CalendarDataSourceAction.reset, app);
      }


    }


  }



  dialog(BuildContext context){
    return  showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Color(0xFFE3D9D9),
              elevation: 0,
              content: Container(
                child:StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Employee")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('loading');
                      if (snapshot.data!.docs.isEmpty)
                        return Padding(
                            padding: EdgeInsets.all(20),
                            child: const Text('No Added Employees',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.grey),
                                textAlign: TextAlign.center));
                      return ListView.builder(
                        //  shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            String key = (snapshot.data!).docs[index]['empID'];
                            EmpList[key] =  EmpList[key] ??  true;

                            return CheckboxListTile(
                                title: Text( (snapshot.data!).docs[index]['empName']),
                                value: EmpList[key],
                                onChanged: (value){

                                  setState((){
                                    EmpList[key] = value!;});

                                  _updateAppointments(key, value);
                                }
                            );
                          });
                    })

              )
          );
        });

  }




}

DataSource getCalendarDataSource()  {

  // required: Date, DocName, PetOwner Name, Type
  List<Appointment> _appointments = <Appointment>[];

  FirebaseFirestore.instance
      .collection("appointment")
      .get().then((QuerySnapshot data) async {
    for (var doc in data.docs) {
String workshiftID =  doc['workshiftID'];
String petOwnerID = doc['petOwnerID'];
String appointmentID = doc['appointmentID'];
late String name, docName, type, empId;
late DateTime _startDateTime,  _endDateTime;

await FirebaseFirestore.instance
    .collection("pet owners")
    .where('ownerID', isEqualTo: petOwnerID)
    .get().then((QuerySnapshot pwdata) {
  var docPetOwner =  pwdata.docs.single;
  if(docPetOwner.exists) {
    name = docPetOwner['fname'].toString() + " " + docPetOwner['lname'].toString();
  }
});

      await FirebaseFirestore.instance.collection("Work Shift").where('appointmentID', isEqualTo: workshiftID)
          .get().then((QuerySnapshot wdata) async {
            String id;
            var docWork =  wdata.docs.single;
if(docWork.exists) {
  empId = docWork['empID'].toString();
  type = docWork['type'].toString();
  ;
  DateTime _date = DateFormat("dd/MM/yyyy").parse(docWork['date'].toString());

  DateTime _startTimeFormat = DateFormat("hh:mm").parse(
      docWork['startTime'].toString());
  TimeOfDay _start = TimeOfDay.fromDateTime(_startTimeFormat);

  DateTime _endTimeFormat = DateFormat("h:mm").parse(
      docWork['endTime'].toString());
  TimeOfDay _end = TimeOfDay.fromDateTime(_endTimeFormat);

  _startDateTime = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _start.hour,
      _start.minute,
      0);

  _endDateTime = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _end.hour,
      _end.minute,
      0);


  await FirebaseFirestore.instance.collection("Employee").where(
      'empID', isEqualTo: empId)
      .get().then((QuerySnapshot edoc) {
    var docemp = edoc.docs.single;
    docName = docemp['empName'].toString();
  });
}


Appointment a = Appointment(
  id: empId,
  startTime:_startDateTime,
  endTime:_endDateTime,
  subject: 'Customer: $name \n $docName ',
  notes: type,
  color: Colors.lightBlue,
);

      _appointments.add(a);
    });}
          _dataSource.notifyListeners(CalendarDataSourceAction.add, _appointments);
   _allappointments.addAll(_appointments);
  });

  return DataSource(_appointments);
}



class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}