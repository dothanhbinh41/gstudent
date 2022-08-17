import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class StoryTestInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StoryTestInputState();
}

class StoryTestInputState extends State<StoryTestInput> with TickerProviderStateMixin {
  int step = 1;
bool _visibleItem = false;
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
  Animation<double> _fadeBg;
  Animation<double> _fadeBg2;
  Animation<double> _fadeInFadeOut3;
  Animation<double> _fadeInFadeOut4;
  Animation<double> _fadeInFadeOut5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadController();
    loadImage();
    fadeIsland();
  }

  loadController() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    controller2 = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    controller3 = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    controller4 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller5 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller6 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller7 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller8 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    _fadeBg = Tween<double>(begin: 1.0, end: 0.0).animate(controller2);
    _fadeBg2 = Tween<double>(begin: 0.0, end: 1.0).animate(controller3);
    _fadeInFadeOut3 = Tween<double>(begin: 0.0, end: 1.0).animate(controller4);
    _fadeInFadeOut4 = Tween<double>(begin: 0.0, end: 1.0).animate(controller5);
    _fadeInFadeOut5 = Tween<double>(begin: 0.0, end: 1.0).animate(controller6);

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
      Future.delayed(Duration(milliseconds: 3500)).whenComplete(() => setState(() {
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
        controller3.forward();
      });
      Future.delayed(Duration(milliseconds: 4000)).whenComplete(() {
        controller4.forward();
      });
    } catch (e) {}
  }

  step3() {
    setState(() {
      _isCanNext = false;
    });
    try {

      controller4.reverse();
      Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
        controller5.forward();
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
      controller5.reverse();

      Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
        controller6.forward();
      });
      Future.delayed(Duration(milliseconds: 2000)).whenComplete(() => setState(() {
        _visibleItem = true;
      }));
      Future.delayed(Duration(milliseconds: 2500)).whenComplete(() => setState(() {
        _isCanNext = true;
      }));
    } catch (e) {}
  }

  step5() {

  }


  AssetImage bgGame;
  AssetImage component;
  AssetImage imgFlyland;
  AssetImage imgEdo;
  AssetImage imgArcint;
  AssetImage imgIsukha;
  AssetImage imgAmazonica;
  AssetImage imgAthena;
  AssetImage bgTest;
  AssetImage book1;
  AssetImage book2;

  loadImage() {
    bgGame = AssetImage('assets/game_bg_map.png');
    book1 = AssetImage('assets/images/book_testinput1.png');
    book2 = AssetImage('assets/images/book_testinput2.png');
    bgTest = AssetImage('assets/bg_testinput.png');
    component = AssetImage('assets/images/item_2_chapter1.png');
    imgFlyland = AssetImage('assets/fly_land.png');
    imgEdo = AssetImage('assets/edo_land.png');
    imgArcint = AssetImage('assets/arcint_land.png');
    imgIsukha = AssetImage('assets/isukha_land.png');
    imgAmazonica = AssetImage('assets/amazonica_land.png');
    imgAthena = AssetImage('assets/athena_land.png');

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(component, context);
    precacheImage(bgGame, context);
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
              child:  FadeTransition(
                opacity: _fadeBg,
                child:Image(
                  image: bgGame,
                  fit: BoxFit.fill,
                ),
              ),
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
            ),
            Positioned(
              child:  FadeTransition(
                opacity: _fadeBg2,
                child: Image(
                  image: bgTest,
                  fit: BoxFit.fill,
                ),
              ),
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
            ),
            Positioned(
              child:  FadeTransition(
                opacity: _fadeInFadeOut3,
                child: Image(
                  image: book1,
                ),
              ),
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
            ),
            Positioned(
              child:  FadeTransition(
                opacity: _fadeInFadeOut4,
                child: Image(
                  image: book2,
                ),
              ),
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
            ),
          step == 4 ?  Positioned(
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
                child: Stack(
                  children: [
                    Center(
                      child: FadeTransition(
                        child: Image(
                          image: AssetImage('assets/img_result_attack.png'),
                          height: 400,
                        ),
                        opacity: _fadeInFadeOut5,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                      child: AnimatedOpacity(
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                          opacity: _visibleItem ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 1500),
                          // The green box must be a child of the AnimatedOpacity widget.
                          child: Image(
                            image: component,
                            height: 100,
                          )),
                    )
                  ],
                ),
              ),
              top: 0,
              right: 0,
              left: 0,
              bottom: MediaQuery.of(context).size.height * 0.2,
            ) : Container(),
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
                                'Shinobi',
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
            // Positioned(child: Image(image: bgGame,fit: BoxFit.fill,),top: 0,right: 0,bottom: 0,left: 0,),
          ],
        ),
      ),
    );
  }

  String text(int step) {
    switch (step) {
      case 1:
        return 'Tôi luôn mơ ước trở thành một thủ lĩnh của thế giới Ecoach. Một ước mơ cao cả với bất kì ai. Đó là một thách thức rất lớn với một người không có kỹ năng như tôi.';
      case 2:
        return 'Nhưng điều đó không thể ngăn cản tôi gia nhập vào Ecoach - một trong những học viện danh giá nhất thế giới với những nhân vật xuất chúng như: Alchemist of Althena, Hero of Arcint, Queen of Edo.';
      case 3:
        return 'Nhưng điều đó không thể ngăn cản tôi gia nhập vào Ecoach - một trong những học viện danh giá nhất thế giới với những nhân vật xuất chúng như: Alchemist of Althena, Hero of Arcint, Queen of Edo.';
      default:
        return 'Để được gia nhập tôi cần vượt qua bài kiểm tra của học viện';
    }
  }
}
