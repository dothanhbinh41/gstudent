
import 'dart:convert';

import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';

// ignore: must_be_immutable
class MultiSelectionPage extends StatefulWidget {
  GroupQuestionTest groupQuestionTest;

  MultiSelectionPage({this.groupQuestionTest, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      MultiSelectionPageState(groupQuestionTest: this.groupQuestionTest);
}

class MultiSelectionPageState extends State<MultiSelectionPage> {
  GroupQuestionTest groupQuestionTest;

  MultiSelectionPageState({this.groupQuestionTest});

  @override
  void initState() {
    super.initState();
    groupQuestionTest.groupQuestion.forEach((element) {
      if (element.answerSubmit == null) {
        element.answerSubmit = AnswerQuestion(
            id: element.id,
            answers: [],
            type: element.groupQuestionType,
            answerType: element.answerType);

        try {
          element.answers =
          List<Answer>.from(jsonDecode(jsonEncode(element.answers)).map((x) => Answer.fromJson(x)));
          element.answers.forEach((e) {
            e.isSelected = false;
          });
        } catch (e) {
          print(e.toString());
        }

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) => item(context, index),
        itemCount: groupQuestionTest.groupQuestion.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  item(BuildContext context, int index) {
    double height =
        40.0 + (groupQuestionTest.groupQuestion[index].answers.length * 56);


   return  Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Card(
            color: HexColor("#9c7f6a"),
            margin: EdgeInsets.only(top: 24, bottom: 24, right: 8, left: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          groupQuestionTest.groupQuestion[index].idQuestionImport.toString() + ". " + groupQuestionTest.groupQuestion[index].content,
                          style: TextStyle(color: HexColor("#a12525"), fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro', fontSize: 14),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)), boxShadow: [], shape: BoxShape.rectangle, color: HexColor("#9c7f6a")),
                  ),
                ),
                for (var a in   groupQuestionTest.groupQuestion[index].answers)
                  CheckboxListTile(
                      activeColor: Colors.black,
                      checkColor: Colors.white,
                      dense: true,
                      title: Text(
                        a.noiDung,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro', color: Colors.black),
                      ),
                      value:  a.isSelected,
                      onChanged: (value) {
                        if(value == true){
                          if(groupQuestionTest.groupQuestion[index].answers
                              .where((e) => e.isSelected == true)
                              .toList().length < 2){
                            setState(() {
                              a.isSelected = value;
                              reloadDataSubmit(index);
                            });
                          }
                        }else{
                          setState(() {
                            a.isSelected = value;
                            reloadDataSubmit(index);
                          });
                        }


                      }),
              ],
            )),

      ],
    );
  }

  void reloadDataSubmit(index) {
    var l = groupQuestionTest.groupQuestion[index].answers
        .where((e) => e.isSelected == true)
        .toList();
    if (l != null && l.length > 0) {
      groupQuestionTest.groupQuestion[index].answersSubmit =
          List<AnswerQuestion>.empty(growable: true);
      l.forEach((element) {
        groupQuestionTest.groupQuestion[index].answersSubmit.add(AnswerQuestion(
            id: groupQuestionTest.groupQuestion[index].id,
            answers: element.noiDung,
            type: groupQuestionTest.groupQuestion[index].groupQuestionType,
            answerType: groupQuestionTest.groupQuestion[index].answerType));
      });
      print(jsonEncode(groupQuestionTest.groupQuestion[index].answersSubmit));
    }
  }
}
