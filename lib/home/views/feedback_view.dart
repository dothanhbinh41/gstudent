import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/route_cubit.dart';
import 'package:gstudent/main.dart';

class FeedbackDialogView extends StatefulWidget {
  RouteCubit cubit;
  int lesson;
  int classroomId;

  FeedbackDialogView({this.lesson, this.classroomId, this.cubit});

  @override
  State<StatefulWidget> createState() => FeedbackDialogViewState(
      lesson: this.lesson, classroomId: this.classroomId, cubit: this.cubit);
}

class FeedbackDialogViewState extends State<FeedbackDialogView> {
  RouteCubit cubit;
  int lesson;
  int classroomId;

  FeedbackDialogViewState({this.lesson, this.classroomId, this.cubit});
String comment = "";
  int rate = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 400,
        width: MediaQuery.of(context).size.width * 0.9 > 400
            ? 400
            : MediaQuery.of(context).size.width * 0.9,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Image(
                image: AssetImage('assets/bg_notification_large.png'),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
                top: 16,
                bottom: 16,
                right: 28,
                left: 28,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Gửi đánh giá',
                          style: ThemeStyles.styleBold(font: 20),
                        ),
                      ),
                      Container(
                        child: Image(
                          image: AssetImage('assets/images/eclipse_login.png'),
                          fit: BoxFit.fill,
                        ),
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                            color: HexColor("#fcd19a")),
                        child: Text(
                          "Hãy giúp chúng tôi cải thiện chất lượng lớp học với Edutalk bằng cách đánh giá buổi học này.",
                          textAlign: TextAlign.justify,
                          style: ThemeStyles.styleNormal(font: 14),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(4, 8, 16, 8),
                        child: Text(
                          textByRate(),
                          style: ThemeStyles.styleNormal(font: 14),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      rating(),
                      Container(
                        height: 48,
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: HexColor("#ad9958"), width: 0.5),
                          color: HexColor("#fff6d8"),
                        ),
                        child: TextField(
                          style: ThemeStyles.styleNormal(font: 14),
                          onChanged: (t){
                            comment = t;
                          },
                          decoration: new InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              hintText: 'Để lại lời khen',
                              hintStyle: ThemeStyles.styleNormal(font: 14),),
                        ),
                      ),
                      Container(
                        child: Image(
                          image: AssetImage('assets/images/ellipse.png'),
                          fit: BoxFit.fill,
                        ),
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      ),
                      GestureDetector(
                        onTap: () => sendFeedback(),
                        child: Center(
                          child: ButtonYellowSmall(
                            'TIẾP TỤC',
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  rating() {
    return Container(
        child: RatingBar(
      initialRating: 5,
      itemSize: 36,
      minRating: 1,
      maxRating: 5,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: Icon(
          Icons.star_rounded,
          color: Colors.amber,
        ),
        half: Icon(Icons.star_rounded, color: Colors.amber),
        empty: Icon(
          Icons.star_rounded,
          color: Colors.grey,
        ),
      ),
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      onRatingUpdate: (rating) => changeSuggest(rating),
    ));
  }

  changeSuggest(double rating) {
    print(rating);
    setState(() {
      rate = rating.toInt();
    });
  }

  sendFeedback() async {
    var res = await cubit.sendFeesback(classroomId, lesson, rate, comment);
    if (res.error == false) {
      toast(context, res.message);
      Navigator.of(context).pop(3);
    } else {
      toast(context, res.message);
      return;
    }
  }

  String textByRate() {
    switch (rate) {
      case 0:
        return 'Quá tệ';
      case 1:
        return 'Quá tệ';
      case 2:
        return 'Kém';
      case 3:
        return 'Bình thường';
      case 4:
        return 'Tốt';
      case 5:
        return 'Hoàn Hảo';
    }
  }
}
