
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/owner.dart';
import 'models/pet.dart';
import 'models/global.dart';


//firebase database

String userName="unknown";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
AssetImage profile = new AssetImage("images/logo.jpeg");
class MyApp extends StatelessWidget {



 final Future<FirebaseApp> fbApp =  Firebase.initializeApp();
   MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ));

  }
}

class Home extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: Colors.red[50],

      body:Stack(

      children: <Widget>[
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 70),
          child: CircleAvatar(
            radius: 60,

            backgroundImage: new AssetImage("images/logo.jpeg"),
          ),
        ),

      ],

    ),
        Container(
          margin: EdgeInsets.only(top: 60,left: 40),
          child: CircleAvatar(
            radius: 25, backgroundColor: Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 58,left: 37),
          child: CircleAvatar(
            radius: 25, backgroundColor: Colors.blueGrey[100],
          ),
        ),


        //owner container
    Container(
    padding: EdgeInsets.only(top: 220, bottom: 350),
    child: ListView(
    padding: EdgeInsets.only(left: 20),
    children: getMyInfo(),
    scrollDirection: Axis.horizontal,
    ),
    ),
        Container(
          padding: EdgeInsets.only(bottom: 320),
          child: Center(
    child: Text(
          'profile information',
            style: TextStyle(
              fontSize: 18, color: Colors.black87,
              fontStyle: FontStyle.italic,),
          textAlign: TextAlign.center,
            ),
        ),
        ),

        Container(
          margin: EdgeInsets.only(top:410,left:250),

          width: 120, height:35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: Colors.black87,

          ),


          child: Row(
            children: [ ElevatedButton(onPressed:() async {

                DocumentSnapshot variable = await FirebaseFirestore.instance.collection('pet owners').doc("afs7JhgoMfFVDyFbNqO5").get();
                userName= variable["fname"];

              },


                child: Center(
              
               child:  Text(userName, style: new TextStyle(  color: Colors.white),
                textAlign: TextAlign.center,),

            ),
            
          ),]


        ),),
        Container(
          padding: EdgeInsets.only(top: 500, left:30),

            child: Text(
              'My Pets',
              style: TextStyle(
                fontSize: 30, color: Colors.black87,
                fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

    Container(
      padding: EdgeInsets.only(top: 550, bottom: 50),
      child: ListView(
        padding: EdgeInsets.only(left: 20),
        children: getMyPets(),
        scrollDirection: Axis.horizontal,
      ),
    ),
    ]));
  }
  List<pet> getPets() {
    List<pet> techies = [];
    for (int i = 0; i < 5; i++) {
      AssetImage profilePic = new AssetImage("images/logo.jpeg");
      pet myPets = new pet("cloud", "Cat", profilePic);
      techies.add(myPets);
    }
    return techies;
  }

  List<Widget> getMyPets() {
    List<pet> techies = getPets();
    List<Widget> cards = [];
    for (pet techy in techies) {
      cards.add(petCard(techy));
    }
    return cards;
  }
  String userName="unknown";
  Future<void> getUserInfo() async {

    DocumentSnapshot variable = await FirebaseFirestore.instance.collection('pet owners').doc("afs7JhgoMfFVDyFbNqO5").get();
    userName= variable["fname"];

  }

  List<owner> getUser()  {
    List<owner> techies = [];
      owner myInfo = new owner(userName, "Alqahtani", "0531116781", "samar-alq@hotmail.com");
      techies.add(myInfo);


    return techies;
  }

  List<Widget> getMyInfo() {
    List<owner> techies = getUser();
    List<Widget> cards = [];
    for (owner techy in techies) {
      cards.add(ownerCard(techy));
    }
    return cards;
  }
  Map statusStyles = {
    'Cat' : statusCatStyle,
    'Dog' : statusDogStyle
  };
  Widget petCard(pet newPet) {
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 20),
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: Colors.white,

        ),
        child:
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: newPet.profilePic,
                  ),
                ),

              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                children: <Widget>[
                  Text("Pet Name:  ", style: petCardSubTitleStyle,),
                  Text(newPet.name, style: statusStyles[newPet.name])
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  Text("Pet Speceis:  ", style: petCardSubTitleStyle,),
                  Text(newPet.species, style: statusStyles[newPet.species])
                ],
              ),
            ),
          ],
        ));

  }
  Widget ownerCard(owner ownerInfo) {

    return Container(
        padding: EdgeInsets.all(20),
        width: 370,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: Colors.white,

        ),
        child:
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Row(
                children: <Widget>[
                  Text("first name:  ", style: petCardTitleStyle),
                  Text(ownerInfo.first_name, style: petCardTitleStyle)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  Text("last name:  ", style: petCardTitleStyle),
                  Text(ownerInfo.last_name, style: petCardTitleStyle)
                ],
              ),
            ),Container(
              margin: EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  Text("Mobile:  ", style: petCardTitleStyle),
                  Text(ownerInfo.phone, style: petCardTitleStyle)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  Text("email:  ", style: petCardTitleStyle),
                  Text(ownerInfo.email, style: petCardTitleStyle)
                ],
              ),
            ),

          ],
        ));

  }

}


