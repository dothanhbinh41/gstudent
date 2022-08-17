import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_painting.dart';

class ButtonGraySmall extends StatelessWidget {
  final String text;
  Color textColor;
  double fontSize;

  ButtonGraySmall(this.text, {this.textColor = Colors.white, this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Image(
              image: AssetImage('assets/images/button_small_gray.png'),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Center(child: textpaintingBoldBase(text, fontSize, textColor, HexColor("#452e35"), 3)),
          )
        ],
      ),
    );
  }
}

class ButtonYellowLarge extends StatelessWidget {
  final String text;
  Color textColor;
  double fontSize;

  ButtonYellowLarge(this.text, {this.textColor = Colors.white, this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 0,
            left: 0,
            bottom: 4,
            child: Image(
              image: AssetImage('assets/images/button_yellow_long.png'),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Center(child: textpaintingBoldBase(text, fontSize, textColor, HexColor("#452e35"), 3)),
          )
        ],
      ),
    );
  }
}

class ButtonYellowSmall extends StatelessWidget {
  final String text;
  Color textColor;
  double fontSize;

  ButtonYellowSmall(this.text, {this.textColor = Colors.white, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: Image(
                  image: AssetImage('assets/images/button_small_yellow.png'),
                )),
            Positioned(
              child: Center(
                child: textpaintingBoldBase(text, fontSize, textColor, HexColor("#452e35"), 3),
              ),
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
            )
          ],
        ));
  }
}
