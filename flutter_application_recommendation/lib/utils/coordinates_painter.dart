// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// double translateX(double x, InputImageRotation rotation, final Size size,
//     final Size absoluteImageSize) {
//   switch (rotation) {
//     case InputImageRotation.rotation90deg:
//       return x *
//           size.width /
//           (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
//     // return x * size.width / absoluteImageSize.width;
//     case InputImageRotation.rotation270deg:
//       return size.width -
//           x *
//               size.width /
//               (Platform.isIOS
//                   ? absoluteImageSize.width
//                   : absoluteImageSize.height);
//     // return size.width - x * size.width / absoluteImageSize.width;
//     default:
//       return x * size.width / absoluteImageSize.width;
//   }
// }

// double translateY(double y, InputImageRotation rotation, final Size size,
//     final Size absoluteImageSize) {
//   switch (rotation) {
//     case InputImageRotation.rotation90deg:

//     case InputImageRotation.rotation270deg:
//       return y *
//           size.height /
//           (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width);
//     // return y * size.height / absoluteImageSize.height;
//     default:
//       return y * size.height / absoluteImageSize.height;
//   }
// }
