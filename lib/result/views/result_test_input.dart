import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/TestInput/ResultDto.dart';
import 'package:gstudent/api/dtos/TestInput/ResultSubmitDto.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/LinearPercentIndicator.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/draw_progress_tripped.dart';
import 'package:gstudent/common/styles/theme_text.dart';

import '../../settings/helper/ApplicationSettings.dart';

class ResultTestInputView extends StatefulWidget {
  DataResultTest data;

  ResultTestInputView({
    this.data,
  });

  @override
  State<StatefulWidget> createState() => ResultTestInputViewState(data: this.data);
}

class ResultTestInputViewState extends State<ResultTestInputView> {
  DataResultTest data;

  ResultTestInputViewState({this.data});

  String nameUser = "";

  ApplicationSettings settings;
  bool isExpanded = false;
  DataSkill detailData;
  String skill = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings = GetIt.instance.get<ApplicationSettings>();

    loadData();
  }

  loadData() async {
    var dataLogin = await settings.getCurrentUser();
    setState(() {
      nameUser = dataLogin.userInfo.name;
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
             Positioned(child:  Column(
               children: [
                 Expanded(
                     child: Container(child: Center(
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
                     ),margin: EdgeInsets.fromLTRB(0, 24, 0, 0),)),
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
                       data.writing != null && data.common.type != "daihoc" ? item('Writing', data.writing) : Container(),
                       data.speaking != null  && data.common.type != "daihoc"? item('Speaking', data.speaking) : Container(),
                       data.listening != null  && data.common.type != "daihoc" ? item('Listening', data.listening) : Container(),
                       data.reading != null ? item('Reading', data.reading) : Container(),
                       data.general != null  && data.common.type != "daihoc"? item('General', data.general) : Container(),
                       Container(
                         child: Text(
                           'Nhận xét tổng quan',
                           style: ThemeStyles.styleNormal(textColors: Colors.white),
                         ),
                         padding: EdgeInsets.all(8),
                         margin: EdgeInsets.fromLTRB(
                           16,
                           8,
                           16,
                           4,
                         ),
                       ),
                       Container(
                         height: 100,
                         width: MediaQuery
                             .of(context)
                             .size
                             .width,
                         child: SingleChildScrollView(
                             child:  Text(
                               data.common.comment != null ? data.common.comment : "",
                               style: ThemeStyles.styleNormal(textColors: Colors.white),
                             ), ),
                         margin: EdgeInsets.fromLTRB(16, 4, 16, 8),
                         // decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: Colors.white),
                       ),
                       Container(
                         child: Text(
                           'Gợi ý khóa học',
                           style: ThemeStyles.styleNormal(textColors: Colors.white),
                         ),
                         padding: EdgeInsets.all(8),
                         margin: EdgeInsets.fromLTRB(
                           16,
                           8,
                           16,
                           4,
                         ),
                       ),
                       Container(
                         height: 60,
                         child: Stack(
                           children: [
                             Positioned(
                                 top: 0,
                                 right: 0,
                                 bottom: 0,
                                 left: 0,
                                 child: Image(
                                   image: AssetImage('assets/images/bg_content_reward.png'),
                                   fit: BoxFit.fill,
                                 )),
                             Positioned(
                               top: 0,
                               right: 16,
                               bottom: 0,
                               left: 16,
                               child: Center(
                                 child: Text(
                                   data.common.courseSuggest != null ? data.common.courseSuggest : "ielts",
                                   style: ThemeStyles.styleNormal(textColors: Colors.white),
                                 ),
                               ),
                             )
                           ],
                         ),
                         margin: EdgeInsets.fromLTRB(0, 4, 0, 8),
                         width: MediaQuery
                             .of(context)
                             .size
                             .width,
                       ),
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
                         child: GestureDetector(
                           child: ButtonGraySmall('ĐÓNG'),
                           onTap: () {
                             Navigator.of(context).pop();
                           },
                         ),
                         margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                       ),
                     ],
                   ),
                 )
               ],
             ),top: 0,bottom: 0,right: 0,left: 0,),
              AnimatedPositioned(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = false;
                      });
                    },
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: HexColor("#fbf5d5").withOpacity(0.9)),
                      child: detailData != null
                          ? Column(
                        children: [
                          Container(margin: EdgeInsets.fromLTRB(4, 4, 4, 4), child: Center(child: Text('Chi tiết kết quả', style: ThemeStyles.styleBold(font: 16, textColors: Colors.black)))),
                          Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          Container(
                            child: Text('Kỹ năng: ' + this.skill, style: ThemeStyles.styleNormal(font: 16, textColors: Colors.black)),
                            margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Text('Trả lời đúng: ' + calculate(detailData, skill), style: ThemeStyles.styleNormal(font: 16, textColors: Colors.black))),
                          Container(
                              margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Text('Nhận xét: ' + (detailData.commentItem != null ? detailData.commentItem : ""), style: ThemeStyles.styleNormal(font: 16, textColors: Colors.black))),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      )
                          : Container(),
                    ),
                  ),
                  duration: Duration(milliseconds: 500),
                  height: isExpanded ? MediaQuery
                      .of(context)
                      .size
                      .height * 0.3 : 0,
                  top: MediaQuery
                      .of(context)
                      .size
                      .width / 2,
                  right: 0,
                  left: isExpanded ? 0 : MediaQuery
                      .of(context)
                      .size
                      .width)
            ],
          ),
        ));
  }

  item(String skill, DataSkill data) {
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
                      child:  this.data.common.type != "daihoc" ? Text(
                        skill,
                        style: ThemeStyles.styleNormal(textColors: Colors.white),
                      ) : Container(),
                    ),
                    Text(
                      this.data.common.type == "giaotiep" ? 10.0.toString() : 9.0.toString(),
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
                          painter: StripePainter(
                              height: 16,
                              progress: data.exactly > 0
                                  ? data.exactly /
                                  (data.total > 0
                                      ? data.total
                                      : (this.data.common.type == "giaotiep"
                                      ? 10.0
                                      : (skill == 'Speaking' || skill == 'Writing')
                                      ? 9.0
                                      : 10.0))
                                  : 0.0,
                              distance: (MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.1)),
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
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                        if (isExpanded == true) {
                          detailData = data;
                          this.skill = skill;
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

  String calculate(DataSkill detailData, String skill) {
    double point;
    double totalPoint;
    if (skill == 'General') {
      point = detailData.exactly / detailData.total * 10;
      totalPoint = detailData.total / detailData.total * 10;
      return point.toString() + '/' + totalPoint.toString();
    }
    else if(skill == 'Speaking' || skill == 'Writing') {
      point = detailData.exactly;
      totalPoint = detailData.total > 0
          ? detailData.total
          : (this.data.common.type == "giaotiep"
          ? 10.0
          : (skill == 'Speaking' || skill == 'Writing')
          ? 9.0
          : 10.0);
      return point.toString();
    }else{
      point = detailData.exactly;
      totalPoint = detailData.total > 0
          ? detailData.total
          : (this.data.common.type == "giaotiep"
          ? 10.0
          : (skill == 'Speaking' || skill == 'Writing')
          ? 9.0
          : 10.0);
      return point.toString() + '/' + totalPoint.toString();
    }
  }
}
