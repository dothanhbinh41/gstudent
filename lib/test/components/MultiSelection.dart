import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/dialog_zoom_image.dart';
import 'package:gstudent/homework/components/PlayAudioView.dart';

class MultiSelection extends StatefulWidget {
  PracticeGroupQuestion grQuestion;

  MultiSelection({this.grQuestion, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MultiSelectionState(grQuestion: this.grQuestion);
}

class MultiSelectionState extends State<MultiSelection> {
  PracticeGroupQuestion grQuestion;

  MultiSelectionState({this.grQuestion});

  @override
  void initState() {
    super.initState();

    grQuestion.practiceQuestions.forEach((element) {
      if (element.answer == null) {
        element.answer = PracticeAnswer(content: "", position: element.id);
      }
      element.practiceAnswers.forEach((e) {
        e.isSelected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (grQuestion.audio.isNotEmpty)
          PlayAudioView(
            url: grQuestion.audio,
          ),
        grQuestion.image.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ShowImageDialog(
                      file: grQuestion.image,
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Image.network(grQuestion.image),
                ),
              )
            : Container(),
        ListView.builder(
          itemBuilder: (context, index) => item(context, index),
          itemCount: grQuestion.practiceQuestions.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  item(BuildContext context, int index) {
    return  Card(
      color: HexColor("#9c7f6a"),
      margin: EdgeInsets.only(top: 24, bottom: 24, right: 8, left: 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Text((index + 1).toString() + ". " + grQuestion.practiceQuestions[index].title,
                    style: TextStyle(
                      color: HexColor("#a12525"),
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SourceSerifPro',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                width: MediaQuery.of(context).size.width - 60,
              ),
            ],
          ),
          Container(
              child: ListView.builder(
            itemBuilder: (context, indexSelect) {
              return CheckboxListTile(
                activeColor: Colors.black,
                value: grQuestion.practiceQuestions[index].practiceAnswers[indexSelect].isSelected,
                onChanged: (value) {
                  setState(() {
                    if (grQuestion.practiceQuestions[index].practiceAnswers.where((c) => c.isSelected == true).toList().length == 2) {
                      if (value == false) {
                        grQuestion.practiceQuestions[index].practiceAnswers[indexSelect].isSelected = value;
                      }
                      return;
                    }
                    grQuestion.practiceQuestions[index].practiceAnswers[indexSelect].isSelected = value;
                    List<String> qss = [];
                    grQuestion.practiceQuestions[index].practiceAnswers.forEach((element) {
                      qss.add(element.content);
                    });
                    grQuestion.practiceQuestions[index].answer.content = qss.join(" ## ");
                    qss.clear();
                  });
                },
                title: Text(
                  grQuestion.practiceQuestions[index].practiceAnswers[indexSelect].content.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SourceSerifPro',
                  ),
                ),
              );
            },
            itemCount: grQuestion.practiceQuestions[index].practiceAnswers.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          ))
        ],
      ),
    );
  }
}
