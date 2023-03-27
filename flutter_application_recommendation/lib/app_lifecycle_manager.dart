import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';

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
  late User user = widget.user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("LIFE CYCLEEEEEE");
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    // try {
    // switch (state) {
    //   case AppLifecycleState.paused:
    //     print("paused");
    //     break;
    //   case AppLifecycleState.resumed:
    //     print("resumed");
    //     break;
    //   case AppLifecycleState.inactive:
    //     print("inactive");
    //     break;
    //   case AppLifecycleState.detached:
    //     print("detached");
    //     break;
    // }
    try {
      if (state == AppLifecycleState.detached) {
        if (user.isAnonymous) {
          print("ANONYM");
          await AuthServices.logOut();
          print("LOGOUT");
        }
      }
    } catch (error) {
      print("ERROR");
      print(error.toString());
    }

    // if (state != AppLifecycleState.detached) {
    //   print("OPEN");
    //   widget.child;
    // } else {
    //   print("CLOSE");

    //   if (user.isAnonymous) {
    //     print("ANONIM");
    //     print(user);

    //     try {
    //       print("TRY");
    //       // await user.delete();
    //       await AuthServices.logOut();

    //       print("TRY END");
    //     } catch (error) {
    //       print("ERROR");
    //       print(error);
    //     }
    //     print(user);
    //     print("DDDDDd");
    //     print("LLL");
    //     print("DELETED");
    //   }
    // }
    // // } catch (e) {
    // //   print("GAGAL");
    // //   print(e);
    // //   print("error");
    // // }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
