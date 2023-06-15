import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/utils/coordinates_try_on.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorTryOn extends CustomPainter {
  final List<Face> faces;
  final Size absoluteImageSize;
  final Size deviceSize;
  final InputImageRotation rotation;
  final Color color;

  FaceDetectorTryOn(this.faces, this.absoluteImageSize, this.rotation,
      this.color, this.deviceSize);

  var scaleWidth;
  var scaleHeight;

  @override
  void paint(final Canvas canvas, final Size size) {
    print("demo SIZE : , ${size.toString()}");
    print("demo ABSOLUTE : , ${absoluteImageSize.toString()}");
    print("demo DEVICE : , ${deviceSize.toString()}");
    print("demo FIRST : , ${faces.first.boundingBox.toString()}");
    // TODO: implement paint
    scaleWidth = size.width / absoluteImageSize.width;
    // scaleWidth = size.width / widthDevice;
    scaleHeight = size.height / absoluteImageSize.height;
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.blue;
    for (final Face face in faces) {
      // canvas.drawRect(
      //   // Rect.fromLTRB(
      //   //     face.boundingBox.left * scaleWidth,
      //   //     face.boundingBox.top * scaleHeight,
      //   //     face.boundingBox.right * scaleWidth,
      //   //     face.boundingBox.bottom * scaleHeight),
      //   Rect.fromLTRB(
      //     translateX(face.boundingBox.left, rotation, size, absoluteImageSize),
      //     translateY(face.boundingBox.top, rotation, size, absoluteImageSize),
      //     translateX(face.boundingBox.right, rotation, size, absoluteImageSize),
      //     translateY(
      //         face.boundingBox.bottom, rotation, size, absoluteImageSize),
      //   ),
      //   paint,
      // );
      // draw the blue circle for detected points of the face
      void paintContour(final FaceContourType type) {
        final faceContour = face.contours[type];
        if (faceContour?.points != null) {
          for (final Point point in faceContour!.points) {
            canvas.drawCircle(
                //     Offset(
                //         absoluteImageSize.width - point.x.toDouble() * scaleWidth,
                //         point.y.toDouble() * scaleHeight),
                //     1.0,
                //     paint);
                Offset(
                    translateX(
                        point.x.toDouble(), rotation, size, absoluteImageSize),
                    translateY(
                        point.y.toDouble(), rotation, size, absoluteImageSize)),
                1.0,
                paint);
          }
        }
      }

      void paintLine(final FaceContourType type) {
        final pointMode = ui.PointMode.polygon;
        final List<Offset> points = [];
        final paint = Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.black
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

        final faceContour = face.contours[type];
        if (faceContour?.points != null) {
          for (final Point point in faceContour!.points) {
            // points.add(Offset(point.x.toDouble() * scaleWidth,
            //     point.y.toDouble() * scaleHeight));
            points.add(Offset(
                translateX(
                    point.x.toDouble(), rotation, size, absoluteImageSize),
                translateY(
                    point.y.toDouble(), rotation, size, absoluteImageSize)));
          }
        }

        canvas.drawPoints(pointMode, points, paint);
      }

      void paintFill(
        final FaceContourType type1,
        final FaceContourType type2,
        // final FaceContourType type3,
        // final FaceContourType type4,
      ) {
        var path = Path();
        var paint = Paint()
          ..color = color
          ..strokeWidth = 1;
        final faceContour1 = face.contours[type1];
        final faceContour2 = face.contours[type2];
        // final faceContour3 = face.contours[type3];
        // final faceContour4 = face.contours[type4];

        int counter = 0;
        if (faceContour1?.points != null) {
          for (final Point point in faceContour1!.points) {
            if (counter == 0) {
              // path.moveTo(point.x.toDouble() * scaleWidth,
              //     point.y.toDouble() * scaleHeight);
              path.moveTo(
                  translateX(
                      point.x.toDouble(), rotation, size, absoluteImageSize),
                  translateY(
                      point.y.toDouble(), rotation, size, absoluteImageSize));
              counter = 1;
            } else {
              // path.lineTo(point.x.toDouble() * scaleWidth,
              //     point.y.toDouble() * scaleHeight);

              path.lineTo(
                  translateX(
                      point.x.toDouble(), rotation, size, absoluteImageSize),
                  translateY(
                      point.y.toDouble(), rotation, size, absoluteImageSize));
            }
          }
        }
        if (faceContour2?.points != null) {
          for (final Point point in faceContour2!.points) {
            // path.lineTo(point.x.toDouble() * scaleWidth,
            //     point.y.toDouble() * scaleHeight);

            path.lineTo(
                translateX(
                    point.x.toDouble(), rotation, size, absoluteImageSize),
                translateY(
                    point.y.toDouble(), rotation, size, absoluteImageSize));
          }
        }

        canvas.drawPath(path, paint);
      }

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
            translateX(faceContour1!.points[0].x.toDouble(), rotation, size,
                absoluteImageSize),
            translateY(faceContour1.points[0].y.toDouble(), rotation, size,
                absoluteImageSize));
        for (int i = 1; i <= 10; i++) {
          path.lineTo(
              translateX(faceContour1.points[i].x.toDouble(), rotation, size,
                  absoluteImageSize),
              translateY(faceContour1.points[i].y.toDouble(), rotation, size,
                  absoluteImageSize));
        }
        for (int i = 8; i >= 0; i--) {
          path.lineTo(
              translateX(faceContour2!.points[i].x.toDouble(), rotation, size,
                  absoluteImageSize),
              translateY(faceContour2.points[i].y.toDouble(), rotation, size,
                  absoluteImageSize));
        }

        path.moveTo(
            translateX(faceContour2!.points[0].x.toDouble(), rotation, size,
                absoluteImageSize),
            translateY(faceContour2.points[0].y.toDouble(), rotation, size,
                absoluteImageSize));
        for (int i = 8; i >= 0; i--) {
          path.lineTo(
              translateX(faceContour3!.points[i].x.toDouble(), rotation, size,
                  absoluteImageSize),
              translateY(faceContour3.points[i].y.toDouble(), rotation, size,
                  absoluteImageSize));
        }
        path.lineTo(
            translateX(faceContour2.points[8].x.toDouble(), rotation, size,
                absoluteImageSize),
            translateY(faceContour2.points[8].y.toDouble(), rotation, size,
                absoluteImageSize));
        path.lineTo(
            translateX(faceContour1.points[10].x.toDouble(), rotation, size,
                absoluteImageSize),
            translateY(faceContour1.points[10].y.toDouble(), rotation, size,
                absoluteImageSize));
        for (int i = 0; i <= 8; i++) {
          path.lineTo(
              translateX(faceContour4!.points[i].x.toDouble(), rotation, size,
                  absoluteImageSize),
              translateY(faceContour4.points[i].y.toDouble(), rotation, size,
                  absoluteImageSize));
        }
        path.lineTo(
            translateX(faceContour1.points[0].x.toDouble(), rotation, size,
                absoluteImageSize),
            translateY(faceContour1.points[0].y.toDouble(), rotation, size,
                absoluteImageSize));
        canvas.drawPath(path, paint);
      }

      // paintContour(FaceContourType.face);
      // paintContour(FaceContourType.leftEyebrowTop);
      // paintContour(FaceContourType.leftEyebrowBottom);
      // paintContour(FaceContourType.rightEyebrowTop);
      // paintContour(FaceContourType.rightEyebrowBottom);
      // paintContour(FaceContourType.leftEye);
      // paintContour(FaceContourType.rightEye);

      // paintFill(FaceContourType.upperLipTop, FaceContourType.lowerLipTop,
      //     FaceContourType.upperLipBottom, FaceContourType.lowerLipBottom);
      // paintFill(FaceContourType.upperLipTop, FaceContourType.upperLipBottom);
      // paintFill(FaceContourType.lowerLipTop, FaceContourType.lowerLipBottom);

      // paintLine(FaceContourType.upperLipTop);
      // paintLine(FaceContourType.upperLipBottom);
      // paintLine(FaceContourType.lowerLipTop);
      // paintLine(FaceContourType.lowerLipBottom);
      // paintContour(FaceContourType.upperLipTop);
      // paintContour(FaceContourType.upperLipBottom);
      // paintContour(FaceContourType.lowerLipTop);
      // paintContour(FaceContourType.lowerLipBottom);

      // paintContour(FaceContourType.noseBridge);
      // paintContour(FaceContourType.noseBottom);
      // paintContour(FaceContourType.leftCheek);
      // paintContour(FaceContourType.rightCheek);
      paintNewFill();
    }
  }

  @override
  bool shouldRepaint(final FaceDetectorTryOn oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces ||
        oldDelegate.color != color;
  }
}
