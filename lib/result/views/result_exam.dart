import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class ResultExamView extends StatefulWidget {
  int duration;
  String process;

  ResultExamView({ this.duration, this.process});

  @override
  State<StatefulWidget> createState() => ResultExamViewState( duration: this.duration, process: this.process);
}

class ResultExamViewState extends State<ResultExamView> {
  int duration;
  String process;

  ResultExamViewState({this.duration, this.process});


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Column(
        children: [
          Expanded(
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image(
                      image: AssetImage('assets/bg_result_homework.png'),
                    ),
                  ),
                  Container(
                    child: Text(
                      'KẾT QUẢ',
                      style: ThemeStyles.styleBold(textColors: HexColor("#fffac7"),font: 40),
                    ),
                    alignment: Alignment.center,
                  )
                ],
              ),flex: 3,),

          Expanded(
              child: Column(
                children: [
                  Container(
                    height: 120,
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        Container(
                          width: 100,
                          child: Stack(
                            children: [
                              Positioned(
                                child: Image(
                                  image: AssetImage('assets/images/bg_content_result_homework.png'),
                                  fit: BoxFit.fill,
                                ),
                                top: 40,
                                right: 24,
                                left: 24,
                                bottom: 0,
                              ),
                              Positioned(
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Image(
                                          image: AssetImage('assets/images/game_border_avatar_member.png'),
                                        ),
                                        top: 0,
                                        right: 0,
                                        left: 0,
                                        bottom: 0,
                                      ),
                                      Center(
                                        child: Image(
                                          image: AssetImage('assets/images/icon_total_time.png'),
                                          height: 32,
                                          width: 32,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                top: 0,
                                right: 0,
                                left: 0,
                              ),
                              Positioned(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(text: formatDuration(Duration(milliseconds: duration)) , style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                      TextSpan(text: '\n', style: ThemeStyles.styleNormal()),
                                      TextSpan(text: 's', style: ThemeStyles.styleNormal()),
                                    ],
                                  ),
                                ),
                                bottom: 16,
                                right: 0,
                                left: 0,
                              )
                            ],
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(
                          width: 100,
                          child: Stack(
                            children: [
                              Positioned(
                                child: Image(
                                  image: AssetImage('assets/images/bg_content_result_homework.png'),
                                  fit: BoxFit.fill,
                                ),
                                top: 40,
                                right: 24,
                                left: 24,
                                bottom: 0,
                              ),
                              Positioned(
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Image(
                                          image: AssetImage('assets/images/game_border_avatar_member.png'),
                                        ),
                                        top: 0,
                                        right: 0,
                                        left: 0,
                                        bottom: 0,
                                      ),
                                      Center(
                                        child: Image(
                                          image: AssetImage('assets/images/icon_tick_score.png'),
                                          height: 32,
                                          width: 32,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                top: 0,
                                right: 0,
                                left: 0,
                              ),
                              Positioned(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(text: process.split('/').first, style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black)),
                                      TextSpan(text: '\n', style: DefaultTextStyle.of(context).style),
                                      TextSpan(text:'/'+ process.split('/').last.toString(), style: ThemeStyles.styleNormal()),
                                    ],
                                  ),
                                ),
                                bottom: 16,
                                right: 0,
                                left: 0,
                              )
                            ],
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(width: 100, ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),flex: 3,),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children:  <TextSpan>[
                    TextSpan(
                        text: 'Thời gian luyện : '+ formatDuration(Duration(milliseconds: duration))+'s',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro')),
                    TextSpan(text: '\n', ),
                    TextSpan(
                        text: 'Số câu đúng/Số câu làm : $process' ,
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro')),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: Image(
              image: AssetImage('assets/images/ellipse.png'),
            ),
          ),
          Expanded(  child: Container()),
          Container(
            margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: ButtonGraySmall('THOÁT', textColor: HexColor("#e3effa"),),
            ),
          ),
          Expanded(  child: Container()),
        ],
      ),
    );
  }

  String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    return seconds < 60 ?'0'+ seconds.toString() : seconds.toString();
  }
}
