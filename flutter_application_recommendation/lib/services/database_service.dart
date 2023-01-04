import 'package:cloud_firestore/cloud_firestore.dart';

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
}
