import 'dart:math' as math;
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class ChapterTutorial extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChapterTutorialState();
}

class ChapterTutorialState extends State<ChapterTutorial> with TickerProviderStateMixin {
  int step = 1;
  bool _isCanNext = true;
  bool _isFaded = false;
  AnimationController controller;
  AnimationController controller2;
  AnimationController controller3;
  AnimationController controller4;
  AnimationController controller5;
  AnimationController controller6;
  AnimationController controller7;
  AnimationController controller8;
  CurvedAnimation base;
  Animation<double> _fadeInFadeOut;
  Animation<double> _fadeInFadeOut1;
  Animation<double> _fadeInFadeOut2;
  Animation<double> _fadeInFadeOut3;
  Animation<double> _fadeInFadeOut4;
  Animation<double> _fadeInFadeOut5;
  Animation<double> _fadeInFadeOut6;
  Animation<double> _fadeInFadeOut7;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadController();
    loadImage();
    fadeIsland();
  }

  loadController() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller2 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller3 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller4 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller5 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller6 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller7 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller8 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    _fadeInFadeOut1 = Tween<double>(begin: 0.0, end: 1.0).animate(controller2);
    _fadeInFadeOut2 = Tween<double>(begin: 0.0, end: 1.0).animate(controller3);
    _fadeInFadeOut3 = Tween<double>(begin: 0.0, end: 1.0).animate(controller4);
    _fadeInFadeOut4 = Tween<double>(begin: 0.0, end: 1.0).animate(controller5);
    _fadeInFadeOut5 = Tween<double>(begin: 0.0, end: 1.0).animate(controller6);
    _fadeInFadeOut6 = Tween<double>(begin: 0.0, end: 1.0).animate(controller7);
    _fadeInFadeOut7 = Tween<double>(begin: 0.0, end: 1.0).animate(controller8);
  }

  fadeIsland() {
    setState(() {
      _isCanNext = false;
    });
    try {
      if (_isFaded) {
        controller.reverse();
        _isFaded = !_isFaded;
      } else {
        controller.forward();
        _isFaded = !_isFaded;
      }
      Future.delayed(Duration(milliseconds: 2500)).whenComplete(() => setState(() {
            _isCanNext = true;
          }));
    } catch (e) {}
  }

  void action(int step) {
    switch (step) {
      case 2:
        step2();
        return;
      case 3:
        step3();
        return;
      case 4:
        step4();
        return;
      case 5:
        step5();
        return;
      case 6:
        step6();
        return;
      case 7:
        step7();
        return;
      case 8:
        step8();
        return;
      case 9:
        stepLast();
        fadeIsland();
        return ;
      default:
       Navigator.of(context).pop(true);
        return;
    }
  }

  stepLast() {
    try {
      controller8.reverse();
    } catch (e) {}
  }

  step2() {
    setState(() {
      _isCanNext = false;
    });
    fadeIsland();
    try {
      Future.delayed(Duration(milliseconds: 2500)).whenComplete(() {
        controller2.forward();
      });
    } catch (e) {}
  }

  step3() {
    setState(() {
      _isCanNext = false;
    });
    try {
      controller2.reverse();
      Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
        controller3.forward();
      });
      Future.delayed(Duration(milliseconds: 2500)).whenComplete(() => setState(() {
            _isCanNext = true;
          }));
    } catch (e) {}
  }

  step4() {
    setState(() {
      _isCanNext = false;
    });
    try {
      controller3.reverse();
      Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
        controller4.forward();
      });
      Future.delayed(Duration(milliseconds: 2500)).whenComplete(() => setState(() {
            _isCanNext = true;
          }));
    } catch (e) {}
  }

  step5() {
    setState(() {
      _isCanNext = false;
    });
    try {
      controller4.reverse();
      Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
        controller5.forward();
      });
      Future.delayed(Duration(milliseconds: 2500)).whenComplete(() => setState(() {
            _isCanNext = true;
          }));
    } catch (e) {}
  }

  step6() {
    setState(() {
      _isCanNext = false;
    });
    try {
      controller5.reverse();
      Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
        controller6.forward();
      });
      Future.delayed(Duration(milliseconds: 2500)).whenComplete(() => setState(() {
            _isCanNext = true;
          }));
    } catch (e) {}
  }

  step7() {
    setState(() {
      _isCanNext = false;
    });
    try {
      controller6.reverse();
      Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
        controller7.forward();
      });
      Future.delayed(Duration(milliseconds: 2500)).whenComplete(() => setState(() {
            _isCanNext = true;
          }));
    } catch (e) {}
  }

  step8() {
    setState(() {
      _isCanNext = false;
    });
    try {
      controller7.reverse();
      Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
        controller8.forward();
      });
      Future.delayed(Duration(milliseconds: 2500)).whenComplete(() => setState(() {
            _isCanNext = true;
          }));
    } catch (e) {}
  }

  AssetImage bgGame;

  AssetImage imgFlyland;
  AssetImage imgEdo;
  AssetImage imgArcint;
  AssetImage imgIsukha;
  AssetImage imgAmazonica;
  AssetImage imgAthena;
  Image img1;
  Image img2;
  Image img3;
  Image img4;
  Image img5;
  Image img6;
  Image img7;

  loadImage() {
    bgGame = AssetImage('assets/game_bg_map.png');
    imgFlyland = AssetImage('assets/fly_land.png');
    imgEdo = AssetImage('assets/edo_land.png');
    imgArcint = AssetImage('assets/arcint_land.png');
    imgIsukha = AssetImage('assets/isukha_land.png');
    imgAmazonica = AssetImage('assets/amazonica_land.png');
    imgAthena = AssetImage('assets/athena_land.png');
    img1 = imgPreCache('img1_tutorial.png');
    img2 = imgPreCache('img2_tutorial.png');
    img3 = imgPreCache('img3_tutorial.png');
    img4 = imgPreCache('img4_tutorial.png');
    img5 = imgPreCache('img5_tutorial.png');
    img6 = imgPreCache('img6_tutorial.png');
    img7 = imgPreCache('img7_tutorial.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGame, context);
    precacheImage(img1.image, context);
    precacheImage(img2.image, context);
    precacheImage(img3.image, context);
    precacheImage(img4.image, context);
    precacheImage(img5.image, context);
    precacheImage(img6.image, context);
    precacheImage(img7.image, context);
    precacheImage(imgFlyland, context);
    precacheImage(imgEdo, context);
    precacheImage(imgArcint, context);
    precacheImage(imgIsukha, context);
    precacheImage(imgAmazonica, context);
    precacheImage(imgAthena, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (_isCanNext == false) {
            return;
          }
          setState(() {
            step++;
          });
          action(step);
        },
        child: Stack(
          children: [
            Positioned(
              child: Image(
                image: bgGame,
                fit: BoxFit.fill,
              ),
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
            ),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOut,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      left: 0,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Image(
                            image: imgEdo,
                          )),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.15,
                      left: 0,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Image(
                            image: imgArcint,
                          )),
                    ),
                    Positioned(
                      right: 0,
                      top: MediaQuery.of(context).size.height * 0.15,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Image(
                            image: imgFlyland,
                          )),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      left: 40,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Image(
                            image: imgIsukha,
                          )),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.15,
                      left: 0,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Image(
                            image: imgAmazonica,
                          )),
                    ),
                    Positioned(
                      right: -24,
                      bottom: MediaQuery.of(context).size.height * 0.15,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Image(
                            image: imgAthena,
                          )),
                    ),
                  ],
                ),
              ),
              top: MediaQuery.of(context).size.height * 0.05,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.25,
              left: 0,
            ),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOut1,
                child: img1,
              ),
              top: MediaQuery.of(context).size.height * 0.02,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.3,
              left: 0,
            ),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOut2,
                child: img2,
              ),
              top: MediaQuery.of(context).size.height * 0.02,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.3,
              left: 0,
            ),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOut3,
                child: img3,
              ),
              top: MediaQuery.of(context).size.height * 0.02,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.3,
              left: 0,
            ),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOut4,
                child: img4,
              ),
              top: MediaQuery.of(context).size.height * 0.02,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.3,
              left: 0,
            ),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOut5,
                child: img5,
              ),
              top: MediaQuery.of(context).size.height * 0.02,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.3,
              left: 0,
            ),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOut6,
                child: img6,
              ),
              top: MediaQuery.of(context).size.height * 0.02,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.3,
              left: 0,
            ),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOut7,
                child: img7,
              ),
              top: MediaQuery.of(context).size.height * 0.02,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.3,
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
                    right: -40,
                    left: -40,
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
              height: MediaQuery.of(context).size.height * 0.25,
              bottom: 0,
              right: 0,
              left: 0,
            ),
            Positioned(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image(
                  image: AssetImage('assets/ninja_nam_avatar.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              bottom: -8,
              left: -48,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Positioned(
              child: _isCanNext
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
    switch (step) {
      case 1:
        return 'Chào mừng đến với học viện Edutalk';
      case 2:
        return '6 vùng đất ...';
      case 3:
        return '6 vùng đất ...';
      case 4:
        return '6 giảng viên ...';
      case 5:
        return '6 giảng viên ...';
      case 6:
        return '6 giảng viên ...';
      case 7:
        return 'Vượt qua thử thách';
      case 8:
        return 'Vượt qua thử thách';

      default:
        return 'Bạn đã sẵn sàng bước vào hành trình mới chưa?';
    }
  }
}
