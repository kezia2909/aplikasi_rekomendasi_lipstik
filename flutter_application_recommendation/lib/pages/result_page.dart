import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/pages/login_from_anonymous_page.dart';
import 'package:flutter_application_recommendation/pages/registration_from_anonymous_page.dart';
import 'package:flutter_application_recommendation/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/services/painter_lips_service.dart';
import 'package:flutter_application_recommendation/utils/face_detector_painter.dart';
import 'package:flutter_application_recommendation/services/database_service.dart';

import '../utils/color_utils.dart';

// PRIVATE
class ResultPage extends StatefulWidget {
  final User firebaseUser;

  const ResultPage({Key? key, required this.firebaseUser}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late User user = widget.firebaseUser;
  int tempIndex = 0;
  TextEditingController textFieldNameHistoryController =
      TextEditingController();
  var snackBar = SnackBar(
    content: const Text('Yay! A SnackBar!'),
  );
  String temp = "baru";

  late double sizeFrame;
  late double sizePadding;

  @override
  void dispose() {
    // TODO: implement dispose
    textFieldNameHistoryController.dispose();
    super.dispose();
  }

  Future<void> modalSaveEditLogin(BuildContext context, bool statusSave) async {
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
                  child:
                      statusSave ? Text("Edit History") : Text('Save History')),
              IconButton(
                color: colorTheme(colorBlack),
                padding: EdgeInsets.all(0),
                alignment: Alignment.topRight,
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                  textFieldNameHistoryController.clear();
                },
              ),
            ],
          ),
          content: TextField(
            controller: textFieldNameHistoryController,
            decoration: InputDecoration(
                hintText: "history name",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorTheme(colorBlack)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorTheme(colorBlack)),
                )),
          ),
          actions: <Widget>[
            statusSave
                ? reusableButtonLog(
                    context,
                    "SUBMIT",
                    colorTheme(colorAccent),
                    colorTheme(colorWhite),
                    () async {
                      print(textFieldNameHistoryController.text);
                      listSaved[tempIndex] = true;
                      if (textFieldNameHistoryController.text !=
                          listNameHistory[tempIndex]) {
                        if (await DatabaseService.checkHistoryRekomendasi(
                            userId: user.uid,
                            nameHistory: textFieldNameHistoryController.text)) {
                          var message = "Sorry the name is already used";
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
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          if (await DatabaseService.createHistoryRekomendasi(
                              // lipsArea, lipsLabel, lipsCluster,
                              faceArea,
                              userId: user.uid,
                              nameHistory: textFieldNameHistoryController.text,
                              faceUrl: listFaceUrl[tempIndex],
                              faceCategory: listFaceCategory[tempIndex])) {
                            DatabaseService.deleteHistoryRekomendasi(user.uid,
                                nameHistory: listNameHistory[tempIndex]);
                            print("SNACKBARRRRRRRRRR");
                            listSaved[tempIndex] = true;
                            Navigator.pop(context);
                            var message = "History Edited";
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
                            listNameHistory[tempIndex] =
                                textFieldNameHistoryController.text;
                          }
                        }
                      } else {
                        Navigator.pop(context);
                        var message = "History Edited";
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
                        listNameHistory[tempIndex] =
                            textFieldNameHistoryController.text;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      textFieldNameHistoryController.clear();
                      setState(() {
                        // textFieldNameHistoryController.
                      });
                    },
                  )
                : reusableButtonLog(
                    context,
                    "SUBMIT",
                    colorTheme(colorAccent),
                    colorTheme(colorWhite),
                    () async {
                      print(textFieldNameHistoryController.text);

                      listNameHistory[tempIndex] =
                          textFieldNameHistoryController.text;

                      if (await DatabaseService.checkHistoryRekomendasi(
                          userId: user.uid,
                          nameHistory: textFieldNameHistoryController.text)) {
                        var message = "Sorry the name is already used";
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

                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        print("mlkit");
                        print(faceMLKit.toString());
                        print(
                            "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW");
                        print(lipsArea);
                        print(lipsLabel);
                        print(lipsCluster);
                        print(faceArea);
                        if (await DatabaseService.createHistoryRekomendasi(
                            // lipsArea, lipsLabel, lipsCluster,
                            faceArea,
                            userId: user.uid,
                            nameHistory: textFieldNameHistoryController.text,
                            faceUrl: listFaceUrl[tempIndex],
                            faceCategory: listFaceCategory[tempIndex])) {
                          print("SNACKBARRRRRRRRRR");
                          listSaved[tempIndex] = true;
                          Navigator.pop(context);
                          var message = "History Saved";
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
                        }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      textFieldNameHistoryController.clear();

                      print("NOOOOOOOOOO");
                      setState(() {});
                    },
                  ),
          ],
        );
      },
    );
  }

  Future<void> modalSaveEditNotLogin(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
            buttonPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            actionsOverflowButtonSpacing: 0.0,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text('Sign In / Sign Up')),
                IconButton(
                  color: colorTheme(colorBlack),
                  padding: EdgeInsets.all(0),
                  alignment: Alignment.topRight,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                    textFieldNameHistoryController.clear();
                  },
                ),
              ],
            ),
            content: Text(
              'Please sign in to your account / sign up new account to save your data',
              style: TextStyle(color: colorTheme(colorBlack)),
            ),
            // content: TextField(
            //   controller: textFieldNameHistoryController,
            //   decoration: InputDecoration(hintText: "Text Field in Dialog"),
            // ),

            actions: <Widget>[
              reusableButtonLog(
                context,
                "Get started",
                colorTheme(colorAccent),
                colorTheme(colorWhite),
                () async {
                  Navigator.pop(context);
                  user = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationFromAnonymousPage(
                                firebaseUser: user,
                              )));
                  setState(() {});
                  // user = Provider.of<User?>(context);

                  setState(() {});
                },
              ),
              SizedBox(
                height: 10,
              ),
              reusableButtonLog(
                context,
                "I already have an account",
                colorTheme(colorShadow),
                colorTheme(colorWhite),
                () async {
                  Navigator.pop(context);
                  user = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginFromAnonymousPage(
                                firebaseUser: user,
                              )));
                  setState(() {});
                  // user = Provider.of<User?>(context);

                  setState(() {});
                },
              ),
            ]);
      },
    );
  }

// START WIDGET
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width <
        MediaQuery.of(context).size.height) {
      if (MediaQuery.of(context).size.width * 0.1 >= 40) {
        print("aaaaaa${MediaQuery.of(context).size.width}");
        sizePadding = 40;
        // sizePadding = MediaQuery.of(context).size.width * 0.1;
      } else {
        print("bbbbbbbbbbb${MediaQuery.of(context).size.width}");
        sizePadding = MediaQuery.of(context).size.width * 0.1;
      }
      sizeFrame = (MediaQuery.of(context).size.width - sizePadding * 2);
    } else {
      if (MediaQuery.of(context).size.height >= 700) {
        print("aaaaaa${MediaQuery.of(context).size.height}");
        sizeFrame = 350;
      } else {
        print("bbbbbbbbbbb${MediaQuery.of(context).size.height}");
        sizeFrame = MediaQuery.of(context).size.height * 0.5;
      }
      sizePadding = (MediaQuery.of(context).size.width - sizeFrame) / 2;
    }
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: colorTheme(colorHighlight),
        foregroundColor: colorTheme(colorAccent),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Result",
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(sizePadding, 10, sizePadding, 0),
            child: Column(
              children: <Widget>[
                Text(
                    "$countFace face detected (face : ${tempIndex + 1}/$countFace)",
                    style: TextStyle(
                        color: colorTheme(colorBlack),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
                CarouselSlider(
                  options: CarouselOptions(
                    height: sizeFrame,
                    aspectRatio: 1 / 1,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) async {
                      tempIndex = index;
                      testLink = listFaceUrl[index];
                      testCategory = listFaceCategory[index];

                      faceArea = listFaceArea[index];
                      var url = listFaceUrl[index];

                      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa");
                      print("DOWNLAD DONEE");

                      print("PROSES SELESAII");
                      getLipstik(testCategory);

                      // WEB GAK BISA
                      if (kIsWeb) {
                        testLipsArea = listFaceLipsArea[index].toString();
                        lipsArea = listFaceLipsArea[index];
                        lipsLabel = listFaceLipsLabel[index];
                        lipsCluster = listFaceLipsCluster[index];
                      } else {
                        faceMLKit = listFaceMLKit[index];
                        print("MASUK PAINTER");
                        painter = FaceDetectorPainter(
                            faceMLKit, faceArea, lipColor, sizeFrame, 5.0);
                      }

                      setState(() {});
                    },
                  ),
                  items: listFaceUrl.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: sizeFrame,
                          height: sizeFrame,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: colorTheme(colorBlack), width: 5),
                            image: DecorationImage(
                                image: NetworkImage(url), fit: BoxFit.cover),
                          ),
                          child: kIsWeb
                              ? CustomPaint(
                                  painter: LipsPainter(
                                      lips: lipsArea,
                                      lipsLabel: lipsLabel,
                                      lipsCluster: lipsCluster,
                                      face: faceArea,
                                      color: lipColor,
                                      sizeForScale: sizeFrame),
                                )
                              : CustomPaint(
                                  painter: FaceDetectorPainter(faceMLKit,
                                      faceArea, lipColor, sizeFrame, 5.0),
                                ),
                        );
                      },
                    );
                  }).toList(),
                ),
                // Text(testLink),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: listFaceUrl.map((url) {
                    int index = listFaceUrl.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tempIndex == index
                            ? colorTheme(colorAccent)
                            : colorTheme(colorMidtone),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 20,
                ),

                Text(
                  "Skin Type : ${listFaceCategory[tempIndex]}",
                  style: TextStyle(
                      color: colorTheme(colorBlack),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: listLipstikFace.map((element) {
                      int index = listLipstikFace.indexOf(element);
                      String hexString = element['kode_warna'];

                      // FOR PALLETE
                      final buffer = StringBuffer();
                      if (hexString.length == 6 || hexString.length == 7)
                        buffer.write('ff');
                      buffer.write(hexString.replaceFirst('#', ''));

                      // FOR LIPS
                      final bufferLip = StringBuffer();
                      if (hexString.length == 6 || hexString.length == 7)
                        bufferLip.write('99');
                      bufferLip.write(hexString.replaceFirst('#', ''));
                      return GestureDetector(
                        onTap: () {
                          testChosenLipstik = element['nama_lipstik'];
                          currentIndex = index;
                          lipColor =
                              Color(int.parse(bufferLip.toString(), radix: 16));

                          setState(() {
                            // _customPaint = CustomPaint(
                            //   painter: FaceDetectorPainter(
                            //       faceMLKit, faceArea, lipColor),
                            // );
                          });
                        },
                        child: Container(
                          width: sizeFrame / 5,
                          height: sizeFrame / 5,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Color(int.parse(buffer.toString(), radix: 16)),
                            border: currentIndex == index
                                ? Border.all(
                                    color: colorTheme(colorBlack), width: 5)
                                : Border(),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Text(
                  testChosenLipstik,
                  style: TextStyle(
                      color: colorTheme(colorBlack),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                // (listSaved[tempIndex])
                //     ? Text(
                //         "Name : ${listNameHistory[tempIndex]}",
                //         style: TextStyle(
                //             color: colorTheme(colorBlack),
                //             fontSize: 15,
                //             fontWeight: FontWeight.bold),
                //         textAlign: TextAlign.center,
                //       )
                //     : Text(
                //         "Not save",
                //         style: TextStyle(
                //             color: colorTheme(colorBlack),
                //             fontSize: 15,
                //             fontWeight: FontWeight.bold),
                //         textAlign: TextAlign.center,
                //       ),
                // gak login gak bisa simpan
                // (!user.isAnonymous)
                //     ? (!listSaved[tempIndex])
                //         ? ElevatedButton(
                //             child: Text("Simpan"),
                //             onPressed: () {
                //               modalSaveEditLogin(
                //                   context, listSaved[tempIndex]);
                //             })
                //         : ElevatedButton(
                //             child: Text("Edit"),
                //             onPressed: () {
                //               textFieldNameHistoryController.text =
                //                   listNameHistory[tempIndex];
                //               modalSaveEditLogin(
                //                   context, listSaved[tempIndex]);
                //             })
                //     : Container()
                (!listSaved[tempIndex])
                    ? reusableButtonLog(context, "SAVE",
                        colorTheme(colorAccent), colorTheme(colorWhite), () {
                        if (!user.isAnonymous) {
                          modalSaveEditLogin(context, listSaved[tempIndex]);
                        } else {
                          modalSaveEditNotLogin(context);
                        }
                      })
                    : reusableButtonLog(
                        context,
                        "EDIT \"${listNameHistory[tempIndex]}\"",
                        colorTheme(colorDark),
                        colorTheme(colorWhite), () {
                        textFieldNameHistoryController.text =
                            listNameHistory[tempIndex];
                        modalSaveEditLogin(context, listSaved[tempIndex]);
                      }),
                // (!listSaved[tempIndex])
                //     ? ElevatedButton(
                //         child: Text("save"),
                //         onPressed: () {
                //           if (!user.isAnonymous) {
                //             modalSaveEditLogin(context, listSaved[tempIndex]);
                //           } else {
                //             modalSaveEditNotLogin(context);
                //           }
                //         })
                //     : ElevatedButton(
                //         child: Text("Edit"),
                //         onPressed: () {
                //           textFieldNameHistoryController.text =
                //               listNameHistory[tempIndex];
                //           modalSaveEditLogin(context, listSaved[tempIndex]);
                //         }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
