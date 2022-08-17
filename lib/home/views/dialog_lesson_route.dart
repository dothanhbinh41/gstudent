import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/Route/route.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:intl/intl.dart';

class RouteLessonDialog extends StatefulWidget {
  Routes lesson;
  String comment;

  RouteLessonDialog({this.lesson, this.comment});

  @override
  State<StatefulWidget> createState() =>
      RouteLessonDialogState(lesson: this.lesson, comment: this.comment);
}

class RouteLessonDialogState extends State<RouteLessonDialog> {
  Routes lesson;
  String comment;

  RouteLessonDialogState({this.lesson, this.comment});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: fixHeight(),
        width: MediaQuery.of(context).size.width * 0.9 > 400
            ? 400
            : MediaQuery.of(context).size.width * 0.9,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Image(
                image: AssetImage('assets/bg_notification_large.png'),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
                top: 24,
                bottom: 24,
                right: 24,
                left: 24,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        lesson.lesson != null
                            ? 'Buổi ' + lesson.lesson.toString()
                            : 'Buổi phụ đạo',
                        style: ThemeStyles.styleBold(font: 24),
                      ),
                    ),
                    Container(
                      child: Image(
                        image: AssetImage('assets/images/eclipse_login.png'),
                        fit: BoxFit.fill,
                      ),
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 4),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: HexColor("#F3D39A"),
                                borderRadius: BorderRadius.circular(4)),
                            child: Column(
                              children: [
                                lesson.action != null
                                    ? Container(
                                        height: 40,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  8, 0, 4, 4),
                                              height: lesson.action.checkin !=
                                                          null &&
                                                      lesson.action.checkin ==
                                                          true
                                                  ? 24
                                                  : 20,
                                              width: 24,
                                              child: Center(
                                                child: Image(
                                                  image: lesson.action.checkin !=
                                                              null &&
                                                          lesson.action
                                                                  .checkin ==
                                                              true
                                                      ? AssetImage(
                                                          'assets/images/icon_checkbox_checked.png')
                                                      : AssetImage(
                                                          'assets/images/icon_checkbox.png'),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child: Text(
                                              lesson.startTime +
                                                  ' ' +
                                                  DateFormat("dd-MM-yyyy")
                                                      .format(lesson.date),
                                              style: ThemeStyles.styleNormal(
                                                  font: 14),
                                            )),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                lesson.action != null
                                    ? Container(
                                        margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                                        height: 0.5,
                                        decoration: BoxDecoration(
                                            color: Colors.black38),
                                      )
                                    : Container(),
                                lesson.action != null
                                    ? Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop(2);
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    8, 0, 4, 4),
                                                height:
                                                    lesson.action.feedback !=
                                                                null &&
                                                            lesson.action
                                                                    .feedback ==
                                                                true
                                                        ? 28
                                                        : 20,
                                                width: 24,
                                                child: Center(
                                                  child: Image(
                                                    image: lesson.action.feedback !=
                                                                null &&
                                                            lesson.action
                                                                    .feedback ==
                                                                true
                                                        ? AssetImage(
                                                            'assets/images/icon_checkbox_checked.png')
                                                        : AssetImage(
                                                            'assets/images/icon_checkbox.png'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Text(
                                                'Gửi đánh giá',
                                                style: ThemeStyles.styleNormal(
                                                    font: 14),
                                              )),
                                            ],
                                          ),
                                        ),
                                        height: 40,
                                      )
                                    : Container(),
                                lesson.action != null
                                    ? Container(
                                        margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                                        height: 0.5,
                                        decoration: BoxDecoration(
                                            color: Colors.black38),
                                      )
                                    : Container(),
                                lesson.action != null
                                    ? Container(
                                        height: 40,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop(3);
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    8, 0, 4, 4),
                                                height:
                                                    lesson.action.homework !=
                                                            null
                                                        ? 24
                                                        : 20,
                                                width: 28,
                                                child: Center(
                                                  child: Image(
                                                    image: lesson
                                                                .action.homework !=
                                                            null
                                                        ? AssetImage(
                                                            'assets/images/icon_checkbox_checked.png')
                                                        : AssetImage(
                                                            'assets/images/icon_checkbox.png'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Text(
                                                'Làm bài tập ',
                                                style: ThemeStyles.styleNormal(
                                                    font: 14),
                                              )),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          Container(
                            child: Image(
                              image: AssetImage('assets/images/ellipse.png'),
                              fit: BoxFit.fill,
                            ),
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(4);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: HexColor("#F3D39A"),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.all(8),
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/book.png"),
                                        height: 32,
                                      )),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                      child: Text(
                                        'Nội dung bài học',
                                        style: ThemeStyles.styleBold(font: 14),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          lesson.zoomPassword != null &&
                                  lesson.zoomPassword.isNotEmpty &&
                                  lesson.zoomId != null &&
                                  lesson.zoomId.isNotEmpty
                              ? Container(
                                  child: Image(
                                    image:
                                        AssetImage('assets/images/ellipse.png'),
                                    fit: BoxFit.fill,
                                  ),
                                  margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                )
                              : Container(),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(-1);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: HexColor("#F3D39A"),
                                  borderRadius: BorderRadius.circular(4)),
                              child: lesson.zoomPassword != null &&
                                      lesson.zoomPassword.isNotEmpty &&
                                      lesson.zoomId != null &&
                                      lesson.zoomId.isNotEmpty
                                  ? Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(8),
                                          height: 32,
                                          width: 32,
                                          child: Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/zoom_meeting.png'),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          'Học online',
                                          style:
                                              ThemeStyles.styleNormal(font: 14),
                                        )),
                                      ],
                                    )
                                  : Container(),
                            ),
                          ),
                          comment != null && comment.isNotEmpty
                              ? Container(
                                  child: Image(
                                    image:
                                        AssetImage('assets/images/ellipse.png'),
                                    fit: BoxFit.fill,
                                  ),
                                  margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                )
                              : Container(),
                          comment != null && comment.isNotEmpty
                              ? _comment()
                              : Container()
                        ],
                      ),
                    ),
                    Container(
                      child: Image(
                        image: AssetImage('assets/images/ellipse.png'),
                        fit: BoxFit.fill,
                      ),
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    ),
                    GestureDetector(
                        onTap: () {
                          var index = -2;

                          if (lesson.action?.feedback == null) {
                            index = 2;
                          } else if (lesson.action?.homework == null) {
                            index = 3;
                          }

                          Navigator.of(context).pop(index);
                        },
                        child: lesson.action != null && ( lesson.action.feedback == null ||
                            lesson.action.homework == null)
                            ? ButtonYellowSmall("TIẾP TỤC")
                            : ButtonGraySmall(
                                "ĐÓNG",
                                textColor: HexColor("#e3effa"),

                              ))
                  ],
                )),
          ],
        ),
      ),
    );
  }

  double fixHeight() {
    var d = 560.0;
    if (lesson.action == null) {
      d = d - 140;
    }

    if (lesson.zoomId == null && lesson.zoomPassword == null) {
      d = d - 60;
    }
    if (comment == null || comment.isEmpty) {
      d = d - 80;
    }
    return d;
  }

  _comment() {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pop(5);
      },
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(8),
            height: 32,
            width: 32,
            child: Center(
              child: Icon(Icons.comment),
            ),
          ),
          Expanded(
              child: Text(
                'Nhận xét',
                style:
                ThemeStyles.styleNormal(font: 14),
              )),
        ],
      ),
    );
  }
}
