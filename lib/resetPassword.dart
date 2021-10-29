import 'package:MyPet/petOwner_screen.dart';
import 'package:flutter/material.dart';
import 'admin_screen.dart';
import 'register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:email_validator/email_validator.dart';
import 'admin_main.dart';
import 'petOwner_main.dart';
import 'login.dart';
import 'models/global.dart';
void main() {
  runApp(Reset());
}

class ResetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ResetPageState();
}

class Reset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResetPage(),
    );
  }
}

class _ResetPageState extends State<ResetPage> {
  final _formKey = new GlobalKey<FormState>();
  String _email = '';
  final auth = FirebaseAuth.instance ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF4E3E3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => login()));
            },

            child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
            style: backButton ),// <-- Button color// <-- Splash color

      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(50, 10, 50, 30),
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
        validator: (value) {
          if (value!.isEmpty) {
            return 'Email must not be empty';
          }
          else
          if (EmailValidator.validate(value.replaceAll(" ", "")))
            return null;
          else
            return "Please enter a valid email";
        },
        onSaved: (Value) => _email = Value!,
      ),
    ];
  }
  List<Widget> buildSubmitButtons() {
    return [

      SizedBox(height: 80),
      Container(
        height: 60,
        width: 200,
        decoration: BoxDecoration(
            color: Color(0xff313540), borderRadius: BorderRadius.circular(16)),
        child:
        TextButton(
          onPressed: validateAndSubmit ,
          child: Text(
            'Reset password',
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
        auth.sendPasswordResetEmail(email :_email);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("We sent instructions to your email to change your password ,please check your email"),
          backgroundColor:Colors.green,),);
      //  Navigator.push(context, MaterialPageRoute(builder: (_) => login()));


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


      }

    }
  }
}
