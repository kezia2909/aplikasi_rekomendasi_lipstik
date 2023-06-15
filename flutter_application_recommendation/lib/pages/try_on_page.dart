import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/main.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/utils/camera_view.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';
import 'package:flutter_application_recommendation/utils/face_detector_try_on.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../utils/face_detector_painter.dart';

class TryOnPage extends StatefulWidget {
  const TryOnPage({Key? key}) : super(key: key);

  @override
  State<TryOnPage> createState() => _TryOnPageState();
}

class _TryOnPageState extends State<TryOnPage> {
  final FaceDetector _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  ));

  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  int currentIndexTryOn = 0;
  String currentLipstick = "40 - Witty";

  @override
  void dispose() {
    // TODO: implement dispose
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState

    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraView(
          title: "Virtual Try-On",
          customPaint: _customPaint,
          text: _text,
          onImage: (inputImage) {
            processImage(inputImage);
          },
          initialDirection: CameraLensDirection.front,
        ),
        Positioned(
          bottom: 25,
          left: 0,
          right: 0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: list_lipstik.map((element) {
                int index = list_lipstik.indexOf(element);
                String hexString = element['kode_warna'];
                String detail =
                    element['kode_lipstik'] + " - " + element['nama_lipstik'];

                // FOR PALLETE
                final buffer = StringBuffer();
                if (hexString.length == 6 || hexString.length == 7)
                  buffer.write('ff');
                buffer.write(hexString.replaceFirst('#', ''));

                // FOR LIPS
                final bufferLip = StringBuffer();
                if (hexString.length == 6 || hexString.length == 7)
                  bufferLip.write('ff');
                bufferLip.write(hexString.replaceFirst('#', ''));
                return GestureDetector(
                  onTap: () {
                    // testChosenLipstik = element['kode_lipstik'] +
                    //     " - " +
                    //     element['nama_lipstik'];
                    currentIndexTryOn = index;
                    currentLipstick = detail;
                    lipColorTryOn =
                        Color(int.parse(bufferLip.toString(), radix: 16));

                    setState(() {});
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 6,
                    height: MediaQuery.of(context).size.width / 6,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(int.parse(buffer.toString(), radix: 16)),
                      border: currentIndexTryOn == index
                          ? Border.all(color: colorTheme(colorBlack), width: 5)
                          : Border(),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Positioned(
                bottom: 15,
                child: Container(
                  decoration: BoxDecoration(color: lipColorTryOn),
                  alignment: Alignment.center,
                  child: Text(currentLipstick,
                      style: TextStyle(
                          color: colorTheme(colorBlack), fontSize: 20)),
                )),
          ],
        ),
      ],
    );
  }

  Future<void> processImage(final InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = "";
    });

    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorTryOn(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation,
          lipColorTryOn,
          MediaQuery.of(context).size);
      _customPaint = CustomPaint(
        painter: painter,
      );
    } else {
      String text = "faces found: ${faces.length}\n\n";
      for (final face in faces) {
        text += "face: ${face.contours}\n\n";
      }

      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
