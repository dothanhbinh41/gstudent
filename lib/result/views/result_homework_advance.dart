import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class ResultHomeworkAdvanceView extends StatefulWidget {
  int duration;
  int total;
  int score;
  int avgTime;
  bool isMark;

  ResultHomeworkAdvanceView({this.total, this.duration, this.score,this.isMark,this.avgTime});

  @override
  State<StatefulWidget> createState() => ResultHomeworkAdvanceViewState(total: this.total, duration: this.duration, score: this.score,isMark:this.isMark,avgTime: this.avgTime);
}

class ResultHomeworkAdvanceViewState extends State<ResultHomeworkAdvanceView> {
  int duration;
  int total;
  int score;
  bool isMark;
  int avgTime;
  ResultHomeworkAdvanceViewState({this.total, this.duration, this.score,this.isMark,this.avgTime});

  Duration time;
  Duration timePermin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    time = Duration(milliseconds: duration);
    print(duration ~/ 1000);
    timePermin = Duration(milliseconds: (duration * (score / total)).toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
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
                      style: ThemeStyles.styleBold(textColors: HexColor("#fffac7"), font: 40),
                    ),
                    alignment: Alignment.center,
                  )
                ],
              )),
          isMark ?   Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Container()),
                    Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
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
                                  image: AssetImage('assets/images/icon_mic.png'),
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Text(
                              'Đang chấm...',
                              style: ThemeStyles.styleNormal(textColors: HexColor("#fffac7"), font: 14),
                            ))
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
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
                                  image: AssetImage('assets/images/icon_writing.png'),
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Text(
                              'Đang chấm...',
                              style: ThemeStyles.styleNormal(textColors: HexColor("#fffac7"), font: 14),
                            ))
                      ],
                    ),
                    Expanded(child: Container()),
                  ],
                )  ,
              )) : Container(),
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
                                      TextSpan(text: score.toString(), style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                      TextSpan(text: '\n', style: DefaultTextStyle.of(context).style),
                                      TextSpan(text: '/' + total.toString(), style: DefaultTextStyle.of(context).style),
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
                                      TextSpan(text: _printDuration(time), style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                                      TextSpan(text: '\n', style: DefaultTextStyle.of(context).style),
                                      TextSpan(text: 'Phút', style: DefaultTextStyle.of(context).style),
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
                                          image: AssetImage('assets/images/icon_question_per_min.png'),
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
                                      TextSpan(
                                          text: (avgTime~/1000).toString(),
                                          style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                      TextSpan(text: '\n', style: DefaultTextStyle.of(context).style),
                                      TextSpan(text:   'giây' , style: DefaultTextStyle.of(context).style),
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
                      ],
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              )),
          Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                ((score/total )*100) > 75 ?  'Bạn làm bài tập rất tốt, bạn có muốn thử thách hơn với các dạng bài khó hơn ?' : 'Bạn làm bài tập chưa đc tốt, bạn nên luyện tập để có kết quả tốt hơn',
                style: ThemeStyles.styleNormal(
                  textColors: HexColor("#fffac7"),
                ),
                textAlign: TextAlign.center,
              )),
          Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: 'Số câu đúng/Tổng số câu:' + score.toString() + '/' + total.toString() + '\n',
                      style: ThemeStyles.styleNormal(
                        textColors: HexColor("#fffac7"),
                      )),
                  TextSpan(
                      text: 'Thời gian làm: ' + _printDuration(time) + '\n',
                      style: ThemeStyles.styleNormal(
                        textColors: HexColor("#fffac7"),
                      )),
                  TextSpan(
                      text: 'Thời gian trung bình: ' + (avgTime~/1000).toString()+'s/câu',
                      style: ThemeStyles.styleNormal(
                        textColors: HexColor("#fffac7"),
                      )),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Image(
              image: AssetImage('assets/images/ellipse.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: GestureDetector(
              onTap: () {
                print((score/total )*100);
                Navigator.of(context).pop((score/total )*100 > 75 ? true : false);
              },
              child: ButtonGraySmall('ĐÓNG', textColor: HexColor("#e3effa"),  ) ,
            ),
          )
        ],
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(1, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return twoDigitMinutes+":"+twoDigitSeconds;
  }
}
