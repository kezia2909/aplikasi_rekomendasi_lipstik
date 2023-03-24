import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppLifeCycleManager extends StatefulWidget {
  final Widget child;
  final User user;

  const AppLifeCycleManager({Key? key, required this.child, required this.user})
      : super(key: key);

  @override
  State<AppLifeCycleManager> createState() => _AppLifeCycleManagerState();
}

class _AppLifeCycleManagerState extends State<AppLifeCycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    try {
      switch (state) {
        case AppLifecycleState.paused:
          print("paused");
          break;
        case AppLifecycleState.resumed:
          print("resumed");
          break;
        case AppLifecycleState.inactive:
          print("inactive");
          break;
        case AppLifecycleState.detached:
          print("detached");
          break;
      }

      if (state != AppLifecycleState.detached) {
        print("OPEN");
        widget.child;
      } else {
        print("CLOSE");

        if (widget.user.isAnonymous) {
          print("ANONIM");
          print(widget.user);
          await widget.user.delete();
          print("CCCCcccc");
          print(await widget.user);
        }
      }
    } catch (e) {
      print("GAGAL");
      print(e);
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
