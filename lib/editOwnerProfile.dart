import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/global.dart';
import 'ownerProfile.dart';

final validCharacters = RegExp(r'^[a-zA-Z]');

User? user = FirebaseAuth.instance.currentUser;
DocumentReference owner =
FirebaseFirestore.instance.collection('pet owners').doc(user?.uid);
DocumentReference userRef =
FirebaseFirestore.instance.collection('users').doc(user?.uid);

class editProfile extends StatelessWidget {
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
            style: backButton), // <-- Button color// <-- Splash color
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 5),
                    width: 120,
                    height: 110,
                    child:

                    //card pets method
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: new AssetImage(
                          owner['gender'] == "Female"
                              ? "images/owner.png"
                              : "images/maleProfile.jpg"),
                    )),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Edit My Information',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blueGrey,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              width: 500,
              height: 680,
              child: _buildOwnerCard(context, owner),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerCard(BuildContext context, DocumentSnapshot document) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10),

        width: 250,
        height: 640,

        //i dont know why this cammand does not work
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),

            //first name
            Container(
              margin: EdgeInsets.only(top: 10),
              child: ListTile(
                title: Text("First name:  ", style: petCardTitleStyle),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                controller: fnameController,
                decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 17),
                    hintText: owner['fname']),
              ),
            ),

            //last name
            Container(
              margin: EdgeInsets.only(top: 10),
              child: ListTile(
                title: Text("Last name:  ", style: petCardTitleStyle),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                controller: lnameController,
                decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 17),
                    hintText: owner['lname']),
              ),
            ),

            //Mobile
            Container(
              margin: EdgeInsets.only(top: 10),
              child: ListTile(
                title: Text("Phone number:  ", style: petCardTitleStyle),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                controller: mobileController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 17),
                  hintText: owner['mobile'],
                ),
              ),
            ),

            //Email
            Container(
              margin: EdgeInsets.only(top: 10),
              child: ListTile(
                title: Text("Email:  ", style: petCardTitleStyle),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 17),
                  hintText: owner['email'],
                ),
              ),
            ),

            //Edit button

            FlatButton(
              minWidth: 200,
              height: 60,
              padding: const EdgeInsets.all(20),
              color: greenColor,
              textColor: primaryColor,
              child: const Text(
                'Edit My Information',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onPressed: () async {
                int change = 0;
                int emailError = 0;
                int phoneError = 0;
                int fnameError = 0;
                int lnameError = 0;

                if (!fnameController.text.isEmpty) {
                  if (!validCharacters.hasMatch(fnameController.text)) {
                    fnameError++;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("first name must contain only characters"),
                      backgroundColor: Theme.of(context).errorColor,
                    ));
                  } else {
                    owner.reference.update({
                      'fname': fnameController.text[0].toUpperCase() +
                          fnameController.text.substring(1)
                    });
                    change++;
                  }
                }

                if (!lnameController.text.isEmpty) {
                  if (!validCharacters.hasMatch(lnameController.text)) {
                    lnameError++;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("last name must contain only characters"),
                      backgroundColor: Theme.of(context).errorColor,
                    ));
                  } else {
                    document.reference.update({
                      'lname': lnameController.text[0].toUpperCase() +
                          lnameController.text.substring(1)
                    });
                    change++;
                  }
                }
                if (!mobileController.text.isEmpty) {
                  if (mobileController.text.length != 10) {
                    phoneError++;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("phone number must be 10 digits"),
                      backgroundColor: Theme.of(context).errorColor,
                    ));
                    phoneError++;
                  } else if (!isNumeric(mobileController.text)) {
                    phoneError++;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("phone number must be numeric"),
                      backgroundColor: Theme.of(context).errorColor,
                    ));
                  } else if (!(mobileController.text.startsWith('05'))) {
                    phoneError++;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                      Text("Invalid phone number format (ex.05########)"),
                      backgroundColor: Theme.of(context).errorColor,
                    ));
                  } else {
                    owner.reference.update({'mobile': mobileController.text});
                    change++;
                  }
                }
                if (!emailController.text.isEmpty) {
                  if (!EmailValidator.validate(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please enter a valid email"),
                      backgroundColor: Theme.of(context).errorColor,
                    ));
                    emailError++;
                  } else {
                    try {
                      await FirebaseAuth.instance.currentUser!
                          .updateEmail(emailController.text);

                      owner.reference.update({'email': emailController.text});
                      userRef.update({'email': emailController.text});
                      change++;
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'The account already exists for that email.'),
                            backgroundColor: Theme.of(context).errorColor,
                          ),
                        );
                        emailError++;
                      }
                    }
                  }
                }

                if (change > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text("your information is updated successfully "),
                      backgroundColor: Colors.green,
                    ),
                  );

                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Profile()))
                      .catchError((error) => print('Delete failed: $error'));
                  ;
                } else if ((emailError == 0) &
                (change == 0) &
                (phoneError == 0) &
                (fnameError == 0) &
                (lnameError == 0))
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please fill any of the fields"),
                    backgroundColor: Theme.of(context).errorColor,
                  ));
              },
            ),

            Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
            ),

            //Edit button
            FlatButton(
              minWidth: 200,
              height: 60,
              padding: const EdgeInsets.all(20),
              color: redColor,
              textColor: primaryColor,
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Profile()))
                    .catchError((error) => print('update failed: $error'));
                ;
              },
            )
          ],
        ),
      ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  DocumentReference getuser() {
    User? user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance.collection('pet owners').doc(user?.uid);
  }
}
//;