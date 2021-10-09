import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'petOwner_main.dart';

import 'models/global.dart';
import 'petProfile_ownerProfile.dart';
import 'editOwnerProfile.dart';
import 'addPet.dart';

User? user = FirebaseAuth.instance.currentUser;
String owner = FirebaseFirestore.instance.collection('pet owners').doc(user?.uid).id;

int myPets = 0;

class Profile extends StatelessWidget {
  String ownerID="";
  GlobalKey _globalKey = navKeys.globalKey;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF4E3E3),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation:0,
          leading: ElevatedButton(
            onPressed: () {
              BottomNavigationBar navigationBar =  _globalKey.currentWidget as BottomNavigationBar;
              navigationBar.onTap!(0);
            },
            child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
            style: backButton ),
      ),
      body:SingleChildScrollView(

        child:  Column(
          children: [ Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: new AssetImage("images/owner.png"),
                ),
              ),
            ],
          ),

            Container(
              margin: EdgeInsets.only(top: 5),
              child: Center(
                child: Text(
                  'Profile Information',
                  style: TextStyle(
                    fontSize: 30, color: Colors.blueGrey,
                    fontStyle: FontStyle.italic,),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
 Container(
            padding: EdgeInsets.only(left:20,right: 20),
            height:300,
            child: StreamBuilder<QuerySnapshot>(
 stream: FirebaseFirestore.instance.collection('pet owners').where('ownerID', isEqualTo: owner.toString()).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('loading');
            return
              //card pets method
              _buildOwnerCard(context, (snapshot.data!).docs[0]);

          }
      ),
          ),




          Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only( left:30),
                  child: Text(
                    'My Pets',
                    style: TextStyle(
                        fontSize: 30, color: Colors.black87,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left:  MediaQuery.of(context).size.width * 0.45,),
                  child:
                  //Add button
                  MaterialButton(
                    minWidth: 50,
                    height: 25,
                    padding: const EdgeInsets.all(5),
                    color: primaryColor,
                    textColor: Colors.white,
                    child: const Text('+', style: TextStyle(
                      fontSize: 28, ),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),onPressed:(){
                 //   Navigator.push(context,MaterialPageRoute(builder: (_) =>addPet(ownerID))) .catchError((error) => print('Delete failed: $error'));;
                  },



                  ),),]),

          //pest cards
          Container(

            height: 260,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('pets').snapshots(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('loading');
                  return ListView.builder(scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>

                    //card pets method
                    _buildPetsCard(context, (snapshot.data!).docs[index]),
                  );
                }
            ),
          ),


    ],  ),
    ),);
  }


  Widget _buildOwnerCard(BuildContext context, DocumentSnapshot document ) {

    if (document['ownerID'].toString() == owner.toString()){
      ownerID = document['ownerID'].toString();
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(

          padding: EdgeInsets.only(left: 10, top: 5),

          width: 290,
          height: 220,

          //i dont know why this cammand does not work
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
                 // margin: EdgeInsets.only(top: 10),
                  child: ListTile(
                    title: Text(
                        "First name:  " + document['fname'] + "\nLast name:  " +
                            document['lname'] + "\nMobile:  " +
                            document['mobile'] + "\nEmail:  " + document['email'],
                        style: petCardTitleStyle),

                  ),),

                //Edit button
                Container(
                  margin: EdgeInsets.only(left: 15,right: 15,bottom: 10),
                ),


                //Edit button
                MaterialButton(

                  minWidth: 130,
                  height: 25,
                  padding: const EdgeInsets.all(10),
                  color: primaryColor,
                  textColor: Colors.white,
                  child: const Text('Edit'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => editProfile(document)))
                        .catchError((error) => print('Delete failed: $error'));
                    ;
                  },
                ),
              ]),),);
    }   else  return Card();

  }
  Widget _buildPetsCard(BuildContext context, DocumentSnapshot document ) {
    String img ="";

    if (document['ownerId'].toString()==owner.toString()){
      myPets--;
      if (document['species']=="Dog")
        img="images/dog.png";
      else
        img="images/cat.png";

      return Card(

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),

          child: Container(

            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 20,right:20),
            width: 160,

            //i dont know why this cammand does not work
            decoration: BoxDecoration(
              color: Colors.white,

            ),
            child:
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(

                      margin: EdgeInsets.only(top: 20),
                      child: CircleAvatar(
                          radius: 50,
                          backgroundImage:new AssetImage(img)),


                    ),

                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ListTile(
                      title: Text("  "+document['name'],style: statusStyles[document['species']]),
                      onTap: (){

                        Navigator.push(context,MaterialPageRoute(builder:(context) {
                          return pet(document['petId']);

                        } ));}),
                ),],
            ),));
    }
    else return Card();
  }
  Map statusStyles = {
    'Cat' : statusCatStyle,
    'Dog' : statusDogStyle
  };

}
