import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
//import 'package:provider/provider.dart';
import 'login.dart';
import 'package:email_validator/email_validator.dart';
import 'petOwner_main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(register());
}

class register extends StatelessWidget {
  final Future<FirebaseApp> fbApp = Firebase.initializeApp();
  register({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: FutureBuilder(
          future: fbApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("An error has occured ${snapshot.error.toString()}");
              return const Text("Something went wrong");
            } else if (snapshot.hasData) {
              return homereg();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
final _formKey = GlobalKey<FormState>();
class homereg extends StatefulWidget {


  homereg();
  @override
  State<homereg> createState() => Home();
}

class Home extends State<homereg> {

  late UserCredential userCredential;
  String _email = "";
  String _password = "";
  String _firstName = "";
  String _lastName = "";
  String _phoneNumber = "";
  String _confirmpassword = "";
  final _auth = FirebaseAuth.instance;
  bool validatePassword(String value) {
    //Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regex = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#\$&*~]).{8,}$');
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }
  //to validate the phone number
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF4E3E3),
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Color(0xFFF4E3E3),
        leading: IconButton(
          onPressed: () {
            //  Navigator.push(
            Navigator.of(context,).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>  LoginPage()), (Route<dynamic> route)=>false); //register button******
          },
          icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color:  Color(0xFF2F3542)),


        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Builder(
            builder: (context) => Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Registration",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[300]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {

                            setState(() {
                              _firstName = value;
                            });
                           // _firstName = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your first name';
                            }
                            else if(!RegExp('[a-zA-Z _]+').hasMatch(_firstName)){
                              return 'first name must contain only letters';
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter your first name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            _lastName = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your last name';
                            }
                            else if(!RegExp('[a-zA-Z _]+').hasMatch(_lastName)){
                              return 'last name must contain only letters';
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter your last name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )),
                          ),
                        ),
                        //inputFile(label: "Enter your last name"),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            _phoneNumber = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (!isNumeric(value)) {
                              return 'phone number must be numeric';
                            } else if (value.length != 10) {
                              return 'phone number must be 10 digits';
                            } else if (!(value.startsWith('05'))) {
                              return 'Invalid phone number format (ex.05########)';
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter your phone number",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            _email = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            } else if (EmailValidator.validate(value.trim())) {
                              return null;
                            }else if (EmailValidator.validate(value))
                              return null;
                            else
                              return "Please enter a valid email";
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter your email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            _password = value;
                          },
                          validator: (Value) {
                            if (Value == null || Value.isEmpty) {
                              return 'Password must not be empty';
                            }else if (validatePassword(Value))
                              return 'Must be at least 8 characters and should contain a small letter,a capital letter,and a special character';
                            return null;
                          },
                          decoration: InputDecoration(
                            errorMaxLines: 2 ,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            _confirmpassword = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please confirm your password ';
                            } else if (_password != _confirmpassword) {
                              return 'password did not match';
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter confirm password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )),
                          ),
                          obscureText: true,
                        ),

                        // inputFile(
                        //label: "Enter confirm password ", obscureText: true),
                      ],
                    ),
                    Container(
                      //  padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        /*border: Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                          )*/),
                      child: MaterialButton(
                        minWidth: 230,
                        height: 60,
                        onPressed: () async {

                          final form = _formKey.currentState;
                          if (form!.validate()) {
                            try {
                              userCredential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                  email: _email, password: _password);
                            } on FirebaseAuthException catch (e) {
                              String msg = "";
                              if (e.code == 'weak-password') {
                                msg = 'The password provided is too weak.';
                              } else if (e.code == 'email-already-in-use') {
                                msg =
                                'The account already exists for that email.';
                              }
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(msg),
                                duration: Duration(seconds: 6),
                                backgroundColor: Colors.red,
                              ));
                            }
                            //userCredential = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
                            /*userCredential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _email, password: _password);*/

                            if (userCredential != null &&
                                userCredential.user != null) {
                              /*await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'email': _email,
                               // 'password': _password,
                                'uid': userCredential.user!.uid
                              });*/
                              await FirebaseFirestore.instance
                                  .collection('pet owners')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'fname': _firstName,
                                'lname': _lastName,
                                'email': _email,
                                'mobile': _phoneNumber,
                                'ownerID': userCredential.user!.uid,
                                'uid': userCredential.user!.uid
                              });


                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Your account is create successfully"),
                                backgroundColor: Colors.green,));
                              Navigator.of(context,).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>  LoginPage()), (Route<dynamic> route)=>false); //register button******


                            } else {
                              print('user does not exist');
                            }
                          } /*else {
                            //show message try again
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "please validate all fields before submiting"),
                              duration: Duration(seconds: 6),
                            ));
                          }*/


                        },
                        color: Color(0xff313540),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(""),
                        Text(
                          "",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 50),
                        )
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

// we will be creating a widget for text field
Widget inputFile({label, obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 4,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}