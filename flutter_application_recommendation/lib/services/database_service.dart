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

  static CollectionReference listImagesOriCollection =
      FirebaseFirestore.instance.collection('list_images_ori');

  static Future<void> createOrUpdateListImagesOri(String id,
      {required String imageURL}) async {
    await listImagesOriCollection.doc().set({
      'uid': id,
      'imageURL': imageURL,
    });
  }

  //   Future<String> uploadImageNew(PlatformFile? file) async {
  //   try {

  //     TaskSnapshot upload = await FirebaseStorage.instance
  //         .ref(
  //             'events/${file!.path}-${DateTime.now().toIso8601String()}.${file.extension}')
  //         .putData(
  //           file.bytes,
  //           SettableMetadata(contentType: 'image/${file.extension}'),
  //         );

  //     String url = await upload.ref.getDownloadURL();
  //     return url;
  //   } catch (e) {
  //     print('error in uploading image for : ${e.toString()}');
  //     return '';
  //   }
  // }

  static Future<String> uploadImage(PickedFile? imageFile) async {
    print("start firebase");
    String imageUrl = "";
    print("start ref");

    Reference reference = FirebaseStorage.instance
        .ref()
        .child("ori_image/${basename(imageFile!.path)}");
    print("ref oke");

    print("upload");
    print(imageFile.path);
    // UploadTask uploadTask = reference.putFile(imageFile);
    UploadTask uploadTask;
    if (kIsWeb) {
      print("web");
      uploadTask = reference.putData(await imageFile.readAsBytes(),
          SettableMetadata(contentType: 'image/jpg'));
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
