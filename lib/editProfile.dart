//Navigator.push(context,MaterialPageRoute(builder: (_) =>Profile())) .catchError((error) => print('Delete failed: $error'));;
//title: Text('Edit your information'), content:
//TextField(
//controller: customController,
//decoration: InputDecoration(

//hintText: 'first Name',
//),

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mypet/pet.dart';

import 'models/global.dart';
import 'main.dart';

int myPets = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(EditProfile());
}
class EditProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.red[50],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body:Stack(

        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: new AssetImage("images/owner.jpg"),
                ),
              ),
            ],
          ),


          Container(
            padding: EdgeInsets.only(top: 180,left:20,right: 20),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('pet owners').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('loading');
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>
                    //card pets method
                    _buildOwnerCard(context, (snapshot.data!).docs[index]),
                  );
                }
            ),
          ),



          Container(
            padding: EdgeInsets.only(bottom: 440),
            child: Center(
              child: Text(
                'Edit my information',
                style: TextStyle(
                  fontSize: 30, color: Colors.blueGrey,
                  fontStyle: FontStyle.italic,),
                textAlign: TextAlign.center,
              ),
            ),
          ),








        ],
      ),
    );
  }


  Widget _buildOwnerCard(BuildContext context, DocumentSnapshot document ) {
    if (document['ownerID'].toString() == 'GApYHCG0gGYHp4D097maEgTnWQ92')
      return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(

            padding: EdgeInsets.only(left: 10,top:10),

            width: 250,height: 550,

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

                  //first name
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListTile(
                      title: Text("First name:  "
                        ,style: petCardTitleStyle),

                    ),
                  ),
                  Container(
            margin: EdgeInsets.only(left: 15,right: 15),
                      child: TextFormField(   initialValue: document['fname']
                    ),),

                  //last name
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListTile(
                      title: Text("Last name:  ",style: petCardTitleStyle),

                    ),
                  ),  Container(
                    margin: EdgeInsets.only(left: 15,right: 15),
              child: TextFormField(   initialValue: document['lname']
                    ),),

                  //Mobile
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListTile(
                      title: Text("Mobile:  ",style: petCardTitleStyle),

                    ),
                  ),  Container(
                    margin: EdgeInsets.only(left: 15,right: 15),
              child: TextFormField(   initialValue: document['mobile']
                    ),),


                  //Email
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListTile(
                      title: Text("Email:  ",style: petCardTitleStyle),

                    ),
                  ),  Container(
                    margin: EdgeInsets.only(left: 15,right: 15),
                    child: TextFormField(   initialValue: document['email'],
                    ),),


                  //Edit button
                  Container(
                    margin: EdgeInsets.only(top: 25,right: 10),
                    width: 120, height:35,
                    child: ElevatedButton(onPressed:( ){
                      Navigator.push(context,MaterialPageRoute(builder: (_) =>Profile())) .catchError((error) => print('Delete failed: $error'));;
                    },
                      child:  Text("Edit", style: new TextStyle(  color: Colors.white),
                        textAlign: TextAlign.center,),
                      style: buttons,
                    ),

                  ),
                ]),));
    else  return Card();

  }



}


