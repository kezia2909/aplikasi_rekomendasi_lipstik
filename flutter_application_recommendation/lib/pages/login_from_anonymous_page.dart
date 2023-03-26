import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/pages/registration_from_anonymous_page.dart';
import 'package:flutter_application_recommendation/pages/registration_page.dart';
import 'package:flutter_application_recommendation/pages/result_page.dart';
import 'package:flutter_application_recommendation/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';
import 'package:provider/provider.dart';

class LoginFromAnonymousPage extends StatefulWidget {
  final User firebaseUser;

  const LoginFromAnonymousPage({Key? key, required this.firebaseUser})
      : super(key: key);

  @override
  State<LoginFromAnonymousPage> createState() => _LoginFromAnonymousPageState();
}

class _LoginFromAnonymousPageState extends State<LoginFromAnonymousPage> {
  late User user = widget.firebaseUser;

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  late var credential;
  var snackBar = SnackBar(
    content: const Text('Yay! A SnackBar!'),
  );

  var message = "Error Sign In";

  Future<void> anonymousLogInEmail({
    required User user,
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
      // await user.linkWithCredential(credential);
      // await user.reload();

      // REGIST DAN LOGIN
      await user.delete();
      // await AuthServices.logOut();
      // user = await AuthServices.logInEmail(email, password);
      var error = await AuthServices.logInEmail(email, password);
      if (error.runtimeType.toString() != "User") {
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
      }
      user = await AuthServices.logInEmail(email, password);
      Navigator.pop(context, await user);
    } catch (error) {
      print("GAGAL MASUK ANONYMOUS");
      // user.delete();
      user = await AuthServices.logInAnonymous();
      print(error.toString());

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
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
  }

// START WIDGET
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: colorTheme(colorShadow),
        foregroundColor: colorTheme(colorHighlight),
        elevation: 0,
        centerTitle: true,
        // title: Text(
        //   "SIGN IN",
        //   style: TextStyle(
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
      ),
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
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0, 20, 0),
          child: Column(
            children: [
              logoWidget("assets/images/logo.png"),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
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
                        SizedBox(
                          height: 10,
                        ),
                        reusableButtonLog(
                            context,
                            "SIGN IN",
                            colorTheme(colorDark),
                            colorTheme(colorHighlight), () async {
                          credential = EmailAuthProvider.credential(
                              email: _emailTextController.text,
                              password: _passwordTextController.text);
                          await anonymousLogInEmail(
                              user: user,
                              email: _emailTextController.text,
                              password: _passwordTextController.text);
                        }),
                        // reusableButtonLog(context, "SKIP", () async {
                        //   await AuthServices.logInAnonymous();
                        // }),
                        // reusableButtonLog(context, "SUBMIT", () async {
                        //   await AuthServices.registAccount("coba", "coba",
                        //       _emailTextController.text, _passwordTextController.text);
                        // }),
                        // registrationOption()
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

  Row registrationOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account? ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            // Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegistrationFromAnonymousPage(
                          firebaseUser: user,
                        )));
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
