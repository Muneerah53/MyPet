
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/global.dart';
import 'main.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(editProfile());
}
class editProfile extends StatelessWidget{

  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();

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

            width: 250,height: 640,

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
                      child: TextFormField(    controller: fnameController,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 17),
                            hintText: document['fname']
                    ),),),

                  //last name
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListTile(
                      title: Text("Last name:  ",style: petCardTitleStyle),

                    ),
                  ),  Container(
                    margin: EdgeInsets.only(left: 15,right: 15),
              child: TextFormField(  controller: lnameController,
                decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 17),
                    hintText: document['lname']
                    ),),),

                  //Mobile
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListTile(
                      title: Text("Mobile:  ",style: petCardTitleStyle),

                    ),
                  ),  Container(
                    margin: EdgeInsets.only(left: 15,right: 15),
              child: TextFormField(    controller: mobileController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 17),
                  hintText: document['mobile'],
                    ),),),


                  //Email
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListTile(
                      title: Text("Email:  ",style: petCardTitleStyle),

                    ),
                  ),  Container(
                    margin: EdgeInsets.only(left: 15,right: 15),
                    child: TextFormField( controller: emailController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 17),
                        hintText: document['email'],
                    ),),),


                  //Edit button
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    width: 300, height: 50,
                    child: ElevatedButton(
    child:  Text("Edit", style: new TextStyle(  color: Colors.white),
    textAlign: TextAlign.center,),
    style: buttons,
    onPressed:( ){
      int change=0;
      if( !fnameController.text.isEmpty){
      document.reference.update({'fname': fnameController.text});
      change++;}
      if( !lnameController.text.isEmpty) {document.reference.update({'lname': lnameController.text});
      change++;}
      if( !mobileController.text.isEmpty){
        document.reference.update({
          'mobile': mobileController.text
        });
    change++;}
      if( !emailController.text.isEmpty){
        document.reference.update({
          'email': emailController.text
        });
        change++;}

if(  change>0)
    showDialog(
    context: context,
    builder: (context) {
                      return AlertDialog(
                        // Retrieve the text the that user has entered by using the
                        // TextEditingController.
                        content: Text('your information is updated'),
                          actions: <Widget>[
                      FlatButton(
                      child: Text("Okay"),
      onPressed: () {
      Navigator.push(context,MaterialPageRoute(builder: (_) =>Profile())) .catchError((error) => print('update failed: $error'));;

      },

      ),  ],
                      );},);
                      else showDialog(
    context: context,
    builder: (context) {
    return AlertDialog(
    // Retrieve the text the that user has entered by using the
    // TextEditingController.
    content: Text('there is no change'),
    actions: <Widget>[
    FlatButton(
    child: Text("Okay"),
    onPressed: () {
    Navigator.push(context,MaterialPageRoute(builder: (_) =>Profile())) .catchError((error) => print('update failed: $error'));;

    },

    ),  ],
    );
                    },);},


                  ),
                ),

                  //Edit button
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    width: 300, height: 50,
                    child: ElevatedButton(
                      child:  Text("Cancel", style: new TextStyle(  color: Colors.white),
                        textAlign: TextAlign.center,),
                      style: buttons,
                      onPressed:( ){


    Navigator.push(context,MaterialPageRoute(builder: (_) =>Profile())) .catchError((error) => print('update failed: $error'));;

    },
                                ),),
                            ],
                         ),


                    ),
      );
    else  return Card();

  }



}


