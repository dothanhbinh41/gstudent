import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class DialogResultHomeWork extends StatelessWidget {
  final int totalScore;
  final int score;
  final String comment;

  const DialogResultHomeWork(
      {Key key, this.totalScore, this.score, this.comment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned(
                child: Image(
                  image: AssetImage('assets/game_bg_dialog_create_long.png'),
                  fit: BoxFit.fill,
                ),
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
              ),
              Positioned(
                top: 40,
                right: 16,
                bottom: 16,
                left: 16,
                child: Column(
                  children: [
                    Container(
                      child: OutlinedText(
                        text: Text("NHẬN XÉT",
                            textAlign: TextAlign.center,
                            style: ThemeStyles.styleBold(
                                textColors: HexColor("#e7d3a1"), font: 24)),
                        strokes: [
                          OutlinedTextStroke(
                              color: HexColor("#772f32"), width: 3),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Image(
                        image: AssetImage('assets/images/ellipse.png'),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Số câu trả lời đúng : $score/$totalScore \n",
                              style: ThemeStyles.styleBold(font: 12)),
                          Text(comment, style: ThemeStyles.styleBold(font: 12)),
                        ],
                      )),
                    )),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Image(
                        image: AssetImage('assets/images/ellipse.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          flex: 5,
        ),
        Expanded(
            child: Center(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: ButtonGraySmall('ĐÓNG')),
        ))
      ],
    );
  }
}
