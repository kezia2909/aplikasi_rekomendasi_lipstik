import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/home_page_try.dart';
import 'package:flutter_application_recommendation/pages/registration_page.dart';
import 'package:flutter_application_recommendation/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4"),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/logo.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                // reusableButtonLog(context, "LOG IN", () {
                //   FirebaseAuth.instance
                //       .signInWithEmailAndPassword(
                //           email: _emailTextController.text,
                //           password: _passwordTextController.text)
                //       .then((value) {
                //     print("login");
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => HomePage(firebaseUser)));
                //   }).onError((error, stackTrace) {
                //     print("Error ${error.toString()}");
                //   });
                // }),
                reusableButtonLog(context, "LOG IN", () async {
                  await AuthServices.logInEmail(
                      _emailTextController.text, _passwordTextController.text);
                }),
                reusableButtonLog(context, "SKIP", () async {
                  await AuthServices.logInAnonymous();
                }),
                // reusableButtonLog(context, "SUBMIT", () async {
                //   await AuthServices.registAccount("coba", "coba",
                //       _emailTextController.text, _passwordTextController.text);
                // }),
                registrationOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row registrationOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account? ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegistrationPage()));
          },
          child: const Text(
            "Registration",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
