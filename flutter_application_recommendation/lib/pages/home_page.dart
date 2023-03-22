import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/main.dart';
import 'package:flutter_application_recommendation/pages/guidebook_page.dart';
import 'package:flutter_application_recommendation/pages/history_page.dart';
import 'package:flutter_application_recommendation/pages/result_page.dart';
import 'package:flutter_application_recommendation/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/services/database_service.dart';
import 'package:flutter_application_recommendation/services/painter_lips_service.dart';
import 'package:flutter_application_recommendation/services/painter_service.dart';
import 'package:flutter_application_recommendation/utils/face_detector_painter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

String testLink = "..............";
List listFaceUrl = [];
String testCategory = "category";
int countFace = 0;

List listSaved = [];
List listNameHistory = [];

List listFaceCategory = [];
List listFaceArea = [];
List<dynamic> faceArea = [];
String testWarna = "warna";
String testLipstik = "lipstik";
List listLipstikFace = [];
String testChosenLipstik = "chosen";
int currentIndex = 0;

late Color lipColor;

String testLipsArea = "area";
List<dynamic> lipsArea = [];
List<dynamic> lipsLabel = [];
List<dynamic> lipsCluster = [];

List listFaceLipsArea = [];
List listFaceLipsLabel = [];
List listFaceLipsCluster = [];

// mlkit
List listFaceMLKit = [];
List<Face> faceMLKit = [];
var painter;

void getLipstik(String kategoriKulit) {
  print("START GET LIPSTIK");
  var tempMap = mapping_lists.where(
    (element) {
      if (element['id'] == kategoriKulit) {
        return true;
      }
      return false;
    },
  ).take(1);
  testWarna = tempMap.first['warna'].toString();

  var tempLipstik = [];
  listLipstikFace = [];
  tempMap.first['warna'].forEach((warna) {
    list_lipstik.forEach(
      (element) {
        if (element['kategori'] == warna) {
          listLipstikFace.add(element);
        }
      },
    );
  });
  testLipstik = listLipstikFace.toString();
  testChosenLipstik = listLipstikFace.first['nama_lipstik'];

  String hexString = listLipstikFace.first['kode_warna'];
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('80');
  buffer.write(hexString.replaceFirst('#', ''));
  lipColor = Color(int.parse(buffer.toString(), radix: 16));
  currentIndex = 0;

  print(testChosenLipstik);
}

// mlkit
final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
  enableContours: true,
  enableClassification: true,
));
String? _textMLKIT = "MLKIT";
List listDownloadPath = [];

Future<void> processImage(
    final InputImage inputImage, List<dynamic> face) async {
  print("START PROSEESSS DETECTTTT");
  final faces = await _faceDetector.processImage(inputImage);
  print("- FACES");
  String text = "faces found: ${faces.length}\n\n";
  print("- TEXT");
  for (final face in faces) {
    text += "face: ${face.boundingBox}\n\n";
  }
  print("- FOR");
  listFaceMLKit.add(faces);
  // listSizeAbsolute.add(inputImage.inputImageData!.size);

  _textMLKIT = text;

  // print("MASUK PAINTER");
  // final painter = FaceDetectorPainter(faces, face
  //     // inputImage.inputImageData!.size,
  //     // inputImage.inputImageData!.imageRotation,
  //     );
  // _customPaint = CustomPaint(
  //   painter: painter,
  // );
  // if (inputImage.inputImageData?.size != null) {
  //   print("MASUK PAINTER");
  //   final painter = FaceDetectorPainter(faces, face
  //       // inputImage.inputImageData!.size,
  //       // inputImage.inputImageData!.imageRotation,
  //       );
  //   _customPaint = CustomPaint(
  //     painter: painter,
  //   );
  // } else {
  //   print("GAGAL MASUK");
  // }
  print(await "END PROSEESSS DETECTTTT");
}

Future<void> download(String _url) async {
  print("START DOWNLOADDD");
  final response = await http.get(Uri.parse(_url));
  // final response = await http.get(Uri.https(_url, ''));
  // var uri = Uri.https(_url, '');
  // var response = await http.get(
  //   uri,
  //   headers: {
  //     // "Content-Type": "application/json",
  //     "Access-Control-Allow-Origin": "*",
  //     'Accept': '*/*'
  //   },
  // );
  print("response done");

  // final response = await http.get(
  //   Uri.parse(_url),
  //   headers: {
  //     // "Content-Type": "application/json",
  //     "Access-Control-Allow-Origin": "*",
  //     'Accept': '*/*'
  //   },
  // );
  // Get the image name
  final imageName = path.basename(_url);
  print(imageName);
  // Get the document directory path
  final appDir = await path_provider.getApplicationDocumentsDirectory();
  print(appDir);
  // This is the saved image path
  // You can use it to display the saved image later
  final localPath = await path.join(appDir.path, imageName);
  print(localPath);
  // Downloading
  final imageFile = File(localPath);
  print("imageFile done");
  await imageFile.writeAsBytes(response.bodyBytes);
  print("download");

  listDownloadPath.add(await localPath);
  // setState(() {
  //   _displayImage = imageFile;
  //   _displayPath = localPath;
  // });
  // print("SELESAII");
  // print(_displayImage);
  // print(_displayPath);
  print(await "END DOWNLOADDDD");
}

// late User global_firebaseUser;

class HomePage extends StatefulWidget {
  final User firebaseUser;
  const HomePage({Key? key, required this.firebaseUser}) : super(key: key);
  // const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user = widget.firebaseUser;
  String imageOriURL = "";
  String imageRecomendationURL = "";

  // String pathNgrok = "https://16b7-140-213-40-19.ap.ngrok.io/face_detection";
  String pathNgrok = "https://kezia24.pythonanywhere.com/face_detection";

  File? _selectedImage;
  PickedFile? pickedImage;
  bool recommendationStatus = false;
  bool isRecommendationLoading = false;

  late bool check_using_lips;

// mlkit

  CustomPaint? _customPaint;
  File? _displayImage;
  String _displayPath = "path";

  List listSizeAbsolute = [];
  var sizeAbsolute;

  @override
  void setState(ui.VoidCallback fn) {
    // TODO: implement setState
    // global_firebaseUser = user;
    kIsWeb ? check_using_lips = true : check_using_lips = false;
    super.setState(fn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _faceDetector.close();
    super.dispose();
  }

  Future<void> imageFromCamera() async {
    pickedImage =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      recommendationStatus = false;
      _selectedImage = File(pickedImage!.path);
      listFaceUrl = [];
      listSaved = [];
      listNameHistory = [];
      listFaceCategory = [];
      testLink = "..............";
      testCategory = "category";
      testWarna = "warna";
      testLipstik = "lipstik";
      testChosenLipstik = "choosen";
      testLipsArea = "area";
      listDownloadPath = [];
      listFaceMLKit = [];
      listSizeAbsolute = [];
      listFaceArea = [];
    }
    setState(() {});
  }

  Future<void> imageFromGallery() async {
    pickedImage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      recommendationStatus = false;
      _selectedImage = File(pickedImage!.path);
      listFaceUrl = [];
      listSaved = [];
      listNameHistory = [];
      listFaceCategory = [];
      testLink = "..............";
      testCategory = "category";
      testWarna = "warna";
      testLipstik = "lipstik";
      listLipstikFace = [];
      testChosenLipstik = "choosen";
      testLipsArea = "area";
      listDownloadPath = [];
      listFaceMLKit = [];
      listSizeAbsolute = [];
      listFaceArea = [];
    }

    setState(() {});
  }

  Future<http.Response> getRecommendation(
      String userId, String oriURL, String oriName) async {
    print("start function");
    print(pathNgrok);
    Map data = {
      'userId': userId,
      'oriURL': oriURL,
      'oriName': oriName,
      'check_using_lips': check_using_lips
    };
    print("map data");
    var body = json.encode(data);
    print("encode data");
    var response = await http.post(Uri.parse(pathNgrok),
        headers: {
          "Content-Type": "application/json",
          // "Access-Control-Allow-Origin": "*",
          // 'Accept': '*/*'
        },
        body: body);
    print("response done");
    print(response);
    return response;
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Maaf tidak terdeteksi wajah pada gambar'),
          content: const Text(
              'silahkan upload ulang gambar sesuai dengan panduan yang tersedia'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                setState(() {
                  pickedImage = null;
                  _selectedImage = null;
                });
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Guidebook'),
              onPressed: () {
                setState(() {
                  pickedImage = null;
                  _selectedImage = null;
                });
                Navigator.of(context).pop();

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GuidebookPage()));
              },
            ),
            // TextButton(
            //   style: TextButton.styleFrom(
            //     textStyle: Theme.of(context).textTheme.labelLarge,
            //   ),
            //   child: const Text('Close'),
            //   onPressed: () {
            //     print(_selectedImage);
            //     // _selectedImage!.delete();

            //     setState(() {
            //       pickedImage = null;
            //       _selectedImage = null;
            //     });
            //     print("deleteee");
            //     print(_selectedImage);
            //     Navigator.of(context).pop();
            //   },
            // ),
            // TextButton(
            //   style: TextButton.styleFrom(
            //     textStyle: Theme.of(context).textTheme.labelLarge,
            //   ),
            //   child: const Text('Guidebook'),
            //   onPressed: () {
            //     setState(() {
            //       pickedImage = null;
            //       _selectedImage = null;
            //     });
            //     Navigator.of(context).pop();
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => GuidebookPage()));
            //   },
            // ),
          ],
        );
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
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      // Navigator.pop(context);
                    },
                  ),
                  (!user.isAnonymous)
                      ? IconButton(
                          icon: Icon(Icons.history),
                          onPressed: () {
                            recommendationStatus = false;
                            // _selectedImage = File(pickedImage!.path);
                            listFaceUrl = [];
                            listSaved = [];
                            listNameHistory = [];
                            listFaceCategory = [];
                            testLink = "..............";
                            testCategory = "category";
                            testWarna = "warna";
                            testLipstik = "lipstik";
                            listLipstikFace = [];
                            testChosenLipstik = "choosen";
                            testLipsArea = "area";
                            listDownloadPath = [];
                            listFaceMLKit = [];
                            listSizeAbsolute = [];
                            listFaceArea = [];
                            print("Look history");
                            print(listDownloadPath);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HistoryPage(firebaseUser: user)));
                          },
                        )
                      : Container(),
                ],
              ),
              Text(user.uid),
              Text(user.isAnonymous ? "ANONIM" : "USER"),

              const SizedBox(
                height: 30,
              ),
              // CarouselSlider(
              //   options: CarouselOptions(height: 400.0),
              //   items: [1, 2, 3, 4, 5].map((i) {
              //     return Builder(
              //       builder: (BuildContext context) {
              //         return Container(
              //             width: MediaQuery.of(context).size.width,
              //             margin: EdgeInsets.symmetric(horizontal: 5.0),
              //             decoration: BoxDecoration(color: Colors.amber),
              //             child: Text(
              //               'text $i',
              //               style: TextStyle(fontSize: 16.0),
              //             ));
              //       },
              //     );
              //   }).toList(),
              // ),
              (isRecommendationLoading)
                  ? Center(child: CircularProgressIndicator())
                  // : (_selectedImage == null || recommendationStatus)
                  // ? (imageRecomendationURL != "")
                  //     ? CarouselSlider(
                  //         options: CarouselOptions(
                  //           height: 200.0,
                  //           enableInfiniteScroll: false,
                  //           onPageChanged: (index, reason) async {
                  //             testLink = listFaceUrl[index];
                  //             testCategory = listFaceCategory[index];

                  //             faceArea = listFaceArea[index];
                  //             var url = listFaceUrl[index];

                  //             print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa");
                  //             print("DOWNLAD DONEE");

                  //             print("PROSES SELESAII");
                  //             getLipstik(testCategory);

                  //             // WEB GAK BISA
                  //             if (kIsWeb) {
                  //               testLipsArea =
                  //                   listFaceLipsArea[index].toString();
                  //               lipsArea = listFaceLipsArea[index];
                  //               lipsLabel = listFaceLipsLabel[index];
                  //               lipsCluster = listFaceLipsCluster[index];
                  //             } else {
                  //               faceMLKit = listFaceMLKit[index];
                  //               print("MASUK PAINTER");
                  //               painter = FaceDetectorPainter(
                  //                   faceMLKit, faceArea, lipColor);
                  //             }

                  //             setState(() {});
                  //           },
                  //         ),
                  //         items: listFaceUrl.map((url) {
                  //           return Builder(
                  //             builder: (BuildContext context) {
                  //               return Container(
                  //                 width: 200,
                  //                 height: 200,
                  //                 decoration: BoxDecoration(
                  //                   shape: BoxShape.rectangle,
                  //                   image: DecorationImage(
                  //                       image: NetworkImage(url),
                  //                       fit: BoxFit.cover),
                  //                 ),
                  //                 child: kIsWeb
                  //                     ? CustomPaint(
                  //                         painter: LipsPainter(
                  //                             lips: lipsArea,
                  //                             lipsLabel: lipsLabel,
                  //                             lipsCluster: lipsCluster,
                  //                             face: faceArea,
                  //                             color: lipColor),
                  //                       )
                  //                     : CustomPaint(
                  //                         painter: FaceDetectorPainter(
                  //                             faceMLKit,
                  //                             faceArea,
                  //                             lipColor),
                  //                       ),
                  //               );
                  //             },
                  //           );
                  //         }).toList(),
                  //       )
                  //     : reusablePhotoFrame(
                  //         Image.asset(
                  //           "assets/images/model.png",
                  //           fit: BoxFit.cover,
                  //         ),
                  //       )
                  : (_selectedImage == null || pickedImage == null)
                      ? reusablePhotoFrame(
                          Image.asset(
                            "assets/images/model.png",
                            fit: BoxFit.cover,
                          ),
                        )
                      : kIsWeb
                          ? reusablePhotoFrame(
                              Image.network(
                                _selectedImage!.path,
                                fit: BoxFit.cover,
                              ),
                            )
                          : reusablePhotoFrame(
                              Image.file(
                                File(_selectedImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
              // Text(testLink),
              // Text(testCategory),
              // Text(testWarna),
              // Text(_textMLKIT!),
              // Text(listLipstikFace.toString()),
              // (listLipstikFace.isNotEmpty)
              //     ? CarouselSlider(
              //         options: CarouselOptions(
              //           height: 50.0,
              //           enableInfiniteScroll: false,
              //           viewportFraction: 0.1,
              //           initialPage: (listLipstikFace.length / 2).toInt(),
              //           onPageChanged: (index, reason) async {
              //             setState(() {});
              //           },
              //         ),
              //         items: listLipstikFace.map((element) {
              //           // var tempColor = "0xff";
              //           // tempColor += element['kode_warna'];
              //           String hexString = element['kode_warna'];
              //           // tempColor = "#b76384";
              //           final buffer = StringBuffer();
              //           if (hexString.length == 6 || hexString.length == 7)
              //             buffer.write('ff');
              //           buffer.write(hexString.replaceFirst('#', ''));
              //           // buffer.write(tempColor);
              //           // buffer.write(tempColor.replaceFirst('#', ''));
              //           // Color(int.parse(buffer.toString(), radix: 16));

              //           return Builder(
              //             builder: (BuildContext context) {
              //               return Container(
              //                 width: 50,
              //                 height: 50,
              //                 decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: Color(
              //                       int.parse(buffer.toString(), radix: 16)),
              //                   // border: Border.all(
              //                   //     color: Color(int.parse(buffer.toString(),
              //                   //         radix: 16)),
              //                   //     width: 5),
              //                 ),
              //               );
              //             },
              //           );
              //         }).toList(),
              //       )
              //     : Text("NO LIPSTIK AVAILABLE"),
              // Text(testChosenLipstik),
              // Text(testLipsArea),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: listLipstikFace.map((element) {
              //       int index = listLipstikFace.indexOf(element);
              //       String hexString = element['kode_warna'];

              //       // FOR PALLETE
              //       final buffer = StringBuffer();
              //       if (hexString.length == 6 || hexString.length == 7)
              //         buffer.write('ff');
              //       buffer.write(hexString.replaceFirst('#', ''));

              //       // FOR LIPS
              //       final bufferLip = StringBuffer();
              //       if (hexString.length == 6 || hexString.length == 7)
              //         bufferLip.write('80');
              //       bufferLip.write(hexString.replaceFirst('#', ''));
              //       return GestureDetector(
              //         onTap: () {
              //           testChosenLipstik = element['nama_lipstik'];
              //           currentIndex = index;
              //           lipColor =
              //               Color(int.parse(bufferLip.toString(), radix: 16));

              //           setState(() {
              //             // _customPaint = CustomPaint(
              //             //   painter: FaceDetectorPainter(
              //             //       faceMLKit, faceArea, lipColor),
              //             // );
              //           });
              //         },
              //         child: Container(
              //           width: 50,
              //           height: 50,
              //           margin: EdgeInsets.symmetric(
              //               vertical: 10.0, horizontal: 2.0),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Color(int.parse(buffer.toString(), radix: 16)),
              //             border: currentIndex == index
              //                 ? Border.all(color: Colors.black, width: 5)
              //                 : Border(),
              //           ),
              //         ),
              //       );
              //     }).toList(),
              //   ),
              // ),
              const SizedBox(
                height: 30,
              ),
              const Text("Tentukan Foto"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          imageFromCamera();
                          String testLink = "..............";

                          setState(() {});
                        },
                        child: const Icon(Icons.photo_camera_outlined),
                      ),
                      Text("Kamera")
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          imageFromGallery();
                          String testLink = "..............";

                          setState(() {});
                        },
                        child: const Icon(Icons.photo_camera_outlined),
                      ),
                      Text("Galeri")
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              (_selectedImage != null && pickedImage != null)
                  ? ElevatedButton(
                      onPressed: () async {
                        print("button start");
                        setState(() {
                          listFaceArea = [];
                          listDownloadPath = [];
                          isRecommendationLoading = true;
                        });
                        imageOriURL = await DatabaseService.uploadImage(
                            user.uid, pickedImage!);
                        print("upload");
                        DatabaseService.createOrUpdateListImagesOri(user.uid,
                            imageURL: imageOriURL);
                        print("aaaaaaaaaa");
                        final res = await getRecommendation(user.uid,
                            imageOriURL, _selectedImage!.path.split('/').last);
                        print("responseeee");
                        print(res.runtimeType);
                        // final val = jsonDecode(res.body);
                        // print(val['urlNew'].toString());
                        final val = jsonDecode(res.body);
                        print("vallll");
                        print(val);

                        if (val['faceDetected']) {
                          // if (val['urlNew'] != "") {
                          if (val['listFaceUrl'][0] != "") {
                            print("masukk");
                            print(val['listFaceUrl']);
                            listFaceUrl = val['listFaceUrl'];
                            countFace = listFaceUrl.length;

                            listSaved = [
                              for (var i = 0; i < countFace; i++) false
                            ];
                            listNameHistory = [
                              for (var i = 0; i < countFace; i++) ""
                            ];

                            listFaceCategory = val['listFaceCategory'];
                            print(listFaceUrl);
                            print(listFaceUrl.length);
                            print(listFaceUrl[0]);
                            recommendationStatus = true;
                            // imageRecomendationURL = val['urlNew'];
                            imageRecomendationURL = listFaceUrl[0];

                            testLink = listFaceUrl[0];
                            testCategory = listFaceCategory[0];
                            print(testCategory);

                            getLipstik(testCategory);

                            print(
                                "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
                            print(val['listAreaFaces'].toString());
                            listFaceArea = val['listAreaFaces'];
                            faceArea = listFaceArea[0];

                            if (kIsWeb) {
                              print(
                                  "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                              print(val['listAreaLips'].toString());
                              listFaceLipsArea = val['listAreaLips'];
                              testLipsArea = listFaceLipsArea[0].toString();
                              lipsArea = listFaceLipsArea[0];
                              listFaceLipsLabel = val['listLabels'];
                              lipsLabel = listFaceLipsLabel[0];
                              listFaceLipsCluster = val['listChoosenCluster'];
                              lipsCluster = listFaceLipsCluster[0];
                            } else {
                              // download image
                              print("downloaddd");
                              // WEB GAK BISA
                              for (String url in listFaceUrl) {
                                await download(url);
                                setState(() {});
                              }
                              print("selesaii downloadd");
                              print(listDownloadPath);

                              print("detecttt");
                              var counterIndex = 0;
                              // WEB GAK BISA
                              for (String path in listDownloadPath) {
                                print("path");
                                print(path);
                                String tempPath =
                                    listDownloadPath[counterIndex];
                                print("temp path");
                                print(tempPath);
                                print("list face");
                                print(listFaceArea);
                                print(counterIndex);
                                faceArea = listFaceArea[counterIndex];

                                await processImage(
                                    InputImage.fromFilePath(
                                        File(tempPath).path),
                                    faceArea);
                                counterIndex++;
                              }
                              print(counterIndex.toString());
                              print(listFaceMLKit.toString());

                              // SET FIRST
                              faceMLKit = listFaceMLKit[0];
                              faceArea = listFaceArea[0];
                              // sizeAbsolute = listSizeAbsolute[0];
                              // WEB GAK BISAprint("MASUK PAINTER");
                              painter = FaceDetectorPainter(
                                  faceMLKit, faceArea, lipColor);
                            }
                          }
                        } else {
                          print("no face detected");
                        }

                        print(res.toString());
                        print(imageRecomendationURL);
                        setState(() {
                          isRecommendationLoading = false;
                          if (val['faceDetected']) {
                            pickedImage = null;
                            _selectedImage = null;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResultPage(
                                          firebaseUser: user,
                                        )));
                          } else {
                            print("OHHHHHHH NOOOOOOO");
                            _dialogBuilder(context);
                            print("OHHHHHHH NOOOOOOO 2");
                          }
                        });
                      },
                      child: const Text("Cari Rekomendasi"),
                    )
                  : Container(),
              // ElevatedButton(
              //     child: Text("result"),
              //     onPressed: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => ResultPage()));
              //     }),
              ElevatedButton(
                  child: Text("LOG OUT"),
                  onPressed: () async {
                    await AuthServices.logOut();
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}
