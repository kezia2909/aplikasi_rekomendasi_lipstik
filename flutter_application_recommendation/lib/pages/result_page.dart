import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/services/painter_lips_service.dart';
import 'package:flutter_application_recommendation/utils/face_detector_painter.dart';

class ResultPage extends StatefulWidget {
  final User firebaseUser;
  const ResultPage({Key? key, required this.firebaseUser}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late User user = widget.firebaseUser;

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
                Text("Pilihan Warna Untukmu"),
                Text("${countFace} face detected"),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) async {
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
                Text(testLink),
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
                (!user.isAnonymous)
                    ? ElevatedButton(child: Text("Simpan"), onPressed: () {})
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
