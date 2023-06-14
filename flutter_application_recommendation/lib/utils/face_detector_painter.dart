import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/utils/coordinates_painter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorPainter extends CustomPainter {
  final List<Face> faces;
  final List<dynamic> face;
  final Color color;
  final double sizeForScale;
  final double sizeBorder;
  // final Size absoluteImageSize;

  var scaleW;
  var scaleH;
  // final Size absoluteImageSize;
  // final InputImageRotation rotation;

  // FaceDetectorPainter(this.faces, this.absoluteImageSize, this.rotation);
  FaceDetectorPainter(
      this.faces, this.face, this.color, this.sizeForScale, this.sizeBorder);

  @override
  void paint(final Canvas canvas, final Size size) {
    print("mlkit : $faces");
    print("area : $face");

    scaleW = sizeForScale / face[2];
    scaleH = sizeForScale / face[3];
    // scaleH = 1.0;
    // scaleW = 1.0;

    for (final Face face in faces) {
      print(
          "LTRB : ${face.boundingBox.left}, ${face.boundingBox.top}, ${face.boundingBox.right}, ${face.boundingBox.bottom}");
      print("landmarks : ${face.landmarks}");
      print("contours : ${face.contours}");

      void paintNewFill() {
        var path = Path();
        var path2 = Path();
        var paint = Paint()
          ..color = color.withOpacity(0.8)
          ..strokeWidth = 1;

        var paint2 = Paint()
          ..color = Colors.transparent
          ..strokeWidth = 1;
        final faceContour1 = face.contours[FaceContourType.upperLipTop];
        final faceContour2 = face.contours[FaceContourType.upperLipBottom];
        final faceContour3 = face.contours[FaceContourType.lowerLipTop];
        final faceContour4 = face.contours[FaceContourType.lowerLipBottom];

        // final faceContour3 = face.contours[type3];
        // final faceContour4 = face.contours[type4];
        path.moveTo(
          faceContour1!.points[0].x.toDouble() * scaleW - sizeBorder,
          faceContour1.points[0].y.toDouble() * scaleH - sizeBorder,
        );
        for (int i = 1; i <= 10; i++) {
          path.lineTo(
            faceContour1.points[i].x.toDouble() * scaleW - sizeBorder,
            faceContour1.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }
        for (int i = 8; i >= 0; i--) {
          path.lineTo(
            faceContour2!.points[i].x.toDouble() * scaleW - sizeBorder,
            faceContour2.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }

        path.moveTo(
          faceContour2!.points[0].x.toDouble() * scaleW - sizeBorder,
          faceContour2.points[0].y.toDouble() * scaleH - sizeBorder,
        );
        for (int i = 8; i >= 0; i--) {
          path.lineTo(
            faceContour3!.points[i].x.toDouble() * scaleW - sizeBorder,
            faceContour3.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }
        path.lineTo(
          faceContour2.points[8].x.toDouble() * scaleW - sizeBorder,
          faceContour2.points[8].y.toDouble() * scaleH - sizeBorder,
        );
        path.lineTo(
          faceContour1.points[10].x.toDouble() * scaleW - sizeBorder,
          faceContour1.points[10].y.toDouble() * scaleH - sizeBorder,
        );
        for (int i = 0; i <= 8; i++) {
          path.lineTo(
            faceContour4!.points[i].x.toDouble() * scaleW - sizeBorder,
            faceContour4.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }
        path.lineTo(
          faceContour1.points[0].x.toDouble() * scaleW - sizeBorder,
          faceContour1.points[0].y.toDouble() * scaleH - sizeBorder,
        );
        canvas.drawPath(path, paint);
      }

      void paintFaceFill() {
        var path = Path();
        var paint = Paint()
          ..color = Color.fromRGBO(241, 209, 188, 0.2)
          // ..color = color.withOpacity(0.5)
          ..strokeWidth = 1;

        // rgb(241, 209, 188)
        final faceContour = face.contours[FaceContourType.face];
        final rightEyebrowTopContour =
            face.contours[FaceContourType.rightEyebrowTop];
        final leftEyebrowTopContour =
            face.contours[FaceContourType.leftEyebrowTop];
        final rightEyebrowBottomContour =
            face.contours[FaceContourType.rightEyebrowBottom];
        final rightEyeContour = face.contours[FaceContourType.rightEye];
        final leftEyeContour = face.contours[FaceContourType.leftEye];
        final leftEyebrowBottomContour =
            face.contours[FaceContourType.leftEyebrowBottom];
        final upperLipTopContour = face.contours[FaceContourType.upperLipTop];
        final lowerLipBottomContour =
            face.contours[FaceContourType.lowerLipBottom];

        // dahi
        path.moveTo(
          faceContour!.points[0].x.toDouble() * scaleW - sizeBorder,
          faceContour.points[0].y.toDouble() * scaleH - sizeBorder,
        );

        for (int i = 1; i <= 7; i++) {
          path.lineTo(
            faceContour!.points[i].x.toDouble() * scaleW - sizeBorder,
            faceContour.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }

        for (int i = 0; i <= 4; i++) {
          path.lineTo(
            rightEyebrowTopContour!.points[i].x.toDouble() * scaleW -
                sizeBorder,
            rightEyebrowTopContour.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }

        for (int i = 4; i >= 0; i--) {
          path.lineTo(
            leftEyebrowTopContour!.points[i].x.toDouble() * scaleW - sizeBorder,
            leftEyebrowTopContour.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }

        for (int i = 29; i <= 35; i++) {
          path.lineTo(
            faceContour!.points[i].x.toDouble() * scaleW - sizeBorder,
            faceContour.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }

        path.lineTo(
          faceContour.points[0].x.toDouble() * scaleW - sizeBorder,
          faceContour.points[0].y.toDouble() * scaleH - sizeBorder,
        );

        // alis dan mata
        // kanan
        path.moveTo(
          rightEyebrowTopContour!.points[4].x.toDouble() * scaleW - sizeBorder,
          rightEyebrowTopContour.points[4].y.toDouble() * scaleH - sizeBorder,
        );
        for (int i = 4; i >= 0; i--) {
          path.lineTo(
            rightEyebrowBottomContour!.points[i].x.toDouble() * scaleW -
                sizeBorder,
            rightEyebrowBottomContour.points[i].y.toDouble() * scaleH -
                sizeBorder,
          );
        }
        path.lineTo(
          rightEyebrowTopContour!.points[0].x.toDouble() * scaleW - sizeBorder,
          rightEyebrowTopContour.points[0].y.toDouble() * scaleH - sizeBorder,
        );
        path.lineTo(
          faceContour!.points[7].x.toDouble() * scaleW - sizeBorder,
          faceContour.points[7].y.toDouble() * scaleH - sizeBorder,
        );
        for (int i = 8; i >= 0; i--) {
          path.lineTo(
            rightEyeContour!.points[i].x.toDouble() * scaleW - sizeBorder,
            rightEyeContour.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }
        // kiri
        for (int i = 8; i >= 0; i--) {
          path.lineTo(
            leftEyeContour!.points[i].x.toDouble() * scaleW - sizeBorder,
            leftEyeContour.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }
        path.lineTo(
          faceContour.points[29].x.toDouble() * scaleW - sizeBorder,
          faceContour.points[29].y.toDouble() * scaleH - sizeBorder,
        );
        path.lineTo(
          leftEyebrowTopContour!.points[0].x.toDouble() * scaleW - sizeBorder,
          leftEyebrowTopContour.points[0].y.toDouble() * scaleH - sizeBorder,
        );
        for (int i = 0; i <= 4; i++) {
          path.lineTo(
            leftEyebrowBottomContour!.points[i].x.toDouble() * scaleW -
                sizeBorder,
            leftEyebrowBottomContour.points[i].y.toDouble() * scaleH -
                sizeBorder,
          );
        }
        path.lineTo(
          leftEyebrowTopContour.points[4].x.toDouble() * scaleW - sizeBorder,
          leftEyebrowTopContour.points[4].y.toDouble() * scaleH - sizeBorder,
        );

        // pipi dan hidung
        // kanan
        path.moveTo(
          rightEyeContour!.points[0].x.toDouble() * scaleW - sizeBorder,
          rightEyeContour.points[0].y.toDouble() * scaleH - sizeBorder,
        );
        for (int i = 15; i >= 8; i--) {
          path.lineTo(
            rightEyeContour.points[i].x.toDouble() * scaleW - sizeBorder,
            rightEyeContour.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }
        for (int i = 7; i <= 11; i++) {
          path.lineTo(
            faceContour.points[i].x.toDouble() * scaleW - sizeBorder,
            faceContour.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }
        for (int i = 10; i >= 0; i--) {
          path.lineTo(
            upperLipTopContour!.points[i].x.toDouble() * scaleW - sizeBorder,
            upperLipTopContour.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }
        for (int i = 25; i <= 29; i++) {
          path.lineTo(
            faceContour.points[i].x.toDouble() * scaleW - sizeBorder,
            faceContour.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }
        path.lineTo(
          leftEyeContour!.points[0].x.toDouble() * scaleW - sizeBorder,
          leftEyeContour.points[0].y.toDouble() * scaleH - sizeBorder,
        );
        for (int i = 15; i >= 8; i--) {
          path.lineTo(
            leftEyeContour.points[i].x.toDouble() * scaleW - sizeBorder,
            leftEyeContour.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }

        // dagu
        path.moveTo(
          upperLipTopContour!.points[10].x.toDouble() * scaleW - sizeBorder,
          upperLipTopContour.points[10].y.toDouble() * scaleH - sizeBorder,
        );
        for (int i = 11; i <= 25; i++) {
          path.lineTo(
            faceContour.points[i].x.toDouble() * scaleW - sizeBorder,
            faceContour.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }
        path.lineTo(
          upperLipTopContour.points[0].x.toDouble() * scaleW - sizeBorder,
          upperLipTopContour.points[0].y.toDouble() * scaleH - sizeBorder,
        );
        for (int i = 8; i >= 0; i--) {
          path.lineTo(
            lowerLipBottomContour!.points[i].x.toDouble() * scaleW - sizeBorder,
            lowerLipBottomContour.points[i].y.toDouble() * scaleH - sizeBorder,
          );
        }
        path.lineTo(
          upperLipTopContour.points[10].x.toDouble() * scaleW - sizeBorder,
          upperLipTopContour.points[10].y.toDouble() * scaleH - sizeBorder,
        );
        // gambar
        canvas.drawPath(path, paint);
      }

      // paintFaceFill();

      paintNewFill();
    }
  }

  @override
  bool shouldRepaint(final FaceDetectorPainter oldDelegate) {
    // TODO: implement shouldRepaint

    return oldDelegate.faces != faces ||
        oldDelegate.color != color ||
        oldDelegate.face != face;
  }
}
