import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' as fb_core;
import 'dart:io';
class Storage{
  final fb_storage = FirebaseStorage.instance;

Future<void> uploadImg (String path, String name) async{
File file = File(path);

try{

  await fb_storage.ref('pet_icons/$name').putFile(file);

} on fb_core.FirebaseException catch(e) {print(e);}
}
}

