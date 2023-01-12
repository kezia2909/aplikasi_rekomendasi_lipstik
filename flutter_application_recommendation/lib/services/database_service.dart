import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
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

  static Future<String> uploadImage(PickedFile? imageFile) async {
    // print("masuk upload");
    // String fileName = basename(imageFile.path);
    // print("filename :");
    // print(fileName);
    // print("filename oke");
    // Reference ref = FirebaseStorage.instance.ref().child(fileName);
    // print("ref :");
    // print(ref);
    // print("ref oke");
    // UploadTask task = ref.putFile(imageFile);
    // print("task :");
    // print(task);
    // print("task oke");
    // gagal youtube
    // String urlString;
    // TaskSnapshot snapshot = await task.whenComplete(() async {
    //   urlString = await task.snapshot.ref.getDownloadURL();
    // });
    // TaskSnapshot snapshot = await task.whenComplete();
    // print("url :");
    // print(task.snapshot.ref.getDownloadURL().toString());
    // print("url oke");
    // // return await task.snapshot.ref.getDownloadURL();
    // return await snapshot.ref.getDownloadURL();

    // gagal stack
    // String urlString = "";
    // task.whenComplete(() async {
    //   try {
    //     print("try");
    //     urlString = await ref.getDownloadURL();
    //     print(urlString);
    //     print("try oke");
    //   } catch (onError) {
    //     print("error");
    //     urlString = "url error";
    //     print("error oke");
    //   }
    // });

    // print("urlstring");
    // print(urlString);
    // print("urlstring oke");
    // return urlString;

    print("start firebase");
    String imageUrl = "";
    print("start ref");

    Reference reference = FirebaseStorage.instance
        .ref()
        .child("original image")
        .child(basename(imageFile!.path));
    print("ref oke");

    print("upload");
    print(imageFile.path);
    // UploadTask uploadTask = reference.putFile(imageFile);
    UploadTask uploadTask;
    if (kIsWeb) {
      print("web");
      uploadTask = reference.putData(await imageFile.readAsBytes());
      print("web oke");
    } else {
      print("android");
      uploadTask = reference.putFile(File(imageFile.path));
      print("android oke");
    }
    print("upload oke");

    print("await task");
    await uploadTask.whenComplete(() async {
      try {
        print("try");
        imageUrl = await reference.getDownloadURL();
        print(imageUrl);
        print("try oke");
      } catch (onError) {
        print("Error");
      }

      print(imageUrl);
    });
    print("await oke");

    print("return");
    return await imageUrl;
  }

  // static Future<String> uploadImageNew(PickedFile? pickedFile) async {
  //   String imageUrl = "";

  //   Reference reference = FirebaseStorage.instance
  //       .ref()
  //       .child("original image")
  //       .child(basename(pickedFile!.path));

  //   UploadTask uploadTask;

  //   if (kIsWeb) {
  //     uploadTask = reference.putData(await pickedFile!.readAsBytes());
  //   }

  //   return imageUrl;
  // }

  // uploadImageToStorage(PickedFile? pickedFile) async {
  //   if (kIsWeb) {
  //     Reference _reference = _firebaseStorage
  //         .ref()
  //         .child('images/${Path.basename(pickedFile!.path)}');
  //     await _reference
  //         .putData(
  //       await pickedFile!.readAsBytes(),
  //       SettableMetadata(contentType: 'image/jpeg'),
  //     )
  //         .whenComplete(() async {
  //       await _reference.getDownloadURL().then((value) {
  //         uploadedPhotoUrl = value;
  //       });
  //     });
  //   } else {
  //     //write a code for android or ios
  //   }
  // }
}
