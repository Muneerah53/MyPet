import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(login());
}
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState () =>  new _LoginPageState();
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


// enum FormType {
//  login,
//  register ,
// }
 class _LoginPageState extends State<LoginPage> {

   final formKey = new GlobalKey<FormState>();
   String _email = '';
   String _password = '';

 //  FormType _formType = FormType.login;

   bool validateAndSave() {
     final form = formKey.currentState;
     if (form !.validate()) {
       form.save();
       return true;
     }
     return false;
   }

   void validateAndSubmit() async {
     if (validateAndSave()) {
       try {
       // if (_formType == FormType.login) {
         final UserCredential authResult = (await FirebaseAuth.instance
             .signInWithEmailAndPassword(email: _email, password: _password));
         final User? user = authResult.user;
         print('Signed in : ${user!.uid}');
      // }
      //  else{
      //    final UserCredential authResult = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password));
      //     final User? user = authResult.user;
      //     print('registerd user: ${user!.uid}');
      //  }
       }
       catch (e) {
         print('no such user');
       }
     }
   }

   //
   // void moveToRegister() {
   //   formKey.currentState!.reset() ;
   //   setState(() {
   //  //   _formType = FormType.register;
   //   });
   // }

  // void moveToLogin() {
  //   formKey.currentState!.reset() ;
   //  setState(() {
    //   _formType = FormType.login;
    // });
  // }


   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.red[50],
       body: SingleChildScrollView(
         child: Column(
           children: <Widget>[
             Container(
                 margin: EdgeInsets.fromLTRB(50, 40, 50, 30),
                 width: 130,
                 height: 160,
                 decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     image: DecorationImage(
                         image: AssetImage('images/logo.jpeg')
                     )
                 )
             ),
             Padding(
                 padding: EdgeInsets.symmetric(horizontal: 26),
                 child: new Form (
                     key: formKey,
                     child: new Column (
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
                 borderRadius: BorderRadius.circular(25.0),
                 borderSide: BorderSide(
                   width: 0,
                   style: BorderStyle.none,
                 )
             )
         ),
         validator: (Value) {
           if (Value == null || Value.isEmpty) {
             return '* Required';
           }
     else if(!Value.contains('@'))
     return 'Invalid Email';
     else
     return null;
         },
         onSaved: (value) => _email = value!,
       ),

       SizedBox(height: 20),
       Padding(
         padding: EdgeInsets.symmetric(horizontal: 5),
         child: new TextFormField(
           obscureText: true,
           decoration: InputDecoration(
               filled: true,
               fillColor: Colors.white,
               hintText: 'Enter your password',
               border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(25.0),
                   borderSide: BorderSide(
                     width: 0,
                     style: BorderStyle.none,
                   )
               )
           ),

           validator: (Value) {
             if (Value == null || Value.isEmpty) {
               return '* Required';
             }
             return null;
           },
           onSaved: (value) => _password = value!,

         ),)

     ];
   }

   List<Widget> buildSubmitButtons() {
   //  if (_formType == FormType.login) {

       return [
         FlatButton(
           onPressed: () {
             //TODO FORGOT PASSWORD SCREEN GOES HERE
           },
           child: Text(
             'Forget password',
             style: TextStyle(
                 color: Colors.blueGrey, fontSize: 15),
           ),
         ),
         SizedBox(height: 20),

         Container(
           height: 60,
           width: 230,
           decoration: BoxDecoration(
               color: Colors.blueGrey,
               borderRadius: BorderRadius.circular(20)),
           child: FlatButton(
             onPressed: validateAndSubmit,
             child: Text('Login', style: TextStyle(
                 color: Colors.white, fontSize: 20),

             ),
           ),
         ),
         SizedBox(height: 30,),
         FlatButton(
           child: Text(
             'New User? Creat An Account',
             style: TextStyle(
                 color: Colors.blueGrey, fontSize: 15)),
             onPressed:() { // Navigator.push(
               //  Navigator.push(
               //  context, MaterialPageRoute(builder: (_) => reg()));
             }
     ),

         //
         // SizedBox(height: 50,),
         // //
         // new FlatButton(
         //   child: new Text ('Creat An Account',
         //       style: new TextStyle(fontSize: 15)),
         //   onPressed: moveToRegister,
         //   //
         // )
       ];
//    // else {
//        return[
//        Container(
//          height: 60,
//          width: 230,
//          decoration: BoxDecoration(
//              color: Colors.blueGrey,
//              borderRadius: BorderRadius.circular(20)),
//          child: FlatButton(
//            onPressed: validateAndSubmit,
//            child: Text('create account', style: TextStyle(
//                color: Colors.white, fontSize: 20),
//
//            ),
//          ),
//        ),
//
//        SizedBox(height: 80,),
//        //
//      //  new FlatButton(
//       //   child: new Text ('Have An Account? login',
//          //    style: new TextStyle(fontSize: 15)),
//         // onPressed: moveToLogin,
//          //
//        )
//      ];
// //}
   }
 }