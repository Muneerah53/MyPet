import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';




void main(){
  WidgetsFlutterBinding.ensureInitialized();
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
    return Scaffold(backgroundColor: Colors.red[50],

      body:  Center(
          child: Column(children: <Widget>[

            Container(
              margin: EdgeInsets.fromLTRB(50, 40, 50, 30),
              width: 140,
              height: 170,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage('images/logo.jpeg')
                  )
                  )
                  ),
            Image.asset(
              'images/dog2.png',
              height: 250,
              width: 350,
            ),
            SizedBox(height: 40),
            Text("Hi there would you like start a journey in Mypet app ?  " ,textAlign: TextAlign.center, style: new TextStyle(
              fontSize: 20.0,
              color: Colors.blueGrey,)),



          ])),
    );


  }
}
