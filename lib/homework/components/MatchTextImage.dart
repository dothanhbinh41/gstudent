// import 'package:edutalkapp/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/colors/HexColor.dart';

// ignore: must_be_immutable
class MatchTextImage extends StatefulWidget {
  GroupQuestion question;

  MatchTextImage({this.question, Key key}) : super(key: key);

  @override
  MatchTextImageState createState() {
    return new MatchTextImageState(grQuestion: this.question);
  }
}

class MatchTextImageState extends State<MatchTextImage> {
  GroupQuestion grQuestion;
  PageController _pageController = PageController(initialPage: 0, viewportFraction: 3/4);

  MatchTextImageState({this.grQuestion});

  List<String> listAnswers;
  Question currentQs;
  int timeStart = 0;

  @override
  void initState() {
    super.initState();
    listAnswers = [];
    setState(() {
      timeStart = DateTime.now().millisecondsSinceEpoch;
      currentQs = grQuestion.questions[0];
      for (var i = 0; i < grQuestion.questions[0].answers.length; i++) {
        listAnswers.add(grQuestion.questions[0].answers[i].content);
      }
      grQuestion.questions.forEach((element) {
        if (element.answer != null && element.answer.content.isNotEmpty) {
          if (listAnswers.where((e) => e == element.answer.content).isNotEmpty) {
            listAnswers.remove(listAnswers.where((e) => e == element.answer.content).first);
          }
        }
      });
      for (var i = 0; i < grQuestion.questions.length; i++) {
        if (grQuestion.questions[i].answer == null) {
          grQuestion.questions[i].answer = QuestionAnswer(content: "", questionId: grQuestion.questions[i].id);
        }
      }
    });
  }

  _questionSelector(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 270.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => selectQuestion(index),
        child: Column(
          children: [
            Expanded(
                child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0.0, 4.0),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        grQuestion.questions[index].image,
                        fit: BoxFit.fill,
                      ),
                    ))),
            Container(
              child: Text(
                grQuestion.questions[index].answer.content,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceSerifPro',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 280,
          width: double.infinity,
          child: PageView.builder(
              controller: _pageController,
              onPageChanged: (value) => currentQs = grQuestion.questions[value],
              itemCount: grQuestion.questions.length,
              itemBuilder: (BuildContext context, int index) {
                return _questionSelector(index);
              }),
        ),
        Container(
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Wrap(spacing: 20, direction: Axis.horizontal, alignment: WrapAlignment.start, children: [
                  for (int i = 0; i < listAnswers.length; i++)
                    GestureDetector(
                      onTap: () => setState(() {
                        selectAnswer(i);
                        listAnswers.removeAt(i);
                      }),
                      child: Chip(
                        label: Text(
                          listAnswers[i],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SourceSerifPro',
                          ),
                        ),
                        backgroundColor: HexColor("#9c7f6a"),
                      ),
                    )
                ]))),
      ],
    );
  }

  selectAnswer(index) {
    if (currentQs.answer.content.isEmpty) {
      setState(() {
        currentQs.answer.content = listAnswers[index];
        currentQs.answer.timeAnswer = DateTime.now().millisecondsSinceEpoch - timeStart;
      });
    } else {
      setState(() {
        listAnswers.add(currentQs.answer.content);
        currentQs.answer.content = listAnswers[index];
      });
    }
  }

  selectQuestion(index) {
    if (currentQs.answer.content.isEmpty) {
      return;
    }
    setState(() {
      var answered = grQuestion.questions.where((element) => element.id == currentQs.id).first.answer;
      listAnswers.add(answered.content);
      currentQs.answer.content = "";
    });
  }
}
