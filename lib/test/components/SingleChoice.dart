import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/dialog_zoom_image.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/homework/components/PlayAudioView.dart';

// ignore: must_be_immutable
class SingleChoice extends StatefulWidget {
  PracticeGroupQuestion grQuestions;

  SingleChoice({this.grQuestions, Key key}) : super(key: key);

  @override
  SingleChoiceState createState() {
    return new SingleChoiceState(grQuestions: this.grQuestions);
  }
}

class SingleChoiceState extends State<SingleChoice> {
  PracticeGroupQuestion grQuestions;
  List<PracticeQuestion> questions;

  SingleChoiceState({this.grQuestions});

  List<String> listAnswers;
  PracticeQuestion currentQs;

  @override
  void initState() {
    super.initState();
    listAnswers = [];
    setState(() {
      currentQs = grQuestions.practiceQuestions[0];
      questions = grQuestions.practiceQuestions;
      for (var i = 0; i < grQuestions.practiceQuestions[0].practiceAnswers.length; i++) {
        listAnswers.add(grQuestions.practiceQuestions[0].practiceAnswers[i].content);
      }
      for (var i = 0; i < grQuestions.practiceQuestions.length; i++) {
        if (grQuestions.practiceQuestions[i].answer == null) {
          grQuestions.practiceQuestions[i].answer = PracticeAnswer(content: "", position: grQuestions.practiceQuestions[i].id);
        } else {
          if (grQuestions.practiceQuestions[i].answer.content.isNotEmpty) {
            grQuestions.practiceQuestions[i].practiceAnswers.where((element) => element.content == grQuestions.practiceQuestions[i].answer.content).first.isSelected = true;
            grQuestions.practiceQuestions[i].answer = grQuestions.practiceQuestions[i].practiceAnswers.where((element) => element.content == grQuestions.practiceQuestions[i].answer.content).first;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (grQuestions.audio.isNotEmpty)
        PlayAudioView(
          url: grQuestions.audio,
        ),
      grQuestions.image.isNotEmpty
          ? GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ShowImageDialog(
                    file: grQuestions.image,
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Image.network(grQuestions.image),
              ),
            )
          : Container(),
      Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        child: ListView.builder(physics: NeverScrollableScrollPhysics(), shrinkWrap: true, itemCount: questions.length, itemBuilder: (context, index) => listItem(questions[index])),
      )
    ]);
  }

  listItem(PracticeQuestion question) => Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Card(
              color: HexColor("#9c7f6a"),
              margin: EdgeInsets.only(top: 24, bottom: 24, right: 8, left: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  question.title != null ?   SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: question.title != null ? textQuestion(question.title) : textQuestion(''),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)), boxShadow: [], shape: BoxShape.rectangle, color: HexColor("#9c7f6a")),
                    ),
                  ) : Container(),
                  for (var a in question.practiceAnswers)
                    RadioListTile(
                        activeColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        value: a,
                        title: textAnswer(a.content),
                        groupValue: question.answer,
                        onChanged: (value) => setState(() {
                              question.answer = value;
                            })),
                ],
              )),
        ],
      );

  textAnswer(String text) {
    if (text.contains("#")) {
      var lst = text.split(' ');
      if (lst.length == 1) {
        var splitWord = text.split('#');
        var indexFirst = 1;
        return RichText(
          text: TextSpan(children: [
            if (splitWord.length > 0)
              for (int i = 0; i < splitWord.length; i++)
                if (i > indexFirst && i < indexFirst)
                  TextSpan(text: splitWord[i], style: ThemeStyles.styleBold())
                else if (i == indexFirst)
                  TextSpan(
                    text: splitWord[i],
                    style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, color: Colors.black, decoration: TextDecoration.underline),
                  )
                else
                  TextSpan(text: splitWord[i], style: ThemeStyles.styleNormal())
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
                    TextSpan(text: lst[i] + ' ', style: ThemeStyles.styleBold())
                  else if (i == indexFirst || i == indexLast)
                    TextSpan(
                      text: lst[i].split('#').where((element) => element.isNotEmpty).first + ' ',
                      style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, color: Colors.black, decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(text: lst[i] + ' ', style: ThemeStyles.styleNormal())
            ]),
          );
        } else {
          return RichText(
            text: TextSpan(children: [
              if (lst.length > 0)
                for (int i = 0; i < lst.length; i++)
                  if (lst[i].contains('#'))
                    TextSpan(
                      text: lst[i].split('#').where((element) => element.isNotEmpty).first + ' ',
                      style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, color: Colors.black, decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(text: lst[i] + ' ', style: ThemeStyles.styleNormal())
            ]),
          );
        }
      }
    } else {
      return Text(text, textAlign: TextAlign.start, style: ThemeStyles.styleNormal());
    }
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
                TextSpan(text: lst[i] + ' ', style: ThemeStyles.styleNormal(textColors: HexColor("#a12525")))
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
}
