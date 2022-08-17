// import 'package:edutalkapp/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';

// ignore: must_be_immutable
class MatchTextImageView extends StatefulWidget {
  GroupQuestion question;
  MatchTextImageView({this.question, Key key}) : super(key: key);
  @override
  MatchTextImageViewState createState() {
    return new MatchTextImageViewState(grQuestion: this.question);
  }
}

class MatchTextImageViewState extends State<MatchTextImageView> {
  GroupQuestion grQuestion;
  PageController _pageController = PageController();

  MatchTextImageViewState({this.grQuestion});
  Question currentQs;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    setState(() {
      currentQs = grQuestion.questions[0];
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
            height: Curves.easeInOut.transform(value) * 280.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width/1.5,
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20.0),
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
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  grQuestion.questions[index].image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text(
              grQuestion.questions[index].studentAnswer,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: grQuestion.questions[index].studentAnswer.trim() == grQuestion.questions[index].correctAnswer.trim() ? Colors.green : Colors.red
              ),
            ),
          ),
          Container(child: Divider(height: 1, thickness: 1,), width: MediaQuery.of(context).size.width/1.5,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          child: PageView.builder(
              controller: _pageController,
              onPageChanged: (value) => currentQs = grQuestion.questions[value],
              itemCount: grQuestion.questions.length,
              itemBuilder: (BuildContext context, int index) {
                return _questionSelector(index);
              }),
        ),
      ],
    );
  }
}
