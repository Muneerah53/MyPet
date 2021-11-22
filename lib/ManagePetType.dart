import 'package:MyPet/PetType_add.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:MyPet/login.dart';
import 'PetType_view.dart';

class ManagePetType extends StatefulWidget {

  ManagePetType();

  State<ManagePetType> createState() => _ManagePetType();
}

class _ManagePetType extends State<ManagePetType> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4E3E3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            iconSize: 35.0,
            icon: Icon(
              Icons.logout,
              color: Color(0xFF2F3542),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut().catchError((error){
                print(error.toString());
              });
              Navigator.of(context,rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new  LoginPage()));
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        width: 120,
                        height: 110,
                        fit: BoxFit.fill,
                        image: new AssetImage('images/logo.jpeg'))
                  ],
                ),
                SizedBox(height: 50),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image(
                          width: 140.0,
                          height: 120.0,
                          fit: BoxFit.contain,
                          image: new AssetImage('images/image_2.png')),

                    ]

                ),

               // SizedBox(height: 30),
                Container(
                  width: 344,
                  height: 120,
                  child: ElevatedButton(
                      onPressed: () {
                      Navigator.pop(context);},
                      child: Text('Add Pet Types',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Color(0XFFFF6B81)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                      )),






                ),


                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  width: 344,
                  height: 120,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PetTypeList(
                                      title: 'Pet Types', type: 0)),
                        );
                      },

                      child: Text('View Pet Types',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Color(0XFF2F3542)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                      )),






                ),
                SizedBox(height: 50),
//
// )

              ],
            )),
      ),
    );
  }
}