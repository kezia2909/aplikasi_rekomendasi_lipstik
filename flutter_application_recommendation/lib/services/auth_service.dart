// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_recommendation/services/database_service.dart';

class AuthServices {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  // static Future addUsersDetails(
  //     String firstname, String lastname, String email) async {
  //   await FirebaseFirestore.instance.collection('users').add({
  //     'first name': firstname,
  //     'last name': lastname,
  //     'email': email,
  //   });
  // }

  static Future registAccount(
      String firstname, String lastname, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? firebaseUser = result.user;
      DatabaseService.createOrUpdateUser(firebaseUser!.uid,
          firstname: firstname, lastname: lastname, email: email);
      // addUsersDetails(firstname, lastname, email);
      return firebaseUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future logInEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      return firebaseUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future logInAnonymous() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? firebaseUser = result.user;
      return firebaseUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> logOut() async {
    _auth.signOut();
  }

  // static Future<void> anonymousLogInEmail({
  //   required User user,
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     await Future.wait([
  //       user.updateEmail(email),
  //       user.updatePassword(password),
  //     ]);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  static Stream<User?> get firebaseUserStream => _auth.authStateChanges();
}
