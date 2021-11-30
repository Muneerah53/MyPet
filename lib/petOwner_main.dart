import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'appointment/appointment_list.dart';
import 'appointment_main.dart';
import 'login.dart';
import 'package:MyPet/models/global.dart';
import 'models/notifaction_service.dart';


GlobalKey _globalKey = navKeys.globalKey;
class ownerPage extends StatefulWidget {
  const ownerPage({Key? key}) : super(key: key);
  @override
  _PetPageState createState() => _PetPageState();
}
class _PetPageState extends State<ownerPage> {
@override
  void initState() {
    super.initState();
    NotificationService.init();
  }
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
          backgroundColor: Color(0xFFF4E3E3),
          body: SingleChildScrollView(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 120,
                        height: 110,

                          child:  Image(
                        width: 120,
                        height: 110,
                        fit: BoxFit.fill,
                        image: new AssetImage('images/logo.jpeg')),

                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top:30),
                    )
                  ],
                ),
                


                Row(
                 //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Container(
                    //
                    //   //margin: EdgeInsets.only(right: 50 , left: 30),
                    //   height:80,
                    //   width:190 ,
                    //   child: StreamBuilder<QuerySnapshot>(
                    //       stream: FirebaseFirestore.instance.collection('pet owners').where('ownerID', isEqualTo: getuser()).snapshots(),
                    //       builder: (context, snapshot) {
                    //         if (!snapshot.hasData) return const Text('loading');
                    //         return Text("Hi " + (snapshot.data!).docs[0]['fname'].toString()
                    //             ,textAlign: TextAlign.center,
                    //             softWrap: true ,
                    //             style: new TextStyle(
                    //               fontSize: 30.0,
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.blueGrey,)
                    //         );
                    //
                    //
                    //       }
                    //   ),
                    // ),
                    Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Container(
                      child:Image(
                        width: 140.0,
                        height: 120.0,
                        fit: BoxFit.contain,
                        image: new AssetImage('images/image_2.png')),
                    )
                   ]

                    ),

                  ],

                ),
                /*Column(
                      children: <Widget>[ Container(
                        margin: EdgeInsets.only(left: 30),
                        child:
                        Text(
                          'Welcome',
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 35,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold),
                        ),

                      ),],),*/



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
                                  // BottomNavigationBar navigationBar =  _globalKey.currentWidget as BottomNavigationBar;
                                  //  navigationBar.onTap!(1);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AppoinMain()),);
                                },
                                child: Container(
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(16.0),
                                    color: Color(0xFF2F3542),
                                  ),
                                  width:  MediaQuery.of(context).size.width * 0.90,
                                  height: 110,
                                  child: Center(
                                      child: Text(
                                        'Appointment Booking',
                                        style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      )),
                                ),
                              ),
                            ),],),
                Container(
                  padding: EdgeInsets.only( top: 20),

                ),
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
                                  // BottomNavigationBar navigationBar =  _globalKey.currentWidget as BottomNavigationBar;
                                  // navigationBar.onTap!(2);

                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (BuildContext context) =>
                                             AppointmentList(
                                                 title: 'Upcoming Appointment', type: 0)),
                                   );                                },
                                child: Container(
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(16.0),
                                    color: Color(0xFFFF6B81),
                                  ),
                                  width:  MediaQuery.of(context).size.width * 0.90,
                                  height: 110,
                                  child: Center(
                                      child: Text(
                                        'Upcoming Appointment',
                                        style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                Container(
                  padding: EdgeInsets.only( top: 20),

                ),
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
                      // BottomNavigationBar navigationBar =  _globalKey.currentWidget as BottomNavigationBar;
                      // navigationBar.onTap!(2);
                   // Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()),);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AppointmentList(
                                    title: 'Previous Appointment', type: 1)),
                      );
                    },
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(16.0),
                        color: Color(0xFF2F3542),
                      ),
                      width:  MediaQuery.of(context).size.width * 0.90,
                      height: 110,
                      child: Center(
                          child: Text(
                            'Previous Appointment',
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          )),
                    ),
                  ),
                ),],),
              /*  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  width:  MediaQuery.of(context).size.width * 0.90,
                                  height: 90,
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
                            ),],),


*/


              ],
            ),
          )
      ),
    );
  }

String getuser(){
  User? user = FirebaseAuth.instance.currentUser;
  return user!.uid.toString();
}

}