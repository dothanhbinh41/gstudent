// import 'package:edutalkapp/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';

// ignore: must_be_immutable
class ViewArrangeSentencesView extends StatefulWidget {
  GroupQuestion question;
  ViewArrangeSentencesView({this.question, Key key}) : super(key: key);
  @override
  ViewArrangeSentencesViewState createState() =>
      ViewArrangeSentencesViewState(grQuestion: this.question);
}

class ViewArrangeSentencesViewState extends State<ViewArrangeSentencesView> {
  GroupQuestion grQuestion = GroupQuestion();
  PageController pageController = PageController();

  ViewArrangeSentencesViewState({this.grQuestion});


  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            height: 200,
            width: double.infinity,
            child: Wrap(
                spacing: 20,
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          grQuestion.questions[0].studentAnswer.isNotEmpty ? grQuestion.questions[0].studentAnswer : "chưa trả lời câu hỏi" ,
                          style: TextStyle(color: grQuestion.questions[0].studentAnswer.toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'') == grQuestion.questions[0].correctAnswer.toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'') ? Colors.green :  Colors.red, fontSize: 16),
                        ),
                      SizedBox(
                        height: 24,
                      ),
                      Visibility(
                        visible: !(grQuestion.questions[0].studentAnswer.toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'') == grQuestion.questions[0].correctAnswer.toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'')),
                        child: Text(
                          grQuestion.questions[0].correctAnswer,
                          style:
                              TextStyle(color: Colors.green[600], fontSize: 16),
                        ),
                      ),
                    ],
                  )
                ])),
      ],
    );
  }
}
