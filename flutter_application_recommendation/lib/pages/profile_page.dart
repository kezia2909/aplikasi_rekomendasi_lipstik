import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  final User firebaseUser;

  const ProfilePage({Key? key, required this.firebaseUser}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user = widget.firebaseUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("PROFILE"),
          Text(user.uid),
          Text(user.email!),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthServices.logOut();
            },
          ),
        ],
      ),
    );
  }
}
