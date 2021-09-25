library event_calendar;

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



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
        primaryColor: const Color(0XFFFF6B81),
        primarySwatch: Colors.pink,
        // Define the default font family.
        fontFamily: 'Gotham',
        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Gotham',color: Colors.blue),
        ),
        scaffoldBackgroundColor: Color(0xFFF4E3E3),
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
late CalendarTapDetails _selected;
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
String _doc = '';
String _description = '';
String _id = '';

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
    appointments = <Appointment>[];
    _events = _AppointmentDataSource(appointments);
    _selectedAppointment = null;
    _doc = '';
    _description = '';
    _id='';

    super.initState();
    fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: getCalendar(_calendarView, _events, onCalendarTapped)



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
                addAppointment(_selected.date!);
              },
              child: Icon(Icons.add),
            )
        )
])
    );
  }

  SfCalendar getCalendar(
      CalendarView _calendarView,
      CalendarDataSource _calendarDataSource,
      CalendarTapCallback calendarTapCallback) {
    return SfCalendar(
        backgroundColor: Color(0xFFF4E3E3),
        view: _calendarView,
        showNavigationArrow: true,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          agendaViewHeight: 500,
            numberOfWeeksInView: 1
        ),
        dataSource: _calendarDataSource,
        onTap: calendarTapCallback,
        initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0),
        initialSelectedDate: DateTime(DateTime.now().year, DateTime.now().month,
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


  Future<void> fetchAppointments() async {

    var data= await FirebaseFirestore.instance.collection("appointment ").get();
    for(int i=0;i<data.docs.length;i++){
      DateTime _date = DateFormat("dd/MM/yyyy").parse(data.docs[i].data()['date'].toString());

      DateTime _startTimeFormat = DateFormat("hh:mm").parse(
          data.docs[i].data()['startTime'].toString());
      TimeOfDay _start = TimeOfDay.fromDateTime(_startTimeFormat);

      DateTime _endTimeFormat = DateFormat("h:mm").parse(data.docs[i].data()['endTime'].toString());
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
          id: data.docs[i].data()['appointmentID'].toString(),
          docName: data.docs[i].data()['DrName'].toString(),
          description: data.docs[i].data()['description'].toString(),
          from: _startDateTime,
          to: _endDateTime,
          start: TimeOfDay.fromDateTime(_startDateTime),
          end: TimeOfDay.fromDateTime(_endDateTime),
          background: Color(0xFF9C4350),
          type: 0//result['typeID']
      );


        appointments.add(a);
      print(i);
    }
    _events.notifyListeners(
        CalendarDataSourceAction.add, appointments);
  }

  void editAppointment(Appointment appointmentDetails) {
    _startDate = appointmentDetails.from;
    _endDate = appointmentDetails.to;
    _startTime = appointmentDetails.start;
    _endTime = appointmentDetails.end;
    _doc = appointmentDetails.docName == '(No title)'
        ? ''
        : appointmentDetails.docName;
    _description = appointmentDetails.description;
    _id = appointmentDetails.id;
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
    _description = '';

    _startDate = date;
    _endDate = date.add(const Duration(minutes: 30));
    _startTime =
        TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);

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
  {this.id = '',
  this.docName = '',
  this.description = '',
  required this.from,
  required this.to,
  required this.start,
   required this.end,
  required this.background,
  required this.type,
  });
  String id;
  String docName;
  String description;
  DateTime from;
  DateTime to;
  TimeOfDay start;
  TimeOfDay end;
  Color background;
  int type;
  }

  class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source){
  appointments = source;
  }

  String getID(int index) {
    return appointments![index].id;
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
