import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  static CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  static Future<void> createOrUpdateUser(String id,
      {required String firstname,
      required String lastname,
      required String email}) async {
    await userCollection.doc(id).set({
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
    });
  }

  static Future<String> uploadImage(File imageFile) async {
    String fileName = basename(imageFile.path);

    Reference ref =
        FirebaseStorage.instance.ref().child('flutter-tests').child(fileName);
    UploadTask task = ref.putFile(imageFile);

    // String urlString;
    // TaskSnapshot snapshot = await task.whenComplete(() async {
    //   urlString = await task.snapshot.ref.getDownloadURL();
    // });
    print("helooooooooo");
    print(task.snapshot.ref.getDownloadURL());
    return await task.snapshot.ref.getDownloadURL();
  }
}
