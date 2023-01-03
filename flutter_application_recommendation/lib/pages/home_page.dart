import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/login_page.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';

class HomePage extends StatefulWidget {
  final User firebaseUser;
  // const HomePage(User firebaseUser, {Key? key}) : super(key: key);
  const HomePage({Key? key, required this.firebaseUser}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user = widget.firebaseUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(colors: [
        //     hexStringToColor("CB2B93"),
        //     hexStringToColor("9546C4"),
        //     hexStringToColor("5E61F4"),
        //   ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        // ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: [
                Text(user.uid),
                Text(user.isAnonymous ? "ANONIM" : "USER"),
                // Center(
                //   child: ElevatedButton(
                //       child: Text("Logout"),
                //       onPressed: () {
                //         FirebaseAuth.instance.signOut().then(
                //           (value) {
                //             print("logout");
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => LoginPage()),
                //             );
                //           },
                //         );
                //       }),
                // ),
                ElevatedButton(
                    child: Text("LOG OUT"),
                    onPressed: () async {
                      await AuthServices.logOut();
                    }),
                const Text("aaa"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
