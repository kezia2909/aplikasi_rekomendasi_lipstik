import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/detail_history_page.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_recommendation/services/database_service.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';
import 'package:flutter_application_recommendation/utils/face_detector_painter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// START PRIVATE

class HistoryPage extends StatefulWidget {
  final User firebaseUser;

  const HistoryPage({Key? key, required this.firebaseUser}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late User user = widget.firebaseUser;
  late double sizePadding;

  final _searchHistoryController = TextEditingController();
  Stream<QuerySnapshot<Object?>> onSearch() {
    setState(() {});
    return DatabaseService.getHistoryRekomendasi(_searchHistoryController.text,
        userId: user.uid);
  }

  var snackBar = SnackBar(
    content: const Text('Warning!'),
  );

  Future<void> _deleteHistory(BuildContext context, String name) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
          buttonPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text('Confirm Delete')),
              IconButton(
                padding: EdgeInsets.all(0),
                alignment: Alignment.topRight,
                icon: Icon(
                  Icons.close,
                  color: colorTheme(colorBlack),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete history of \"$name\"?",
            style: TextStyle(color: colorTheme(colorBlack)),
          ),
          actions: <Widget>[
            // ElevatedButton(
            //   child: Text('CANCEL'),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ),
            reusableButtonLog(
              context,
              "DELETE",
              colorTheme(colorAccent),
              colorTheme(colorWhite),
              () async {
                if (await DatabaseService.deleteHistoryRekomendasi(user.uid,
                    nameHistory: name)) {
                  // snackBar = SnackBar(
                  //   content: Text('History $name berhasil didelete'),
                  // );
                  var message = "History \"$name\" delete successfully";
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
                } else {
                  var message = "History $name delete failed";
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
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetHistory(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Yakin mau reset?'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('DELETE'),
              onPressed: () async {
                if (await DatabaseService.resetHistoryRekomendasi(user.uid)) {
                  snackBar = SnackBar(
                    content: Text('History berhasil direset'),
                  );
                } else {
                  snackBar = SnackBar(
                    content: Text('History gagal direset'),
                  );
                }
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _searchHistoryController.addListener(onSearch);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchHistoryController.dispose();

    super.dispose();
  }

// START WIDGET
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
          "History",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: colorTheme(colorHighlight)),

        // child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(sizePadding, 10, sizePadding, 0),
          child: Column(
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     IconButton(
              //       icon: Icon(Icons.arrow_back),
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //     ),
              //     ElevatedButton(
              //       child: Text("Reset History"),
              //       onPressed: () {
              //         _resetHistory(context);
              //       },
              //     ),
              //   ],
              // ),
              // reusableTextFieldLog("Search History", Icons.search, false,
              //     _searchHistoryController),
              TextField(
                controller: _searchHistoryController,
                onChanged: (String value) {
                  onSearch();
                },
                style: TextStyle(color: colorTheme(colorWhite)),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorTheme(colorWhite),
                  ),
                  labelText: "Search History",
                  labelStyle: TextStyle(color: colorTheme(colorWhite)),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: colorTheme(colorDark).withOpacity(0.5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: history.length,
              //     itemBuilder: (context, index) {
              //       return Container(
              //         color: (index % 2 == 0) ? Colors.grey : Colors.white,
              //         padding: EdgeInsets.all(10.0),
              //         child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Text(history[index]),
              //               Row(
              //                 children: [
              //                   Icon(Icons.info_rounded),
              //                   Icon(Icons.delete)
              //                 ],
              //               ),
              //             ]),
              //       );
              //     },
              //   ),
              // ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: onSearch(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Data Error");
                      } else if (snapshot.hasData || snapshot.data != null) {
                        if (snapshot.data!.size == 0) {
                          return Text("Data Not Found");
                        } else {
                          return ListView.separated(
                            itemBuilder: (context, index) {
                              DocumentSnapshot historyData =
                                  snapshot.data!.docs[index];
                              String name = historyData['nameHistory'];
                              String url = historyData['faceUrl'];
                              String category = historyData['faceCategory'];
                              List<dynamic> area = historyData['faceArea'];
                              return Container(
                                decoration: BoxDecoration(
                                  // border: Border.all(width: 3.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0) //
                                          ),
                                  color:
                                      colorTheme(colorWhite).withOpacity(0.8),
                                  // color: (index % 2 == 0)
                                  //     ? colorTheme(colorMidtone)
                                  //         .withOpacity(0.5)
                                  //     : colorTheme(colorShadow)
                                  //         .withOpacity(0.5),
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: colorTheme(colorBlack),
                                      radius: 36,
                                      child: CircleAvatar(
                                          backgroundColor:
                                              colorTheme(colorShadow),
                                          radius: 35,
                                          backgroundImage: NetworkImage(url)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(name,
                                              style: TextStyle(
                                                  color: colorTheme(colorBlack),
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.left),
                                          Text(category,
                                              style: TextStyle(
                                                  color: colorTheme(colorBlack),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300),
                                              textAlign: TextAlign.left),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: colorTheme(colorRed),
                                              size: 30),
                                          onPressed: () {
                                            _deleteHistory(context, name);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.arrow_forward_ios,
                                              color: colorTheme(colorDark),
                                              size: 30),
                                          onPressed: () async {
                                            print(
                                                "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCAAAAAAAAAAAaaaa==================BBBBBBBBBBB");
                                            getLipstik(category);
                                            if (kIsWeb) {
                                              print("WEBBB");
                                            } else {
                                              print("start download");
                                              listDownloadPath = [];
                                              listFaceMLKit = [];
                                              setState(() {});
                                              print(listDownloadPath);

                                              await download(url);
                                              setState(() {});

                                              print("selesaii downloadd");
                                              print(listDownloadPath);

                                              print("detecttt");
                                              var counterIndex = 0;
                                              // WEB GAK BISA
                                              for (String path
                                                  in listDownloadPath) {
                                                print("path");
                                                print(path);
                                                String tempPath =
                                                    listDownloadPath[
                                                        counterIndex];
                                                print("temp path");
                                                print(tempPath);
                                                print("list face");
                                                print(listFaceArea);
                                                print(counterIndex);
                                                faceArea = area;
                                                print(faceArea);
                                                // faceArea = await listFaceArea[
                                                //     counterIndex];

                                                await processImage(
                                                    InputImage.fromFilePath(
                                                        File(tempPath).path),
                                                    faceArea);
                                                counterIndex++;

                                                // SET FIRST
                                                faceMLKit = listFaceMLKit[0];
                                                // sizeAbsolute = listSizeAbsolute[0];
                                                // WEB GAK BISAprint("MASUK PAINTER");
                                                painter = FaceDetectorPainter(
                                                    faceMLKit,
                                                    faceArea,
                                                    lipColor,
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.8,
                                                    5.0);
                                              }
                                              setState(() {});
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailHistoryPage(
                                                  nameHistory: name,
                                                  faceUrl: url,
                                                  faceCategory: category,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 8.0),
                            itemCount: snapshot.data!.docs.length,
                          );
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.pinkAccent,
                          ),
                        ),
                      );
                    }
                    // return ListView.builder(
                    //   itemCount: history.length,
                    //   itemBuilder: (context, index) {
                    //     return Container(
                    //       color:
                    //           (index % 2 == 0) ? Colors.grey : Colors.white,
                    //       padding: EdgeInsets.all(10.0),
                    //       child: Row(
                    //           mainAxisAlignment:
                    //               MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Text(history[index]),
                    //             Row(
                    //               children: [
                    //                 Icon(Icons.info_rounded),
                    //                 Icon(Icons.delete)
                    //               ],
                    //             ),
                    //           ]),
                    //     );
                    //   },
                    // );
                    ),
              )
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
