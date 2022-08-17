
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/TestInput/answer.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';

// ignore: must_be_immutable
class FillImagePage extends StatefulWidget {
  GroupQuestionTest groupQuestionTest;

  FillImagePage({this.groupQuestionTest, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      FillImageStatePage(groupQuestionTest: this.groupQuestionTest);
}

class FillImageStatePage extends State<FillImagePage> {
  GroupQuestionTest groupQuestionTest;

  FillImageStatePage({this.groupQuestionTest});

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              groupQuestionTest.groupQuestion[0].groupQuestionMediaContent[0],
              width: MediaQuery.of(context).size.height / 2,
            ),
            ListView.builder(
              itemBuilder: (context, index) => itemFillImage(context, index),
              itemCount: groupQuestionTest.groupQuestion.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            )
          ],
        ),
      ),
    );
  }

  itemFillImage(context, index) {
    TextEditingController textEditingController = TextEditingController();
    textEditingController.text =
        groupQuestionTest.groupQuestion[index].answerSubmit.answers;
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
    return Container(
      height: 40,
      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: [
          Container(
              child: Text(groupQuestionTest
                      .groupQuestion[index].idQuestionImport
                      .toString() +
                  ". " +
                  groupQuestionTest.groupQuestion[index].content.toString(),style: TextStyle(  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400),),),
          Spacer(),
          Container(
            width: 40,
            height: 40,
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  isDense: true,
                  counterText: "",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black),
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black),
                      borderRadius: BorderRadius.circular(8))
              ),
              textAlign: TextAlign.center,
              maxLength: 1,
              maxLines: 1,
              style: TextStyle(  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.black
              ),
              onChanged: (value) {
                setState(() {
                  groupQuestionTest.groupQuestion[index].answerSubmit.answers =
                      value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
