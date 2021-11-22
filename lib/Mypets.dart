import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/global.dart';
import 'models/data.dart';
import 'petProfile.dart';
import 'addPet.dart';

GlobalKey _globalKey = navKeys.globalKey;
int pets=0;
class Mypets extends StatelessWidget {

  final Future<FirebaseApp> fbApp =  Firebase.initializeApp();
  Mypets({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.pink,
        ),
        home: FutureBuilder(
          future: fbApp,
          builder:(context,snapshot) {
            if (snapshot.hasError){
              print("An error has occured ${snapshot.error.toString()}");
              return const Text("Something went wrong");}
            else if (snapshot.hasData) {
              return MyPets();
            }
            else{return const Center(child:CircularProgressIndicator());}
          },
        )


    );
  }
}
class MyPets extends StatelessWidget {
  fbHelper fb = fbHelper();
  var primaryColor = const Color(0xff313540);
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
              style: backButton ),// <-- Button color// <-- Splash color

      ),
      body:SingleChildScrollView(
        child:  Column(
    children: [
    Container(
            child: Center(
              child: Text(
                'My Pets', style: TextStyle(
                    color: Color(0xffe57285),
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            ),
          ),

    GestureDetector(

    onTap:() {
    Navigator.push(context,MaterialPageRoute(builder: (_) =>addPet(fb.getuser()))) .catchError((error) => print('Delete failed: $error'));

    },
    child:Container(//add
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 25,right:25,top:10),
            width: 365,height: 200,

            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: primaryColor,),
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
                        backgroundImage:new AssetImage('images/Add.png'),

                      ),

                    ),

                  ],
                ),

                Container(

                  child:  ListTile(
                      title: Text('Add new pet', style: TextStyle(
                        fontSize: 25, color: Colors.white,
                        fontStyle: FontStyle.italic,), textAlign: TextAlign.center),

                  ),),],),
    )
          ),


          //pest cards
          Container(

            padding: EdgeInsets.only(left:25,right:25,top: 10,bottom: 50),
            height: 530,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("pets")
                    .where('ownerId', isEqualTo: (fb.getuser()))
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
                  return ListView.builder(scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>
                    //card pets method
                    _buildPetsCard(context, (snapshot.data!).docs[index]),
                  );
                }
            ),
          ),
            Container(
            padding: EdgeInsets.only(left:25,right:25,top: 10),
    height: 530,
    child: Text(msg(),
    style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.grey),
    textAlign: TextAlign.center)
    ),
        ],
      ),
    ),);
  }


  Widget _buildPetsCard(BuildContext context, DocumentSnapshot document ) {

    //profile pic based on pet's species
    String img ="";
    if (document['ownerId'].toString() == fb.getuser()){
      pets++;
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



      return GestureDetector(
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder:(context) {
              return pet(document['petId']);

            } ));},
          child: Card(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child:
        Container(
          margin: EdgeInsets.only(left: 25,right:25),

            color: Colors.white,

          child:
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: CircleAvatar(
                        radius: 50,
                        backgroundImage:new AssetImage(img)),

                  ),

                ],
              ),
              Container(

                child:ListTile(
                    title: Text(document['name'],style: PetStyle,
                        textAlign: TextAlign.center),
              ),
              ),],
          ),
        ),));

    }else
      return Card();}

}

String msg(){
  if (true)
 return 'You haven\'t added Any Pets!';
  else
    return '';
}

