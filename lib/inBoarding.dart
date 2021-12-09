import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'models/global.dart';
import 'models/data.dart';
import 'petProfile.dart';
import 'addPet.dart';

GlobalKey _globalKey = navKeys.globalKeyAdmin;
int pets=0;

class inHousePets extends StatelessWidget {
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
                    'in- House Pets', style: TextStyle(
                    color: Color(0xffe57285),
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
              ),
            ),


            //pest cards
            Container(

              padding: EdgeInsets.only(left:25,right:25,top: 10,bottom: 50),
              height: 530,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("boarding")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('loading');
                    if (snapshot.data!.docs.isEmpty)
                      return    Container(
                          padding: EdgeInsets.only(left:25,right:25,top: 10),
                          height: 100,
                          child: Text('No in House pets',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey),
                              textAlign: TextAlign.center)
                      );


                    return ListView.builder(scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = (snapshot.data!).docs[index];
                        DateTime startDate = new DateFormat(
                            "EEE, MMM dd yyyy").parse(doc['startDate']);
                        DateTime endDate = new DateFormat("EEE, MMM dd yyyy")
                            .parse(doc['endDate']);
                        DateTime today = DateTime(DateTime
                            .now()
                            .year, DateTime
                            .now()
                            .month, DateTime
                            .now()
                            .day);
                        print('Today: $today Start: $startDate End: $endDate');
                        if ((today.isAfter(startDate) &&
                            today.isBefore(endDate))||
                            (today.isAtSameMomentAs(startDate) ||
                                today.isAtSameMomentAs(endDate)))
                          return// _buildPetsCard(context, doc['petID']);
                        StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("pets")
                            .where('petId', isEqualTo: doc['petID'])
                            .snapshots(),
                        builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Text('loading');
                        if (snapshot.data!.docs.isEmpty)
                        return    Container(
                        padding: EdgeInsets.only(left:25,right:25,top: 10),
                        height: 100,
                        child: Text('No found pets',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey),
                        textAlign: TextAlign.center)
                        );
                        try{
                          _buildPetsCard(context, (snapshot.data!).docs[0]);
                         print(snapshot.data!.docs.single['petId']);
                        }

                        catch(StateError){}
                        return Text('');

                        }
                        );

                        return Text('');
                        //card pets method
                        //    },
                      });

                  }
              ),
            ),

          ],
        ),
      ),);
  }


  Widget _buildPetsCard(BuildContext context, DocumentSnapshot document ) {




    //profile pic based on pet's species
    String img ="";

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
        img = "images/logo4.png";

      String? url;
      Map<String, dynamic> dataMap = document.data() as Map<String, dynamic>;

      if(dataMap.containsKey('img'))
        url = document['img']['imgURL'];
      else
        url = null;




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
                            backgroundImage: url == null ? new AssetImage(img) : Image.network(url).image),

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

}

}

String msg(){
  if (true)
    return 'You haven\'t added Any Pets!';
  else
    return '';
}

