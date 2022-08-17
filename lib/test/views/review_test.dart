import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/test/component_view/FillTextScriptView.dart';
import 'package:gstudent/test/component_view/ViewSingleSelection.dart';

class ReviewTestPage extends StatefulWidget {
  List<PracticeGroupQuestion> gqs;

  ReviewTestPage({this.gqs });

  @override
  State<StatefulWidget> createState() =>
      ReviewTestPageState(gqs: this.gqs );
}

class ReviewTestPageState extends State<ReviewTestPage> {

  List<PracticeGroupQuestion> gqs;

  ReviewTestPageState({this.gqs });

  int index = 0;
  int timeStart = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                  image: AssetImage('assets/game_bg_arena.png'),
                  fit: BoxFit.fill,
                )),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 60,
                              child: Row(children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    child:  Image(
                                      image: AssetImage('assets/images/game_button_back.png'),
                                      height: 48,
                                      width: 48,
                                    ),
                                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: 160,
                                    child: TextButton(
                                      onPressed: () async {
                                        var currentIndex = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                          child: Stack(
                                                            clipBehavior: Clip.none,
                                                            alignment: Alignment.topCenter,
                                                            children: [
                                                              Positioned(
                                                                child: Image(
                                                                  image: AssetImage('assets/game_bg_dialog_create_long.png'),
                                                                  fit: BoxFit.fill,
                                                                ),
                                                                top: 0,
                                                                right: 8,
                                                                bottom: 0,
                                                                left: 8,
                                                              ),
                                                              Positioned(
                                                                  child: Column(
                                                                    children: [
                                                                      Center(
                                                                          child: OutlinedText(
                                                                            text: Text('TẤT CẢ CÂU HỎI',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontSize: 18, fontFamily: 'UTMThanChienTranh', fontWeight: FontWeight.w400, color: HexColor("#f0dea7"))),
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
                                                                  right: 48,
                                                                  bottom: 16,
                                                                  left: 48),
                                                            ],
                                                          )),
                                                      Container(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: ButtonGraySmall(
                                                            'ĐÓNG',
                                                            textColor: HexColor("#d5e7d5"),

                                                          ),
                                                        ),
                                                        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Colors.blue;
                                          return null;
                                        }),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .lbl_review_question,
                                        style: TextStyle( fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                          child: ListView(
                            children: [
                              gqs != null && gqs[index].description != null && gqs[index].description.isNotEmpty ?  Container(child: textQuestion(gqs[index].description),margin: EdgeInsets.fromLTRB(16, 4, 16, 4),): Container(),
                              gqs != null && gqs[index].scripts != null && gqs[index].scripts.isNotEmpty ? Container(child: textQuestion(gqs[index].scripts),margin: EdgeInsets.fromLTRB(16, 4, 16, 4),): Container(),
                              gqs != null ? content(context) : Container(),
                            ],
                          )),
                      Row(
                        children: [
                          Visibility(
                            visible: index == 0 ? false : true,
                            child: GestureDetector(
                                onTap: () => prevQuestion(),
                                child:Image(
                                  image: AssetImage('assets/images/game_select_character_left.png'),
                                  height: 28,
                                )),
                          ), Expanded(
                              child:Container()),
                          Visibility(
                            visible: gqs != null && index == gqs.length - 1 ? false : true,
                            child: GestureDetector(
                                onTap: () => nextQuestion(),
                                child:  Image(
                                  image: AssetImage('assets/images/game_select_character_right.png'),
                                  height: 28,
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
        ));
  }

  textQuestion(String title) {
    if (title.contains("<b>") || title.contains("</b>")) {
      var lst = title.split(' ');
      var listBold = lst.where((element) => element.contains("<b>") || element.contains("</b>")).toList();
      var indexFirst = lst.indexOf(listBold.first);
      var indexLast = lst.indexOf(listBold.last);
      return RichText(
        text: TextSpan(children: [
          if (lst.length > 0)
            for (int i = 0; i < lst.length; i++)
              if (i > indexFirst && i < indexLast)
                TextSpan(
                    text: lst[i] + ' ', style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, color: HexColor("#a12525"), decoration: TextDecoration.underline))
              else if (i == indexFirst || i == indexLast)
                TextSpan(text: ' ', style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, color: HexColor("#a12525"), decoration: TextDecoration.underline))
              else
                TextSpan(text: lst[i] + ' ', style: ThemeStyles.styleNormal(textColors: Colors.black))
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
                    text: splitWord[i].split("#").where((element) => element.isNotEmpty).first,
                    style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, color: HexColor("#a12525"), decoration: TextDecoration.underline),
                  )
                else
                  TextSpan(text: splitWord[i], style: ThemeStyles.styleNormal(textColors: HexColor("#a12525")))
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
                    TextSpan(text: lst[i] + ' ', style: ThemeStyles.styleBold(textColors: HexColor("#a12525")))
                  else if (i == indexFirst || i == indexLast)
                    TextSpan(
                      text: lst[i].split('#').where((element) => element.isNotEmpty).first + ' ',
                      style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, color: HexColor("#a12525"), decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(text: lst[i] + ' ', style: ThemeStyles.styleNormal(textColors: HexColor("#a12525")))
            ]),
          );
        } else {
          return RichText(
            text: TextSpan(children: [
              if (lst.length > 0)
                for (int i = 0; i < lst.length; i++)
                  if (lst[i].contains("#"))
                    TextSpan(
                      text: lst[i].split('#').where((element) => element.isNotEmpty).first + ' ',
                      style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, color: HexColor("#a12525"), decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(text: lst[i] + ' ', style: ThemeStyles.styleNormal(textColors: HexColor("#a12525")))
            ]),
          );
        }
      }
    } else {
      return Text(
        title,
        style: TextStyle(fontSize: 14, fontFamily: 'SourceSerifPro', color: HexColor("#a12525"), fontWeight: FontWeight.w400),
      );
    }
  }

  content(BuildContext context) {
    if (gqs[index] != null) {
      switch (gqs[index].type) {
        case QuestionType.FILL_TEXT_SCRIPT:
          return FillTextScriptView(
            grQuestion: gqs[index],
            key: GlobalKey<ScaffoldState>(),
          );
        case QuestionType.SINGLE_CHOICE:
          return ViewSingleSelection(
              grQuestion: gqs[index], key: GlobalKey<ScaffoldState>());
      // case QuestionType.MULTI_SELECTION:
      //   return MultiSelectionView(
      //       grQuestion: gqs[index], key: GlobalKey<ScaffoldState>());
        default:
          return ViewSingleSelection(
              grQuestion: gqs[index], key: GlobalKey<ScaffoldState>());
      }
    }
    return Container();
  }

  nextQuestion() {
    if (index < gqs.length - 1) {
      setState(() {
        index++;
      });
    }
  }

  prevQuestion() {
    if (index > 0) {
      setState(() {
        index--;
      });
    }
  }

}
