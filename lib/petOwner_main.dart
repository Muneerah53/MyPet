import 'package:flutter/material.dart';
import 'package:mypet/Appointment.dart';
import 'package:mypet/Mypets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'OwnerProfile.dart';
import 'login.dart';

class ownerPage extends StatefulWidget {
  const ownerPage({Key? key}) : super(key: key);

  @override
  _PetPageState createState() => _PetPageState();
}

class _PetPageState extends State<ownerPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                iconSize: 35.0,
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().catchError((error){
                    print(error.toString());
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ],
          ),
          backgroundColor: Color(0xFFF4E3E3),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        width: 150.0,
                        height: 137.0,
                        fit: BoxFit.fill,
                        image: new AssetImage('images/image_1.png'))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(
                        width: 140.0,
                        height: 120.0,
                        fit: BoxFit.contain,
                        image: new AssetImage('images/image_2.png'))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              elevation: 4.0,
                              child: new InkWell(
                                 onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Mypets()),
                                  );
                                },
                                child: Container(
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(16.0),
                                    color: Color(0xFF2F3542),
                                  ),
                                  width: 180,
                                  height: 180,
                                  child: Center(
                                      child: Text(
                                        'My Pets',
                                        style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26.0),
                                      )),
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              elevation: 4.0,
                              child: new InkWell(
                                 onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => appointmentPage()),
                                  );
                                },
                                child: Container(
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(16.0),
                                    color: Color(0xFFFF6B81),
                                  ),
                                  width: 180,
                                  height: 180,
                                  child: Center(
                                      child: Text(
                                        'Appointment',
                                        style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26.0),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              elevation: 4.0,
                              child: new InkWell(
                                /* onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => nPage()),
                                  );
                                },*/
                                child: Container(
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(16.0),
                                    color: Color(0xFFFF6B81),
                                  ),
                                  width: 180,
                                  height: 180,
                                  child: Center(
                                      child: Text(
                                        'About Us',
                                        style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26.0),
                                      )),
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              elevation: 4.0,
                              child: new InkWell(
                             onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Profile()),
                                  );
                                },
                                child: Container(
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(16.0),
                                    color: Color(0xFF2F3542),
                                  ),
                                  width: 180,
                                  height: 180,
                                  child: Center(
                                      child: Text(
                                        'View Profile',
                                        style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26.0),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        width: 210.0,
                        height: 120.0,
                        fit: BoxFit.contain,
                        image: new AssetImage('images/image_3.png'))
                  ],
                ),
              ],
            ),
          )),
    );
  }
}