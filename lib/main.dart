import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mypet/pet.dart';

import 'models/global.dart';
import 'pet.dart';
import 'editProfile.dart';
int myPets = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}
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
        ),
        home: FutureBuilder(
          future: fbApp,
          builder:(context,snapshot) {
            if (snapshot.hasError){
              print("An error has occured ${snapshot.error.toString()}");
              return const Text("Something went wrong");}
            else if (snapshot.hasData) {
              return Profile();
            }
            else{return const Center(child:CircularProgressIndicator());}
          },
        )


    );
  }
}
class Profile extends StatelessWidget {

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
                        padding: EdgeInsets.only(top: 180, bottom: 350,left:20,right: 20),
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
                    'profile information',
                    style: TextStyle(
                      fontSize: 30, color: Colors.blueGrey,
                      fontStyle: FontStyle.italic,),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),



              //Edit button
              Container(
                margin: EdgeInsets.only(top:420,left:250),
                width: 120, height:35,
                child: ElevatedButton(onPressed:( ){
                  Navigator.push(context,MaterialPageRoute(builder: (_) =>EditProfile())) .catchError((error) => print('Delete failed: $error'));;
                },
                  child:  Text("Edit", style: new TextStyle(  color: Colors.white),
                    textAlign: TextAlign.center,),
                  style: buttons,
                ),

              ),
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

              //add button
              Container(
                margin: EdgeInsets.only(top:500,left:355),
                width: 50, height:35,
                child: ElevatedButton(onPressed:(){},
                  child:  Text("+", style: new TextStyle(  color: Colors.white),
                    textAlign: TextAlign.center,),
                  style: buttons,
                ),

              ),


              //pest cards
              Container(
                margin: EdgeInsets.only(top: 550, bottom: 50,left:25),
                height: 300,
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


            ],
        ),
    );
  }


  Widget _buildOwnerCard(BuildContext context, DocumentSnapshot document ) {
  if (document['ownerID'].toString() == 'GApYHCG0gGYHp4D097maEgTnWQ92')
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(

          padding: EdgeInsets.only(left: 10,top:20),

          width: 250,height: 350,

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
                  margin: EdgeInsets.only(top: 10),
                  child: ListTile(
                    title: Text("First name:  "+document['fname']+"\nLast name:  "+document['lname']+"\nMobile:  "+document['mobile']+"\nEmail:  "+document['email'],style: petCardTitleStyle),

                  ),),
              ]),));
    else  return Card();

  }
   Widget _buildPetsCard(BuildContext context, DocumentSnapshot document ) {
    String img ="";

    if (document['userID'].toString()=='GApYHCG0gGYHp4D097maEgTnWQ92'){
      myPets--;
      if (document['species']=="Dog")
        img="images/dog.png";
      else
        img="images/cat.jpeg";

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
                 return pet(document['petID']);

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


