import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/pages/login_from_anonymous_page.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/services/painter_lips_service.dart';
import 'package:flutter_application_recommendation/utils/face_detector_painter.dart';
import 'package:flutter_application_recommendation/services/database_service.dart';

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
          title: Text('TextField in Dialog'),
          content: TextField(
            controller: textFieldNameHistoryController,
            decoration: InputDecoration(hintText: "Text Field in Dialog"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
                textFieldNameHistoryController.clear();
              },
            ),
            statusSave
                ? ElevatedButton(
                    child: Text('Edit'),
                    onPressed: () async {
                      print(textFieldNameHistoryController.text);
                      listSaved[tempIndex] = true;
                      if (textFieldNameHistoryController.text !=
                          listNameHistory[tempIndex]) {
                        if (await DatabaseService.checkHistoryRekomendasi(
                            userId: user.uid,
                            nameHistory: textFieldNameHistoryController.text)) {
                          snackBar = SnackBar(
                            content: const Text(
                                'Maaf history dengan nama tersebut sudah ada'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                            snackBar = SnackBar(
                              content: const Text('History berhasil diedit'),
                            );
                            listNameHistory[tempIndex] =
                                textFieldNameHistoryController.text;
                          }
                        }
                      } else {
                        Navigator.pop(context);
                        snackBar = SnackBar(
                          content: const Text('History berhasil diedit'),
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
                : ElevatedButton(
                    child: Text('Save'),
                    onPressed: () async {
                      print(textFieldNameHistoryController.text);

                      listNameHistory[tempIndex] =
                          textFieldNameHistoryController.text;

                      if (await DatabaseService.checkHistoryRekomendasi(
                          userId: user.uid,
                          nameHistory: textFieldNameHistoryController.text)) {
                        snackBar = SnackBar(
                          content: const Text(
                              'Maaf history dengan nama tersebut sudah ada'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                          snackBar = SnackBar(
                            content: const Text('History berhasil dibuat'),
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
            title: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            content: Text('Login/regist to save your data'),
            // content: TextField(
            //   controller: textFieldNameHistoryController,
            //   decoration: InputDecoration(hintText: "Text Field in Dialog"),
            // ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('LOGIN'),
                onPressed: () async {
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
              ElevatedButton(
                child: Text('REGIST'),
                onPressed: () {
                  // Navigator.pop(context);
                },
              ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                // Text("Pilihan Warna Untukmu"),
                Text(user.uid),
                // Text(temp),
                Text(user.isAnonymous ? "ANONYMOUSLY" : "USER"),

                Text("${countFace} face detected"),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
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
                        painter =
                            FaceDetectorPainter(faceMLKit, faceArea, lipColor);
                      }

                      setState(() {});
                    },
                  ),
                  items: listFaceUrl.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            // border: Border.all(
                            //     color: Colors.green, width: 0),
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
                                      color: lipColor),
                                )
                              : CustomPaint(
                                  painter: FaceDetectorPainter(
                                      faceMLKit, faceArea, lipColor),
                                ),
                        );
                      },
                    );
                  }).toList(),
                ),
                // Text(testLink),
                SizedBox(
                  height: 20,
                ),
                Text(testChosenLipstik),
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
                        bufferLip.write('80');
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
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Color(int.parse(buffer.toString(), radix: 16)),
                            border: currentIndex == index
                                ? Border.all(color: Colors.black, width: 5)
                                : Border(),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
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
                    ? ElevatedButton(
                        child: Text("save"),
                        onPressed: () {
                          if (!user.isAnonymous) {
                            modalSaveEditLogin(context, listSaved[tempIndex]);
                          } else {
                            modalSaveEditNotLogin(context);
                          }
                        })
                    : ElevatedButton(
                        child: Text("Edit"),
                        onPressed: () {
                          textFieldNameHistoryController.text =
                              listNameHistory[tempIndex];
                          modalSaveEditLogin(context, listSaved[tempIndex]);
                        }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
