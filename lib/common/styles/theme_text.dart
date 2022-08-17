import 'package:flutter/material.dart';

import '../colors/HexColor.dart';

class ThemeStyles {
  static TextStyle styleBold(
          {Color textColors = Colors.black, double font = 16}) =>
      TextStyle(
        fontSize: font,
        fontFamily: fontfamily,
        fontWeight: FontWeight.w700,
        color: textColors,
      );

  static TextStyle styleNormal(
          {Color textColors = Colors.black, double font = 16}) =>
      TextStyle(
          fontSize: font,
          fontFamily: fontfamily,
          fontWeight: FontWeight.w400,
          color: textColors);

  static String fontfamily = "SourceSerifPro";
}
