import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/main.dart';
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
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final User firebaseUser;
  const HomePage({Key? key, required this.firebaseUser}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user = widget.firebaseUser;
  String imageOriURL = "";
  String imageRecomendationURL = "";

  // String pathNgrok = "https://ca00-112-215-172-129.ap.ngrok.io/face_detection";
  String pathNgrok = "https://kezia24.pythonanywhere.com/face_detection";

  File? _selectedImage;
  PickedFile? pickedImage;
  bool recommendationStatus = false;
  bool isRecommendationLoading = false;
  List listFaceUrl = [];
  List listFaceCategory = [];
  String testLink = "..............";
  String testCategory = "category";
  String testWarna = "warna";
  String testLipstik = "lipstik";
  List listLipstikFace = [];
  String testChosenLipstik = "chosen";
  int currentIndex = 0;
  List listFaceLipsArea = [];
  String testLipsArea = "area";
  List<dynamic> lipsArea = [];
  List listFaceArea = [];
  List<dynamic> faceArea = [];
  late Color lipColor;

// mlkit
  final FaceDetector _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  ));
  CustomPaint? _customPaint;
  String? _textMLKIT = "MLKIT";
  File? _displayImage;
  String _displayPath = "path";
  List listDownloadPath = [];
  List listFaceMLKit = [];
  List<Face> faceMLKit = [];
  late final painter;

  @override
  void dispose() {
    // TODO: implement dispose
    _faceDetector.close();
    super.dispose();
  }

  Future<void> processImage(
      final InputImage inputImage, List<dynamic> face) async {
    print("START PROSEESSS DETECTTTT");
    final faces = await _faceDetector.processImage(inputImage);
    print("- FACES");
    String text = "faces found: ${faces.length}\n\n";
    print("- TEXT");
    for (final face in await faces) {
      text += "face: ${face.boundingBox}\n\n";
    }
    print("- FOR");
    listFaceMLKit.add(await faces);
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

  Future<void> _download(String _url, List<dynamic> face) async {
    print("START DOWNLOADDD");
    final response = await http.get(Uri.parse(_url));

    // Get the image name
    final imageName = path.basename(_url);
    // Get the document directory path
    final appDir = await path_provider.getApplicationDocumentsDirectory();

    // This is the saved image path
    // You can use it to display the saved image later
    final localPath = path.join(appDir.path, imageName);
    print(localPath);
    print("END DOWNLOADDDD");
    // Downloading
    // final imageFile = File(localPath);
    // await imageFile.writeAsBytes(response.bodyBytes);

    // listDownloadPath.add(await localPath);
    setState(() {
      _displayPath = localPath;
    });

    print("START PROSEESSS DETECTTTT");
    final faces =
        await _faceDetector.processImage(InputImage.fromFilePath(_displayPath));
    print("- FACES");
    String text = "faces found: ${faces.length}\n\n";
    print("- TEXT");

    for (final face in faces) {
      text += "face: ${face.boundingBox}\n\n";
    }
    print("- FOR");
    listFaceMLKit.add(faces);
    _textMLKIT = text;
    // setState(() {
    //   _displayImage = imageFile;
    //   _displayPath = localPath;
    // });
    // print("SELESAII");
    // print(_displayImage);
    // print(_displayPath);
  }

  Future<void> imageFromCamera() async {
    pickedImage =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      recommendationStatus = false;
      _selectedImage = File(pickedImage!.path);
      listFaceUrl = [];
      listFaceCategory = [];
      testLink = "..............";
      testCategory = "category";
      testWarna = "warna";
      testLipstik = "lipstik";
      testChosenLipstik = "choosen";
      testLipsArea = "area";
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
      listFaceCategory = [];
      testLink = "..............";
      testCategory = "category";
      testWarna = "warna";
      testLipstik = "lipstik";
      listLipstikFace = [];
      testChosenLipstik = "choosen";
      testLipsArea = "area";
    }

    setState(() {});
  }

  Future<http.Response> getRecommendation(String oriURL, String oriName) async {
    print("start function");
    print(pathNgrok);
    Map data = {'oriURL': oriURL, 'oriName': oriName};
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

  void getLipstik(String kategoriKulit) {
    var tempMap = mapping_lists.where(
      (element) {
        // print("masuk");
        // print(element);
        // print("element");
        // print(element['id']);
        if (element['id'] == kategoriKulit) {
          // print("berhasil");
          return true;
        }
        // print("gagal");
        return false;
      },
    ).take(1);
    // print("dapat");
    testWarna = tempMap.first['warna'].toString();

    // print(tempMap.first['warna'].runtimeType);
    // print("panjang : " + tempMap.first['warna'].length.toString());

    var tempLipstik = [];
    listLipstikFace = [];
    tempMap.first['warna'].forEach((warna) {
      list_lipstik.forEach(
        (element) {
          if (element['kategori'] == warna) {
            listLipstikFace.add(element);
            // tempLipstik.add(element['nama_lipstik']);
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
    // testLipstik = tempLipstik.toString();
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
                  : (_selectedImage == null || recommendationStatus)
                      ? (imageRecomendationURL != "")
                          // ? Container(
                          //     width: 200,
                          //     height: 200,
                          //     decoration: BoxDecoration(
                          //       shape: BoxShape.rectangle,
                          //       border:
                          //           Border.all(color: Colors.green, width: 5),
                          //       image: DecorationImage(
                          //           image: NetworkImage(imageRecomendationURL),
                          //           fit: BoxFit.cover),
                          //     ),
                          //   )
                          ? CarouselSlider(
                              options: CarouselOptions(
                                height: 200.0,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) async {
                                  testLink = listFaceUrl[index];
                                  testCategory = listFaceCategory[index];
                                  testLipsArea =
                                      listFaceLipsArea[index].toString();
                                  lipsArea = listFaceLipsArea[index];
                                  faceArea = listFaceArea[index];
                                  var url = listFaceUrl[index];

                                  print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa");
                                  // _download(url);
                                  print("DOWNLAD DONEE");

                                  // processImage(
                                  //     InputImage.fromFilePath(_displayPath),
                                  //     faceArea);
                                  print("PROSES SELESAII");
                                  getLipstik(testCategory);
                                  // print("astagaaaaaa");
                                  // print(testCategory);
                                  // var tempMap = mapping_lists.where(
                                  //   (element) {
                                  //     print("masuk");
                                  //     print(element);
                                  //     print("element");
                                  //     print(element['id']);
                                  //     if (element['id'] == testCategory) {
                                  //       print("berhasil");
                                  //       return true;
                                  //     }
                                  //     print("gagal");
                                  //     return false;
                                  //   },
                                  // ).take(1);
                                  // print("dapat");
                                  // testWarna = tempMap.first['warna'].toString();
                                  faceMLKit = listFaceMLKit[index];
                                  print("MASUK PAINTER");
                                  painter =
                                      FaceDetectorPainter(faceMLKit, faceArea);

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
                                        border: Border.all(
                                            color: Colors.green, width: 5),
                                        image: DecorationImage(
                                            image: NetworkImage(url),
                                            fit: BoxFit.cover),
                                      ),
                                      child: CustomPaint(
                                        painter: painter,
                                      ),
                                      // child: CustomPaint(
                                      //   painter: LipsPainter(
                                      //       lips: lipsArea,
                                      //       face: faceArea,
                                      //       color: lipColor),
                                      // ),
                                    );
                                    // return FutureBuilder<ui.Image>(
                                    //     future: url,
                                    //     builder: (context, snapshot) {
                                    //       if (!snapshot.hasData) {
                                    //         return Container();
                                    //       }
                                    //       return SizedBox(
                                    //         width:
                                    //             snapshot.data!.width.toDouble(),
                                    //         height: snapshot.data!.height
                                    //             .toDouble(),
                                    //         child: CustomPaint(
                                    //           painter: FacePainter(
                                    //             snapshot.data!,
                                    //             lipsArea,
                                    //           ),
                                    //         ),
                                    //       );
                                    //     });
                                  },
                                );
                              }).toList(),
                            )
                          : reusablePhotoFrame(
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
              Text(testLink),
              Text(testCategory),
              Text(testWarna),
              Text(_textMLKIT!),
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
              Text(testChosenLipstik),
              Text(testLipsArea),
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
                        setState(() {});
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.parse(buffer.toString(), radix: 16)),
                          border: currentIndex == index
                              ? Border.all(color: Colors.black, width: 5)
                              : Border(),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
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
              ElevatedButton(
                onPressed: () async {
                  print("button start");
                  setState(() {
                    isRecommendationLoading = true;
                  });
                  imageOriURL = await DatabaseService.uploadImage(pickedImage!);
                  print("upload");
                  DatabaseService.createOrUpdateListImagesOri(user.uid,
                      imageURL: imageOriURL);
                  print("aaaaaaaaaa");
                  final res = await getRecommendation(
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
                      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                      print(val['listAreaLips'].toString());
                      listFaceLipsArea = val['listAreaLips'];
                      testLipsArea = listFaceLipsArea[0].toString();
                      lipsArea = listFaceLipsArea[0];
                      print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
                      print(val['listAreaFaces'].toString());
                      listFaceArea = val['listAreaFaces'];

                      // download image

                      print("downloaddd");
                      var counterIndex = 0;
                      for (String url in listFaceUrl) {
                        faceArea = listFaceArea[counterIndex];
                        await _download(url, faceArea);
                        counterIndex++;
                      }
                      print("selesaii downloadd");
                      print(listDownloadPath);

                      print("detecttt");

                      // for (String path in listDownloadPath) {
                      //   counterIndex++;
                      // }
                      // counterIndex--;
                      // for (String path in listDownloadPath) {
                      //   print("path");
                      //   print(path);
                      //   String tempPath = listDownloadPath[counterIndex];
                      //   print("temp path");
                      //   print(tempPath);
                      //   faceArea = listFaceArea[counterIndex];

                      //   await processImage(
                      //       InputImage.fromFilePath(File(tempPath).path),
                      //       faceArea);
                      // }
                      print("selesaii detecttttt");

                      // SET FIRST
                      faceArea = listFaceArea[0];
                      faceMLKit = listFaceMLKit[0];
                      print("MASUK PAINTER");
                      painter = FaceDetectorPainter(faceMLKit, faceArea);
                    }
                  } else {
                    print("no face detected");
                  }

                  print(res.toString());
                  print(imageRecomendationURL);
                  setState(() {
                    isRecommendationLoading = false;
                  });
                },
                child: const Text("Cari Rekomendasi"),
              ),
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
