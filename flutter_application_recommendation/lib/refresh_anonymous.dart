import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RefreshAnonymous extends StatefulWidget {
  final User firebaseUser;

  const RefreshAnonymous({Key? key, required this.firebaseUser})
      : super(key: key);

  @override
  State<RefreshAnonymous> createState() => _RefreshAnonymousState();
}

class _RefreshAnonymousState extends State<RefreshAnonymous> {
  late User user = widget.firebaseUser;

  @override
  void initState() {
    // TODO: implement initState
    print("START REFRESH");
    user.delete();
    print("END REFRESH");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
