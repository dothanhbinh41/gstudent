import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';

// ignore: must_be_immutable
class FillTextImageView extends StatefulWidget {
  GroupQuestion groupQuestion;
  FillTextImageView({this.groupQuestion, Key key}) : super(key: key);
  @override
  FillTextImageViewState createState() {
    return new FillTextImageViewState(groupQuestion: this.groupQuestion);
  }
}

class FillTextImageViewState extends State<FillTextImageView> {
  GroupQuestion groupQuestion;
  FillTextImageViewState({this.groupQuestion});

  @override
  void initState() {
    super.initState();
    if (groupQuestion == null) {
      return;
    }
    index = 0;
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  int index;
  PageController _pageController;

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
            height: Curves.easeInOut.transform(value) * 170.0,
            width: Curves.easeInOut.transform(value) *
                MediaQuery.of(context).size.width *
                0.9,
            child: widget,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => {
          //setState(() => {answer = ""})
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container(
              width: MediaQuery.of(context).size.width/1.5,
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
            ),),
            Text(
              '${groupQuestion.questions[index].studentAnswer ?? ""}',
              style: TextStyle(
                color:groupQuestion.questions[index].studentAnswer != null ?( groupQuestion.questions[index].studentAnswer.toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'')
                    ==
                    groupQuestion.questions[index].correctAnswer.toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'') ? Colors.green : Colors.red) : Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(child:  Divider(height: 1, thickness: 1,),   width: MediaQuery.of(context).size.width/1.5 ,)
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
          height: 200,
          width: double.infinity,
          child: PageView.builder(
              controller: _pageController,
              itemCount: groupQuestion.questions.length,
              itemBuilder: (BuildContext context, int index) {
                return _questionSelector(index);
              }),
        ),
        // Container(
        //     decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.circular(8),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Color(0x60000000),
        //             offset: Offset(0.0, 3.0),
        //             blurRadius: 5.0,
        //           ),
        //         ]),
        //     margin: EdgeInsets.all(24),
        //     padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
        //     child: TextFormField(
        //       enabled: false,
        //         decoration: InputDecoration(
        //           labelText: 'Answer',
        //           labelStyle: TextStyle(
        //             fontSize: 12,
        //             color: ThemeColors.description,
        //           ),
        //           errorBorder: UnderlineInputBorder(
        //             borderSide: BorderSide(color: ThemeColors.primary),
        //           ),
        //           border: UnderlineInputBorder(
        //             borderSide: BorderSide(color: ThemeColors.description),
        //           ),
        //           focusedBorder: UnderlineInputBorder(
        //             borderSide: BorderSide(color: ThemeColors.gradientStart),
        //           ),
        //         )))
      ],
    );
  }
}
