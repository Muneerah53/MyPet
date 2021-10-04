import 'check_up.dart';
import 'OrderList.dart';
import 'custom_checkbox.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? user = FirebaseAuth.instance.currentUser;
String owner =
    FirebaseFirestore.instance.collection('pet owners').doc(user?.uid).id;

class select extends StatefulWidget {
  final int type;

  // final String date;
  const select({
    Key? key,
    required this.type, //this.date
  }) : super(key: key);

  @override
  selectState createState() => selectState();
}

class selectState extends State<select> {
  int t = 0;
  String? date = ' no pet have been selected';
  String? pets = 'no pet have been selected';
  String? time = 'no time have been \n selected';
  String? appointID;
  int? timeIndex;
  int? petIndex;
  String title = ' ';
  // String? petName;
  //String? stime;

  @override
  void initState() {
    super.initState();
    t = widget.type;
    title = (t == 0) ? "Check-Up" : "Grooming"; //here var is call and set to
  }

  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();

  showDialog() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)); //from db
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _date.value = TextEditingValue(
            text: DateFormat('EEE, MMM dd yyyy').format(selectedDate));
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF4E3E3),
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        // ),
        body: ListView(children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 330, 0),
            padding: EdgeInsets.only(left: 10.0),
            width: 50,
            height: 50,
            child: BackButton(
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color: Colors.lightBlueAccent, shape: (BoxShape.circle)),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0XFFFF6B81),
                      fontSize: 34,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold))),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
            child: Text(
              'Select Day:',
              style: TextStyle(
                  color: const Color(0xFF552648B),
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                  onTap: () => showDialog(),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _date,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.calendar_today,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Date",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            )),
                      ),
                    ),
                  ))),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
            child: Text(
              'Select Time:',
              style: TextStyle(
                  color: const Color(0xFF552648B),
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              height: 120,
              padding: const EdgeInsets.all(10),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('appointment ')
                      .where('date',
                          isEqualTo:
                              DateFormat('dd/MM/yyyy').format(selectedDate))
                      .where('typeID', isEqualTo: t)
                      .where('state', isEqualTo: "available")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('loading');
                    if (snapshot.data!.docs.isEmpty)
                      return Padding(
                          padding: EdgeInsets.all(20),
                          child: const Text('No Available Times',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey),
                              textAlign: TextAlign.center));
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          String? stime = ((snapshot.data!).docs[index]
                                  ['startTime'] +
                              ' - ' +
                              (snapshot.data!).docs[index]['endTime']);

                          return OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                  side: BorderSide(color: Colors.transparent)),
                              onPressed: () => changeTimeSelected(index, stime, ((snapshot.data!).docs[index]
                          ['appointmentID'])),
                              child: Card(
                                  color: timeIndex == index
                                      ? Color(0XFFFF6B81)
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Container(
                                      // margin: EdgeInsets.only(top: 10),
                                      child: ListTile(
                                        title: Text(
                                            ((snapshot.data!).docs[index]
                                                    ['startTime'] +
                                                ' - ' +
                                                (snapshot.data!).docs[index][
                                                    'endTime']) //,style: statusStyles[document['species']]
                                            ,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: timeIndex == index
                                                    ? Colors.white
                                                    : Color(0XFF2F3542))),
                                      ),
                                    ),
                                  )));
                        });
                  })),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
            child: Text(
              'Select Pet:',
              style: TextStyle(
                  color: const Color(0xFF552648B),
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(10),
              height: 250,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("pets")
                      .where('ownerId', isEqualTo: (owner))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('loading');
                    if (snapshot.data!.docs.isEmpty)
                      return Padding(
                          padding: EdgeInsets.all(20),
                          child: const Text('You haven\'t added Any Pets!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey),
                              textAlign: TextAlign.center));
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => _buildListItem(
                          index, context, (snapshot.data!).docs[index]),
                    );
                  })),
          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 1.5,
              child: ElevatedButton(
                  onPressed: () {
                    String massage;
                    if (t == 0) {
                      if ((_date == null) ||
                          (timeIndex == null) ||
                          (petIndex == null)) {
                        massage =
                            'There is a missing field you you should fill it all  ';
                        showAlertDialog(context);
                      } else {
                        date =
                            DateFormat('EEE, MMM dd yyyy').format(selectedDate);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => CheckUP(
                                      date: date,
                                      time: time,
                                      pet: pets,
                                    appointID: appointID
                                    )));
                      }
                    } else {
                      if ((_date == null) ||
                          (timeIndex == null) ||
                          (petIndex == null)) {
                        showAlertDialog(context);
                      } else {
                        date =
                            DateFormat('EEE, MMM dd yyyy').format(selectedDate);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Grooming(
                                      date: date,
                                      time: time,
                                      pet: pets,
                                    appointID: appointID
                                    )));
                      }
                    }
                  },
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 40, right: 40, top: 20, bottom: 20),
                      child: Text("Next",
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 20))),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0XFF2F3542)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                  )
                  //Icon(Icons.navigate_next),

                  ),
            ),
          ),
        ]));
  }

  Widget _buildListItem(
      int index, BuildContext context, DocumentSnapshot document) {
    String? petName = document['name'];
    String img =
        document['species'] == "Dog" ? "images/dog.png" : "images/cat.png";
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(0),
            side: BorderSide(color: Colors.transparent)),
        onPressed: () => changePetSelected(index, petName),
        child: Card(
            color: petIndex == index ? Color(0XFFFF6B81) : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 20, right: 20),
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: petIndex == index ? Color(0XFFFF6B81) : Colors.white,
              ),
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CircleAvatar(
                        radius: 53,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(img),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ListTile(
                      title: Text(
                          "   " +
                              document[
                                  'name'] //,style: statusStyles[document['species']]
                          ,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: petIndex == index
                                  ? Colors.white
                                  : Color(0XFF2F3542)))),
                ),
              ]),
            )));
  }

  changeTimeSelected(int index, String? t, String? id) {
    setState(() {
      timeIndex = index;
      time = t;
      appointID = id;
    });
  }

  changePetSelected(int index, String? p) {
    setState(() {
      petIndex = index;
      pets = p;
    });
  }
}

//
showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Missing Input"),
    content: Text('There is a missing field you you should fill it all '),
    actions: [
      okButton,
    ],
  );
// show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
