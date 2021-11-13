import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'boardingAppointment.dart';
import 'select_appt.dart';
import 'models/global.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   //await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // const MyApp({Key? key}) : super(key: key);
//   final Future<FirebaseApp> fbApp = Firebase.initializeApp();
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: FutureBuilder(
//             future: fbApp,
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 print('you have an error ${snapshot.error.toString()}');
//                 return Text("Somthing wronge");
//               } else if (snapshot.hasData) {
//                 return const MyHomePage(title: 'Flutter Demo Home Page');
//               } else {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             })
//         //const MyHomePage(title: 'Flutter Demo Home Page'),
//         );
//   }
// }
//

class AppoinMain extends StatefulWidget {
  // const AppoinMain({Key? key, this.title}) : super(key: key);
  //
  // final String? title;

  @override
  State<AppoinMain> createState() => _AppoinMainState();
}

class _AppoinMainState extends State<AppoinMain> {
  int _counter = 0;
  bool type = false; // default false: 0 -> Check-Up
  int t = 0;
  setType() {
    setState(() {
      type = !type; // to true(1) if grooming
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4E3E3),
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
            Container(
                child: Row(
              children: [
                // Container(
                //     margin: const EdgeInsets.fromLTRB(250, 80, 0, 0),
                //     child: PopupMenuButton(
                //       itemBuilder: (context) => [
                //         PopupMenuItem(
                //           child: Text("home"),
                //           value: 1,
                //         ),
                //         PopupMenuItem(
                //           child: Text("profile"),
                //           value: 2,
                //         ),
                //         PopupMenuItem(
                //           child: Text("logOut"),
                //           value: 1,
                //         ),
                //       ],
                //     )),
              ],
            )),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 40),
              child: Text(
                'Appointment',
                style: TextStyle(
                    color: Color(0XFFFF6B81),
                    fontSize: 34,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 60, 0, 40),
              width: 344,
              height: 120,
              child: ElevatedButton(
                onPressed: () {
                  t = 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => select(type: t)),
                  );
                },
                child: Text('Check UP',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0XFFFF6B81)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)))),
              ),
            ),
            SizedBox(width: 50),
            Container(
              width: 344,
              height: 120,
              child: ElevatedButton(
                  onPressed: () {
                    t = 1;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => select(type: t)),
                    );
                  },
                  child: Text('Grooming',
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

            SizedBox(
              height: 20.0,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 60, 0, 40),
              width: 344,
              height: 120,
              child: ElevatedButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => boardingapp()),
                  );
                },
                child: Text('Boarding',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0XFFFF6B81)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)))),
              ),
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
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.camera),
      //       label: 'Camera',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.chat),
      //       label: 'Chats',
      //     ),
      //   ],
      // )
    );
  }
}
