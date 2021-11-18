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

  // void _updateAppointments(String empID, bool add) {
  //   List<Appointment> app = _allappointments.where((element) {
  //     return element.location == empID;
  //   }).toList();
  //   print('$empID and $add');
  //   print(app.length);
  //   if (add as bool) {
  //     _dataSource.appointments!.addAll(app);
  //     _dataSource.notifyListeners(CalendarDataSourceAction.reset, app);
  //   } else {
  //     for (Appointment a in app) {
  //       _dataSource.appointments!.remove(a);
  //       _dataSource.notifyListeners(CalendarDataSourceAction.remove, app);
  //     }
  //   }
  // }

  // dialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(// StatefulBuilder
  //             builder: (context, setState) {
  //               return AlertDialog(
  //                   backgroundColor: Color(0xFFE3D9D9),
  //                   elevation: 0,
  //                   actions: [
  //                     ElevatedButton(
  //                         onPressed: () => Navigator.pop(context),
  //                         child: Padding(
  //                             padding: EdgeInsets.only(
  //                                 left: 40, right: 40, top: 20, bottom: 20),
  //                             child: Text("OK",
  //                                 style: TextStyle(
  //                                     fontStyle: FontStyle.italic, fontSize: 18))),
  //                         style: ButtonStyle(
  //                           backgroundColor:
  //                           MaterialStateProperty.all(Color(0XFF2F3542)),
  //                           shape: MaterialStateProperty.all(RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(20.0))),
  //                         )),
  //                   ],
  //                   content: Container(
  //                       width: double.maxFinite,
  //                       child: StreamBuilder<QuerySnapshot>(
  //                           stream: FirebaseFirestore.instance
  //                               .collection("Employee")
  //                               .snapshots(),
  //                           builder: (context, snapshot) {
  //                             if (!snapshot.hasData) return const Text('loading');
  //                             if (snapshot.data!.docs.isEmpty)
  //                               return Padding(
  //                                   padding: EdgeInsets.all(20),
  //                                   child: const Text('No Added Employees',
  //                                       style: TextStyle(
  //                                           fontWeight: FontWeight.bold,
  //                                           fontSize: 20,
  //                                           color: Colors.grey),
  //                                       textAlign: TextAlign.center));
  //                             return ListView.builder(
  //                                 shrinkWrap: true,
  //                                 scrollDirection: Axis.vertical,
  //                                 itemCount: snapshot.data!.docs.length,
  //                                 itemBuilder: (context, index) {
  //                                   String key =
  //                                   (snapshot.data!).docs[index]['empID'];
  //                                   EmpList[key] = EmpList[key] ?? true;
  //
  //                                   return CheckboxListTile(
  //                                       title: Text((snapshot.data!).docs[index]
  //                                       ['empName']),
  //                                       value: EmpList[key],
  //                                       onChanged: (value) {
  //                                         setState(() {
  //                                           EmpList[key] = value!;
  //                                         });
  //
  //                                         _updateAppointments(key, value as bool);
  //                                       });
  //                                 });
  //                           })));
  //             });
  //       });
  // }

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
