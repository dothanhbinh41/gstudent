import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/resize_text.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:gstudent/test/components/FillTextScript.dart';
import 'package:gstudent/test/components/MultiSelection.dart';
import 'package:gstudent/test/components/SingleChoice.dart';
import 'package:gstudent/test/cubit/TestCubit.dart';

class ExamView extends StatefulWidget {
  int id;
  List<PracticeGroupQuestion> gqs;

  ExamView({this.id, this.gqs});

  @override
  State<StatefulWidget> createState() =>
      ExamViewState(id: this.id, gqs: this.gqs);
}

class ExamViewState extends State<ExamView> {
  int id;
  List<PracticeGroupQuestion> gqs;

  ExamViewState({this.id, this.gqs});

  TestCubit cubit;
  int index = 0;
  int idUser = 0;
  final setting = GetIt.instance.get<ApplicationSettings>();
  bool isShowScript = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<TestCubit>(context);
    if (gqs.isEmpty) {
      toast(context, 'Không có bài');
      Navigator.of(context).pop();
      return;
    }
    loadUser();
  }

  loadUser() async {
    var data = await setting.getCurrentUser();
    setState(() {
      idUser = data.userInfo.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: gqs.isNotEmpty
            ? Stack(
                children: [
                  Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: Image(
                        image: AssetImage('assets/game_bg_arena.png'),
                        fit: BoxFit.fill,
                      )),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: SafeArea(
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 52,
                                    child: Row(children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          child: Image(
                                            image: AssetImage(
                                                'assets/images/game_button_back.png'),
                                            height: 48,
                                            width: 48,
                                          ),
                                          margin:
                                              EdgeInsets.fromLTRB(8, 0, 8, 0),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          width: 160,
                                          child: TextButton(
                                            onPressed: () async {
                                              var currentIndex =
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Container(
                                                            color: Colors
                                                                .transparent,
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                    child:
                                                                        Stack(
                                                                  clipBehavior:
                                                                      Clip.none,
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  children: [
                                                                    Positioned(
                                                                      child:
                                                                          Image(
                                                                        image: AssetImage(
                                                                            'assets/game_bg_dialog_create_long.png'),
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                      top: 0,
                                                                      right: 8,
                                                                      bottom: 0,
                                                                      left: 8,
                                                                    ),
                                                                    Positioned(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Center(
                                                                                child: OutlinedText(
                                                                              text: Text('TẤT CẢ CÂU HỎI', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontFamily: 'UTMThanChienTranh', fontWeight: FontWeight.w400, color: HexColor("#f0dea7"))),
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
                                                                            Expanded(
                                                                                child: Container(
                                                                              child: GridView.count(
                                                                                  primary: false,
                                                                                  shrinkWrap: true,
                                                                                  crossAxisSpacing: 8,
                                                                                  mainAxisSpacing: 8,
                                                                                  crossAxisCount: 3,
                                                                                  childAspectRatio: 2,
                                                                                  children: List.generate(gqs.length, (index) {
                                                                                    return GestureDetector(
                                                                                      child: Container(
                                                                                        margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                                                                        height: 24,
                                                                                        child: Stack(
                                                                                          children: [
                                                                                            Container(
                                                                                              decoration: BoxDecoration(color: HexColor("#9c7f6a"), borderRadius: BorderRadius.circular(8), boxShadow: [
                                                                                                BoxShadow(
                                                                                                  color: HexColor("#867355"),
                                                                                                  spreadRadius: 1,
                                                                                                  blurRadius: 1,
                                                                                                  offset: Offset(0, 2), // changes position of shadow
                                                                                                ),
                                                                                              ]),
                                                                                              child: Center(
                                                                                                child: Text('Câu ' + (index + 1).toString(),
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: 'SourceSerifPro',
                                                                                                      fontWeight: FontWeight.w700,
                                                                                                      color: index == this.index ? Colors.white : HexColor("#fddea3"),
                                                                                                    )),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        Navigator.of(context).pop(index);
                                                                                      },
                                                                                    );
                                                                                  })),
                                                                            ))
                                                                          ],
                                                                        ),
                                                                        top: 24,
                                                                        right:
                                                                            48,
                                                                        bottom:
                                                                            16,
                                                                        left:
                                                                            48),
                                                                  ],
                                                                )),
                                                                Container(
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        ButtonGraySmall(
                                                                      'ĐÓNG',
                                                                      textColor:
                                                                          HexColor(
                                                                              "#d5e7d5"),

                                                                    ),
                                                                  ),
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          8,
                                                                          0,
                                                                          8),
                                                                )
                                                              ],
                                                            ));
                                                      });
                                              if (currentIndex != null) {
                                                setState(() {
                                                  index = currentIndex;
                                                });
                                              }
                                            },
                                            style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>((Set<
                                                              MaterialState>
                                                          states) {
                                                if (states.contains(
                                                    MaterialState.pressed))
                                                  return Colors.blue;
                                                return null;
                                              }),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .lbl_review_question,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'SourceSerifPro',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => submitQuestion(),
                                        child: Container(
                                          width: 80,
                                          margin:
                                              EdgeInsets.fromLTRB(4, 8, 4, 8),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(1, 1),
                                                    blurRadius: 1)
                                              ]),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .lbl_submit,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'SourceSerifPro',
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                                child: Stack(
                              children: [
                                ListView(
                                  children: [
                                    gqs != null &&
                                            gqs[index].description != null &&
                                            gqs[index].description.isNotEmpty
                                        ? Container(
                                            child: textQuestion(
                                                gqs[index].description),
                                            margin: EdgeInsets.fromLTRB(
                                                16, 4, 16, 4),
                                          )
                                        : Container(),
                                    gqs != null &&
                                            gqs[index].scripts != null &&
                                            gqs[index].scripts.isNotEmpty
                                        ? Container(
                                            child: textQuestion(
                                                gqs[index].scripts),
                                            margin: EdgeInsets.fromLTRB(
                                                16, 4, 16, 4),
                                          )
                                        : Container(),
                                    gqs != null
                                        ? content(context)
                                        : Container(),
                                  ],
                                ),
                                isShowScript &&
                                        gqs != null &&
                                        gqs[index].scripts != null &&
                                        gqs[index].scripts.isNotEmpty
                                    ? ExpandableText(
                                        child: gqs[index].scripts,
                                        maxHeight:
                                            MediaQuery.of(context).size.height -
                                                100,
                                      )
                                    : Container(),
                                Positioned(
                                  child: gqs != null &&
                                          gqs[index].scripts != null &&
                                          gqs[index].scripts.isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isShowScript = !isShowScript;
                                            });
                                          },
                                          child: Container(
                                            child: Center(
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/pin.png'),
                                                height: 16,
                                              ),
                                            ),
                                            height: 24,
                                            width: 24,
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                          ),
                                        )
                                      : Container(),
                                  top: 8,
                                  right: 8,
                                )
                              ],
                            )),
                            Row(
                              children: [
                                Visibility(
                                  visible: index == 0 ? false : true,
                                  child: GestureDetector(
                                      onTap: () => prevQuestion(),
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/game_select_character_left.png'),
                                          height: 28,
                                        ),
                                      )),
                                ),
                                Expanded(child: Container()),
                                Visibility(
                                  visible:
                                      gqs != null && index == gqs.length - 1
                                          ? false
                                          : true,
                                  child: GestureDetector(
                                      onTap: () => nextQuestion(),
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/game_select_character_right.png'),
                                          height: 28,
                                        ),
                                      )),
                                )
                              ],
                            )
                          ],
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Container());
  }

  content(BuildContext context) {
    if (gqs[index] != null) {
      switch (gqs[index].type) {
        case QuestionType.FILL_TEXT_SCRIPT:
          return FillTextScript(
            grQuestion: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );

        case QuestionType.MULTI_SELECTION:
          return MultiSelection(
              grQuestion: gqs[index], key: GlobalKey<ScaffoldState>());

        default:
          return SingleChoice(
              grQuestions: gqs[index], key: GlobalKey<ScaffoldState>());
      }
    }
    return Container();
  }

  textQuestion(String title) {
    if (title.contains("<b>") || title.contains("</b>")) {
      var lst = title.split(' ');
      var listBold = lst
          .where(
              (element) => element.contains("<b>") || element.contains("</b>"))
          .toList();
      var indexFirst = lst.indexOf(listBold.first);
      var indexLast = lst.indexOf(listBold.last);
      return RichText(
        text: TextSpan(children: [
          if (lst.length > 0)
            for (int i = 0; i < lst.length; i++)
              if (i > indexFirst && i < indexLast)
                TextSpan(
                    text: lst[i] + ' ',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w700,
                        color: HexColor("#a12525"),
                        decoration: TextDecoration.underline))
              else if (i == indexFirst || i == indexLast)
                TextSpan(
                    text: ' ',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w700,
                        color: HexColor("#a12525"),
                        decoration: TextDecoration.underline))
              else
                TextSpan(
                    text: lst[i] + ' ',
                    style: ThemeStyles.styleNormal(textColors: Colors.black))
        ]),
      );
    } else if (title.contains("#")) {
      var lst = title.split(' ');
      if (lst.length == 1) {
        var splitWord = title.split('#');
        return RichText(
          text: TextSpan(children: [
            if (splitWord.length > 0)
              for (int i = 0; i < splitWord.length; i++)
                if (splitWord[i].contains("#"))
                  TextSpan(
                    text: splitWord[i]
                        .split("#")
                        .where((element) => element.isNotEmpty)
                        .first,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w700,
                        color: HexColor("#a12525"),
                        decoration: TextDecoration.underline),
                  )
                else
                  TextSpan(
                      text: splitWord[i],
                      style: ThemeStyles.styleNormal(
                          textColors: HexColor("#a12525")))
          ]),
        );
      } else {
        var listBold = lst.where((element) => element.contains("#")).toList();
        if (listBold.length == 2) {
          var indexFirst = lst.indexOf(listBold.first);
          var indexLast = lst.indexOf(listBold.last);
          return RichText(
            text: TextSpan(children: [
              if (lst.length > 0)
                for (int i = 0; i < lst.length; i++)
                  if (i > indexFirst && i < indexLast)
                    TextSpan(
                        text: lst[i] + ' ',
                        style: ThemeStyles.styleBold(
                            textColors: HexColor("#a12525")))
                  else if (i == indexFirst || i == indexLast)
                    TextSpan(
                      text: lst[i]
                              .split('#')
                              .where((element) => element.isNotEmpty)
                              .first +
                          ' ',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'SourceSerifPro',
                          fontWeight: FontWeight.w700,
                          color: HexColor("#a12525"),
                          decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(
                        text: lst[i] + ' ',
                        style: ThemeStyles.styleNormal(
                            textColors: HexColor("#a12525")))
            ]),
          );
        } else {
          return RichText(
            text: TextSpan(children: [
              if (lst.length > 0)
                for (int i = 0; i < lst.length; i++)
                  if (lst[i].contains("#"))
                    TextSpan(
                      text: lst[i]
                              .split('#')
                              .where((element) => element.isNotEmpty)
                              .first +
                          ' ',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'SourceSerifPro',
                          fontWeight: FontWeight.w700,
                          color: HexColor("#a12525"),
                          decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(
                        text: lst[i] + ' ',
                        style: ThemeStyles.styleNormal(
                            textColors: HexColor("#a12525")))
            ]),
          );
        }
      }
    } else {
      return Text(
        title,
        style: TextStyle(
            fontSize: 14,
            fontFamily: 'SourceSerifPro',
            color: HexColor("#a12525"),
            fontWeight: FontWeight.w400),
      );
    }
  }

  nextQuestion() async {
    if (index < gqs.length - 1) {
      setState(() {
        index++;
      });
      var fakeData = gqs;
      var res = await setting.saveExamById(id, fakeData, idUser);
    }
  }

  prevQuestion() async {
    if (index > 0) {
      setState(() {
        index--;
      });
      var fakeData = gqs;
      var res = await setting.saveExamById(id, fakeData, idUser);
    }
  }

  submitQuestion() async {
    showLoading();
    List<PracticeAnswer> qs = [];
    gqs.forEach((e) {
      var qss = e.practiceQuestions
          .map((e) => e.answer)
          .toList()
          .where((element) => element != null && element.content.isNotEmpty)
          .toList();
      qs.addAll(qss);
    });
    if (qs.isEmpty) {
      toast(context, 'Bạn chưa trả lời câu nào.');
      hideLoading();
      return;
    }
    var result = await cubit.submit(id, qs);
    hideLoading();
    if (result.error == false) {
      if (result.data != null) {
        await setting.deleteExamById(id, idUser);
        toast(context, "Nộp thành công");
        Navigator.of(context).pop(result.data);
      } else {
        toast(context, result.message);
        return;
      }
    } else {
      toast(context, "Lỗi");
    }
  }
}
