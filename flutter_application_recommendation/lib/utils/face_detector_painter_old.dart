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

  var scaleW;
  var scaleH;

  FaceDetectorPainter(
      this.faces, this.face, this.color, this.sizeForScale, this.sizeBorder);

  @override
  void paint(final Canvas canvas, final Size size) {
    print("mlkit : $faces");
    print("area : $face");
    // scaleW = 200.0 / face[2];
    // scaleH = 200.0 / face[3];
    scaleW = sizeForScale / face[2];
    scaleH = sizeForScale / face[3];
    // scaleH = 1.0;
    // scaleW = 1.0;
    // scaleW = size.width / face[2];
    // scaleH = size.height / face[3];
    // scaleW = (200.0 / size.width) * 200.0 / face[2];
    // scaleH = (200.0 / size.height) * 200.0 / face[3];

    // TODO: implement paint
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.blue;

    final Paint paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.red;

    for (final Face face in faces) {
      print(
          "LTRB : ${face.boundingBox.left}, ${face.boundingBox.top}, ${face.boundingBox.right}, ${face.boundingBox.bottom}");
      print("landmarks : ${face.landmarks}");
      print("contours : ${face.contours}");
      // canvas.drawRect(Rect.fromLTRB(0.0, 0.0, 11.0, 11.0), paint);
      // canvas.drawRect(
      //   Rect.fromLTRB(
      //     face.boundingBox.left * scaleW,
      //     face.boundingBox.top * scaleH,
      //     face.boundingBox.right * scaleW,
      //     face.boundingBox.bottom * scaleH,
      //   ),
      //   paint,
      // );
      // draw the blue circle for detected points of the face
      void paintContour(final FaceContourType type) {
        final faceContour = face.contours[type];
        if (faceContour?.points != null) {
          for (final Point point in faceContour!.points) {
            canvas.drawCircle(
                Offset(
                  point.x.toDouble() * scaleW, point.y.toDouble() * scaleH,
                  // translateX(
                  //     point.x.toDouble(), rotation, size, absoluteImageSize),
                  // translateY(
                  //     point.y.toDouble(), rotation, size, absoluteImageSize),
                ),
                1.0,
                paint);
          }
        }
      }

      void paintLandmark(final FaceLandmarkType type) {
        final faceContour = face.contours[type];
        if (faceContour?.points != null) {
          for (final Point point in faceContour!.points) {
            canvas.drawCircle(
                Offset(
                  point.x.toDouble() * scaleW, point.y.toDouble() * scaleH,
                  // translateX(
                  //     point.x.toDouble(), rotation, size, absoluteImageSize),
                  // translateY(
                  //     point.y.toDouble(), rotation, size, absoluteImageSize),
                ),
                10.0,
                paint2);
          }
        }
      }

      void paintLine(final FaceContourType type) {
        final pointMode = ui.PointMode.polygon;
        final List<Offset> points = [];
        final paint = Paint()
          ..style = PaintingStyle.fill
          ..color = color
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

        final faceContour = face.contours[type];
        if (faceContour?.points != null) {
          for (final Point point in faceContour!.points) {
            print(
                "x : ${point.x.toDouble() * scaleW}, y : ${point.y.toDouble() * scaleH}");
            points.add(Offset(
              point.x.toDouble(),
              point.y.toDouble(),
              // point.x.toDouble() * scaleW,
              // point.y.toDouble() * scaleH,
            ));
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

        var paint2 = Paint()
          ..color = Colors.transparent
          ..strokeWidth = 1;
        final faceContour1 = face.contours[type1];
        final faceContour2 = face.contours[type2];
        // final faceContour3 = face.contours[type3];
        // final faceContour4 = face.contours[type4];

        int counter = 0;
        if (faceContour1?.points != null) {
          for (final Point point in faceContour1!.points) {
            if (counter == 0) {
              path.moveTo(
                point.x.toDouble() * scaleW,
                point.y.toDouble() * scaleH,
                // translateX(
                //     point.x.toDouble(), rotation, size, absoluteImageSize),
                // translateY(
                //     point.y.toDouble(), rotation, size, absoluteImageSize),
              );

              counter = 1;
            } else {
              path.lineTo(
                point.x.toDouble() * scaleW,
                point.y.toDouble() * scaleH,
                // translateX(
                //     point.x.toDouble(), rotation, size, absoluteImageSize),
                // translateY(
                //     point.y.toDouble(), rotation, size, absoluteImageSize),
              );
            }
          }
          // canvas.drawPath(path, paint);
        }
        if (faceContour2?.points != null) {
          for (final Point point in faceContour2!.points) {
            path.lineTo(
              point.x.toDouble() * scaleW,
              point.y.toDouble() * scaleH,
              // translateX(point.x.toDouble(), rotation, size, absoluteImageSize),
              // translateY(point.y.toDouble(), rotation, size, absoluteImageSize),
            );
          }
          // canvas.drawPath(path, paint);
        }
        // if (faceContour3?.points != null) {
        //   for (final Point point in faceContour3!.points) {
        //     if (counter == 1) {
        //       path.moveTo(
        //           translateX(
        //               point.x.toDouble(), rotation, size, absoluteImageSize),
        //           translateY(
        //               point.y.toDouble(), rotation, size, absoluteImageSize));
        //       counter = 2;
        //     } else {
        //       path.lineTo(
        //           translateX(
        //               point.x.toDouble(), rotation, size, absoluteImageSize),
        //           translateY(
        //               point.y.toDouble(), rotation, size, absoluteImageSize));
        //     }
        //   }
        // }
        // if (faceContour4?.points != null) {
        //   for (final Point point in faceContour4!.points) {
        //     path.lineTo(
        //         translateX(
        //             point.x.toDouble(), rotation, size, absoluteImageSize),
        //         translateY(
        //             point.y.toDouble(), rotation, size, absoluteImageSize));
        //   }
        // }

        canvas.drawPath(path, paint);
        // path.moveTo(0, size.height * 0.7);
        // path.quadraticBezierTo(size.width * 0.25, size.height * 0.7,
        //     size.width * 0.5, size.height * 0.8);
        // path.quadraticBezierTo(size.width * 0.75, size.height * 0.9,
        //     size.width * 1.0, size.height * 0.8);
        // path.lineTo(size.width, size.height);
        // path.lineTo(0, size.height);
      }

      // paintLine(FaceContourType.face);
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

      void paintNewLine(
          final FaceContourType typeUpper, final FaceContourType typeLower) {
        final pointMode = ui.PointMode.polygon;
        final List<Offset> points = [];
        final paint = Paint()
          ..style = PaintingStyle.fill
          ..color = color
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

        final faceContour = face.contours[typeUpper];
        if (faceContour?.points != null) {
          for (final Point point in faceContour!.points) {
            print(
                "x : ${point.x.toDouble() * scaleW}, y : ${point.y.toDouble() * scaleH}");
            points.add(Offset(
              point.x.toDouble() * scaleW,
              point.y.toDouble() * scaleH,
              // translateX(point.x.toDouble(), rotation, size, absoluteImageSize),
              // translateY(point.y.toDouble(), rotation, size, absoluteImageSize),
            ));
          }
        }

        canvas.drawPoints(pointMode, points, paint);
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

        // int counter = 0;
        // if (faceContour1?.points != null) {
        //   for (final Point point in faceContour1!.points) {
        //     if (counter == 0) {
        //       path.moveTo(
        //         point.x.toDouble() * scaleW,
        //         point.y.toDouble() * scaleH,
        //         // translateX(
        //         //     point.x.toDouble(), rotation, size, absoluteImageSize),
        //         // translateY(
        //         //     point.y.toDouble(), rotation, size, absoluteImageSize),
        //       );

        //       counter = 1;
        //     } else {
        //       path.lineTo(
        //         point.x.toDouble() * scaleW,
        //         point.y.toDouble() * scaleH,
        //       );
        //     }
        //   }
        //   // canvas.drawPath(path, paint);
        // }
        // if (faceContour2?.points != null) {
        //   for (final Point point in faceContour2!.points) {
        //     path.lineTo(
        //       point.x.toDouble() * scaleW,
        //       point.y.toDouble() * scaleH,
        //     );
        //   }
        //   // canvas.(path, paint);
        // }
      }

      paintNewFill();
    }
  }

  @override
  bool shouldRepaint(final FaceDetectorPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // return oldDelegate.absoluteImageSize != absoluteImageSize ||
    //     oldDelegate.faces != faces;
    // return oldDelegate.faces != faces || oldDelegate.color != color;
    return oldDelegate.faces != faces ||
        oldDelegate.color != color ||
        oldDelegate.face != face;
  }
}
