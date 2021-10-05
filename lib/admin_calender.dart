library event_calendar;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part "addappt.dart";

late _AppointmentDataSource _events;
Appointment? _selectedAppointment;
late CalendarTapDetails _selected;
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
String _doc = '';
String _id = '';
late int _type;
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

  @override
  void initState()  {
    _calendarView = CalendarView.month;
   // appointments = <Appointment>[];
    _events = _getCalendarDataSource();
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
          elevation:0,
          title: Text('Schedule',textAlign: TextAlign.center,
              style: TextStyle(color:Color(0XFFFF6B81))),
          backgroundColor: Colors.transparent,
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
    agendaViewHeight: 500,
    numberOfWeeksInView: 1
    ),
    dataSource: _events,
    onTap: onCalendarTapped,
    initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
    DateTime.now().day, 0, 0, 0),
    initialSelectedDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0),
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
                      addAppointment(DateTime(_selected.date!.year,_selected.date!.month,_selected.date!.day,9,0,0));
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
    setState(() {
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
    });
  }

  void editAppointment(Appointment appointmentDetails) {
    _startDate = appointmentDetails.from;
    _endDate = appointmentDetails.to;
    _startTime = appointmentDetails.start;
    _endTime = appointmentDetails.end;
    _doc = appointmentDetails.docName == '(No title)'
        ? ''
        : appointmentDetails.docName;
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
    _type = 0;

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

class Appointment {
  Appointment(
      // ignore: non_constant_identifier_names
          {
        this.title='Appointment',
        this.id = '',
        this.docName = '',
        required this.from,
        required this.to,
        required this.start,
        required this.end,
        required this.background,
        required this.type, this.status='',
      });
  String title;
  String id;
  String docName;
  DateTime from;
  DateTime to;
  TimeOfDay start;
  TimeOfDay end;
  Color background;
  int type;
  String status;
}

_AppointmentDataSource _getCalendarDataSource()  {
  List<Appointment> _appointments = <Appointment>[];

  FirebaseFirestore.instance.collection("appointment ").get().then((QuerySnapshot data) {
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
          docName: doc['empName'].toString(),
          from: _startDateTime,
          to: _endDateTime,
          start: TimeOfDay.fromDateTime(_startDateTime),
          end: TimeOfDay.fromDateTime(_endDateTime),
          background: doc['typeID'] == 0 ? Color(0xFFC6D8FF) : Color(0xFFFFC6F4),
          type: doc['typeID'],
          status:  doc['state'].toString()
      );

      int t = a.type;
      String name = a.docName;
      String s=a.status;
      a.title = ((t==0 ? "Check-Up by $name" : "Grooming by $name"))+" [$s]";
      _appointments.add(a);
    }
    _events.notifyListeners(CalendarDataSourceAction.add, _appointments);
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
    return appointments![index].docName;
  }


  String getStatus(int index) {
    return appointments![index].status;
  }


}
