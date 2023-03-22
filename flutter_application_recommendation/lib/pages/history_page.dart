import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/detail_history_page.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/services/database_service.dart';
import 'package:flutter_application_recommendation/utils/face_detector_painter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class HistoryPage extends StatefulWidget {
  final User firebaseUser;

  const HistoryPage({Key? key, required this.firebaseUser}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late User user = widget.firebaseUser;

  List<String> history = [
    "Alfa",
    "Bravo",
    "Charlie",
    "Delta",
    "Echo",
    "Foxtrot",
    "Golf",
    "Hotel",
    "India",
    "Juliett",
    "Kilo",
    "Lima",
    "Mike",
    "November",
    "Oscar",
    "Papa",
    "Quebec",
    "Romeo",
    "Sierra",
    "Tango",
    "Uniform",
    "Victor",
    "Whiskey",
    "X-ray",
    "Yankee",
    "Zulu"
  ];

  final _searchHistoryController = TextEditingController();
  Stream<QuerySnapshot<Object?>> onSearch() {
    setState(() {});
    return DatabaseService.getHistoryRekomendasi(_searchHistoryController.text,
        userId: user.uid);
  }

  var snackBar = SnackBar(
    content: const Text('Yay! A SnackBar!'),
  );

  Future<void> _deleteHistory(BuildContext context, String name) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Yakin mau delete?'),
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
                if (await DatabaseService.deleteHistoryRekomendasi(user.uid,
                    nameHistory: name)) {
                  snackBar = SnackBar(
                    content: Text('History $name berhasil didelete'),
                  );
                } else {
                  snackBar = SnackBar(
                    content: Text('History $name gagal didelete'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.1, 20, 0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text("Reset History"),
                    onPressed: () {
                      _resetHistory(context);
                    },
                  ),
                ],
              ),
              TextField(
                controller: _searchHistoryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'cari history',
                ),
                onChanged: (String value) {
                  onSearch();
                  // setState(() {});
                },
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
                                color: (index % 2 == 0)
                                    ? Colors.grey
                                    : Colors.white,
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(name),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.info_rounded),
                                          onPressed: () async {
                                            print(
                                                "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCAAAAAAAAAAAaaaa==================BBBBBBBBBBB");
                                            getLipstik(category);
                                            if (kIsWeb) {
                                            } else {
                                              print("start download");
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
                                                    lipColor);
                                              }
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
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            _deleteHistory(context, name);
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
