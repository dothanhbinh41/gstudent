import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/homework/result_homework.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/draw_progress_tripped.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';

class ResultTestView extends StatefulWidget {
  final ResultHomeworkData data;
  final bool isLast;

  const ResultTestView({Key key, this.data, this.isLast}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ResultTestViewState();
}

class ResultTestViewState extends State<ResultTestView> {
  String nameUser = "";

  bool isExpanded = false;
  final String keyAvg = 'avg_';
  final String keyAvgFinal = 'avg_final_';
  final String keyWriting = 'writing';
  final String keyListening = 'listening';
  final String keySpeaking = 'speaking';
  final String keyReading = 'reading';

  String skill;

  String comment;
  double totalPoint;
  ApplicationSettings settings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings = GetIt.instance.get<ApplicationSettings>();
    setNameUser();
    setState(() {
      totalPoint = widget.data.data.first.general.first.courseType == 'ielts' ? '9' : (widget.data.data.first.general.first.courseType == 'giao_tiep' ? 10 : 5);
    });
  }

  setNameUser() async {
    var user = await settings.getCurrentUser();
    setState(() {
      nameUser = user.userInfo.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.7),
        body: GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = false;
            });
          },
          child: Stack(
            children: [
              Positioned(
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                      child: Center(
                        child: Container(
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                right: 0,
                                bottom: 0,
                                left: 0,
                                child: Image(image: AssetImage('assets/bg_result_homework.png'), fit: BoxFit.fill),
                              ),
                              Container(
                                child: Text(
                                  'KẾT QUẢ',
                                  style: ThemeStyles.styleBold(font: 24, textColors: Colors.white),
                                ),
                                alignment: Alignment.center,
                              )
                            ],
                          ),
                          height: 120,
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
                    )),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                nameUser,
                                style: ThemeStyles.styleNormal(textColors: Colors.white, font: 20),
                              ),
                            ),
                          ),
                          widget.isLast
                              ? Container(
                                  margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: widget.data.data.first.general.first.status == 1 ? Colors.green : Colors.red),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: Text(
                                        widget.data.data.first.general.first.status == 1
                                            ? 'Chúc mừng bạn đã vượt qua bài kiểm tra '
                                                'đầu ra của khóa học!'
                                            : 'Rất tiếc! Bạn chưa  vượt qua  chuẩn đầu ra của khóa học!',
                                        style: ThemeStyles.styleNormal(
                                            textColors: widget.data.data.first.general.first.status == 1 ? Colors.green : Colors.red, font: 14)),
                                  ),
                                  padding: EdgeInsets.all(8),
                                )
                              : Container(),
                          widget.data.data.first.details.where((element) => element.key.contains(keySpeaking)).isNotEmpty
                              ? item('Speaking', widget.data.data.first.details.where((element) => element.key == this.keyAvg + keySpeaking).first.value,
                                  widget.data.data.first.general.first.speakingComment)
                              : Container(),
                          widget.data.data.first.details.where((element) => element.key.contains(keyWriting)).isNotEmpty
                              ? item('Writing', widget.data.data.first.details.where((element) => element.key == this.keyAvgFinal + keyWriting).first.value,
                                  widget.data.data.first.general.first.writingComment)
                              : Container(),
                          widget.data.data.first.details.where((element) => element.key.contains(keyReading)).isNotEmpty
                              ? item('Reading', widget.data.data.first.details.where((element) => element.key == this.keyAvg + keyReading).first.value,
                                  widget.data.data.first.general.first.autoMarkComment)
                              : Container(),
                          widget.data.data.first.details.where((element) => element.key.contains(keyListening)).isNotEmpty
                              ? item('Listening', widget.data.data.first.details.where((element) => element.key == this.keyAvg + keyListening).first.value,
                                  widget.data.data.first.general.first.autoMarkComment)
                              : Container(),
                          widget.data.data.first.details.where((element) => element.key.contains('total_use_of_english')).isNotEmpty
                              ? item('Use of English', widget.data.data.first.details.where((element) => element.key == 'count_use_of_english').first.value,
                                  widget.data.data.first.general.first.autoMarkComment)
                              : Container(),
                          item('Total', widget.data.data.first.general.first.avgScore, '', isTotal: true),
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isExpanded = false;
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                  ))),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                    child: Center(
                                  child: GestureDetector(
                                    child: ButtonGraySmall('ĐÓNG'),
                                    onTap: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                )),
                                Expanded(
                                  child: Center(
                                    child: GestureDetector(
                                        child: ButtonYellowSmall(
                                          'XEM KẾT QUẢ',
                                          fontSize: 14,
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop(true);
                                        }),
                                  ),
                                )
                              ],
                            ),
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
              ),
              AnimatedPositioned(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = false;
                      });
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: HexColor("#fbf5d5").withOpacity(0.9)),
                        child: Scrollbar(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                  child: Center(child: Text('Chi tiết kết quả', style: ThemeStyles.styleBold(font: 16, textColors: Colors.black)))),
                              Divider(
                                height: 1,
                                color: Colors.black,
                              ),
                              Container(
                                child:
                                    Text(skill != null ? 'Kỹ năng: ' + skill : 'Kỹ năng :', style: ThemeStyles.styleNormal(font: 16, textColors: Colors.black)),
                                margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  child: Text(comment != null ? 'Nhận xét: ' + comment : 'Nhận xét: ',
                                      style: ThemeStyles.styleNormal(font: 16, textColors: Colors.black))),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ))),
                  ),
                  duration: Duration(milliseconds: 500),
                  height: isExpanded ? MediaQuery.of(context).size.height * 0.3 : 0,
                  top: MediaQuery.of(context).size.width / 2,
                  right: 0,
                  left: isExpanded ? 0 : MediaQuery.of(context).size.width)
            ],
          ),
        ));
  }

  item(String skill, double point, String comment, {bool isTotal = false}) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        skill,
                        style: ThemeStyles.styleNormal(textColors: Colors.white),
                      ),
                    ),
                    Text(
                      isTotal == false ? point.toString() + ' / ' + totalPoint.toString() : totalPoint.toString(),
                      style: ThemeStyles.styleBold(textColors: Colors.white),
                    ),
                  ],
                ),
                flex: 2,
              ),
              Expanded(child: Container())
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Container(
                    height: 20,
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: HexColor("#6a6a6a"),
                    ),
                    child: Stack(
                      children: [
                        CustomPaint(
                          painter: StripePainter(height: 16, progress: point > 0 ? point / totalPoint : 0, distance: (MediaQuery.of(context).size.width * 0.1)),
                          size: Size.infinite,
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(0.5),
                ),
              ),
              Expanded(
                  child: isTotal
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                              if (isExpanded == true) {
                                setState(() {
                                  this.skill = skill;
                                  this.comment = comment;
                                });
                              }
                            });
                          },
                          child: Container(
                            child: Text(
                              'Chi tiết',
                              style: ThemeStyles.styleNormal(textColors: Colors.white),
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        ))
            ],
          ),
        ],
      ),
    );
  }
}
