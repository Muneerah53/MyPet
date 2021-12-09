import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ownerProfile.dart';
import 'models/global.dart';
import 'edit_pet_profile.dart';

GlobalKey _globalKey = navKeys.globalKey;
int pets=0;
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

          primarySwatch: Colors.pink,
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
    GlobalKey _globalKey = navKeys.globalKey;
    return Scaffold(

      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF4E3E3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: ElevatedButton(
            onPressed: () {
              //BottomNavigationBar navigationBar =  _globalKey.currentWidget as BottomNavigationBar;
              //navigationBar.onTap!(3);
              Navigator.of(context).pop();
            },

            child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
            style: backButton ),// <-- Button color// <-- Splash color

      ),


      body: Stack(


        children: <Widget>[
          Container(
         //  padding: EdgeInsets.only(bottom: 380,),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('pets').where("petId",isEqualTo: petID ).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('loading');
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>
                    //card pets method
                    _buildPicCard(context, (snapshot.data!).docs[index]),
                  );
                }
            ),
            ),


          Container(
            padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.1,top: 180, right: 35),
            height: 1000,

            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('pets').where("petId",isEqualTo: petID ).snapshots(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('loading');
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>
                    //card pets method
                    _buildPetCard(context, (snapshot.data!).docs[index]),
                  );
                }
            ),

          ),

            ], ),);
  }

  Widget _buildPetCard(BuildContext context, DocumentSnapshot document) {

      return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
        child: Container(

          padding: EdgeInsets.only(left: 20),
          width: 250,
          height: 380,

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
                        "\nName:  " + document['name'] + "\nSpecies:  " +
                            document['species'] + "\nGender:  " +
                            document['gender'] + "\nBirth date:  " +
                            document['birthDate'] , style: petCardTitleStyle),

                  ),),


                Container(
                  margin: EdgeInsets.only(left: 15,right: 15,bottom: 40),
                ),


                //Edit button
                FlatButton(

                  minWidth: 200,
                  height: 60,
                  padding: const EdgeInsets.all(20),
                  color: greenColor,
                  textColor: primaryColor,
                  child: const Text('Edit',style: TextStyle( fontSize: 18)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: (){

                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => editPet(document)))
                        .catchError((error) => print('Delete failed: $error'));
                  }
                  ,

                ),
                Container(
                  margin: EdgeInsets.only(left: 15,right: 15,bottom: 20),
                ),

                //delete button
                FlatButton(

                  minWidth: 200,
                  height: 60,
                  padding: const EdgeInsets.all(20),
                  color: redColor,
                  textColor: primaryColor,
                  child: const Text('Delete',style: TextStyle( fontSize: 18)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () => showAlert(context,"Delete my pet",document),


                ),




              ]),),);

  }

  Widget _buildPicCard(BuildContext context, DocumentSnapshot document) {
    String img = "";
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
      img = "images/logo4.png";


    String? url;
    Map<String, dynamic> dataMap = document.data() as Map<String, dynamic>;

    if(dataMap.containsKey('img'))
      url = document['img']['imgURL'];
    else
      url = null;


    return Column(

          children: <Widget>[

            Container(
              margin: EdgeInsets.only(top: 5),
              width: 120,
              height: 110,
              child:    CircleAvatar(
    backgroundImage: url == null ? new AssetImage(img) : Image.network(url).image),
             ),
            Container(
              padding: EdgeInsets.only(bottom: 350),

              child: Text(
                'Pet Information',
                style: TextStyle(
                  fontSize: 30, color: Colors.blueGrey,
                  fontStyle: FontStyle.italic,),
                textAlign: TextAlign.left,
              ),

            ),
          ]
      );

  }



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
    onPressed: () async {
    FirebaseFirestore firestoreInstance= FirebaseFirestore.instance;

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestoreInstance
        .collection('appointment')
        .where('petID', isEqualTo: document.id)
        .get();

    if(snapshot.docs.length==0){
    document.reference.delete().then((_) {
    Navigator.pop(context, true);
    });}
    else{ Navigator.pop(context, false); }
    }),


            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {

                //Put your code here which you want to execute on Cancel button click.
                Navigator.pop(context, false);

              },
            ),
          ],
        );
      },
    ).then((exit) {
      if (exit == null) return;

      if (exit) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Pet deleted successfully"),
          backgroundColor:Colors.green,),);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Pet has not been deleted "),
          backgroundColor:Colors.orange,),);
      }
    },
    );
  }

}
