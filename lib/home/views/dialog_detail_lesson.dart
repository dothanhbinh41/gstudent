import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/Route/route.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class DetailLessonDialog extends StatefulWidget {
  Routes lesson;

  DetailLessonDialog({this.lesson});

  @override
  State<StatefulWidget> createState() => DetailLessonDialogState(lesson: this.lesson);
}

class DetailLessonDialogState extends State<DetailLessonDialog> {
  Routes lesson;

  DetailLessonDialogState({this.lesson});

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
                child:Column(
                  children: [
                    Container(child: OutlinedText(
                      text: Text('Nội dung buổi học',
                          textAlign: TextAlign.center,
                          style:ThemeStyles.styleBold(textColors: HexColor("#e7d3a1"),font: 24)),
                      strokes: [
                        OutlinedTextStroke(color: HexColor("#772f32"), width: 3),
                      ],
                    ),),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Image(
                        image: AssetImage('assets/images/ellipse.png'),
                      ),
                    ),
                    Expanded(child:  Container(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                      child: SingleChildScrollView(
                        child:
                        RichText(
                          text: TextSpan(
                            style: ThemeStyles.styleNormal(font: 12),
                            children: <TextSpan>[
                              TextSpan(text: lesson.listening != null ? 'Listening :\n' : '',style:  ThemeStyles.styleBold(font: 12)),
                              TextSpan(text: lesson.listening != null ? lesson.listening + '\n' : ''),
                              TextSpan(text:lesson.reading != null ? 'Reading :\n' : '',style:  ThemeStyles.styleBold(font: 12)),
                              TextSpan(text: lesson.reading != null ? lesson.reading + '\n' : ''),
                              TextSpan(text: lesson.writing != null ? 'Writing :\n' : '',style:  ThemeStyles.styleBold(font: 12)),
                              TextSpan(text: lesson.writing != null ? lesson.writing + '\n' : ''),
                              TextSpan(text:lesson.speaking != null ? 'Speaking :\n' : '',style:  ThemeStyles.styleBold(font: 12)),
                              TextSpan(text: lesson.speaking != null ? lesson.speaking + '\n' : ''),
                              TextSpan(text: lesson.grammar != null ? 'Grammar :\n' : '',style:  ThemeStyles.styleBold(font: 12)),
                              TextSpan(text: lesson.grammar != null ? lesson.grammar + '\n' : ''),
                              TextSpan(text:lesson.material != null ? 'Material :\n' : '',style:  ThemeStyles.styleBold(font: 12)),
                              TextSpan(text: lesson.material != null ? lesson.material + '\n' : ''),
                              TextSpan(text: lesson.vocabulary != null ?'Vocalbulary :\n' : '',style:  ThemeStyles.styleBold(font: 12)),
                              TextSpan(text: lesson.vocabulary != null ? lesson.vocabulary + '\n' : ''),
                            ],
                          ),
                        ),
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Image(
                        image: AssetImage('assets/images/ellipse.png'),
                      ),
                    )
                  ],
                ),
              )],
            ),flex: 5,),
            Expanded(child: Center(
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
