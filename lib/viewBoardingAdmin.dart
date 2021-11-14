import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'admin_appointDetails.dart';
import 'models/data.dart';
import 'models/global.dart';

class AdminBoardingAppointments extends StatefulWidget {
  @override
  AdminBoardingAppointmentsState createState() => AdminBoardingAppointmentsState();
}
late DataSource _dataSource;
final List<Appointment> _allappointments = <Appointment>[];
fbHelper fb = fbHelper();
class AdminBoardingAppointmentsState extends State<AdminBoardingAppointments> {

  bool _progressController = true;
  GlobalKey _globalKey = navKeys.globalKeyAdmin;
  Map<String, bool> EmpList = {};
  bool vis = false;

  void initState() {
    _dataSource = getCalendarDataSource();
    _allappointments.clear();

    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
            style: backButton), // <-- Button color// <-- Splash color

      ),
      backgroundColor: Color(0xFFF4E3E3),
      body:
      _progressController
          ? Center(child:CircularProgressIndicator())
          : Column(
          children: <Widget>[
            Expanded(
              child:
              Row(
                children: <Widget>[
                  SfCalendar(
                    onTap: onCalendarTapped,
                    backgroundColor: Color(0xFFF4E3E3),
                    view: CalendarView.month,
                    showNavigationArrow: true,
                    monthViewSettings: const MonthViewSettings(
                        showAgenda: true,
                        agendaViewHeight: 400,
                        numberOfWeeksInView: 1
                    ),
                    dataSource: _dataSource,
                    initialDisplayDate: DateTime(DateTime
                        .now()
                        .year, DateTime
                        .now()
                        .month,
                        DateTime
                            .now()
                            .day, 0, 0, 0),
                    timeSlotViewSettings: const TimeSlotViewSettings(
                        minimumAppointmentDuration: Duration(minutes: 30)),
                    appointmentTextStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ]
      ),

    );
  }
  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }
    Appointment a = calendarTapDetails.appointments![0];

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (BuildContext context) =>
    //       new AppointmentDetails(
    //           appointID: a.id.toString(),
    //           details: a.notes
    //
    //       )
    //   ),
    // );
  }
  DataSource getCalendarDataSource()  {
    //
    // // required: Date, DocName, PetOwner Name, Type
    List<Appointment> _appointments = <Appointment>[];
    fb.appointments() ;

    return DataSource(_appointments);
  }


}
class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}
