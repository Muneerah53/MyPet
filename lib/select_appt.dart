import 'OrderList.dart';
import 'appointment_object.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'grooming.dart';
import 'models/global.dart';

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
  appointment a = appointment();
  String reason = '';
  int t = 0;
  String? date = ' no pet have been selected';
  String? pets = 'no pet have been selected';
  String? pid;
  String? time = 'no time have been \n selected';
  String? appointID;
  int? timeIndex;
  int? petIndex;
  String title = ' ';
  String emp = '';
  String img="";
  // String? petName;
  //String? stime;
  var selectedCurrency;
  @override
  void initState() {
    super.initState();
    t = widget.type;
    title = (t == 0) ? "Check-Up" : "Grooming";

    if (title=="Check-Up"){
       img ='images/PBCheckUp.png';
    }
    else
       img ='images/PBGrooming.png';

    emp = (t == 0) ? "Doctor" : "Groomer"; //here var is call and set to
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
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        // ),

        body: ListView(children: <Widget>[

          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0XFFFF6B81),
                      fontSize: 34,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold))),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                  height: 40,
                  fit: BoxFit.fill,
                  image: new AssetImage(img))
            ],
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
            child: Text(
              'Select $emp:',
              style: TextStyle(
                  color: const Color(0xFF552648B),
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),

            child: Form(
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Employee")
                          .where("job", isEqualTo: "$emp")
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<DropdownMenuItem> currencyItems = [];

                        if (!snapshot.hasData)
                          const Text("Loading.....");
                        else {
                          for (int i = 0;
                              i < (snapshot.data!).docs.length;
                              i++) {
                            DocumentSnapshot snap = (snapshot.data!).docs[i];
                            currencyItems.add(
                              DropdownMenuItem(

                                  child: Text(
                                    snap.get("empName"),
                                    style: TextStyle(color: Colors.black38),
                                  ),
                                  value: ("${snap.get("empID")}")),
                            );
                          }
                        }
                        return Row(

                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 5, 120, 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton<dynamic>(
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  items: currencyItems,
                                  hint: new Text("Select $emp ...            "),

                                  onChanged: (currencyValue) {
                                    setState(() {
                                      selectedCurrency = currencyValue;
                                    });
                                  },
                                  value: selectedCurrency,
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 16,
                                    height: 1.0,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  focusColor: Colors.white,
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
            child: Text(
              'Select Day:',

              style: TextStyle(
                  color: const Color(0xFF552648B),
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
              child: GestureDetector(
                  onTap: () {
                    if (selectedCurrency == null)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("You Must Select a Doctor First"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    else
                      showDialog();
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _date,
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 16,
                        height: 1.0,
                        fontStyle: FontStyle.italic,
                      ),
                      decoration: InputDecoration(
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
            padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
            child: Text(
              'Select Time:',
              style: TextStyle(
                  color: const Color(0xFF552648B),
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              height: 120,
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Work Shift')
                      .where('empID', isEqualTo: selectedCurrency.toString())
                      .where('date',
                          isEqualTo:
                              DateFormat('dd/MM/yyyy').format(selectedDate))
                      .where('type', isEqualTo: title)
                      .where('status', isEqualTo: "Available")

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

                    int i = 0, j = 0;
                    String txt = '';

                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                var s =  (snapshot.data!).docs[index]
                          ['startTime'].toString().split(":")[0];
                var t = DateTime.now().hour.toString();

                var date =  (snapshot.data!).docs[index]
                ['date'].toString();
                DateTime d =   DateFormat('dd/MM/yyyy').parse(date);
              DateTime now = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,0,0);
                              if(s.compareTo(t)<=0 && d.isAtSameMomentAs(now)){
                                if(index==(snapshot.data!.docs.length-1) && i==0)
                          return Text('No Available Times',
                          style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey),
                          textAlign: TextAlign.center);
                                else
                                  return Text('');}

                          String? stime = ((snapshot.data!).docs[index]
                                  ['startTime'] +
                              ' - ' +
                              (snapshot.data!).docs[index]['endTime']);




                i++;

                          return OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                  side: BorderSide(color: Colors.transparent)),
                              onPressed: () => changeTimeSelected(
                                  index,
                                  stime,
                                  ((snapshot.data!).docs[index]
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
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    width: 145,
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
                                                fontSize: 18,
                                                color: timeIndex == index
                                                    ? Colors.white
                                                    : Color(0XFF2F3542))),
                                      ),
                                    ),
                                  )));
                        });
                  })),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
            child: Text(
              'Select Pet:',
              style: TextStyle(
                  color: const Color(0xFF552648B),
                  fontSize: 18,
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
          Visibility(
              visible: t == 0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        'Enter Reason:',
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                      //margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextFormField(
                        validator: (Value) {
                          if (Value!.isEmpty) {
                            return "Please enter your reason of visit";
                          }
                        },
                        onChanged: (value) {
                          reason = value;
                        },
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.0,
                            fontStyle: FontStyle.italic,
                            color: Colors.black38),
                        decoration: InputDecoration(
                          hintText: ('Enter your reason of visit...'),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 10.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.black38),
                        ),
                      ),
                    ),
                  ])),
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
                          (petIndex == null) ||
                            (reason.isEmpty)
                      ) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Please fill out all fields."),
                          backgroundColor: Theme.of(context).errorColor,
                        ));
                      } else {
                        if (selectedCurrency == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Please fill out all fields."),
                            backgroundColor: Theme.of(context).errorColor,
                          ));
                        } else {

                          a.date = DateFormat('EEE, MMM dd yyyy')
                              .format(selectedDate);
                          a.time = time;
                          a.petId= pid;
                          a.petName= pets;
                          a.appointID = appointID;
                          a.desc = 'Check-Up: $reason';
                          a.type = title;
                          print(a.toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => OrderList(
                                    appoint: a)),
                          );
                        }
                      }
                    } else {
                      if ((_date == null) ||
                          (timeIndex == null) ||
                          (petIndex == null)) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Please fill out all fields."),
                          backgroundColor: Theme.of(context).errorColor,
                        ));
                      } else {
                        a.date = DateFormat('EEE, MMM dd yyyy')
                            .format(selectedDate);
                        a.time = time;
                            a.petId= pid;
                        a.petName= pets;
                        a.appointID = appointID;
                       // a.desc = 'Check-Up: $reason';
                        a.type = title;
                        print(a.info());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Grooming(
                                  appoint: a,
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
          )
        ]));
  }

  Widget _buildListItem(
      int index, BuildContext context, DocumentSnapshot document) {
    String? petName = document['name'];
    String? petID = document['petId'];
    String img =
        document['species'] == "Dog" ? "images/dog.png" : "images/cat.png";
    if (document['species'] == "Dog")
      img = "images/dog.png";
    else if (document['species'] == "Cat")
      img = "images/cat.png";
    else if (document['species'] == "Bird")
      img = "images/Bird.png";
    else if (document['species'] == "Rabbit")
      img = "images/Rabbit.png";
    else if (document['species'] == "Snake")
      img = "images/Snake.png";
    else if (document['species'] == "Turtle")
      img = "images/Turtle.png";
    else if (document['species'] == "Hamster")
      img = "images/Hamster.png";
    else
      img = "images/New.png";
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(0),
            side: BorderSide(color: Colors.transparent)),
        onPressed: () => changePetSelected(index, petName, petID),
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
                  margin: EdgeInsets.only(
                    top: 3,
                  ),
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

  changePetSelected(int index, String? p, String? petId) {
    setState(() {
      petIndex = index;
      pets = p;
      pid = petId;
    });
  }
}
