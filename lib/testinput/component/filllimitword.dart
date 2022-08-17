
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';

// ignore: must_be_immutable
class FillLimitWordPage extends StatefulWidget {
  GroupQuestionTest groupQuestionTest;

  FillLimitWordPage({this.groupQuestionTest, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      FillLimitWordPageState(groupQuestionTest: this.groupQuestionTest);
}

class FillLimitWordPageState extends State<FillLimitWordPage> {
  GroupQuestionTest groupQuestionTest;

  FillLimitWordPageState({this.groupQuestionTest});

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
    return Container(
      child: Column(
        children: [
          Container(
            child: ListView.builder(
              itemBuilder: (context, index) => item(index),
              itemCount: groupQuestionTest.groupQuestion.length,
              shrinkWrap: true,
            ),
          )
        ],
      ),
    );
  }

  item(int index) {
    TextEditingController textEdit = TextEditingController();
    textEdit.text = groupQuestionTest.groupQuestion[index].answerSubmit.answers;
    textEdit.selection =
        TextSelection.fromPosition(TextPosition(offset: textEdit.text.length));

    return Container(
      height: 40,
      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: [
          Text(groupQuestionTest.groupQuestion[index].idQuestionImport
              .toString()),
          Expanded(
              child: Container(
            child: TextField(
              controller: textEdit,
              maxLines: 1,
              style: TextStyle(fontSize: 14,  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,),
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  isDense: true,
                  hintText: "..............",
                  counterText: "",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(8))),
              onChanged: (value) {
                setState(() {
                  groupQuestionTest.groupQuestion[index].answerSubmit.answers =
                      value;
                });
              },
            ),
            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
          ))
        ],
      ),
    );
  }
}
