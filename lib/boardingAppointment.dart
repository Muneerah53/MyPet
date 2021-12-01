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

class boardingapp extends StatefulWidget {


  // final String date;
  const boardingapp({
    Key? key,
  //this.date
  }) : super(key: key);

  @override
  boardingState createState() => boardingState();
}

class boardingState extends State<boardingapp> {
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
  // String? petName;
  //String? stime;

  int isSelected1=0;
  int isSelected2=0;
  @override
  void initState() {
    super.initState();

  }

  DateTime selected1Date = DateTime.now().add(Duration(days: 1));
  DateTime selected2Date = DateTime.now().add(Duration(days: 2));



  TextEditingController _date1 = new TextEditingController();
  TextEditingController _date2 = new TextEditingController();


  show1stDialog() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selected1Date,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)); //from db
    if (picked != null && picked != selected1Date && (_date2.text.isEmpty || (picked.isBefore(selected1Date)) && !(picked.isAfter(selected1Date)))) {



      setState(() {
        selected1Date = picked;
        _date1.value = TextEditingValue(
            text: DateFormat('EEE, MMM dd yyyy').format(selected1Date)
        );
        if(_date2.text.isEmpty){
          setState(() {
            selected2Date = picked.add(Duration(days: 1));
            _date2.value = TextEditingValue(
                text: DateFormat('EEE, MMM dd yyyy').format(selected2Date)
            );
          });

        }

      });
      isSelected1=1;
    }

    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "drop-off date must be before pick-up date "),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }


  }


  show2ndDialog() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selected1Date.add(Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)); //from db
    if (picked != null && picked != selected2Date && !(picked.isBefore(selected1Date)) && (picked.isAfter(selected1Date))) {
      setState(() {
        selected2Date = picked;
        _date2.value = TextEditingValue(
            text: DateFormat('EEE, MMM dd yyyy').format(selected2Date)
        );
      });
      isSelected2=1;
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "pick-up date must be after drop-off date "),
        backgroundColor: Theme.of(context).errorColor,
      ));
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
              child: Text('Boarding',
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
                  image: new AssetImage('images/PBCheckUp.png'))
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
            child: Text(
              'Select Drop-Off Date:',
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
                      show1stDialog();
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _date1,
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 16,
                        height: 1.0,
                        fontStyle: FontStyle.italic,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Drop-Off Date",
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
              'Select Pick-Up Date:',
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
                    if (isSelected1==0)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("You Must Select Drop-Off Date First"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    else
                      show2ndDialog();
                  },

                  child: AbsorbPointer(
                    child: TextField(
                      controller: _date2,
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 16,
                        height: 1.0,
                        fontStyle: FontStyle.italic,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Pick-Up Date",
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

          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                  child: Text(
                    'Note:',
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
                        return "Please enter your notes of your pet.";
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
                      hintText: ('Enter notes...'),
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
              ]),


          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 1.5,
              child: ElevatedButton(
                  onPressed: () {
                    if ((isSelected1==0) ||
                        (isSelected2==0) ||
                        (petIndex == null) ||
                        (reason.isEmpty)
                    ) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Please fill out all fields."),
                        backgroundColor: Theme.of(context).errorColor,
                      ));
                    }
                    else {
                      a.type = 'Boarding';
                      a.total = 75.0 * selected2Date
                          .difference(selected1Date)
                          .inDays;
                      a.petId = pid;
                      a.petName = pets;
                      a.desc = reason;
                      a.time =
                          DateFormat('EEE, MMM dd yyyy').format(selected2Date);
                      a.date =
                          DateFormat('EEE, MMM dd yyyy').format(selected1Date);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                OrderList(
                                    appoint: a)),
                      );
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
