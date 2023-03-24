import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/pages/login_page.dart';
import 'package:flutter_application_recommendation/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _firstnameTextController = TextEditingController();
  TextEditingController _lastnameTextController = TextEditingController();

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
    User? firebaseUser = Provider.of<User?>(context);
    return (firebaseUser == null)
        ? Scaffold(
            // extendBodyBehindAppBar: true,
            // appBar: AppBar(
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            //   title: const Text(
            //     "Registration",
            //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            //   ),
            // ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                hexStringToColor("db9196"),
                hexStringToColor("d3445d"),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.1, 20, 20),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: reusableTextTitle("Registration")),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                              ),
                              reusableTextFieldLog(
                                  "Enter First Name",
                                  Icons.person_outline,
                                  false,
                                  _firstnameTextController),
                              const SizedBox(
                                height: 20,
                              ),
                              reusableTextFieldLog(
                                  "Enter Last Name",
                                  Icons.person_outline,
                                  false,
                                  _lastnameTextController),
                              const SizedBox(
                                height: 20,
                              ),
                              reusableTextFieldLog(
                                  "Enter Email",
                                  Icons.mail_outline,
                                  false,
                                  _emailTextController),
                              const SizedBox(
                                height: 20,
                              ),
                              reusableTextFieldLog(
                                  "Enter Password",
                                  Icons.lock_outline,
                                  true,
                                  _passwordTextController),
                              const SizedBox(
                                height: 20,
                              ),
                              reusableButtonLog(
                                  context,
                                  "SIGN UP",
                                  hexStringToColor("f9e8e6"),
                                  hexStringToColor("1b1c1e"), () async {
                                await AuthServices.registAccount(
                                    _firstnameTextController.text,
                                    _lastnameTextController.text,
                                    _emailTextController.text,
                                    _passwordTextController.text);
                              }),
                              const SizedBox(
                                height: 20,
                              ),
                              // reusableButtonLog(
                              //     context,
                              //     "SKIP",
                              //     hexStringToColor("db9196"),
                              //     hexStringToColor("1b1c1e"), () async {
                              //   await AuthServices.logInAnonymous();
                              // }),
                              // const SizedBox(
                              //   height: 30,
                              // ),
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //   child: Text(
                              //     "Already have an account?",
                              //     style: TextStyle(
                              //       color: Colors.white.withOpacity(1.0),
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // reusableButtonLog(
                              //     context,
                              //     "SIGN IN",
                              //     hexStringToColor("db9196"),
                              //     hexStringToColor("1b1c1e"), () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => LoginPage()));
                              // }),
                              reusableLogOption(
                                context,
                                "Already have an account?",
                                "Sign In",
                                () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                              ),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              // reusableLogOption(
                              //   context,
                              //   "Log in as",
                              //   "Guest",
                              //   () async {
                              //     await AuthServices.logInAnonymous();
                              //   },
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : HomePage(
            firebaseUser: firebaseUser,
          );
  }
}
