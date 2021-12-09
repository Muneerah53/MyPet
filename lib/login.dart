import 'dart:developer';
import 'package:MyPet/petOwner_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_screen.dart';
import 'register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:email_validator/email_validator.dart';
import 'admin_main.dart';
import 'petOwner_main.dart';
import 'resetPassword.dart';

Future<void> main() async {
  runApp(login());
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool validatePassword(String value) {
    //Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regex = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#\$&*~]).{8,}$');
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4E3E3),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Container(
            //     margin: EdgeInsets.fromLTRB(50, 50, 50, 30),
            //     width: 130,
            //     height: 160,
            //     decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         image: DecorationImage(
            //             image: AssetImage('images/logo.jpeg')))),
            SizedBox(
              height: 140,
            ),
            Container(
              child: Text(
                "Login",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[300]),
              ),
            ), SizedBox(
              height: 60,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 26),
                child: new Form(
                    key: _formKey,
                    child: new Column(
                      children: buildInputs() + buildSubmitButtons(),
                    ))),

          ],
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      SizedBox(height: 10),
      new TextFormField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: ' Enter your email',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ))),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return 'Email must not be empty';
          } else if (EmailValidator.validate(value.trim()))
            return null;
          else
            return "Please enter a valid email";
        },
        onSaved: (Value) => _email = Value!.trim(),
      ),
      SizedBox(height: 30),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: new TextFormField(
          obscureText: true,
          decoration: InputDecoration(
              errorMaxLines: 2 ,
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter your password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ))),
          validator: (Value) {
            if (Value == null || Value.trim().isEmpty) {
              return 'Password must not be empty';
            }  return null;
          },
          onSaved: (Value) => _password = Value!.trim(),
        ),
      )
    ];
  }

  List<Widget> buildSubmitButtons() {
    return [
      Row (
        mainAxisAlignment :MainAxisAlignment.end ,
        children :[
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => Reset()));
            },
            child: Text(
              'Forgot password ?',
              style: TextStyle(
                  color: Colors.blueGrey, fontSize: 15),
            ),
          ),
        ],
      ),

      SizedBox(height: 45),
      Container(
        height: 60,
        width: 200,
        decoration: BoxDecoration(
            color: Color(0xff313540), borderRadius: BorderRadius.circular(16)),
        child:
        TextButton(
          onPressed: validateAndSubmit ,
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      SizedBox(
        height: 15,
      ),

      // Text(
      //   "OR",
      //   style: TextStyle(
      //     fontSize: 15.0,
      //     color: Colors.blueGrey,
      //   ),
      // ),
        SizedBox(height: 13,),
    Row(
    mainAxisAlignment :MainAxisAlignment.center ,
    children :[
    Text('Dont Have An Accont Yet ?',
    style: TextStyle(color: Colors.blueGrey, fontSize: 15)),

    TextButton(
    child: Text(
    "SignUp",
    style: TextStyle(
    fontSize: 15.0,
    color: Colors.redAccent,
    ),
    ),
    onPressed: () {
    //  Navigator.push(
    Navigator.push(context, MaterialPageRoute(builder: (_) => register()));

    },
    ),
    ]
    )
    ];
  }


  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        final UserCredential authResult = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password));
        String uid = authResult.user!.uid;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', uid);
        if (_email.toLowerCase().contains("@admin.com")) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => managerPage()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => mainPage()));
        }
      } on FirebaseAuthException catch (e) {
        String msgError = "";
        if (e.code == 'user-not-found') {
          msgError = "No user found for that email ";
          print('No user found for that email');
        } else if (e.code == 'wrong-password') {
          msgError = "Wrong email or password.";
          print('Wrong email or password');
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msgError),
          backgroundColor: Theme.of(context).errorColor,
        ));
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //content: Text('No user found for that email'),
        //backgroundColor: Theme.of(context).errorColor,
        //));
      }
    }
  }
}
