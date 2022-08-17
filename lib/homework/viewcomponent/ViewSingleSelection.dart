import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/homework/components/PlayAudioView.dart';

// ignore: must_be_immutable
class ViewSingleSelection extends StatefulWidget {
  GroupQuestion grQuestions;
  ViewSingleSelection({this.grQuestions, Key key}) : super(key: key);
  @override
  ViewSingleSelectionState createState() {
    return new ViewSingleSelectionState(grQuestions: this.grQuestions);
  }
}

class ViewSingleSelectionState extends State<ViewSingleSelection> {
  GroupQuestion grQuestions;
  List<Question> questions;
  ViewSingleSelectionState({this.grQuestions});

  @override
  void initState() {
    super.initState();
    setState(() {
      questions = grQuestions.questions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (grQuestions.audio.isNotEmpty)
        PlayAudioView(
          url: grQuestions.audio,
        ),
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

  listItem(Question question) {

    QuestionAnswer studentAnswer =
    question.answers.where((e) => e.content == question.studentAnswer).isNotEmpty ? question.answers.firstWhere((e) => e.content== question.studentAnswer) : QuestionAnswer(content: "") ;
    QuestionAnswer correctAnswer =
        question.answers.where((e) => e.content== question.correctAnswer).isNotEmpty  ?question.answers.firstWhere((e) => e.content == question.correctAnswer)  : QuestionAnswer(content: "");
    print(question.correctAnswer.split(' ').join(''));
    print(question.studentAnswer.split(' ').join(''));
    print(studentAnswer.content.split(' ').join(''));
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Card(
            margin: EdgeInsets.only(top: 24, bottom: 0, right: 8, left: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      question.title,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 14),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4)),
                        boxShadow: [],
                        shape: BoxShape.rectangle,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                for (var a in question.answers)
                  RadioListTile(
                      activeColor: studentAnswer == correctAnswer ? (a.content == studentAnswer.content ? Colors.green.shade600 : Colors.red) : (a.content == correctAnswer.content? Colors.green.shade600 : Colors.red),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      value: a,
                      title: Text(
                        a.content,
                        style: TextStyle(
                            fontSize: 14,
                            color: studentAnswer == correctAnswer ? (a.content == studentAnswer.content ? Colors.green.shade600 : Colors.red) : (a.content == correctAnswer.content? Colors.green.shade600 : Colors.red)),
                      ),
                      groupValue: studentAnswer,
                      onChanged: (value) => null),
              ],
            )),
        if (question.audio.isNotEmpty)
          Positioned(
            bottom: 0,
            right: 40,
            child: PlayAudioView(
              url: question.audio,
            ),
          )
      ],
    );
  }
}
