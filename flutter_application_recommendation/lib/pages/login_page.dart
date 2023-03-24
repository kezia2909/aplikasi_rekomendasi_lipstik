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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            // hexStringToColor("f9e8e6"),
            // hexStringToColor("f8b8c1"),
            hexStringToColor("db9196"),
            hexStringToColor("d3445d"),
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
                            "LOG IN",
                            hexStringToColor("f9e8e6"),
                            hexStringToColor("1b1c1e"), () async {
                          await AuthServices.logInEmail(
                              _emailTextController.text,
                              _passwordTextController.text);
                        }),
                        reusableButtonLog(
                            context,
                            "SKIP",
                            hexStringToColor("f9e8e6"),
                            hexStringToColor("1b1c1e"), () async {
                          await AuthServices.logInAnonymous();
                        }),
                        reusableLogOption(
                          context,
                          "Don't have account?",
                          "Registration",
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationPage()));
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
