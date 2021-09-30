import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app3/CheckUP.dart';
import 'package:flutter_app3/custom_checkbox.dart';
import 'package:flutter_app3/select.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> fbApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: FutureBuilder(
            future: fbApp,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('you have an error ${snapshot.error.toString()}');
                return Text("Somthing wronge");
              } else if (snapshot.hasData) {
                return const MyHomePage(title: 'Flutter Demo Home Page');
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            })
        //const MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(40, 80, 0, 0),
                  padding: EdgeInsets.only(left: 10.0),
                  width: 50,
                  height: 50,
                  child: BackButton(
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.lightBlueAccent, shape: (BoxShape.circle)),
                ),
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
              height: 153,
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
              height: 153,
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
