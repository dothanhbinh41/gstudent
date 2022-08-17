import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/styles/theme_text.dart';

textpaintingBoldBase(String s, double fontSize, Color textColor, Color borderColors,double borderSize, {TextAlign textAlign = TextAlign.justify }) {
  return OutlinedText(
    text: Text(s,
        textAlign: textAlign,
        style: ThemeStyles.styleBold(textColors: textColor,font: fontSize)),
    strokes: [
      OutlinedTextStroke(color: borderColors, width: borderSize),
    ],
  );
}


textpaintingBase(String s, double fontSize, Color textColor, Color borderColors,double borderSize, {TextAlign textAlign = TextAlign.justify }) {
  return OutlinedText(
    text: Text(s,
        textAlign: textAlign,
        style: ThemeStyles.styleNormal(textColors: textColor,font: fontSize),

    ),
    strokes: [
      OutlinedTextStroke(color: borderColors, width: borderSize),
    ],
  );
}