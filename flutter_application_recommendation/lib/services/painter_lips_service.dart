import 'package:flutter/material.dart';

class LipsPainter extends CustomPainter {
  // final Color color;
  final List<dynamic> lips;
  final List<Rect> rects = [];

  final List<dynamic> face;
  var scaleW;
  var scaleH;

  final Color color;

  LipsPainter({required this.lips, required this.face, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // print("PAINTERRRR");
    // print("face: ");
    // print(face);
    // print(lips);

    scaleW = 200 / face[2];
    scaleH = 200 / face[3];
    for (var i = 0; i < lips.length; i++) {
      final x = lips[i][0].toDouble() * scaleW;
      final y = lips[i][1].toDouble() * scaleH;
      final w = lips[i][2].toDouble() * scaleW;
      final h = lips[i][3].toDouble() * scaleH;
      final rect = Rect.fromPoints(Offset(x, y), Offset(x + w, y + h));
      rects.add(rect);
      // print("ADD RECTT");
    }
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0
      ..color = color;

    // print("CANVASSSS");
    for (var i = 0; i < lips.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
    // print("CANVASSS ENDD");
    // print("ENDD PAINTERRR");

    // Paint paint_0 = Paint()
    //   ..color = Color.fromARGB(255, 33, 150, 243)
    //   ..style = PaintingStyle.fill;

    // Path path_0 = Path();
    // path_0.moveTo(size.width * 0.04, size.height * 1.04);
    // path_0.lineTo(size.width * 0.8, size.height * 1.04);
    // path_0.quadraticBezierTo(size.width * 0.79, size.height * 0.21,
    //     size.width * 0.79, size.height * 0.16);
    // path_0.cubicTo(size.width * 0.79, size.height * -0.01, size.width * 0.27,
    //     size.height * -0.18, size.width * 0.04, size.height * -0.4);
    // path_0.quadraticBezierTo(size.width * 0.05, size.height * -0.10,
    //     size.width * 0.04, size.height * 1.04);
    // path_0.close();

    // canvas.drawPath(path_0, paint_0);
  }

  //5
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
