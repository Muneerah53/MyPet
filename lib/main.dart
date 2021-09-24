import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app3/CheckUP.dart';
import 'package:flutter_app3/Grooming.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: _initialization,
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: const Color(0xFFF4E3E3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 60),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CheckUP()),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Grooming()),
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
    );
  }
}
