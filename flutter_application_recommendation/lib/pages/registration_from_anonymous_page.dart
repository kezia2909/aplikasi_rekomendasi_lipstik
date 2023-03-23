import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/services/database_service.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';
import 'package:provider/provider.dart';

class RegistrationFromAnonymousPage extends StatefulWidget {
  final User firebaseUser;

  const RegistrationFromAnonymousPage({Key? key, required this.firebaseUser})
      : super(key: key);

  @override
  State<RegistrationFromAnonymousPage> createState() =>
      _RegistrationFromAnonymousPageState();
}

class _RegistrationFromAnonymousPageState
    extends State<RegistrationFromAnonymousPage> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _firstnameTextController = TextEditingController();
  TextEditingController _lastnameTextController = TextEditingController();

  late User user = widget.firebaseUser;

  late var credential;
  var snackBar = SnackBar(
    content: const Text('Yay! A SnackBar!'),
  );

  Future<void> anonymousRegistEmail({
    required User user,
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  }) async {
    try {
      print("MASUK ANONYMOUS");
      print(user);
      print(email);
      print(password);

      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);

      // REGIST
      await user.linkWithCredential(credential);
      await user.reload();
      // await AuthServices.registAccount(
      //     _firstnameTextController.text,
      //     _lastnameTextController.text,
      //     _emailTextController.text,
      //     _passwordTextController.text);
      DatabaseService.createOrUpdateUser(user.uid,
          firstname: firstname, lastname: lastname, email: email);

      // REGIST DAN LOGIN
      await AuthServices.logOut();
      user = await AuthServices.logInEmail(email, password);

      Navigator.pop(context, await user);
    } catch (e) {
      print("GAGAL MASUK ANONYMOUS");
      // user.delete();
      user = await AuthServices.logInAnonymous();
      print(e.toString());
      snackBar = SnackBar(
        content: const Text('email sudah terdaftar'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordTextController.dispose();
    _emailTextController.dispose();
    _firstnameTextController.dispose();
    _lastnameTextController.dispose();
    super.dispose();
  }

  // Future addUsersDetails(
  //     String firstname, String lastname, String email) async {
  //   await FirebaseFirestore.instance.collection('users').add({
  //     'first name': firstname,
  //     'last name': lastname,
  //     'email': email,
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Registration",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4"),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            reusableTextField("Enter First Name", Icons.person_outline, false,
                _firstnameTextController),
            const SizedBox(
              height: 20,
            ),
            reusableTextField("Enter Last Name", Icons.person_outline, false,
                _lastnameTextController),
            const SizedBox(
              height: 20,
            ),
            reusableTextField(
                "Enter Email", Icons.mail_outline, false, _emailTextController),
            const SizedBox(
              height: 20,
            ),
            reusableTextField("Enter Password", Icons.lock_outline, true,
                _passwordTextController),
            const SizedBox(
              height: 20,
            ),
            // reusableButtonLog(context, "SUBMIT", () {
            //   // create account
            //   FirebaseAuth.instance
            //       .createUserWithEmailAndPassword(
            //           email: _emailTextController.text,
            //           password: _passwordTextController.text)
            //       .then((value) {
            //     print("create new account");
            //     // add detail user in firestore
            //     addUsersDetails(
            //       _firstnameTextController.text.trim(),
            //       _lastnameTextController.text.trim(),
            //       _emailTextController.text.trim(),
            //     );
            //     // navigate to login
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => LoginPage()));
            //   }).onError(((error, stackTrace) {
            //     print("Error ${error.toString()}");
            //   }));
            // }),
            reusableButtonLog(context, "SUBMIT", () async {
              await anonymousRegistEmail(
                  user: user,
                  firstname: _firstnameTextController.text,
                  lastname: _lastnameTextController.text,
                  email: _emailTextController.text,
                  password: _passwordTextController.text);
            }),
          ]),
        )),
      ),
    );
  }
}
