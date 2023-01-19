import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/pages/home_page_copy.dart';
import 'package:flutter_application_recommendation/pages/home_page_try.dart';
import 'package:flutter_application_recommendation/pages/login_page.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? firebaseUser = Provider.of<User?>(context);
    return (firebaseUser == null)
        ? const LoginPage()
        : HomePage(
            firebaseUser: firebaseUser,
          );
  }
}
