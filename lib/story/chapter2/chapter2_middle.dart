import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter2Middle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter2MiddleState();
}

class Chapter2MiddleState extends State<Chapter2Middle> with TickerProviderStateMixin {
  int step = 1;
  Image bgGameStep1;
  AssetImage human1;
  AssetImage human2;
  AssetImage human3;

  bool isCanClick = true;
  bool _isMoved = false;
  Animation<double> _fadeInFadeOut;
  AnimationController _animationbgController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
    _animationbgController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(_animationbgController);
  }

  @override
  void dispose() {
    _animationbgController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future _startAnimationbg() async {
    try {
      await _animationbgController.forward().orCancel;
    } on TickerCanceled {
      print(' animation canceled');
    }
  }

  loadImage() {
    bgGameStep1 = imgPreCache('bg_chapter2.png');
    human1 = AssetImage('assets/human_chapter2_1.png');
    human2 = AssetImage('assets/human_chapter2_2.png');
    human3 = AssetImage('assets/human_chapter2_3.png');
  }

  step2() {
    setState(() {
      _isMoved = true;
      isCanClick = false;
    });
    Future.delayed(Duration(milliseconds: 200)).whenComplete(() {
      _startAnimationbg();
    });
    Future.delayed(Duration(milliseconds: 2000)).whenComplete(() {
      setState(() {
        isCanClick = true;
      });
    });
  }

  step3() {
    setState(() {
      isCanClick = false;
    });
    Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
      setState(() {
        isCanClick = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1.image, context);
    precacheImage(human1, context);
    precacheImage(human2, context);
    precacheImage(human3, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if(isCanClick == false){
            return;
          }
          setState(() {
            step++;
          });

          switch (step) {
            case 2:
              step2();
              return;
            case 3:
              step3();
              return;
            default :
              Navigator.of(context).pop(true);
              return;
          }
        },
        child: Stack(
          children: [
            Positioned(
              child: bgGameStep1,
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
            ),
            Positioned(
              height: 220,
              child: AnimatedOpacity(
                  // If the widget is visible, animate to 0.0 (invisible).
                  // If the widget is hidden, animate to 1.0 (fully visible).
                  opacity: step != 2 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 1500),
                  // The green box must be a child of the AnimatedOpacity widget.
                  child: Image(image: imageByStep(step))),
              right: 0,
              left: 0,
              bottom: step < 3 ? MediaQuery.of(context).size.height * 0.2 : MediaQuery.of(context).size.height * 0.25,
            ),
            step <= 2
                ? AnimatedPositioned(
                    width: _isMoved ? MediaQuery.of(context).size.width / 2 : 48,
                    height: _isMoved ? MediaQuery.of(context).size.width / 2 : 48.0,
                    top: _isMoved ? MediaQuery.of(context).size.height / 2.5 : MediaQuery.of(context).size.height * 0.2,
                    left: _isMoved ? MediaQuery.of(context).size.width / 3.5 : MediaQuery.of(context).size.width * 0.2,
                    duration: const Duration(seconds: 2),
                    curve: Curves.fastOutSlowIn,
                    child: Container(
                      child: Center(child: Image(image: AssetImage('assets/images/gate.png'))),
                    ),
                  )
                : Container(),
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
                                'Giảng viên Kogi',
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
                    image: AssetImage('assets/images/kogi_2.png'),
                    fit: BoxFit.fill,
                  ),flex: 4,),
                  Expanded(child: Container(),flex:5,)
                ],),
                bottom: -16,
                right: 0,
                left: -48,
                height: MediaQuery.of(context).size.height * 0.25,
            ),

            Positioned(
              child:isCanClick ? Image(
                image: AssetImage('assets/images/arrow_bottom.png'),
              ) : Container(),
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
        return 'Tộc trưởng đang rất nguy kịch...\nLuyện đan thành công, bạn có thể cứu sống ông ấy.';
      case 2:
        return 'Chỉ Còn 14 ngày nữa cánh cửa không gian sang hòn đảo khác sẽ mở ra.\nChỉ cứu sống được trưởng tộc, bạn mới có thể đi qua cánh cửa này';
      default:
        return 'Bạn đã thu thập đủ dược liệu cổ? Hãy ôn luyện thật tốt, mình tin bạn làm được, cố lên nhé';
    }
  }

  AssetImage imageByStep(int step) {
    switch (step) {
      case 3:
        return human3;
      default:
        return human1;
    }
  }
}
