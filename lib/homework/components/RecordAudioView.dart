import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/homework/components/PlayAudioView.dart';
import 'package:gstudent/homework/components/RecordView.dart';

// ignore: must_be_immutable
class RecordAudioView extends StatefulWidget {
  GroupQuestion grQuestions;
  RecordAudioView({this.grQuestions,Key key}) : super(key: key);
  @override
  _RecordAudioViewState createState() =>
      _RecordAudioViewState(grQuestions: this.grQuestions);
}

class _RecordAudioViewState extends State<RecordAudioView> {
  GroupQuestion grQuestions;
  PageController pageController;
  _RecordAudioViewState({this.grQuestions});
  Question currentQs;

  @override
  void initState() {
    super.initState();
    if(grQuestions.questions != null && grQuestions.questions.isNotEmpty){
      setState(() {
        grQuestions.questions[0].answer = QuestionAnswer(content: "",questionId: grQuestions.questions[0].id ?? grQuestions.id);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (grQuestions.audio.isNotEmpty)
          PlayAudioView(
            url: grQuestions.audio,
          ),
        grQuestions.image != null && grQuestions.image.isNotEmpty ?   Container(
            margin: EdgeInsets.all(16),
            height: 200,
            child: Image.network(grQuestions.image, fit: BoxFit.fill)) : Container(),
        grQuestions.questions.isNotEmpty ? _recordView() : Container()
      ],
    );
  }

  _recordView() => RecordView(
        grQuestions: grQuestions,
        key: UniqueKey(),
      );
}
