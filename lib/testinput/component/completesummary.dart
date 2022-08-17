
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';

// ignore: must_be_immutable
class CompleteSummaryPage extends StatefulWidget {
  GroupQuestionTest groupQuestionTest;

  CompleteSummaryPage({this.groupQuestionTest, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      CompleteSummaryPageState(groupQuestionTest: this.groupQuestionTest);
}

class CompleteSummaryPageState extends State<CompleteSummaryPage> {
  GroupQuestionTest groupQuestionTest;

  CompleteSummaryPageState({this.groupQuestionTest});

  List<String> str = [];

  @override
  void initState() {
    super.initState();
    if (groupQuestionTest.groupQuestion[0].answersSubmit == null) {
      groupQuestionTest.groupQuestion[0].answersSubmit =
          List<AnswerQuestion>.empty(growable: true);
    }
    groupQuestionTest.groupQuestion[0].answers.forEach((c) {
      groupQuestionTest.groupQuestion[0].answersSubmit.add(AnswerQuestion(
          id: groupQuestionTest.groupQuestion[0].id,
          answers: "",
          type: groupQuestionTest.groupQuestion[0].groupQuestionType,
          answerType: groupQuestionTest.groupQuestion[0].answerType));
    });

    var list = groupQuestionTest.groupQuestion[0].groupQuestionMediaContent
        .split('.......')
        .toList();
    list.forEach((element) {
      str.add(element + " .......");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) => itemText(index),
        itemCount: str.length,
        shrinkWrap: true,
      ),
    );
  }

  itemText(int index) {
    String content = str[index];
    // TextEditingController textEdit = TextEditingController();
    // textEdit.text =
    //     groupQuestionTest.groupQuestion[0].answersSubmit[index].answers;
    // textEdit.selection =
    //     TextSelection.fromPosition(TextPosition(offset: textEdit.text.length));
    return Container(
      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: RichText(
        text: TextSpan(children: [
          for (var i = 0; i < content.split(' ').toList().length; i++)
            if (!content.split(' ').toList()[i].contains("...."))
              TextSpan(
                text: index == 0 && i == 0
                    ? groupQuestionTest.groupQuestion[0].idQuestionImport
                            .toString() +
                        ". " +
                        content.split(' ').toList()[i] +
                        " "
                    : content.split(' ').toList()[i] + " ",
                style: TextStyle(color: Colors.black, fontSize: 15,  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,),
              )
            else
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    width: 120,
                    child: Container(
                      margin: EdgeInsets.only(left: 8, right: 8),
                      height: 40,
                      child: TextField(

                        maxLines: 1,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            isDense: true,
                            hintText:   groupQuestionTest.groupQuestion[0].answersSubmit[index].answers.isNotEmpty ?   groupQuestionTest.groupQuestion[0].answersSubmit[index].answers :"................",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary))),
                        onChanged: (text) {
                          setState(() {
                            groupQuestionTest.groupQuestion[0].answersSubmit[index].answers = text;
                          });
                        },
                        style: TextStyle(fontSize: 14,  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,),
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                  ))
        ]),
      ),
    );
  }
}
