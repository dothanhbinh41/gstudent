import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/colors/HexColor.dart';

class MultiSelection extends StatefulWidget {
  GroupQuestion grQuestion;

  MultiSelection({this.grQuestion, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      MultiSelectionState(grQuestion: this.grQuestion);
}

class MultiSelectionState extends State<MultiSelection> {
  GroupQuestion grQuestion;
  int timeStart = 0;
  MultiSelectionState({this.grQuestion});

  @override
  void initState() {
    super.initState();

    setState(() {
      timeStart = DateTime.now().millisecondsSinceEpoch;
    });
    grQuestion.questions.forEach((element) {
      if (element.answer == null) {
        element.answer = QuestionAnswer(
          content: "",
          questionId: element.id,
            timeAnswer:   0
        );
      }
      element.answers.forEach((e) {
        e.isSelected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) => item(context, index),
        itemCount: grQuestion.questions.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  item(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 2, 16, 2),
      child:Card(
        color: HexColor(
            "#9c7f6a"),
        margin: EdgeInsets.only(top: 24, bottom: 24, right: 8, left: 8),
        child:  Column(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                    (index + 1).toString() +
                        ". " +
                        grQuestion.questions[index].title,
                    style: TextStyle( fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                width: MediaQuery.of(context).size.width - 60,
              ),
            ],
          ),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)),
                  boxShadow: [],
                  shape: BoxShape.rectangle,
                  color: HexColor(
                      "#9c7f6a")),
              child: ListView.builder(
                itemBuilder: (context, indexSelect) {
                  return CheckboxListTile(
                    value:
                    grQuestion.questions[index].answers[indexSelect].isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (grQuestion.questions[index].answers
                            .where((c) => c.isSelected == true)
                            .toList()
                            .length ==
                            2) {
                          if (value == false) {
                            grQuestion.questions[index].answers[indexSelect]
                                .isSelected = value;
                          }
                          return;
                        }
                        grQuestion.questions[index].answers[indexSelect]
                            .isSelected = value;
                        List<String> qss = [];
                        grQuestion.questions[index].answers.forEach((element) {
                          qss.add(element.content);
                        });
                        grQuestion.questions[index].answer.content =
                            qss.join(" ## ");
                        grQuestion.questions[index].answer.timeAnswer = DateTime.now().millisecondsSinceEpoch - timeStart;
                        qss.clear();
                      });
                    },
                    title: Text(grQuestion
                        .questions[index].answers[indexSelect].content
                        .toString(),style: TextStyle( fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),),
                  );
                },
                itemCount: grQuestion.questions[index].answers.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ))
        ],
      ))
    );
  }
}
