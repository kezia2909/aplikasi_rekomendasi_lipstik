import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/services/painter_lips_service.dart';
import 'package:flutter_application_recommendation/utils/face_detector_painter.dart';

class DetailHistoryPage extends StatefulWidget {
  final String nameHistory;
  final String faceUrl;
  final String faceCategory;

  const DetailHistoryPage(
      {Key? key,
      required this.nameHistory,
      required this.faceUrl,
      required this.faceCategory})
      : super(key: key);

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  late String nameHistory = widget.nameHistory;
  late String faceUrl = widget.faceUrl;
  late String faceCategory = widget.faceCategory;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
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
                      listFaceArea = [];
                      Navigator.pop(context);
                    },
                  ),
                ),
                Text("Detail $nameHistory"),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    // border: Border.all(
                    //     color: Colors.green, width: 0),
                    image: DecorationImage(
                        image: NetworkImage(faceUrl), fit: BoxFit.cover),
                  ),
                  child: kIsWeb
                      ? Container()
                      : CustomPaint(
                          painter: FaceDetectorPainter(
                              faceMLKit, faceArea, lipColor),
                        ),
                ),
                Text(faceCategory),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
