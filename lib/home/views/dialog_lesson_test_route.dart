import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:intl/intl.dart';

import '../../api/dtos/Route/route.dart';

class RouteLessonTestDialog extends StatefulWidget {
  final Routes lesson;
  final bool isHaveResult;
  final bool isMarking;
  final bool isLastTest;
  const RouteLessonTestDialog(
      {Key key,
      this.lesson,
      this.isHaveResult,
      this.isMarking,
      this.isLastTest})
      : super(key: key);

  @override
  _RouteLessonTestDialogState createState() =>
      _RouteLessonTestDialogState(lesson, isHaveResult);
}

class _RouteLessonTestDialogState extends State<RouteLessonTestDialog> {
  final Routes lesson;
  final bool isHaveResult;

  _RouteLessonTestDialogState(this.lesson, this.isHaveResult);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      widget.isLastTest
                          ? 'KIỂM TRA CUỐI KHÓA'
                          : 'KIỂM TRA GIỮA KHÓA',
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
                          child: Image(
                            image: AssetImage('assets/images/ellipse.png'),
                            fit: BoxFit.fill,
                          ),
                          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: HexColor("#F3D39A"),
                              borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.all(8),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/ic_time_test.png"),
                                    height: 32,
                                  )),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: Text(
                                    DateFormat("hh:mm dd-MM-yyyy")
                                        .format(lesson.getStartDate()),
                                    style: ThemeStyles.styleNormal(font: 14),
                                  ))
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
                            if (lesson.zoomId != null &&
                                lesson.zoomPassword != null) {
                              Navigator.of(context).pop(1);
                            }
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
                                          child: lesson.zoomId == null &&
                                                  lesson.zoomPassword == null
                                              ? Image(
                                                  image: AssetImage(
                                                      'assets/images/ic_center.png'),
                                                )
                                              : Image(
                                                  image: AssetImage(
                                                      'assets/images/zoom_meeting.png'),
                                                ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(
                                        lesson.zoomId == null &&
                                                lesson.zoomPassword == null
                                            ? 'Kiểm tran offline'
                                            : 'Kiểm tra online',
                                        style:
                                            ThemeStyles.styleNormal(font: 14),
                                      )),
                                    ],
                                  )
                                : Container(),
                          ),
                        )
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
                  widget.isMarking
                      ? Center(
                          child: Text(
                            'Đang chấm bài kiểm tra',
                            style: ThemeStyles.styleNormal(
                                textColors: Colors.green),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(2);
                          },
                          child: isHaveResult
                              ? ButtonYellowSmall(
                                  "KẾT QUẢ THI",
                                  fontSize: 16,
                                )
                              : ButtonYellowSmall(
                                  "VÀO THI",
                                ))
                ],
              )),
        ],
      ),
    );
  }
}
