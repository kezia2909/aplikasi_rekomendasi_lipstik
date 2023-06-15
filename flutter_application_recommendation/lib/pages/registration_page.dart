import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  // late double sizeFrame;
  late double sizePadding;
  late double sizePaddingTop;
  late double sizePaddingSpesial;

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _firstnameTextController = TextEditingController();
  TextEditingController _lastnameTextController = TextEditingController();

  var snackBar = SnackBar(
    content: const Text('Yay! A SnackBar!'),
  );

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

// START WIDGET
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width <
        MediaQuery.of(context).size.height) {
      if (MediaQuery.of(context).size.width * 0.1 >= 20) {
        print("aaaaaa${MediaQuery.of(context).size.width}");
        sizePadding = 20;
        sizePaddingTop = sizePadding;

        // sizePadding = MediaQuery.of(context).size.width * 0.1;
      } else {
        print("bbbbbbbbbbb${MediaQuery.of(context).size.width}");
        sizePadding = MediaQuery.of(context).size.width * 0.1;
        sizePaddingTop = sizePadding;
      }
    } else {
      sizePadding = MediaQuery.of(context).size.width * 0.25;
      sizePaddingTop = MediaQuery.of(context).size.width * 0.1;
    }
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
                colorTheme(colorShadow),
                colorTheme(colorMidtone),
                colorTheme(colorHighlight),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    sizePadding, sizePaddingTop, sizePadding, 0),
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
                                  colorTheme(colorDark),
                                  colorTheme(colorHighlight), () async {
                                var error = await AuthServices.registAccount(
                                    _firstnameTextController.text,
                                    _lastnameTextController.text,
                                    _emailTextController.text,
                                    _passwordTextController.text);

                                var message =
                                    "Error Sign Up, please try again, aaaaaaa";
                                print("TEST ERROR");
                                print(error);
                                print(error.runtimeType.toString());

                                switch (error.toString()) {
                                  case "[firebase_auth/unknown] Given String is empty or null":
                                    print('ERORR ZERO');
                                    message = "Please input all data";
                                    break;
                                  case "[firebase_auth/invalid-email] The email address is badly formatted.":
                                    message = "Email is not valid";
                                    break;
                                  case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
                                    message = "Email is already registered";
                                    break;
                                  case "[firebase_auth/weak-password] Password should be at least 6 characters":
                                    message = "Password at least 6 characters";
                                    break;
                                }
                                if (error.runtimeType.toString() != "User" &&
                                    error.runtimeType.toString() !=
                                        "minified:fS") {
                                  print("BUKANNN USERRR");
                                  print(error.runtimeType.toString());
                                  message = error.runtimeType.toString();
                                  print("AAAAAAaa");
                                  snackBar = SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: colorTheme(colorWhite),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(message),
                                      ],
                                    ),
                                    backgroundColor: colorTheme(colorRed),
                                  );
                                } else {
                                  print("BETULLLL USERRR");
                                  print(error.runtimeType.toString());
                                  print("AAAAAAaa");
                                  message = "Signed up successfully";
                                  snackBar = SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: colorTheme(colorWhite),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(message),
                                      ],
                                    ),
                                    backgroundColor: colorTheme(colorShadow),
                                  );
                                }
                                // if (kIsWeb) {
                                //   Navigator.pop(context);
                                // }

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }),
                              const SizedBox(
                                height: 20,
                              ),
                              reusableLogOption(
                                context,
                                "Already have an account?",
                                "Sign In",
                                () {
                                  Navigator.pop(context);
                                },
                              ),
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
