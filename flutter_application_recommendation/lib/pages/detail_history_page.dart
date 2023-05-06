import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/services/painter_lips_service.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';
import 'package:flutter_application_recommendation/utils/face_detector_painter.dart';

// PRIVATE
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
  // late double size;

  late double sizeFrame;
  late double sizePadding;
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
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
      appBar: AppBar(
        backgroundColor: colorTheme(colorHighlight),
        foregroundColor: colorTheme(colorAccent),
        elevation: 0,
        centerTitle: true,
        title: Text(
          nameHistory,
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
                // Text("Name : \"$nameHistory\"",
                //     style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 20,
                //         fontWeight: FontWeight.w500),
                //     textAlign: TextAlign.center),
                // SizedBox(
                //   height: 10,
                // ),
                Container(
                  width: sizeFrame,
                  height: sizeFrame,
                  // width: size,
                  // height: size,
                  // width: MediaQuery.of(context).size.width * 0.8,
                  // height: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border:
                        Border.all(color: colorTheme(colorBlack), width: 5.0),
                    image: DecorationImage(
                        image: NetworkImage(faceUrl), fit: BoxFit.cover),
                  ),
                  child: kIsWeb
                      ? Container()
                      : CustomPaint(
                          painter: FaceDetectorPainter(
                              faceMLKit, faceArea, lipColor, sizeFrame, 5.0),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Skin Type : $faceCategory",
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
                Text(
                  testChosenLipstik,
                  style: TextStyle(
                      color: colorTheme(colorBlack),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
