import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/owner.dart';
import 'models/pet.dart';
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

  String Fname = "unknown";
  String Lname = "unknown";
  String Mobile = "unknown";
  String userID = "unknown";
  String Email = "unknown";
  String Petname = "unknown";


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
              // Container(
              // margin: EdgeInsets.only(top: 60,left: 40),
              // child: CircleAvatar(
              // radius: 25, backgroundColor: Colors.white,
              //),
              //),
              //Container(
              // margin: EdgeInsets.only(top: 58,left: 37),
              //child: CircleAvatar(
              //radius: 25, backgroundColor: Colors.blueGrey[100],
              //),
              //),


              //owner container
              Container(
                  padding: EdgeInsets.only(top: 220, bottom: 350,left:30),
                  child:  Container(
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
                            margin: EdgeInsets.only(top: 18),
                            child: FutureBuilder(
                              future: getOwnerName(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState != ConnectionState.done)
                                  return Text("Loading data...Please wait");
                                return Text("first name:  $Fname",style: petCardTitleStyle);
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: FutureBuilder(
                              future: getOwnerName(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState != ConnectionState.done)
                                  return Text("Loading data...Please wait");
                                return Text("last name:  $Lname",style: petCardTitleStyle);
                              },
                            ),
                          ),Container(
                            margin: EdgeInsets.only(top: 15),
                            child: FutureBuilder(
                              future: getOwnerName(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState != ConnectionState.done)
                                  return Text("Loading data...Please wait");
                                return Text("mobile:  $Mobile",style: petCardTitleStyle);
                              },
                            ),),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child:FutureBuilder(
                              future: getOwnerName(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState != ConnectionState.done)
                                  return Text("Loading data...Please wait");
                                return Text("email:  $Email",style: petCardTitleStyle);
                              },
                            ),
                          ),

                        ],
                      ))),


              Container(
                padding: EdgeInsets.only(bottom: 450),
                child: Center(
                  child: Text(
                    'profile information',
                    style: TextStyle(
                      fontSize: 25, color: Colors.black87,
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
                    children: [ ElevatedButton(onPressed:(){},
                      child:  Text("Edit", style: new TextStyle(  color: Colors.white),
                        textAlign: TextAlign.center,),


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
              //scrollDirection: Axis.horizontal,
              Container(
                padding: EdgeInsets.only(top: 550, bottom: 50),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('pets').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('loading');
                      return ListView.builder(scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) =>
                            _buildListItem(context, (snapshot.data!).docs[index]),
                      );
                    })),

            ]));
  }
  List<pet> getPets() {
    List<pet> pets = [];
    //for (int i = 0; i < 2; i++) {
    AssetImage profilePic1 = new AssetImage("images/cat.jpeg");
    pet Pet1 = new pet("cloud", "Cat", profilePic1);
    pets.add(Pet1);
    AssetImage profilePic2 = new AssetImage("images/dog.png");
    pet Pet2 = new pet("Charly", "Dog", profilePic2);
    pets.add(Pet2);
    pet Pet3 = new pet("black", "Cat", profilePic1);
    pets.add(Pet3);
    // }
    return pets;
  }

  List<Widget> getMyPets() {
    List<pet> techies = getPets();
    List<Widget> cards = [];
    for (pet techy in techies) {
      cards.add(petCard(techy));
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
              margin: EdgeInsets.only(top: 20),
              child:
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('pets').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('loading');
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) =>
                          _buildListItem(context, (snapshot.data!).docs[index]),
                    );
                  })),
              //Row(
                //children: <Widget>[

                  //Text(newPet.name, style: petCardSubTitleStyle)
               // ],
           //   ),
            //),
           // Container(
            //  margin: EdgeInsets.only(top: 10),
            //  child: Row(
              //  children: <Widget>[
              //    Text(newPet.species, style: statusStyles[newPet.species])
              //  ],
            //  ),
           // ),
          ],
        ));

  }


  getOwnerName() async {

    var data = await FirebaseFirestore.instance.collection('pet owners').get();
    int index = 2;
    Fname = data.docs[index].data()['fname'].toString();
    Lname = data.docs[index].data()['lname'].toString();
    Mobile = data.docs[index].data()['mobile'].toString();
    userID = data.docs[index].data()['uid'].toString();

    data = await FirebaseFirestore.instance.collection('users').get();
    if(userID==data.docs[index].data()['uid'].toString())
      Email = data.docs[index].data()['email'].toString();
  }
  getOwnerPet() async {
    int index = 2;
    var data = await FirebaseFirestore.instance.collection('pet owners').get();

    userID = data.docs[index].data()['uid'].toString();
    var petdata = await FirebaseFirestore.instance.collection('pets').get();
    index = 0;
    data = await FirebaseFirestore.instance.collection('users').get();
    if(userID==petdata.docs[index].data()['userID'].toString())
      Petname = petdata.docs[index].data()['name'].toString();
  }
  getOwnerPets() async {
    int index = 1;
    StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pet owners').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('loading');
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
                _buildListItem(context, (snapshot.data!).docs[index]),
          );
        });
  }
   Widget _buildListItem(BuildContext context, DocumentSnapshot document ) {
     return Card(
         child: Container(
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
                           backgroundImage: new AssetImage("images/dog.png")),

                     ),

                   ],
                 ),
                 Container(
                   margin: EdgeInsets.only(top: 20),
                   child: ListTile(
                     title: Text(document['name']),

                   ),),
               ]),));
   }

  }


