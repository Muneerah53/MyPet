import 'package:flutter/material.dart';
import 'register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(50, 50, 50, 30),
                width: 130,
                height: 160,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('images/logo.jpeg')))),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 26),
                child: new Form(
                    key: _formKey,
                    child: new Column(
                      children: buildInputs() + buildSubmitButtons(),
                    )))
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
        validator: (Value) {
          if (Value == null || Value.isEmpty) {
            return '* Required';
          } else if (!Value.contains('@'))
            return 'Invalid Email';
          else
            return null;
        },
        onSaved: (Value) => _email = Value!,
      ),
      SizedBox(height: 30),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: new TextFormField(
          obscureText: true,
          decoration: InputDecoration(
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
            if (Value == null || Value.isEmpty) {
              return '* Required';
            }else if (Value.length<6)
              return 'Password must be at least 6';
            return null;
          },
          onSaved: (Value) => _password = Value!,
        ),
      )
    ];
  }
  List<Widget> buildSubmitButtons() {
    return [
//FlatButton(
// onPressed: () {
// },
// child: Text(
// 'Forget password',
// style: TextStyle(
// color: Colors.blueGrey, fontSize: 15),
// ),
// ),
      SizedBox(height: 45),
      Container(
        height: 60,
        width: 200,
        decoration: BoxDecoration(
            color: Colors.blueGrey, borderRadius: BorderRadius.circular(16)),
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
      Text(
        "OR",
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.blueGrey,
        ),
      ),
      SizedBox(height: 20,),
      Text('Dont Have An Accont Yet ?',
          style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
      SizedBox(height: 8,),
      FlatButton(
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
        if(_email.contains("@admin.com")){
          final UserCredential authResult = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password));
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => adminHome()));
        }else{
          final UserCredential authResult = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password));
         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => userHome()));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No user found for that email'),
          backgroundColor: Theme.of(context).errorColor,
        ));
      }
    }
  }
}