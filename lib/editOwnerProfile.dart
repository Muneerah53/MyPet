
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/global.dart';
import 'ownerProfile.dart';

User? user = FirebaseAuth.instance.currentUser;
DocumentReference owner = FirebaseFirestore.instance.collection('pet owners').doc(user?.uid);
DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user?.uid);

class editProfile extends StatelessWidget{
  final DocumentSnapshot owner;
  editProfile(this.owner);

  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  var primaryColor = const Color(0xff313540);

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
                  backgroundImage: new AssetImage("images/owner.png"),
                ),
              ),
            ],
          ),


          Container(

            padding: EdgeInsets.only(top: 220,left:20,right: 20),
            width: 500,height: 900,
            child:  ListView.builder(scrollDirection: Axis.vertical,
              itemCount: 1,
              itemBuilder: (context, index) =>

                  _buildOwnerCard(context, owner),
            ),

          ),



          Container(

            padding: EdgeInsets.only(bottom: 440),
            child: Center(
              child: Text(
                'Edit My Information',
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
                      hintText: owner['fname']
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
                      hintText: owner['lname']
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
                    hintText: owner['mobile'],
                  ),),),


              //Email
              Container(
                margin: EdgeInsets.only(top: 10),
                child: ListTile(
                  title: Text("Email:  ",style: petCardTitleStyle),

                ),
              ),  Container(
                margin: EdgeInsets.only(left: 15,right: 15,bottom: 20),
                child: TextFormField( controller: emailController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 17),
                    hintText: owner['email'],
                  ),),),


              //Edit button

              MaterialButton(
                minWidth: 200,
                height: 60,
                padding: const EdgeInsets.all(20),
                color: primaryColor,
                textColor: Colors.white,
                child: const Text('Edit my information'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: () async {
                  int change=0;
                  if( !fnameController.text.isEmpty){
                    owner.reference.update({'fname': fnameController.text});
                    change++;}
                  if( !lnameController.text.isEmpty) {document.reference.update({'lname': lnameController.text});
                  change++;}
                  if( !mobileController.text.isEmpty){
                    owner.reference.update({
                      'mobile': mobileController.text
                    });
                    change++;}
                  if( !emailController.text.isEmpty){
    await FirebaseAuth.instance.currentUser!.updateEmail(emailController.text);

                    owner.reference.update({
                      'email': emailController.text
                    });
                    userRef.update({
                      'email': emailController.text
                    });
                    change++;}

                  if(  change>0) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("your information is updated successfully "),
                      backgroundColor:Colors.green,),);

                    Navigator.push(context,MaterialPageRoute(builder: (_) =>Profile())) .catchError((error) => print('Delete failed: $error'));;
                  }
                  else  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please fill any of the fields"),
                    backgroundColor: Theme.of(context).errorColor,
                  )
                  );
                },),

              Container(
                margin: EdgeInsets.only(left: 15,right: 15,bottom: 20),
              ),

              //Edit button
              MaterialButton(

                minWidth: 200,
                height: 60,
                padding: const EdgeInsets.all(20),
                color: primaryColor,
                textColor: Colors.white,
                child: const Text('Cancel'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed:( ){


                  Navigator.push(context,MaterialPageRoute(builder: (_) =>Profile())) .catchError((error) => print('update failed: $error'));;

                },
              ),
            ],
          ),


        ),
      );


  }



}
