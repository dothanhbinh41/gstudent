import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Exam/exam_data.dart';
import 'package:gstudent/api/dtos/Exam/result_submit.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/draw_progress_tripped.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/result/views/result_exam.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:gstudent/test/cubit/TestCubit.dart';
import 'package:gstudent/test/services/TestServices.dart';
import 'package:gstudent/test/views/exam_view.dart';
import 'package:gstudent/test/views/review_test.dart';

class ListTopicExamView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListTopicExamViewState();
}

class ListTopicExamViewState extends State<ListTopicExamView> {
  GlobalKey _dropdownButtonKey = GlobalKey();
  String dropdownValue = 'Tất cả';
  double progress = 0.0;
  int percent = 0;
  TestCubit cubit;
  List<Exam> ielts;
  List<Exam> toeic;
  List<Exam> university;
  List<Exam> all = [];
  List<Exam> data = [];
  final service = GetIt.instance.get<TestService>();
  final setting = GetIt.instance.get<ApplicationSettings>();
  int idUser = 0;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
    loadData();
  }

  Future loadData() async {
    await Future.wait([loadUser(), loadUniversity(), loadIelts(),loadToeic()]);
  }

 Future loadUser() async {
    var u = await setting.getCurrentUser();
    setState(() {
      idUser = u.userInfo.id;
    });
  }

  Future loadUniversity() async {
    showLoading();
    var res = await cubit.getListTestByType('university');
    hideLoading();
    if (res != null) {
      setState(() {
        university = res.data;
        all.addAll(university);
        data = all;
        isLoading =true;

      });
    }
  }

  Future loadIelts() async {
    showLoading();
    var res = await cubit.getListTestByType('ielts');
    hideLoading();
    if (res != null) {
      setState(() {
        ielts = res.data;
        all.addAll(ielts);
        data = all;
        isLoading =true;

      });
    }
  }

  Future loadToeic() async {
    showLoading();
    var res = await cubit.getListTestByType('toeic');
    hideLoading();
    if (res != null) {
      setState(() {
        toeic = res.data;
        all.addAll(toeic);
        data = all;
        isLoading =true;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        hideLoading();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:isLoading ?  Container(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      child: Image(
                        image: AssetImage('assets/game_bg_dialog_create_long.png'),
                        fit: BoxFit.fill,
                      ),
                      top: 24,
                      right: 16,
                      left: 16,
                      bottom: 0,
                    ),
                    Positioned(
                      top: 60,
                      right: 64,
                      left: 64,
                      bottom: 28,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                              child: OutlinedText(
                                text: Text('DANH SÁCH ĐỀ THI',
                                    textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontFamily: 'UTMThanChienTranh', fontWeight: FontWeight.w400, color: HexColor("#f0dea7"))),
                                strokes: [
                                  OutlinedTextStroke(color: HexColor("#681527"), width: 3),
                                ],
                              )

                            // textpaintingBoldBase('Danh sách đề thi', 20, HexColor("#f8e9a5"), HexColor("#681527"), 3)
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Image(
                              image: AssetImage('assets/images/ellipse.png'),
                            ),
                          ),
                          Container(
                            height: 56,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      'Loại đề',
                                      style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, fontSize: 18),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 40,
                                          padding: EdgeInsets.fromLTRB(8, 4, 0, 0),
                                          decoration: BoxDecoration(
                                              color: HexColor("#ffc288"),
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                                              border: Border.all(color: HexColor("#3f2208"), width: 2)),
                                          child: DropdownButton<String>(
                                            key: _dropdownButtonKey,
                                            value: dropdownValue,
                                            icon: Visibility(visible: false, child: Icon(Icons.arrow_downward)),
                                            style: ThemeStyles.styleBold(),
                                            underline: Container(color: Colors.transparent),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                dropdownValue = newValue;
                                              });
                                              data = loadDataDropdown(newValue);
                                            },
                                            onTap: () {
                                              setState(() {});
                                            },
                                            items: <String>['Tất cả', 'Ielts', 'University', 'Toeic'].map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Container(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          value,
                                                          style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700),
                                                          textAlign: TextAlign.start,
                                                        ),
                                                        // Divider(
                                                        //   color: Colors
                                                        //       .black,
                                                        //   thickness: 0.5,
                                                        // )
                                                      ],
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                    ),
                                                  ));
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => openDropdown(),
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: HexColor("#3f2208"), width: 2),
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4))),
                                          child: Image(
                                            image: AssetImage('assets/images/button_drop_down.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  flex: 3,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return FutureBuilder<ProcessTest>(
                                    builder: (context, snapshot) {
                                      return GestureDetector(
                                        onTap: () => examClick(data[index]),
                                        child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                            decoration: BoxDecoration(border: Border.all(color: HexColor("#d2b06c")), color: HexColor("#fff6d8"), borderRadius: BorderRadius.circular(2)),
                                            child: Column(children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                                child: Text(
                                                  data[index].name,
                                                  style: ThemeStyles.styleBold(),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              snapshot.data != null
                                                  ? Container(
                                                child: Text(
                                                  'Đã làm',
                                                  style: ThemeStyles.styleNormal(font: 12),
                                                ),
                                              )
                                                  : Container(),
                                              snapshot.data != null
                                                  ? Container(
                                                margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4),
                                                  color: Colors.transparent,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      top: 0,
                                                      bottom: 0,
                                                      right: 1,
                                                      left: 1,
                                                      child: CustomPaint(
                                                        painter: StripePainter(progress: snapshot.data.current / snapshot.data.total, distance: (MediaQuery.of(context).size.width * 0.08),height: 18),
                                                        size: Size.infinite,
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(4), color: Colors.transparent, border: Border.all(color: HexColor("#272727"), width: 1)),
                                                    ),
                                                    Center(
                                                      child: Container(
                                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: textpaintingBase(snapshot.data.current.toString() + "/" + snapshot.data.total.toString(), 12, Colors.white, Colors.black, 2),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                                  : Container(),
                                            ])),
                                      );
                                    },
                                    future: itemExam(index),
                                  );
                                },
                                shrinkWrap: true,
                                itemCount: data.length,
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
                      height: 48,
                      child: ButtonGraySmall(
                        'ĐÓNG',
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )  : Container() ,
      ),
    );
  }

  List<Exam> loadDataDropdown(String text) {
    switch (text) {
      case 'Ielts':
        return ielts;

      case 'Toeic':
        return toeic;
      case 'University':
        return university;
      default:
        return all;
    }
  }

  void openDropdown() {
    GestureDetector detector;
    void searchForGestureDetector(BuildContext element) {
      element.visitChildElements((element) {
        if (element.widget != null && element.widget is GestureDetector) {
          detector = element.widget;
          return false;
        } else {
          searchForGestureDetector(element);
        }

        return true;
      });
    }

    searchForGestureDetector(_dropdownButtonKey.currentContext);
    assert(detector != null);

    detector.onTap();
  }

  examClick(Exam data) async {
    showLoading();
    var result = await cubit.getResultExamTest(data.id);
    hideLoading();
    if (result == null || result.data == null && result.error == true ) {
      var currentExamDoing = await setting.getExamById(data.id, idUser);
      if (currentExamDoing == null) {
        var res = await cubit.getExamTest(data.id);
        if (res != null && res.error == false) {
          if (res.data.practiceGroupQuestions.isEmpty) {
            toast(context, 'Không có bài');
            return;
          }
          var timeStart = DateTime.now().millisecondsSinceEpoch;
          ResultTest param = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: TestCubit(services: this.service),
              child: ExamView(
                id: data.id,
                gqs: res.data.practiceGroupQuestions,
              ),
            ),
          ));
          setState(() {
            isLoading = true;
          });
          loadData();
          if (param != null) {
            var time = DateTime.now().millisecondsSinceEpoch - timeStart;

            await showDialog(
              context: context,
              useSafeArea: false,
              builder: (context) => ResultExamView(
                duration: time,
                process: param.process,
              ),
            );
          }
        }
      } else {
        var timeStart = DateTime.now().millisecondsSinceEpoch;
        ResultTest param = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: TestCubit(services: this.service),
            child: ExamView(
              id: data.id,
              gqs: currentExamDoing,
            ),
          ),
        ));
        setState(() {
          isLoading = true;
        });
        loadData();
        if (param != null) {
          var time = DateTime.now().millisecondsSinceEpoch - timeStart;

          await showDialog(
            context: context,
            builder: (context) => ResultExamView(
              duration: time,
              process: param.process,
            ),
          );
        }
      }
    }
    else {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ReviewTestPage(
          gqs: result.data.first.test,
        ),
      ));
    }
  }

  Future<ProcessTest> itemExam(int index) async {
    var exam = await setting.getExamById(data[index].id, idUser);
    if (exam != null) {
      int current = 0;
      int total = 0;
      var a = exam.where((element) => element.practiceQuestions.where((e) => e.answer != null).toList() != null).toList();
      for (var i = 0; i < a.length; i++) {
        current += a[i].practiceQuestions.where((element) => element.answer != null && element.answer.content.isNotEmpty).toList().length;
        total += a[i].practiceQuestions.toList().length;
      }
      print(current);
      print(total);
      return ProcessTest(total: total, current: current);
    }
    return null;
  }
}

class ProcessTest {
  int total;
  int current;

  ProcessTest({this.total, this.current});
}
