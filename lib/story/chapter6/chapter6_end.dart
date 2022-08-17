import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter6End extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter6EndState();
}

class Chapter6EndState extends State<Chapter6End> with TickerProviderStateMixin {
  int step = 1;
  Image bgGameStep1;
  Image bgGameWin;
  AssetImage alice;
  AssetImage stone;
  AssetImage thinking_team;
  AssetImage thinking_stone;
  Animation<double> _fadeInFadeOut;
  AnimationController controllerGate;
  AnimationController controllerBg;
  bool isCanClick = true;
  bool isWin = true;
  bool isAnimateGate = false;
  Animation base;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controllerGate = AnimationController(vsync: this, duration: Duration(milliseconds: 10000));
    base = CurvedAnimation(parent: controllerGate, curve: Curves.easeOut);

    controllerBg = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(controllerBg);

    loadImage();
    step2();
  }

  @override
  void dispose() {
    controllerGate.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  loadImage() {
    bgGameStep1 = imgPreCache('bg_chapter6.png');
    stone = AssetImage('assets/images/chapter6_stone.png');
    alice = AssetImage('assets/images/alice.png');
    thinking_team = AssetImage('assets/images/thinking_team.png');
    thinking_stone = AssetImage('assets/images/thinking_stone.png');
    bgGameWin = imgPreCache('bg_chapter1_middle.png');
  }

  step2() {
    setState(() {
      isCanClick = false;
    });
    if (isWin) {
      try {
        controllerGate.forward();
        Future.delayed(Duration(milliseconds: 2000)).whenComplete(() => setState(() {
              isCanClick = true;
            }));
      } catch (e) {}
    } else {
      try {
        controllerBg.forward();
        Future.delayed(Duration(milliseconds: 500)).whenComplete(() => setState(() {
              isAnimateGate = true;
            }));
        Future.delayed(Duration(milliseconds: 2000)).whenComplete(() => setState(() {
              isCanClick = true;
            }));
      } catch (e) {}
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1.image, context);
    precacheImage(stone, context);
    precacheImage(alice, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (isCanClick == false) {
            return;
          }
          Navigator.of(context).pop(true);
        },
        child: Stack(
          children: [
            Positioned(
              child:isWin ? bgGameWin : bgGameStep1 ,
              top: 0,
              right: 0,
              left: 0,
              bottom: isWin ? 0 : MediaQuery.of(context).size.height * 0.1,
            ),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOut,
                child: Container(
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
                ),
              ),
              bottom: 0,
              right: 0,
              left: 0,
              top: 0,
            ),
            isWin
                ? Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: MediaQuery.of(context).size.height * 0.2,
                    child: RotationTransition(
                        turns: base,
                        child: Image(
                          image: AssetImage('assets/images/gate.png'),
                        )),
                  )
                : AnimatedPositioned(
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 2000),
                    child: Image(
                      image: AssetImage('assets/images/gate.png'),
                    ),
                    height: isAnimateGate ? 120 : 200,
                    top: MediaQuery.of(context).size.height * 0.3,
                    right: 0,
                    left: 0,
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
                                'Giảng viên Alice',
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
                                flex: 2,
                              ),
                              Expanded(
                                child: Text(
                                  text(step),
                                  style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400, fontSize: text(step).length < 150 ? 14 : 12),
                                ),
                                flex: 4,
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
                    image:alice,
                    fit: BoxFit.fill,
                  ),flex: 4,),
                  Expanded(child: Container(),flex:5,)
                ],),
                bottom: -16,
                right: 0,
                left: -48,
            ),

            Positioned(
              child: isCanClick
                  ? Image(
                      image: AssetImage('assets/images/arrow_bottom.png'),
                    )
                  : Container(),
              bottom: 8,
              right: 8,
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  String text(int step) {
    return isWin
        ? 'Đảo Flyland đã xinh đẹp trở lại. Cánh cửa không gian sẽ đưa bạn ra khỏi hòn đảo này.\nChúc mừng bạn đã tốt nghiệp học viện Flyland!'
        : 'Hoàn đảo đã biến mất, cánh cửa không gian ra khỏi đảo Flyland đã đóng...bạn chưa thể ra khỏi vùng đất này!';
  }
}
