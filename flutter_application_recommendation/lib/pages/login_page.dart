import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  var snackBar = SnackBar(
    content: const Text('Yay! A SnackBar!'),
  );

// START WIDGET
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            colorTheme(colorShadow),
            colorTheme(colorMidtone),
            colorTheme(colorHighlight),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Padding(
          // padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.05, 20, 0),
          child: Column(
            children: [
              logoWidget("assets/images/logo.png"),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: <Widget>[
                        reusableTextFieldLog("Enter Email",
                            Icons.person_outline, false, _emailTextController),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextFieldLog("Enter Password",
                            Icons.lock_outline, true, _passwordTextController),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableButtonLog(
                            context,
                            "SIGN IN",
                            colorTheme(colorDark),
                            // hexStringToColor("5a802a"),
                            colorTheme(colorHighlight), () async {
                          print("TRYYYY");
                          var error = await AuthServices.logInEmail(
                              _emailTextController.text,
                              _passwordTextController.text);
                          var message = "Error Sign In";
                          print("END TRYYY");
                          print(error);
                          // if (error.toString() ==
                          //     "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
                          //   message = "password wrong";
                          // }
                          switch (error.toString()) {
                            case "[firebase_auth/unknown] Given String is empty or null":
                              message = "Please input email & password";
                              break;
                            case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
                              message = "Email is not registered";
                              break;
                            case "[firebase_auth/invalid-email] The email address is badly formatted.":
                              message = "Email is not valid";
                              break;
                            case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
                              message = "Wrong password";
                              break;
                          }

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
                          // if (error.runtimeType.toString() == "User") {
                          //   message = "Successfully Sign In";
                          //   snackBar = SnackBar(
                          //     content: Row(
                          //       children: [
                          //         Icon(
                          //           Icons.check_circle,
                          //           color: Colors.white,
                          //         ),
                          //         SizedBox(
                          //           width: 10,
                          //         ),
                          //         Text(message),
                          //       ],
                          //     ),
                          //     backgroundColor: Colors.green,
                          //   );
                          // }

                          // print(error.runtimeType);
                          if (error.runtimeType.toString() != "User") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {}
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        // reusableButtonLog(
                        //     context,
                        //     "SKIP",
                        //     hexStringToColor("db9196"),
                        //     hexStringToColor("f9e8e6"), () async {
                        //   await AuthServices.logInAnonymous();
                        // }),
                        // Text("OR"),
                        // Text("Don't have an account?"),

                        // reusableLogOption(
                        //   context,
                        //   "Don't have an account?",
                        //   "SIGN UP",
                        //   () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => RegistrationPage()));
                        //   },
                        // ),
                        // USING BUTTON
                        // const SizedBox(
                        //   height: 30,
                        // ),
                        // Align(
                        //   alignment: Alignment.topLeft,
                        //   child: Text(
                        //     "Don't have an account?",
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
                        //     "SIGN UP",
                        //     hexStringToColor("db9196"),
                        //     hexStringToColor("1b1c1e"), () {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => RegistrationPage()));
                        // }),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // reusableButtonLog(
                        //     context,
                        //     "SKIP",
                        //     hexStringToColor("db9196"),
                        //     hexStringToColor("1b1c1e"), () async {
                        //   await AuthServices.logInAnonymous();
                        // }),
                        // USING TEXT
                        const SizedBox(
                          height: 20,
                        ),
                        reusableLogOption(
                          context,
                          "Don't have an account?",
                          "Sign Up",
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationPage()));
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "or",
                          style: TextStyle(
                            color: colorTheme(colorBlack),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        reusableLogOption(
                          context,
                          "Sign In",
                          "Anonymously",
                          () async {
                            await AuthServices.logInAnonymous();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
