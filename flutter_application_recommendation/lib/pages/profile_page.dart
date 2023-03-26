import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';
import 'package:flutter_application_recommendation/services/database_service.dart';

class ProfilePage extends StatefulWidget {
  final User firebaseUser;

  const ProfilePage({Key? key, required this.firebaseUser}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double sizePadding;

  late User user = widget.firebaseUser;
  var dataUser;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // stream: usersCollection.doc(user.uid).snapshots(),
  Stream<DocumentSnapshot<Object?>> onCurrentUserChanged() {
    setState(() {});
    return usersCollection.doc(user.uid).snapshots();
  }

  var snackBar = SnackBar(
    content: const Text('Yay! A SnackBar!'),
  );

  TextEditingController textFieldEditController = TextEditingController();

  Future<void> modalEditData(BuildContext context, String type) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
            // actionsPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            buttonPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            // actionsAlignment: MainAxisSize.max,
            actionsOverflowButtonSpacing: 0.0,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: (type == "firstname")
                        ? Text('Edit First Name')
                        : (type == "lastname")
                            ? Text('Edit Last Name')
                            : (type == "email")
                                ? Text('Edit Email')
                                : (type == "password")
                                    ? Text('Edit Password')
                                    : Container()),
                IconButton(
                  color: colorTheme(colorBlack),
                  padding: EdgeInsets.all(0),
                  alignment: Alignment.topRight,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                    textFieldEditController.clear();
                  },
                ),
              ],
            ),
            // content: Text('Edit Name'),

            content: TextField(
              controller: textFieldEditController,
              decoration: InputDecoration(
                  hintText: type,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorTheme(colorBlack)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorTheme(colorBlack)),
                  )),
            ),
            actions: <Widget>[
              reusableButtonLog(context, "SUBMIT", colorTheme(colorAccent),
                  colorTheme(colorWhite), () async {
                var data = textFieldEditController.text;
                if (type == "email") {
                  try {
                    print("TRY EDIT");

                    await user.updateEmail(data);
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .update({
                      type: data,
                    });
                    var message = "Edit $type successfull";
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
                    setState(() {});
                    Navigator.pop(context);
                  } catch (error) {
                    var message = "error";

                    print("ERROR EDIT");
                    print(user);
                    print(error);
                    switch (await error.toString()) {
                      case "[firebase_auth/unknown] Given String is empty or null":
                        print('ERORR ZERO');
                        message = "Please input email";
                        break;
                      case "[firebase_auth/invalid-email] The email address is badly formatted.":
                        message = "Email is not valid";
                        break;
                      case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
                        message = "Email is already used";
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
                  }
                } else if (type == "password") {
                  try {
                    print("TRY EDIT");

                    await user.updatePassword(data);
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .update({
                      type: data,
                    });
                    var message = "Edit $type successfull";
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
                    setState(() {});
                    Navigator.pop(context);
                  } catch (error) {
                    var message = "error";

                    print("ERROR EDIT");
                    print(user);
                    print(error);
                    switch (await error.toString()) {
                      case "[firebase_auth/unknown] Given String is empty or null":
                        print('ERORR ZERO');
                        message = "Please input password";
                        break;
                      case "[firebase_auth/weak-password] Password should be at least 6 characters":
                        message = "Password at least 6 characters";
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
                  }
                } else {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update({
                    type: data,
                  });
                  var message = "Edit $type successfull";
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
                  Navigator.pop(context);
                }

                onCurrentUserChanged();

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              })
            ]);
      },
    );
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState

    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width <
        MediaQuery.of(context).size.height) {
      if (MediaQuery.of(context).size.width * 0.1 >= 20) {
        print("aaaaaa${MediaQuery.of(context).size.width}");
        sizePadding = 20;
        // sizePadding = MediaQuery.of(context).size.width * 0.1;
      } else {
        print("bbbbbbbbbbb${MediaQuery.of(context).size.width}");
        sizePadding = MediaQuery.of(context).size.width * 0.1;
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorTheme(colorHighlight),
        foregroundColor: colorTheme(colorAccent),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: colorTheme(colorHighlight)),
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: onCurrentUserChanged(),
            // stream: usersCollection.doc(user.uid).snapshots(),
            builder: (context, snapshot) {
              return Padding(
                padding: EdgeInsets.fromLTRB(sizePadding, 10, sizePadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    reusableDataProfile(Icons.person, "First Name",
                        "${snapshot.data!['firstname']}", () {
                      textFieldEditController.text =
                          snapshot.data!['firstname'];
                      modalEditData(context, "firstname");
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    reusableDataProfile(Icons.person, "Last Name",
                        "${snapshot.data!['lastname']}", () {
                      textFieldEditController.text = snapshot.data!['lastname'];
                      modalEditData(context, "lastname");
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    reusableDataProfile(
                        Icons.email, "Email", "${snapshot.data!['email']}", () {
                      textFieldEditController.text =
                          "${snapshot.data!['email']}";
                      modalEditData(context, "email");
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    reusableDataProfile(
                        Icons.lock, "Password", "${snapshot.data!['password']}",
                        () {
                      textFieldEditController.text =
                          "${snapshot.data!['password']}";
                      modalEditData(context, "password");
                    }),
                    SizedBox(
                      height: 30,
                    ),
                    reusableButtonLog(
                        context,
                        "SIGN OUT",
                        colorTheme(colorAccent),
                        colorTheme(colorWhite), () async {
                      await AuthServices.logOut();
                    })
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
