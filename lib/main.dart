library event_calendar;

import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


part "addappt.dart";

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 final Future<FirebaseApp> fbApp =  Firebase.initializeApp();
   MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
             future: fbApp,
      builder:(context,snapshot) {
               if (snapshot.hasError){
                 print("An error has occured ${snapshot.error.toString()}");
                 return const Text("Something went wrong");}
      else if (snapshot.hasData) {
        return const appointCalendar();
      }
      else{return const Center(child:CircularProgressIndicator());}
      },
    )
    );
  }
}

late _AppointmentDataSource _events;
Appointment? _selectedAppointment;
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
String _doc = '';
String _description = '';

class appointCalendar extends StatefulWidget {
  const appointCalendar({Key? key}) : super(key: key);

  @override
  appointCalendarState createState() => appointCalendarState();
}

class appointCalendarState extends State<appointCalendar> {
  appointCalendarState();

  CalendarView _calendarView = CalendarView.month;
  late List<String> eventNameCollection;
  late List<Appointment> appointments;

  @override
  void initState() {
    _calendarView = CalendarView.month;
    appointments = getAppointmentDetails();
    _events = _AppointmentDataSource(appointments);
    _selectedAppointment = null;
    _doc = '';
    _description = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Schedule'),
    backgroundColor: Color(0xFFFF6B81),
        ),
    resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: getCalendar(_calendarView, _events, onCalendarTapped)));
  }

  SfCalendar getCalendar(
      CalendarView _calendarView,
      CalendarDataSource _calendarDataSource,
      CalendarTapCallback calendarTapCallback) {
    return SfCalendar(
        backgroundColor: Color(0xFFF4E3E3),
        view: _calendarView,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          agendaViewHeight: 500,
            numberOfWeeksInView: 1
        ),
        dataSource: _calendarDataSource,
        onTap: calendarTapCallback,
        initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0),

        timeSlotViewSettings: const TimeSlotViewSettings(
            minimumAppointmentDuration: Duration(minutes: 30)));
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }
    setState(() {
      _selectedAppointment = null;
      _doc = '';
      _description = '';

        if (calendarTapDetails.appointments != null &&
            calendarTapDetails.appointments!.length == 1) {
          final Appointment meetingDetails = calendarTapDetails.appointments![0];
          _startDate = meetingDetails.from;
          _endDate = meetingDetails.to;
          _doc = meetingDetails.docName == '(No title)'
              ? ''
              : meetingDetails.docName;
          _description = meetingDetails.description;
          _selectedAppointment = meetingDetails;
        } else {
          final DateTime date = calendarTapDetails.date!;
          _startDate = date;
          _endDate = date.add(const Duration(minutes: 30));
        }
        _startTime =
            TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
        Navigator.push<Widget>(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => appointmentForm()),
        );
    });
  }

  List<Appointment> getAppointmentDetails() {
    final List<Appointment> apointmentCollection = <Appointment>[];
    //reterive from firebase
    return apointmentCollection;
  }
}

  class Appointment {
  Appointment(
  {this.docName = '',
  this.description = '',
  required this.from,
  required this.to,
  required this.background,
  this.recurrenceRule,
  });

  String docName;
  String description;
  DateTime from;
  DateTime to;
  Color background;
  String? recurrenceRule;
  }

  class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source){
  appointments = source;
  }
  @override
  DateTime getStartTime(int index) {
  return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
  return appointments![index].to;
  }

  @override
  Color getColor(int index) {
  return appointments![index].background;
  }

  String getDoctor(int index) {
  return appointments![index].docName;
  }

  String getDescription(int index) {
  return appointments![index].description;
  }


  }


/*
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: SfCalendar(
            firstDayOfWeek: 7,
            backgroundColor: Color(0xFFF6E9E9),
            todayHighlightColor: Color(0xFFFF6B81),
            showNavigationArrow: true,
            view: CalendarView.day,
            dataSource: _getCalendarDataSource(),
          ),
        ),
      ),
    );
  }
}

  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      from: DateTime.now(),
      to: DateTime.now().add(Duration(minutes: 30)),
      docName: 'Meeting',
      description: 'Meeting',
      background: Colors.blue,
      recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO,WE,FR;INTERVAL=1;COUNT=10'
    ));

    return _AppointmentDataSource(appointments);
  }

class Appointment {
  Appointment(
      {this.docName = '',
        this.description = '',
        required this.from,
        required this.to,
        required this.background,
        this.recurrenceRule});

  String docName;
  String description;
  DateTime from;
  DateTime to;
  Color background;
  String? recurrenceRule;
}

  class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source){
  appointments = source;
  }
  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  String getDoctor(int index) {
    return appointments![index].docName;
  }

  String getDescription(int index) {
    return appointments![index].description;
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

appBar: AppBar(
backgroundColor:Color(0xFFF5CDCD) ,
  elevation: 0.0,
),
body:
SfCalendar(
    view: CalendarView.month,
    firstDayOfWeek: 7,
      backgroundColor: Color(0xFFF6E9E9),
      todayHighlightColor: Color(0xFFFF6B81),
      showNavigationArrow: true,
    ),
    );
  }
}

   */
