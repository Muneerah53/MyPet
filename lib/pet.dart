import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/global.dart';
import '/main.dart';

final  primaryColor = const Color(0xff313540);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Pet());
}
class Pet extends StatelessWidget {

  final Future<FirebaseApp> fbApp =  Firebase.initializeApp();


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
              return pet("");
            }
            else{return const Center(child:CircularProgressIndicator());}
          },
        )

    );
  }
}
class pet extends StatelessWidget {
  final String petID;
  pet(this.petID);


  @override
  Widget build(BuildContext context) {
    var primaryColor = const Color(0xff313540);

    return Scaffold(

      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.red[50],
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (_) =>Profile()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(

        children: <Widget>[ Center(child:

        Container(
          padding: EdgeInsets.only(bottom: 380,),
          width: 150,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('pets').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('loading');
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                  //card pets method
                  _buildPicCard(context, (snapshot.data!).docs[index]),
                );
              }
          ),
        ),


        ),

          Container(
            padding: EdgeInsets.only(top: 180, left: 20, right: 20),

            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('pets')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('loading');
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>
                    //card pets method
                    _buildPetCard(context, (snapshot.data!).docs[index]),
                  );
                }
            ),
          ),


          Container(
            padding: EdgeInsets.only(bottom: 350),
            child: Center(
              child: Text(
                'Pet Information',
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


  Widget _buildPetCard(BuildContext context, DocumentSnapshot document) {

    if (document['petId'] == petID)
      return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          child: Container(

            padding: EdgeInsets.only(left: 20, top: 90),

            width: 250,
            height: 500,

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

                    child: ListTile(
                      title: Text(
                          "name:  " + document['name'] + "\nspecies:  " +
                              document['species'] + "\ngender:  " +
                              document['gender'] + "\nbirth date:  " +
                              document['birthDate'] , style: petCardTitleStyle),

                    ),),

                  Container(
                    margin: EdgeInsets.only(left: 15,right: 15,bottom: 60),
                  ),


                  //Edit button
                    MaterialButton(

                      minWidth: 200,
                      height: 60,
                      padding: const EdgeInsets.all(20),
                      color: primaryColor,
                      textColor: Colors.white,
                      child: const Text('Edit'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () => showAlert(context,"Delete my pet",document)
                      ,

                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15,right: 15,bottom: 20),
                  ),

                  //delete button
            MaterialButton(

              minWidth: 200,
              height: 60,
              padding: const EdgeInsets.all(20),
              color: primaryColor,
              textColor: Colors.white,
              child: const Text('Delete'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onPressed: () => showAlert(context,"Delete my pet",document),


                  ),




                ]),),);
    else
      return Card();
  }

  Widget _buildPicCard(BuildContext context, DocumentSnapshot document) {
    String img = "";
    if (document['petId'] == petID) {
      if (document['species'] == "Dog")
        img = "images/dog.png";
      else
        img = "images/cat.jpeg";
      return CircleAvatar(

        radius: 80,
        backgroundImage: new AssetImage(img),

      );
    } else
      return Card();
  }

  Map statusStyles = {
    'Cat': statusCatStyle,
    'Dog': statusDogStyle
  };

  showAlert(BuildContext context,String message,DocumentSnapshot document) {
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                document.reference.delete().then((_) => print('Deleted'));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Pet deleted successfully"),
                backgroundColor:Colors.green,),);
                Navigator.push(context,MaterialPageRoute(builder: (_) =>Profile())) .catchError((error) => print('Delete failed: $error'));;
                //Put your code here which you want to execute on Yes button click.

              },
            ),


            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Pet has not been deleted "),
                  backgroundColor:Colors.orange,),);
                //Put your code here which you want to execute on Cancel button click.
                Navigator.push(context,MaterialPageRoute(builder: (_) =>Profile())) .catchError((error) => print('Delete failed: $error'));;

              },
            ),
          ],
        );
      },
    );
  }

}



