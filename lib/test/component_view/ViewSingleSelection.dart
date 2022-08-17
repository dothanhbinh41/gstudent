
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/dialog_zoom_image.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/homework/components/PlayAudioView.dart';

class ViewSingleSelection extends StatefulWidget {
  PracticeGroupQuestion grQuestion;
  ViewSingleSelection({this.grQuestion, Key key}) : super(key: key);
  @override
  ViewSingleSelectionState createState() {
    return new ViewSingleSelectionState(grQuestion: this.grQuestion);
  }
}

class ViewSingleSelectionState extends State<ViewSingleSelection> {
  PracticeGroupQuestion grQuestion;

  ViewSingleSelectionState({this.grQuestion});
  List<PracticeQuestion> questions;

  @override
  void initState() {
    super.initState();
    setState(() {
      questions = grQuestion.practiceQuestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (grQuestion.audio.isNotEmpty)
        PlayAudioView(
          url: grQuestion.audio,
        ),
      grQuestion.image.isNotEmpty
          ? GestureDetector(
        onTap: () {
          showDialog(context: context, builder: (context) => ShowImageDialog(
            file:  grQuestion.image,
          ),);
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Image.network(grQuestion.image),
        ),
      )
          : Container(),
      Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: questions.length,
            itemBuilder: (context, index) => listItem(questions[index])),
      )
    ]);
  }

  listItem(PracticeQuestion question) {
    PracticeAnswer studentAnswer =
    question.practiceAnswers.where((e) => e.content.split("#").join() == question.studentAnswer.split("#").join()).isNotEmpty ? question.practiceAnswers.firstWhere((e) => e.content.split("#").join()== question.studentAnswer.split("#").join()) : PracticeAnswer(content: "") ;
    PracticeAnswer correctAnswer =
        question.practiceAnswers.where((e) => e.content.split("#").join().trim()== question.correctAnswers).isNotEmpty  ?question.practiceAnswers.firstWhere((e) => e.content.split("#").join().trim() == question.correctAnswers)  : PracticeAnswer(content: "");
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Card(
          color: HexColor("#9c7f6a"),
            margin: EdgeInsets.only(top: 24, bottom: 0, right: 8, left: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child:  question.title != null ? textQuestion(question.title) : textQuestion(grQuestion.description),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4)),
                        boxShadow: [],
                        shape: BoxShape.rectangle,
                        color: HexColor("#9c7f6a")),
                  ),
                ),
                for (var a in question.practiceAnswers)
                  RadioListTile(
                      activeColor: studentAnswer == correctAnswer ? (a.content.split("#").join().trim() == studentAnswer.content.split("#").join().trim() ? Colors.green.shade600 : Colors.red) : (a.content.split("#").join().trim() == correctAnswer.content.split("#").join().trim()? Colors.green.shade600 : Colors.red),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      value: a,
                      title: Text(
                        a.content.split("#").join(),
                        style: TextStyle(
                            fontSize: 14,
                            color: studentAnswer == correctAnswer ? (a.content.split("#").join().trim() == studentAnswer.content.split("#").join().trim() ? Colors.green.shade600 : Colors.red) : (a.content.split("#").join().trim() == correctAnswer.content.split("#").join().trim()? Colors.green.shade600 : Colors.red)),
                      ),
                      groupValue: studentAnswer,
                      onChanged: (value) => null),
              ],
            )),

      ],
    );
  }


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
