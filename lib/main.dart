import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/global.dart';



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
              return Home();
            }
            else{return const Center(child:CircularProgressIndicator());}
          },
        )


    );
  }
}
class Home extends StatelessWidget {

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

              Container(
                padding: EdgeInsets.only(bottom: 750),
                child: Center(
                  child: Text(
                    'My Pets',
                    style: TextStyle(
                      fontSize: 30, color: Colors.blueGrey,
                      fontStyle: FontStyle.italic,),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

 Container(//add


   padding: EdgeInsets.all(10),
    margin: EdgeInsets.only(left: 30,right:20,top:90,bottom: 10),
    width: 365,height: 200,

    //i dont know why this cammand does not work
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.blueGrey,),
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
    backgroundImage:new AssetImage('images/Add.png')),

    ),

    ],
    ),

    Container(

    child:  ListTile(
    title: Text('Add new pet', style: TextStyle(
      fontSize: 25, color: Colors.white,
      fontStyle: FontStyle.italic,), textAlign: TextAlign.center),

    ),),],),),


      //pest cards
              Container(
                padding: EdgeInsets.only(top: 300,left:25,right:25),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('pets').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('loading');
                      return ListView.builder(scrollDirection: Axis.vertical,
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


   Widget _buildPetsCard(BuildContext context, DocumentSnapshot document ) {

    //profile pic based on pet's species
    String img ="";
    if (document['userID'].toString() == 'GApYHCG0gGYHp4D097maEgTnWQ92'){
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
                       margin: EdgeInsets.only(top: 20),
                       child: CircleAvatar(
                           radius: 50,
                           backgroundImage:new AssetImage(img)),

                     ),

                   ],
                 ),
                 Container(
                   margin: EdgeInsets.only(top: 20,bottom: 20),
                   child: Text(document['name'],style: statusStyles[document['species']],
                     textAlign: TextAlign.center)
                   ),
               ]),));
   }else
    return Card();}
  Map statusStyles = {
    'Cat' : statusCatStyle,
    'Dog' : statusDogStyle
  };
  }


