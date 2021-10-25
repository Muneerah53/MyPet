library event_calendar;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'models/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/global.dart';
import 'admin_viewappts.dart';
part "addappt.dart";


late _AppointmentDataSource events;
Appointment? _selectedAppointment;
late CalendarTapDetails _selected;
DateTime sDate= DateTime(2015);
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
String _doc = '';
String _docName ='';
String _id = '';
late String _type;
late Color _background;


class appointCalendar extends StatefulWidget {
  const appointCalendar({Key? key}) : super(key: key);

  @override
  appointCalendarState createState() => appointCalendarState();
}

class appointCalendarState extends State<appointCalendar> {
  appointCalendarState();
  CalendarView _calendarView = CalendarView.month;

  late List<Appointment> appointments;
  GlobalKey _globalKey = navKeys.globalKeyAdmin;
  @override
  void initState()  {
    _calendarView = CalendarView.month;
   // appointments = <Appointment>[];
    events = getCalendarDataSource();
    _selectedAppointment = null;
    _doc = '';
    _id='';

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF4E3E3),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation:0,
            title: Text('Schedule',textAlign: TextAlign.center,
                style: TextStyle(color:Color(0XFFFF6B81))),
            leading: ElevatedButton(
              onPressed: () {
                BottomNavigationBar navigationBar =  _globalKey.currentWidget as BottomNavigationBar;
                navigationBar.onTap!(0);
              },

                child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
                style: backButton ),// <-- Button color// <-- Splash color

        ),

        resizeToAvoidBottomInset: false,
        body:
        Stack(
            children:  <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child:SfCalendar(

        backgroundColor: Color(0xFFF4E3E3),
    view: _calendarView,
    showNavigationArrow: true,
    monthViewSettings: const MonthViewSettings(
    showAgenda: true,
    agendaViewHeight: 400,
    numberOfWeeksInView: 1
    ),
    dataSource: events,
    onTap: onCalendarTapped,
    initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
    DateTime.now().day, 0, 0, 0),
    timeSlotViewSettings: const TimeSlotViewSettings(
    minimumAppointmentDuration: Duration(minutes: 30)),
    appointmentTextStyle: TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold),
    )



              ),

              Align(
                  alignment: Alignment.bottomRight,
                  heightFactor: 10,
                  child:

                  FloatingActionButton(
                    backgroundColor: const  Color(0xFF9C4350),
                    foregroundColor: Colors.white,
                    //mini: true,
                    onPressed: () {
                      try{
                        DateTime date = _selected.date!.isBefore(
                            DateTime(DateTime
                                .now()
                                .year, DateTime
                                .now()
                                .month,
                                DateTime
                                    .now()
                                    .day, 0, 0, 0)) ? DateTime.now() : DateTime(
                            _selected.date!.year, _selected.date!.month,
                            _selected.date!.day, 9, 0, 0);
                        addAppointment(date);
                      }
                      catch(LateInitializationError){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Please sleect a date first."),
                          backgroundColor:Colors.red,),);
                      }
                    },
                    child: Icon(Icons.add),
                  )
              )
            ])
    );
  }




  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }
  if(calendarTapDetails.date!.isBefore(DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0)) && calendarTapDetails.targetElement == CalendarElement.appointment)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("You can't edit past appointments details."),
      backgroundColor:Colors.red,),);

  else{  setState(() {
      _selectedAppointment = null;
      _doc = '';

      if (calendarTapDetails.targetElement == CalendarElement.appointment){
        if (calendarTapDetails.appointments != null &&
            calendarTapDetails.appointments!.length == 1) {
          final Appointment appointmentDetails = calendarTapDetails.appointments![0];
          editAppointment(appointmentDetails);
        }} else {
        _selected = calendarTapDetails;
      }
    }); }
  }

  void editAppointment(Appointment appointmentDetails) {
    _startDate = appointmentDetails.from;
    _endDate = appointmentDetails.to;
    _startTime = appointmentDetails.start;
    _endTime = appointmentDetails.end;
    _docName = appointmentDetails.docName;
    _doc = appointmentDetails.docID == '(No title)'
        ? ''
        : appointmentDetails.docID;
    _id = appointmentDetails.id;
    _type = appointmentDetails.type;
    _background = appointmentDetails.background;

    _selectedAppointment = appointmentDetails;

    Navigator.push<Widget>(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => appointmentForm()),
    );
  }

  void addAppointment(DateTime date) {
    _selectedAppointment = null;
    _doc = '';
    _type = '';

    _startDate = date;
    _endDate = date.add(const Duration(minutes: 30));
    _startTime =
        TimeOfDay(hour: 9, minute: 0);
    _endTime = TimeOfDay(hour: 9, minute: 30);

    Navigator.push<Widget>(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => appointmentForm()),
    );
  }




}
void updateName(String id,String name){

  var appoints = events.appointments!.where((element) { return element.docID==id;}).toList();

  for (var appt in appoints) {
    var appointments = <Appointment>[];
    String s = appt.status;
    Appointment temp = Appointment(
        title: appt.type+' ' "by $name"+" [$s]",
        id: appt.id,
        from: appt.from,
        to: appt.to,
        start: appt.start,
        end: appt.end,
        docID: appt.docID,
        docName: name,
        background: appt.background,
        type: appt.type,
        status: s);


    events.appointments!.removeAt(events.appointments!
        .indexOf(appt));
  events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[]..add(appt!));
    appointments.add(temp);
    events.appointments!.add(temp);
    events.notifyListeners(CalendarDataSourceAction.reset,appointments);
  }





}

class Appointment {
  Appointment(
      // ignore: non_constant_identifier_names
          {
        this.title='Appointment',
        this.id = '',
        this.docID = '',
        this.docName = '',
        required this.from,
        required this.to,
        required this.start,
        required this.end,
        required this.background,
        required this.type, this.status=''
      });
  String title;
  String id;
  String docID;
  String docName;
  DateTime from;
  DateTime to;
  TimeOfDay start;
  TimeOfDay end;
  Color background;
  String type;
  String status;
}

_AppointmentDataSource getCalendarDataSource()  {
  List<Appointment> _appointments = <Appointment>[];

  FirebaseFirestore.instance.collection("Work Shift").get().then((QuerySnapshot data) async {
    for (var doc in data.docs) {
      DateTime _date = DateFormat("dd/MM/yyyy").parse(doc['date'].toString());

      DateTime _startTimeFormat = DateFormat("hh:mm").parse(
          doc['startTime'].toString());
      TimeOfDay _start = TimeOfDay.fromDateTime(_startTimeFormat);

      DateTime _endTimeFormat = DateFormat("h:mm").parse(
          doc['endTime'].toString());
      TimeOfDay _end = TimeOfDay.fromDateTime(_endTimeFormat);

      DateTime _startDateTime = DateTime(
          _date.year,
          _date.month,
          _date.day,
          _start.hour,
          _start.minute,
          0);

      DateTime _endDateTime = DateTime(
          _date.year,
          _date.month,
          _date.day,
          _end.hour,
          _end.minute,
          0);

      Appointment a = Appointment(
          id: doc['appointmentID'].toString(),
          docID: doc['empID'].toString(),
          from: _startDateTime,
          to: _endDateTime,
          start: TimeOfDay.fromDateTime(_startDateTime),
          end: TimeOfDay.fromDateTime(_endDateTime),
          background: doc['type'] == 'Check-Up' ? Colors.lightBlue : Colors.pinkAccent[100] as Color,
          type: doc['type'].toString(),
          status:  doc['status'].toString()
      );
      String? name;
     await FirebaseFirestore.instance.collection("Employee").where('empID', isEqualTo: a.docID)
      .get().then((QuerySnapshot data) {
        for (var doc in data.docs) {
          name = doc['empName'].toString();
        }
        });
      a.docName = name?? a.docID;
      String s=a.status;
      a.title = a.type+' ' "by $name"+" [$s]";
      _appointments.add(a);
    }
    events.notifyListeners(CalendarDataSourceAction.add, _appointments);
  });
  return _AppointmentDataSource(_appointments);
}



class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source){
    appointments = source;
  }

  String getID(int index) {
    return appointments![index].id;
  }


  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  TimeOfDay getStart(int index) {
    return appointments![index].start;
  }


  TimeOfDay getEnd(int index) {
    return appointments![index].end;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  String getDoctor(int index) {
    return appointments![index].docID;
  }

  String getName(int index) {
    return appointments![index].docName;
  }
  String getStatus(int index) {
    return appointments![index].status;
  }


}
