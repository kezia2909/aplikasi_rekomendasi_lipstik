import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/login_page.dart';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

String colorShadow = "shadow";
String colorMidtone = "midtone";
String colorHighlight = "highlight";
String colorAccent = "accent";
String colorDark = "dark";
String colorBlack = "black";
String colorWhite = "white";
String colorRed = "red";

// PINK VERSION
// String hexShadow = "d3445d";
// String hexMidtone = "f8b8c1";
// String hexHighlight = "f9e8e6";
// String hexAccent = "d07e64";

// BROWN VERSION
String hexShadow = "d07e64";
String hexMidtone = "f5b39b";
String hexHighlight = "f9e8e6";
String hexDark = "705b48";
String hexAccent = "ad3131";

String hexBlack = "1f1f1f";
String hexWhite = "ffffff";
String hexRed = "ff0000";

colorTheme(String type) {
  if (type == colorShadow) {
    return hexStringToColor(hexShadow);
  } else if (type == colorMidtone) {
    return hexStringToColor(hexMidtone);
  } else if (type == colorHighlight) {
    return hexStringToColor(hexHighlight);
  } else if (type == colorAccent) {
    return hexStringToColor(hexAccent);
  } else if (type == colorDark) {
    return hexStringToColor(hexDark);
  } else if (type == colorBlack) {
    return hexStringToColor(hexBlack);
  } else if (type == colorWhite) {
    return hexStringToColor(hexWhite);
  } else if (type == colorRed) {
    return hexStringToColor(hexRed);
  }
}
