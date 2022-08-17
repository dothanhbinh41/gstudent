import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WalkThroughView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WalkThroughViewState();
}

class WalkThroughViewState extends State<WalkThroughView> {
  PageController controller;
  int position = 0;
  List<SlideWalkthrough> slide = [
    SlideWalkthrough(
        gradient: LinearGradient(
            colors: [
              HexColor("#ffb94c"),
              HexColor("#7c0f0b"),
            ],
            begin: const FractionalOffset(1.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        image: 'assets/slide1.png'),
    SlideWalkthrough(
        gradient: LinearGradient(
            colors: [
              HexColor("#3ec7dc"),
              HexColor("#739e01"),
            ],
            begin: const FractionalOffset(1.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        image: 'assets/slide2.png'),
    SlideWalkthrough(
        gradient: LinearGradient(
            colors: [
              HexColor("#8652b6"),
              HexColor("#070d22"),
            ],
            begin: const FractionalOffset(1.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        image: 'assets/slide3.png'),
    // SlideWalkthrough(
    //     gradient: LinearGradient(
    //         colors: [
    //           HexColor("#fabb79"),
    //           HexColor("#710d4b"),
    //         ],
    //         begin: const FractionalOffset(1.0, 0.0),
    //         end: const FractionalOffset(0.0, 1.0),
    //         stops: [0.0, 1.0],
    //         tileMode: TileMode.clamp),
    //     image: 'assets/slide4.png'),
    SlideWalkthrough(
        gradient: LinearGradient(
            colors: [
              HexColor("#624455"),
              HexColor("#251d2e"),
            ],
            begin: const FractionalOffset(1.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        image: 'assets/slide5.png'),
  ];
  bool isAnimateDone = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(
      initialPage: position,
      keepPage: false,
      viewportFraction: 1,
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    slide.forEach((element) {
      precacheImage(AssetImage(element.image), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: slide[position].gradient,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (value) {
                    setState(() {
                      position = value;
                    });
                  },
                  controller: controller,
                  itemBuilder: (context, index) => builder(index),
                  itemCount: slide.length,
                ),
                margin: EdgeInsets.fromLTRB(8, 16, 8, 8),
              ),
              flex: 3,
            ),
            Expanded(child: textByPosition(position)),
            Container(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: SmoothPageIndicator(
                        controller: controller, // PageController
                        count: slide.length,
                        effect: WormEffect(
                            dotColor: Colors.white,
                            activeDotColor: HexColor("#3A1502"),
                            dotHeight: 12,
                            dotWidth: 12), // your preferred effect
                        onDotClicked: (index) {}),
                    alignment: Alignment.center,
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () async {
                        if (isAnimateDone == false) {
                          return;
                        }
                        if (position < slide.length - 1) {
                          setState(() {
                            position++;
                            isAnimateDone = false;
                          });
                          await controller
                              .animateToPage(position,
                                  duration: Duration(milliseconds: 1000),
                                  curve: Curves.easeIn)
                              .whenComplete(() {
                            setState(() {
                              isAnimateDone = true;
                            });
                          });
                        } else {
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(
                            fontFamily: 'SourceSerifPro',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(0, 0, 24, 24),
                  ),
                ],
              ),
              height: 96,
            )
          ],
        ),
      ),
    );
  }

  textByPosition(int position) {
    switch (position) {
      case 0:
        return Container(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: 'Lựa chọn ',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white)),
                TextSpan(
                    text: 'Nhân Vật ',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
                TextSpan(
                    text: 'và tham gia ',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white)),
                TextSpan(
                    text: 'Team ',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
                TextSpan(
                    text: 'để học hiệu quả nhất',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white)),
              ],
            ),
          ),
          padding: EdgeInsets.fromLTRB(32, 4, 32, 4),
        );
      case 1:
        return Container(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: 'Vào ',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white)),
                TextSpan(
                    text: 'Lộ Trình ',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
                TextSpan(
                    text: 'để làm bài tập sau mỗi buổi học',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white)),
              ],
            ),
          ),
          padding: EdgeInsets.fromLTRB(32, 4, 32, 4),
        );
      case 2:
        return Container(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: 'Luyện tập hằng ngày với ',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white)),
                TextSpan(
                    text: 'Phòng Luyện',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
              ],
            ),
          ),
          padding: EdgeInsets.fromLTRB(32, 4, 32, 4),
        );
      case 3:
        return Container(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: 'Leo lên đỉnh vinh quang tại các ',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white)),
                TextSpan(
                    text: 'Sự kiện giải đấu ',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
                TextSpan(
                    text: 'và nhận nhiều phần thưởng giá trị',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white)),
              ],
            ),
          ),
          padding: EdgeInsets.fromLTRB(32, 4, 32, 4),
        );
      default:
        return Container(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: 'Leo lên đỉnh vinh quang tại các ',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white)),
                TextSpan(
                    text: 'Sự kiện giải đấu ',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
                TextSpan(
                    text: 'và nhận nhiều phần thưởng giá trị',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white)),
              ],
            ),
          ),
          padding: EdgeInsets.fromLTRB(32, 4, 32, 4),
        );
    }
  }

  builder(int index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = controller.page - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) *
                (MediaQuery.of(context).size.height * 0.8),
            width: Curves.easeOut.transform(value) *
                MediaQuery.of(context).size.width,
            child: child,
          ),
        );
      },
      child: Container(
        child: Image(
          image: AssetImage(slide[index].image),
        ),
      ),
    );
  }
}

class SlideWalkthrough {
  String image;
  String content;
  LinearGradient gradient;

  SlideWalkthrough({this.gradient, this.image, this.content});
}
