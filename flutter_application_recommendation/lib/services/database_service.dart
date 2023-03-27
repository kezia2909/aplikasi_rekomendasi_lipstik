import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
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
      required String email,
      required String password}) async {
    await userCollection.doc(id).set({
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
    });
  }

  static Stream<DocumentSnapshot<Object?>> getUser({required String userId}) {
    return userCollection.doc(userId).snapshots();
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

  static CollectionReference historyRekomendasiCollection =
      FirebaseFirestore.instance.collection('history_rekomendasi');

  static Future<void> createHistoryRekomendasiOld(String userId,
      {required String nameHistory,
      required String faceUrl,
      required String faceCategory}) async {
    await historyRekomendasiCollection.doc("${userId}_$nameHistory").set({
      "uid": FirebaseFirestore.instance.collection('users').doc(userId),
      "nameHistory": nameHistory,
      "faceUrl": faceUrl,
      "faceCategory": faceCategory,
    });
  }

  static Stream<QuerySnapshot> getHistoryRekomendasi(String nameSearch,
      {required String userId}) {
    if (nameSearch == "") {
      return historyRekomendasiCollection
          .doc(userId)
          .collection("detail")
          .snapshots();
    }

    return historyRekomendasiCollection
        .doc(userId)
        .collection("detail")
        .orderBy("nameHistory")
        .startAt([nameSearch]).endAt([nameSearch + '\uf8ff']).snapshots();
  }

  static Future<bool> checkHistoryRekomendasi(
          {required String userId, required String nameHistory}) async =>
      await historyRekomendasiCollection
          .doc(userId)
          .collection("detail")
          .doc(nameHistory)
          .get()
          .then(
        (result) {
          // print("ADAAAAAa");
          print(result);
          print(result.exists);
          return result.exists;
        },
      ).catchError((error) {
        // print("TIDAK ADAAA");
        return false;
      });

  static Future<bool> createHistoryRekomendasi(
          // List<dynamic> lipsArea,
          // List<dynamic> lipsLabel,
          // List<dynamic> lipsCluster,
          List<dynamic> faceArea,
          {required String userId,
          required String nameHistory,
          required String faceUrl,
          required String faceCategory}) async =>
      await historyRekomendasiCollection
          .doc(userId)
          .collection("detail")
          .doc(nameHistory)
          .set({
        "uid": FirebaseFirestore.instance.collection('users').doc(userId),
        "nameHistory": nameHistory,
        "faceUrl": faceUrl,
        "faceCategory": faceCategory,
        // "lipsArea": lipsArea,
        // "lipsLabel": lipsLabel,
        // "lipsCluster": lipsCluster,
        "faceArea": faceArea,
      }).then(
        (result) {
          print("oke");
          return true;
        },
      ).catchError((error) {
        print("error");
        print(error);
        return false;
      });

  // static Future<void> editHistoryRekomendasi(
  //     String userId, String faceUrl, String faceCategory,
  //     {required String oldName, required String nameHistory}) async {
  //   await historyRekomendasiCollection.doc("${userId}_$nameHistory").update({
  //     "uid": FirebaseFirestore.instance.collection('users').doc(userId),
  //     "nameHistory": nameHistory,
  //     "faceUrl": faceUrl,
  //     "faceCategory": faceCategory
  //   });
  //   historyRekomendasiCollection.doc("${userId}_$oldName").delete();
  // }
  static Future<bool> deleteHistoryRekomendasi(String userId,
          {required String nameHistory}) async =>
      await historyRekomendasiCollection
          .doc(userId)
          .collection("detail")
          .doc(nameHistory)
          .delete()
          .then(
        (result) {
          print("DELETE");
          print("oke");
          return true;
        },
      ).catchError((error) {
        print("DELETE");

        print("error");
        print(error);
        return false;
      });

  static Future<bool> resetHistoryRekomendasi(String userId) async =>
      await historyRekomendasiCollection
          .doc(userId)
          .collection("detail")
          .get()
          .then(
        (result) {
          for (DocumentSnapshot ds in result.docs) {
            ds.reference.delete();
          }
          return true;
        },
      ).catchError((error) {
        print("TIDAK ADAAA");
        return false;
      });
  // await historyRekomendasiCollection.doc(userId).delete().then(
  //   (result) {
  //     print(userId);
  //     print("reset oke");
  //     return true;
  //   },
  // ).catchError((error) {
  //   print("error");
  //   print(error);
  //   return false;
  // });
  // await historyRekomendasiCollection.doc("${userId}_$oldName").delete();

  // static Future<void> deleteHistoryRekomendasi(String userId,
  //     {required String oldName}) async {
  //   await historyRekomendasiCollection
  //       .doc(userId)
  //       .collection("detail")
  //       .doc(oldName)
  //       .delete();
  // }
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

  static Future<String> uploadImage(
      String userId, PickedFile? imageFile) async {
    print("start firebase");
    String imageUrl = "";
    print("start ref");

    Reference reference = FirebaseStorage.instance
        .ref()
        .child("ori_image")
        .child(userId)
        .child(basename(imageFile!.path));
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
