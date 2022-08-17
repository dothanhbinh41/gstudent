import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gstudent/api/dtos/Exam/GroupQuestionExam.dart';
import 'package:gstudent/common/controls/dialog_zoom_image.dart';
import 'package:gstudent/homework/components/PlayAudioView.dart';

class MultiSelectionView extends StatefulWidget {
  PracticeGroupQuestion grQuestion;

  MultiSelectionView({this.grQuestion, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      MultiSelectionViewState(grQuestion: this.grQuestion);
}

class MultiSelectionViewState extends State<MultiSelectionView> {
  PracticeGroupQuestion grQuestion;

  MultiSelectionViewState({this.grQuestion});

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    List<String> corrects = grQuestion.practiceQuestions[index].correctAnswers.split('##').toList();

    return Container(
      margin: EdgeInsets.fromLTRB(16, 2, 16, 2),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                    (index + 1).toString() +
                        ". " +
                        grQuestion.practiceQuestions[index].title,
                    style: TextStyle( fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),
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
                    value:
                    grQuestion.practiceQuestions[index].practiceAnswers[indexSelect].isSelected,
                    onChanged: null,
                    title: Text(grQuestion
                        .practiceQuestions[index].practiceAnswers[indexSelect].content
                        .toString(),style: TextStyle( fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),),
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
