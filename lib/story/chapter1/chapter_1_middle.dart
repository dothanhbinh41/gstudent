import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter1Middle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter1MiddleState();
}

class Chapter1MiddleState extends State<Chapter1Middle> with TickerProviderStateMixin {
  int step = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
    step1();
  }

  step1() {
    setState(() {
      step++;
    });
  }

  step2() {
    setState(() {
      step++;
    });
  }

  step3() {
    setState(() {
      step++;
    });
  }

  loadImage() {
    bgGameStep1 = imgPreCache('bg_chapter1_middle.png');
    bgGameStep2 = imgPreCache('bg_chapter_1.png');
  }

  Image bgGameStep1;
  Image bgGameStep2;

  @override
  void dispose() {
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1.image, context);
    precacheImage(bgGameStep2.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
       switch(step){
         case 1:
           step1();
           return;
         case 2 :
           step2();
           return;
         case 3:
           step3();
           return;
         default:
           Navigator.of(context).pop(true);
           return;
       }
        },
        child: Stack(
          children: [
            Positioned(
              child: background(),
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
            ),
            Positioned(
              child: Stack(
                children: [
                  Positioned(
                    child: Image(
                      image: AssetImage('assets/bg_notification.png'),
                      fit: BoxFit.fill,
                    ),
                    top: 0,
                    right: 0,
                    left: 0,
                  ),
                  Positioned(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Text(
                                'Giảng viên Ohara',
                                style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, fontSize: 18),
                              )),
                          Container(
                            height: 16,
                            child: Image(
                              image: AssetImage('assets/images/eclipse_login.png'),
                            ),
                          ),
                          Expanded(
                              child: Row(
                            children: [
                              Expanded(
                                child: Container(),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text(
                                  text(step),
                                  style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400),
                                ),
                                flex: 2,
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ))
                        ],
                      ),
                    ),
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: 0,
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.22,
              bottom: 0,
              right: 0,
              left: 0,
            ),
            Positioned(
              child: Row(children: [
                Expanded(child:   Image(
                  image: step < 4 ? AssetImage('assets/images/ohara_teacher_2.png') : AssetImage('assets/images/ohara_teacher.png'),
                  fit: BoxFit.fill,
                ),flex: 4,),
                Expanded(child: Container(),flex:5,)
              ],),
              bottom: -16,
              right: 0,
              left:  -32  ,
              height:   MediaQuery.of(context).size.height * 0.25,
            ),


            Positioned(
              left: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.15,
              bottom: MediaQuery.of(context).size.height * 0.26,
              child: step > 1 && step < 4? AnimatedCrossFade(
                crossFadeState: step == 2 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstCurve: Curves.fastOutSlowIn,
                secondCurve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: step == 1 ? 100 : 1500),
                firstChild: Image(
                  image: AssetImage('assets/images/thinking_gate.png'),
                ),
                secondChild: Image(
                    image: AssetImage('assets/images/thinking_team.png')
                ),
              ) : Container(),
            ),

            Positioned(
              child: Image(
                image: AssetImage('assets/images/arrow_bottom.png'),
              ),
              bottom: 8,
              right: 8,
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  text(int step) {
    switch (step) {
      case 1:
        return 'Cánh cửa chỉ mở ra với những ai đủ năng lực...';
      case 2:
        return 'Chỉ 3 ngày nữa cánh cửa không gian sẽ mở ra...';
      case 3:
        return 'Các trò của ta thế nào rồi nhỉ';
      default:
        return 'Bạn hãy gia tăng tốc độ thu thập sách cổ, chứng minh bạn xứng đáng. Mình tin bạn làm được!';
    }
  }

  background() {
    return step < 2 ? bgGameStep1 : bgGameStep2;
  }
}
