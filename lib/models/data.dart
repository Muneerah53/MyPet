import 'package:firebase_auth/firebase_auth.dart';


  String getuser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid.toString();
  }
