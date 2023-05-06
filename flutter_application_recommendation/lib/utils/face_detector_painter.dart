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
          ..color = color
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
