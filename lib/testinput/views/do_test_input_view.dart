import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/TestInput/ResultDto.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/answer_submit.dart';
import 'package:gstudent/api/dtos/TestInput/communicate.dart';
import 'package:gstudent/api/dtos/TestInput/data.dart';
import 'package:gstudent/api/dtos/TestInput/enum.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';
import 'package:gstudent/api/dtos/TestInput/ielts.dart';
import 'package:gstudent/api/dtos/TestInput/toeic.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/views/home_view.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/result/views/result_test_input.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:gstudent/settings/views/notification_dialog.dart';
import 'package:gstudent/testinput/cubit/testinput_cubit.dart';
import 'package:gstudent/testinput/services/testinput_services.dart';
import 'package:gstudent/testinput/views/do_test_view/skill_reading.dart';
import 'package:gstudent/testinput/views/do_test_view/skill_general.dart';
import 'package:gstudent/testinput/views/do_test_view/skill_listening.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gstudent/testinput/views/do_test_view/skill_speaking.dart';
import 'package:gstudent/testinput/views/do_test_view/skill_writing.dart';

class DoTestInputView extends StatefulWidget {
  String type;
  int id;

  DoTestInputView({this.type, this.id});

  @override
  State<StatefulWidget> createState() => DoTestInputViewState(type: this.type, id: this.id);
}

class DoTestInputViewState extends State<DoTestInputView> {
  String type;
  int id;

  DoTestInputViewState({this.type, this.id});

  TestInputDto data;
  int idImport;
  ResultTestInputData resultData;
  bool isVisibleListening = false;
  bool isVisibleReading = false;

  bool isVisibleWriting = false;

  // bool isVisibleSpeaking = false;
  bool isVisibleGeneral = false;
  bool isLast = false;
  bool canSubmit = false;
  TestInputCubit cubit;
  TestInputService testinput;
  ApplicationSettings settings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testinput = GetIt.instance.get<TestInputService>();
    settings = GetIt.instance.get<ApplicationSettings>();
    cubit = BlocProvider.of<TestInputCubit>(context);
    getData();
  }

  void checkData() async {
    List<bool> checkList = [];
    var lTest = await cubit.getTestInput('listening', this.id);
    var rdTest = await cubit.getTestInput('reading', this.id);
    var wtTest = await cubit.getTestInput('writing', this.id);
    // isVisibleSpeaking = false;
    var generalTest = await cubit.getTestInput('general', this.id);

    setState(() {
      isVisibleListening = lTest != null;
      isVisibleReading = rdTest != null;
      isVisibleWriting = wtTest != null;
      // isVisibleSpeaking = false;
      isVisibleGeneral = generalTest != null;
    });

    checkList.add(isVisibleListening);
    checkList.add(isVisibleReading);
    checkList.add(isVisibleWriting);
    // checkList.add(isVisibleSpeaking);
    checkList.add(isVisibleGeneral);
    isLast = checkList.where((element) => element == false).toList().length == 1;
    canSubmit = checkList.where((element) => element == false).isEmpty;

    //  if(resultData.data.length == checkList.where((element) => element == false).toList().length){
    //    await  showDialog(context: context, builder: (context) => InfoTypeTest(result: resultData),);
    // //   HomeGamePage()
    //  }
  }

  void getData() async {
    showLoading();
    var res = await cubit.getExamByType(type);
    if (res != null) {
      setState(() {
        data = res.data;
      });
    }

    idImport = res.importId;
    checkData();
    hideLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Image(
              image: AssetImage('assets/game_bg_arena_light.png'),
              fit: BoxFit.fill,
            )),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          bottom: 0,
          child: content(context),
        )
      ],
    ));
  }

  content(context) {
    return Column(
      children: [
        header(context),
        listening(context),
        writing(context),
        // speaking(context),
        reading(context),
        general(context),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }

  header(context) {
    return SafeArea(
        child: Container(
      height: 120,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(8, 8, 0, 0),
              child: Image(
                image: AssetImage('assets/images/game_button_back.png'),
                height: 48,
                width: 48,
              ),
            ),
          ),
          Expanded(child: Container()),
          Visibility(
            //   visible:
            //    resultData != null && resultData.data.length > 0 ? true : false,
            child: SafeArea(child: Container(
              margin: EdgeInsets.all(8),
              height: 40,
              child: GestureDetector(
                child: Center(
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: HexColor("#9c7f6a")),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).lbl_submit,
                          style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
                onTap: () => submitTestinput(),
              ),
            ),),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    ));
  }

  submitTestinput() async {
    List<QuestionTestInputDto> data = [];
    var listening = await cubit.getTestInput('listening', this.id);
    var rd = await cubit.getTestInput('reading', this.id);
    var wt = await cubit.getTestInput('writing', this.id);
    var general = await cubit.getTestInput('general', this.id);
    if (listening != null) data.addAll(listening);
    if (rd != null) data.addAll(rd);
    if (wt != null) data.addAll(wt);
    if (general != null) data.addAll(general);

    List<AnswerQuestion> ans = [];
    data.forEach((element) {
      if (element.answerSubmit != null && element.answerSubmit.answers.isNotEmpty) {
        ans.add(element.answerSubmit);
      }
      if (element.answersSubmit != null && element.answersSubmit.isNotEmpty) {
        AnswerQuestion qs = AnswerQuestion(answers: [], id: element.answersSubmit.first.id, type: element.answersSubmit.first.type, answerType: element.answersSubmit.first.answerType);
        element.answersSubmit.forEach((ans) {
          qs.answers.add(ans.answers);
        });
        ans.add(qs);
      }
    });

    List<AnswerSubmit> answers = [];
    ans.forEach((element) {
      var a = AnswerSubmit(id: element.id);
      if (element.type == GroupQuestionType.YES_NO_NOTGIVEN || element.type == GroupQuestionType.TRUE_FALSE_NOTGIVEN) {
        a.answers = List<String>.empty(growable: true);
        a.answers.add(element.answers.toUpperCase());
      } else if (element.type == GroupQuestionType.TEXT) {
        if (element.answerType == AnswerType.MULTIPLE_CHOICE) {
          a.answers = List<String>.empty(growable: true);
          a.answers.add(element.answers);
        } else {
          a.answers = element.answers;
        }
      } else if (element.type == GroupQuestionType.SELECT_MULTIPLE) {
        a.answers = element.answers;
      } else {
        a.answers = element.answers;
      }
      answers.add(a);
    });
    print(jsonEncode(answers));

    var result = await cubit.submitQuestion(type, "", answers, idImport, false, id);

    if (result != null) {
      await cubit.deleteLocalQuestion('listening', this.id);
      await cubit.deleteLocalQuestion('reading', this.id);
      await cubit.deleteLocalQuestion('writing', this.id);
      await cubit.deleteLocalQuestion('general', this.id);
      await showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 300),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Align(
            alignment: Alignment.topCenter,
            child: NotificationDialogView(
              message: "Nộp bài thành công. Xin vui lòng chờ chấm điểm bài thi.",
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
      Navigator.of(context).pop(true);
    }
  }

  listening(context) {
    return GestureDetector(
      child: Visibility(
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
          height: 48,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(blurRadius: 1, offset: Offset(1, 1), color: HexColor("#80FFFFFF"))]),
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Text(
              "Listening",
              style: ThemeStyles.styleNormal(),
            ),
            alignment: Alignment.centerLeft,
          ),
        ),
        visible: isVisibleListening == false && data != null && data.listening != null,
      ),
      onTap: () => navigationToListening(),
    );
  }

  // speaking(context) {
  //   return Visibility(
  //     child: GestureDetector(
  //       child: Container(
  //         margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
  //         height: 48,
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(8),
  //             boxShadow: [
  //               BoxShadow(
  //                   blurRadius: 1,
  //                   offset: Offset(1, 1),
  //                   color: HexColor("#80FFFFFF"))
  //             ]),
  //         child: Container(
  //           margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
  //           child: Text("Speaking"),
  //           alignment: Alignment.centerLeft,
  //         ),
  //       ),
  //       onTap: () => navigationToSpeaking(),
  //     ),
  //     visible: (type == "ielts" && isVisibleSpeaking == false),
  //   );
  // }

  writing(context) {
    return Visibility(
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
          height: 48,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(blurRadius: 1, offset: Offset(1, 1), color: HexColor("#80FFFFFF"))]),
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Text(
              "Writing",
              style: ThemeStyles.styleNormal(),
            ),
            alignment: Alignment.centerLeft,
          ),
        ),
        onTap: () => navigationToWriting(),
      ),
      visible: (type != "giaotiep" && isVisibleWriting == false && data != null &&  data.writing != null),
    );
  }

  reading(context) {
    return Visibility(
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
          height: 48,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(blurRadius: 1, offset: Offset(1, 1), color: HexColor("#80FFFFFF"))]),
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Text(
              "Reading",
              style: ThemeStyles.styleNormal(),
            ),
            alignment: Alignment.centerLeft,
          ),
        ),
        onTap: () => navigationToReading(),
      ),
      visible: isVisibleReading == false && data != null && data.reading != null,
    );
  }

  general(context) {
    return Visibility(
      child: GestureDetector(
        onTap: () => navigationToGeneral(),
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
          height: 48,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(blurRadius: 1, offset: Offset(1, 1), color: HexColor("#80FFFFFF"))]),
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Text(
              "General",
              style: ThemeStyles.styleNormal(),
            ),
            alignment: Alignment.centerLeft,
          ),
        ),
      ),
      visible: (type == "giaotiep" && isVisibleGeneral == false && data != null && data.generalTest != null),
    );
  }

  Widget headerImage(context) {
    return Container(
      alignment: Alignment.topRight,
      child: new Image(
        image: AssetImage('assets/header.png'),
        alignment: Alignment.topRight,
        fit: BoxFit.fill,
      ),
    );
  }

  navigationToListening() async {
    var tests = groupBy(data.listening, (object) => object.groupQuestion).values.toList();
    List<GroupQuestionTest> list = tests.map((e) => GroupQuestionTest(groupQuestion: e)).toList();
    if (list != null) {
      var result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: TestInputCubit(
              settings: settings,
              services: testinput,
            ),
            child: ListeningSkillPage(
              type: type,
              data: list,
              idStudent: id,
              isLast: isLast,
              idImport: idImport,
            ),
          ),
        ),
      );

      checkData();
    }
  }

  navigationToReading() async {
    var tests = groupBy(data.reading, (object) => object.groupQuestion).values.toList();

    List<GroupQuestionTest> list = tests.map((e) => GroupQuestionTest(groupQuestion: e)).toList();
    if (list != null) {
      var result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: TestInputCubit(
              settings: settings,
              services: testinput,
            ),
            child: ReadingSkillPage(
              type: type,
              data: list,
              idStudent: id,
              isLast: isLast,
              idImport: idImport,
            ),
          ),
        ),
      );
      checkData();
    }
  }

  navigationToWriting() async {
    var tests = groupBy(data.writing, (object) => object.groupQuestion).values.toList();
    List<GroupQuestionTest> list = tests.map((e) => GroupQuestionTest(groupQuestion: e)).toList();
    if (list != null) {}

    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: TestInputCubit(
            settings: settings,
            services: testinput,
          ),
          child: WritingSkillPage(
            type: type,
            isLast: isLast,
            data: data.writing,
            idImport: idImport,
            idStudent: this.id,
          ),
        ),
      ),
    );

    checkData();
  }

  // navigationToSpeaking() async {
  //   var tests = groupBy(data.writing, (object) => object.groupQuestion).values.toList();
  //   List<GroupQuestionTest> list = tests.map((e) => GroupQuestionTest(groupQuestion: e)).toList();
  //   if (list != null) {}
  //   var result = await Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => SpeakingSkillPage(
  //       type: type,
  //       isLast: false,
  //       data: data.speaking,
  //       idImport: idImport,
  //     ),
  //   ));
  //
  //   if (result) {
  //     checkData();
  //   }
  // }

  navigationToGeneral() async {
    var tests = groupBy(data.generalTest, (object) => object.groupQuestion).values.toList();
    List<GroupQuestionTest> list = tests.map((e) => GroupQuestionTest(groupQuestion: e)).toList();

    var result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: TestInputCubit(
          settings: settings,
          services: testinput,
        ),
        child: GeneralPage(
          type: type,
          idStudent: this.id,
          isLast: isLast,
          data: list,
          idImport: idImport,
        ),
      ),
    ));

    checkData();
  }
}
