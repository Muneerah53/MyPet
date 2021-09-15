import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
  runApp(MaterialApp(
    home: Scaffold(
        body:
        Center(
          child: SfCalendar(
          view: CalendarView.month,
          firstDayOfWeek: 5,
            backgroundColor: Color(0xF4E3E3),
            todayHighlightColor: Color(0xFF6B81),
            showNavigationArrow: true,
          ),
        ),


    )

  ));

}