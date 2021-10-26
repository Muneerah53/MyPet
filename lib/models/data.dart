import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class fbHelper {

  FirebaseFirestore fb = FirebaseFirestore.instance;
  CollectionReference appointments() {
    return fb.collection("appointment");
  }
  String getuser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid.toString();
  }


}


