import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';

// ignore: must_be_immutable
class FillTextImage extends StatefulWidget {
  GroupQuestion groupQuestion;

  FillTextImage({this.groupQuestion, Key key}) : super(key: key);

  @override
  FillTextImageState createState() {
    return new FillTextImageState(groupQuestion: this.groupQuestion);
  }
}

class FillTextImageState extends State<FillTextImage> {
  GroupQuestion groupQuestion;

  FillTextImageState({this.groupQuestion});
  int timeStart = 0;
  PageController _pageController;
  TextEditingController _textController = new TextEditingController();

  Question currentQs;

  @override
  void initState() {
    super.initState();
    timeStart = DateTime.now().millisecondsSinceEpoch;
    _textController.addListener(() {
      setState(() {
        currentQs.answer.content = _textController.text;
      });
    });
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
    if (groupQuestion == null) {
      return;
    }
    groupQuestion.questions.forEach((element) {
      if (element.answer == null) {
        element.answer = QuestionAnswer(content: "",questionId: element.id);
      }
    });
    currentQs = groupQuestion.questions[0];
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
            height: Curves.easeInOut.transform(value) * 200.0,
            width: Curves.easeInOut.transform(value) *
                MediaQuery.of(context).size.width *
                0.9,
            child: widget,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  groupQuestion.questions[index].image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Text(
            '${groupQuestion.questions[index].answer.content ?? ""}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
        fontFamily: 'SourceSerifPro',
            ),
          ),
          Container(
            child: Divider(
              height: 1,
              thickness: 1,
            ),
            width: MediaQuery.of(context).size.width / 1.5,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(groupQuestion.script != null && groupQuestion.script.isNotEmpty ? groupQuestion.script : '',style: (TextStyle( fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',)),),
          margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        ),
        Container(
          height: 200,
          width: double.infinity,
          child: PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentQs = groupQuestion.questions[value];
                  _textController.text =
                      groupQuestion.questions[value].answer.content ?? "";
                });
              },
              controller: _pageController,
              itemCount: groupQuestion.questions.length,
              itemBuilder: (BuildContext context, int index) {
                return _questionSelector(index);
              }),
        ),
        Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x60000000),
                    offset: Offset(0.0, 3.0),
                    blurRadius: 5.0,
                  ),
                ]),
            margin: EdgeInsets.all(24),
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: textfield()),
        KeyboardAware(
          builder: (context, configuracaoTeclado) {
            return Container(
              height:  configuracaoTeclado.keyboardHeight  > 0 ? configuracaoTeclado.keyboardHeight : 24,
            );
          },
        ),
      ],
    );
  }

  textfield() {
    return TextField(
        autocorrect: false,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          setState(() {
            currentQs.answer.content = value;
            currentQs.answer.timeAnswer = DateTime.now().millisecondsSinceEpoch - timeStart;
          });
        },
        controller: _textController,
        decoration: InputDecoration(
          labelText: 'Answer',
          labelStyle: TextStyle(
            fontSize: 12,
            color: HexColor("#dda386"),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#dda386")),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#dda386")),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#dda386")),
          ),
        ));
  }
}
