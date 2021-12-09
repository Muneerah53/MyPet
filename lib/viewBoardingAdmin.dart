import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'admin_appointDetails.dart';
import 'admin_boardingDetails.dart';
import 'models/data.dart';
import 'models/global.dart';

class AdminBoardingAppointments extends StatefulWidget {
  const AdminBoardingAppointments({Key? key}) : super(key: key);

  @override
  _AdminBoardingAppointmentsState createState() =>
      _AdminBoardingAppointmentsState();
}

late DataSource _dataSource;
final List<Appointment> _allappointments = <Appointment>[];
fbHelper fb = fbHelper();

class _AdminBoardingAppointmentsState extends State<AdminBoardingAppointments> {
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
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: ElevatedButton(
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       },
      //       child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
      //       style: backButton), // <-- Button color// <-- Splash color
      // ),
      backgroundColor: Color(0xFFF4E3E3),
      body: _progressController
          ? Center(child: CircularProgressIndicator())
          : Column(children: <Widget>[
        // TextButton.icon(
        //   onPressed: () {
        //     setState(() {
        //       dialog(context);
        //     });
        //   },
        //   icon: Icon(Icons.filter_alt, color: Colors.pinkAccent),
        //   label: Text('Filter Employees',
        //       style: TextStyle(color: Colors.pinkAccent)),
        // ),
        Expanded(
          child: Row(
            children: <Widget>[
              SfCalendar(
                onTap: onCalendarTapped,
                backgroundColor: Color(0xFFF4E3E3),
                view: CalendarView.month,
                showNavigationArrow: true,
                monthViewSettings: const MonthViewSettings(
                    showAgenda: true,
                    agendaViewHeight: 400,
                    numberOfWeeksInView: 1),
                dataSource: _dataSource,
                initialDisplayDate: DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day),
                timeSlotViewSettings: const TimeSlotViewSettings(
                    minimumAppointmentDuration: Duration(minutes: 30)),
                appointmentTextStyle:
                TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ]),
    );
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }
    Appointment a = calendarTapDetails.appointments![0];

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => new BoardingDetails(
              boardingID: a.id.toString(), details: a.notes)),
    );
  }

  DataSource getCalendarDataSource() {
    print("getCalendarDataSource");
    // required: Date, DocName, PetOwner Name, Type
    List<Appointment> _appointments = <Appointment>[];
    FirebaseFirestore.instance
        .collection("boarding")
        .get()
        .then((QuerySnapshot data) async {
      for (var doc in data.docs) {
        bool e = false;
        //String workshiftID = doc['workshiftID'];
        String petOwnerID = doc['petOwnerID'];
        String boardingID = doc['boardingID'];
        String petID = doc['petID'];
        String totalPrice = doc['totalPrice'].toString();
        DateTime startDate =
        DateFormat("EEE, MMM dd yyyy").parse("${doc['startDate']}");
        DateTime endDate =
        DateFormat("EEE, MMM dd yyyy").parse("${doc['endDate']}");
        late String petOnerFullName, type, empId;

        await FirebaseFirestore.instance
            .collection("pet owners")
            .where('ownerID', isEqualTo: petOwnerID)
            .get()
            .then((QuerySnapshot pwdata) {
          try {
            var docPetOwner = pwdata.docs.single;
            if (docPetOwner.exists) {
              petOnerFullName = docPetOwner['fname'].toString() +
                  " " +
                  docPetOwner['lname'].toString();
            }
          } catch (StateError) {
            e = true;
            print(petOwnerID + 'not found');
          }

          if (!e) {
            Appointment dropOff = Appointment(
                isAllDay: true,
                notes:
                '$petOnerFullName,${startDate.day}-${startDate.month}-${startDate.year},${endDate.day}-${endDate.month}-${endDate.year},$petID,$totalPrice',
                id: boardingID,
                startTime: startDate,
                endTime: startDate,
                subject: 'Customer: $petOnerFullName',
                color: Colors.lightBlue);

            _appointments.add(dropOff);
            _allappointments.add(dropOff);


          }
        });
      }

      _dataSource.notifyListeners(CalendarDataSourceAction.add, _appointments);
      setState(() {
        _progressController = false;
      });
    });

    return DataSource(_appointments);
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}
