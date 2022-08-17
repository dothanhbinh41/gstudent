import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';
import 'package:gstudent/common/styles/theme_text.dart';

// ignore: must_be_immutable
class TrueFalseNotGivenPage extends StatefulWidget {
  GroupQuestionTest groupQuestionTest;

  TrueFalseNotGivenPage({this.groupQuestionTest, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      TrueFalseNotGivenPageState(groupQuestionTest: this.groupQuestionTest);
}

class TrueFalseNotGivenPageState extends State<TrueFalseNotGivenPage> {
  GroupQuestionTest groupQuestionTest;

  TrueFalseNotGivenPageState({this.groupQuestionTest});

  @override
  void initState() {
    super.initState();
    groupQuestionTest.groupQuestion.forEach((element) {
      if (element.answerSubmit == null) {
        element.answerSubmit = AnswerQuestion(
            id: element.id,
            answers: "",
            type: element.groupQuestionType,
            answerType: element.answerType);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Text(
              groupQuestionTest.groupQuestion[0].sectionMediaContent,
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro'),
            ),
            margin: EdgeInsets.fromLTRB(16, 0, 16, 4),
          ),
          ListView.builder(
            itemBuilder: (context, index) => item(index),
            itemCount: groupQuestionTest.groupQuestion.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          )
        ],
      ),
    );
  }

  item(int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: [
          Text(
            groupQuestionTest.groupQuestion[index].idQuestionImport.toString() +
                ". ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
              child: Container(
            child: Text(
              groupQuestionTest.groupQuestion[index].content.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro'),
            ),
            margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
          )),
          DropdownButton(
            items: buildDropDownMenuItems(
                groupQuestionTest.groupQuestion[index].answers),
            value: groupQuestionTest.groupQuestion[index].answer,
            onChanged: (value) {
              setState(() {
                groupQuestionTest.groupQuestion[index].answer = value;
                groupQuestionTest.groupQuestion[index].answerSubmit.answers =
                    value.noiDung.toString().toLowerCase();
              });
            },
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  List<DropdownMenuItem<dynamic>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<dynamic>> items = [];
    for (dynamic listItem in listItems) {
      var a = jsonEncode(listItem);
      var data = jsonDecode(a);
      items.add(
        DropdownMenuItem(
          child: textAnswer(data['noi_dung'].toString()),
          value: listItem,
        ),
      );
    }
    return items;
  }

  textAnswer(String text) {
    if (text.contains("#")) {
      var lst = text.split(' ');
      return RichText(
        text: TextSpan(children: [
          for (int i = 0; i < lst.length; i++)
            if (lst[i].contains("#"))
              if (lst[i].split('#').toList().length > 2)
                for (int j = 0; j < lst[i].split('#').toList().length; j++)
                  if (j % 2 == 1)
                    TextSpan(
                        text: lst[i].split('#').toList()[j],
                        style: ThemeStyles.styleBold(textColors: Colors.black))
                  else
                    TextSpan(
                        text: lst[i].split('#').toList()[j],
                        style: ThemeStyles.styleNormal(textColors: Colors.black))
              else
                TextSpan(
                    text: lst[i].replaceAll('#', '')+' ',
                    style: ThemeStyles.styleBold(textColors: Colors.black))
            else
              TextSpan(
                  text: lst[i]+' ',
                  style: ThemeStyles.styleNormal(textColors: Colors.black))
        ]),
      );
    } else {
      return Text(text,
          textAlign: TextAlign.start,
          style: ThemeStyles.styleNormal(textColors: Colors.black));
    }
  }
}
