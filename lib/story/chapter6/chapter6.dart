import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter6 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter6State();
}

class Chapter6State extends State<Chapter6> with TickerProviderStateMixin {
  int step = 1;
  Image bgGameStep1;
  Image bgGameStep2;
  AssetImage alice;
  AssetImage stone;
  AssetImage stone2;
  AssetImage component1;
  AssetImage component2;
  AssetImage material1;
  AssetImage material2;
  AssetImage material3;
  AssetImage material4;
  AssetImage material5;

  AnimationController controller;
  AnimationController controller2;
  AnimationController controller3;
  AnimationController controller4;
  AnimationController controllerMaterial1;
  AnimationController controllerMaterial2;
  AnimationController controllerMaterial3;
  AnimationController controllerMaterial4;
  AnimationController controllerMaterial5;
  AnimationController controllerRoll;
  Animation<double> _fadeInFadeOut;
  Animation<double> _fadeInFadeOut1;
  Animation<double> _fadeInFadeOut2;
  Animation<double> _fadeInFadeOut3;
  Animation<double> _fadeInFadeOutMaterial1;
  Animation<double> _fadeInFadeOutMaterial2;
  Animation<double> _fadeInFadeOutMaterial3;
  Animation<double> _fadeInFadeOutMaterial4;
  Animation<double> _fadeInFadeOutMaterial5;
  bool isCanClick = true;
  bool isAnimateMaterial = false;
  Animation base;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller2 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller3 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller4 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controllerMaterial1 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controllerMaterial2 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controllerMaterial3 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controllerMaterial4 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controllerMaterial5 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controllerRoll = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    _fadeInFadeOut1 = Tween<double>(begin: 0.0, end: 1.0).animate(controller2);
    _fadeInFadeOut2 = Tween<double>(begin: 0.0, end: 1.0).animate(controller3);
    _fadeInFadeOut3 = Tween<double>(begin: 0.0, end: 1.0).animate(controller4);
    _fadeInFadeOutMaterial1 = Tween<double>(begin: 0.0, end: 1.0).animate(controllerMaterial1);
    _fadeInFadeOutMaterial2 = Tween<double>(begin: 0.0, end: 1.0).animate(controllerMaterial2);
    _fadeInFadeOutMaterial3 = Tween<double>(begin: 0.0, end: 1.0).animate(controllerMaterial3);
    _fadeInFadeOutMaterial4 = Tween<double>(begin: 0.0, end: 1.0).animate(controllerMaterial4);
    _fadeInFadeOutMaterial5 = Tween<double>(begin: 0.0, end: 1.0).animate(controllerMaterial5);
    base = CurvedAnimation(parent: controllerRoll, curve: Curves.easeOut);
    loadImage();
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  loadImage() {
    bgGameStep1 = imgPreCache('bg_chapter6.png');
    bgGameStep2 = imgPreCache('game_bg_map.png');
    stone = AssetImage('assets/images/chapter6_stone.png');
    stone2 = AssetImage('assets/images/chapter6_stone2.png');
    alice = AssetImage('assets/images/alice.png');
    component1 = AssetImage('assets/images/chapter6_component1.png');
    component2 = AssetImage('assets/images/chapter6_component2.png');
    material1 = AssetImage('assets/images/chapte6_material1.png');
    material2 = AssetImage('assets/images/chapte6_material2.png');
    material3 = AssetImage('assets/images/chapte6_material3.png');
    material4 = AssetImage('assets/images/chapte6_material4.png');
    material5 = AssetImage('assets/images/chapte6_material5.png');
  }

  step2() {
    setState(() {
      isCanClick = false;
    });
    try {
      controller.forward();
      Future.delayed(Duration(milliseconds: 2000)).whenComplete(() => setState(() {
            isCanClick = true;
          }));
    } catch (e) {}
  }

  step3() {
    setState(() {
      isCanClick = false;
    });
    try {
      controller2.forward();

      Future.delayed(Duration(milliseconds: 2000)).whenComplete(() => setState(() {
            isCanClick = true;
          }));
    } catch (e) {}
  }

  step4() {
    setState(() {
      isCanClick = false;
    });
    controller.reverse();
    controller2.reverse();

    Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
      controller3.forward();
    });
    Future.delayed(Duration(milliseconds: 2000)).whenComplete(() {
    setState(() {
      isAnimateMaterial = true;
    });
      controllerRoll.forward();

    });

    Future.delayed(Duration(milliseconds: 5000)).whenComplete(() => setState(() {
      isCanClick = true;
    }));

  }

  step5() {
    setState(() {
      isCanClick = false;
    });
    try{
      controller3.reverse();
      controller4.forward();
      Future.delayed(Duration(milliseconds: 1500)).whenComplete(() => controllerMaterial1.forward());
      Future.delayed(Duration(milliseconds: 2500)).whenComplete(() => controllerMaterial2.forward());
      Future.delayed(Duration(milliseconds: 3500)).whenComplete(() => controllerMaterial3.forward());
      Future.delayed(Duration(milliseconds: 4500)).whenComplete(() => controllerMaterial4.forward());
      Future.delayed(Duration(milliseconds: 5500)).whenComplete(() {
        controllerMaterial5.forward();
        setState(() {
          isCanClick = true;
        });
      });
    }catch(e){

    }

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1.image, context);
    precacheImage(stone, context);
    precacheImage(stone2, context);
    precacheImage(material1, context);
    precacheImage(material2, context);
    precacheImage(material3, context);
    precacheImage(material4, context);
    precacheImage(material5, context);
    precacheImage(component1, context);
    precacheImage(component2, context);
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
        },
        child: Stack(
          children: [
            Positioned(
              child:bgGameStep1  ,
              top: 0,
              right: 0,
              left: 0,
              bottom: MediaQuery.of(context).size.height * 0.1,
            ),
            Positioned(
              child: Stack(
                children: [
                  Positioned(
                    child: Stack(
                      children: [
                        Positioned(
                          child: FadeTransition(
                            opacity: _fadeInFadeOut3,
                            child: Image(
                              image: component1,
                            ),
                          ),
                          bottom: 0,
                          right: 0,
                          left: 0,
                        ),
                        Positioned(
                          child: FadeTransition(
                            opacity: _fadeInFadeOutMaterial1,
                            child: Image(
                              image: material1,
                            ),
                          ),
                          top: 0,
                          right: 0,
                          left: 0,
                        ),
                      ],
                    ),
                    width: 80,
                    height: 128,
                    bottom: MediaQuery.of(context).size.height * 0.05,
                    right: MediaQuery.of(context).size.width * 0.2,
                  ),
                  Positioned(
                    child: Stack(
                      children: [
                        Positioned(
                          child:  FadeTransition(
                            opacity: _fadeInFadeOut3,
                            child: Image(
                              image: component2,
                            ),
                          ),
                          bottom: 0,
                          right: 0,
                          left: 0,
                        ),
                        Positioned(
                          child:  FadeTransition(
                            opacity: _fadeInFadeOutMaterial2,
                            child: Image(
                              image: material5,
                            ),
                          ),
                          top: 0,
                          right: 0,
                          left: 0,
                        ),
                      ],
                    ),
                    width: 68,
                    height: 110,
                    bottom: MediaQuery.of(context).size.height * 0.18,
                    left: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Positioned(
                    child: Stack(
                      children: [
                        Positioned(
                          child: FadeTransition(
                            opacity: _fadeInFadeOut3,
                            child: Image(
                              image: component1,
                            ),
                          ),
                          bottom: 0,
                          right: 0,
                          left: 0,
                        ),
                        Positioned(
                          child:  FadeTransition(
                            opacity: _fadeInFadeOutMaterial3,
                            child: Image(
                              image: material4,
                            ),
                          ),
                          top: 0,
                          right: 0,
                          left: 0,
                        ),
                      ],
                    ),
                    width: 60,
                    height: 100,
                    bottom: MediaQuery.of(context).size.height * 0.4,
                    left: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Positioned(
                    child: Stack(
                      children: [
                        Positioned(
                          child:  FadeTransition(
                            opacity: _fadeInFadeOut3,
                            child: Image(
                              image: component2,
                            ),
                          ),
                          bottom: 0,
                          right: 0,
                          left: 0,
                        ),
                        Positioned(
                          child:  FadeTransition(
                            opacity: _fadeInFadeOutMaterial4,
                            child: Image(
                              image: material3,
                            ),
                          ),
                          top: 0,
                          right: 0,
                          left: 0,
                        ),
                      ],
                    ),
                    width: 48,
                    height: 80,
                    top: MediaQuery.of(context).size.height * 0.1,
                    right: MediaQuery.of(context).size.width * 0.4,
                  ),
                  Positioned(
                    child: Stack(
                      children: [
                        Positioned(
                          child: FadeTransition(
                            opacity: _fadeInFadeOut3,
                            child: Image(
                              image: component2,
                            ),
                          ),
                          bottom: 0,
                          right: 0,
                          left: 0,
                        ),
                        Positioned(
                          child:  FadeTransition(
                            opacity: _fadeInFadeOutMaterial5,
                            child: Image(
                              image: material2,
                            ),
                          ),
                          top: 0,
                          right: 0,
                          left: 0,
                        ),
                      ],
                    ),
                    width: 48,
                    height: 80,
                    top: MediaQuery.of(context).size.height * 0.01,
                    right: MediaQuery.of(context).size.width * 0.1,
                  )
                ],
              ),
              top: 0,
              right: 0,
              left: 0,
              bottom: MediaQuery.of(context).size.height * 0.2,
            ),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOut2,
                child:bgGameStep2  ,
              ),
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
            ),
            step == 4
                ? Positioned(
                    child: RotationTransition(
                      turns: base,
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            right: 0,
                            left: 0,
                            curve: Curves.fastOutSlowIn,
                            duration: Duration(milliseconds: 2000),
                            top: isAnimateMaterial ? MediaQuery.of(context).size.height * 0.05 : -MediaQuery.of(context).size.height * 0.2,
                            child: Image(
                              image: material1,
                            ),
                            height: 120,
                          ),
                          AnimatedPositioned(
                            right: isAnimateMaterial ? MediaQuery.of(context).size.width * 0.02 : -MediaQuery.of(context).size.width * 0.2,
                            curve: Curves.fastOutSlowIn,
                            duration: Duration(milliseconds: 2000),
                            top: isAnimateMaterial ? MediaQuery.of(context).size.height * 0.2 : -MediaQuery.of(context).size.height * 0.2,
                            child: Image(
                              image: material2,
                            ),
                            width: 120,
                          ),
                          AnimatedPositioned(
                            right: isAnimateMaterial ? MediaQuery.of(context).size.width * 0.15 : -MediaQuery.of(context).size.width * 0.2,
                            curve: Curves.fastOutSlowIn,
                            duration: Duration(milliseconds: 2000),
                            bottom: isAnimateMaterial ? MediaQuery.of(context).size.height * 0.2 : -MediaQuery.of(context).size.height * 0.2,
                            child: Image(
                              image: material3,
                            ),
                            height: 120,
                          ),
                          AnimatedPositioned(
                            left: isAnimateMaterial ? MediaQuery.of(context).size.width * 0.02 : -MediaQuery.of(context).size.width * 0.2,
                            curve: Curves.fastOutSlowIn,
                            duration: Duration(milliseconds: 2000),
                            top: isAnimateMaterial ? MediaQuery.of(context).size.height * 0.2 : -MediaQuery.of(context).size.height * 0.2,
                            child: Image(
                              image: material4,
                            ),
                            height: 120,
                          ),
                          AnimatedPositioned(
                            bottom: isAnimateMaterial ? MediaQuery.of(context).size.height * 0.2 : -MediaQuery.of(context).size.height * 0.2,
                            curve: Curves.fastOutSlowIn,
                            duration: Duration(milliseconds: 2000),
                            left: isAnimateMaterial ? MediaQuery.of(context).size.width * 0.15 : -MediaQuery.of(context).size.width * 0.2,
                            child: Image(
                              image: material5,
                            ),
                            height: 120,
                          )
                        ],
                      ),
                    ),
                    top: MediaQuery.of(context).size.height * 0.05,
                    right: 0,
                    left: 0,
                    bottom: MediaQuery.of(context).size.height * 0.15,
                  )
                : Container(),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOut,
                child: Image(
                  image: stone,
                ),
              ),
              height: 200,
              top: MediaQuery.of(context).size.height * 0.3,
              right: 0,
              left: 0,
            ),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOut1,
                child: Image(
                  image: stone2,
                ),
              ),
              height: 200,
              top: MediaQuery.of(context).size.height * 0.3,
              right: 0,
              left: 0,
            ),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOut1,
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade300.withOpacity(0.5)),
                ),
              ),
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
    switch (step) {
      case 1:
        return 'Chào mừng bạn tới đảo thần tiên Flyland.';
      case 2:
        return 'Một vùng đất tươi đẹp với muôn hoa đua nở...nhờ năng lượng từ Ngọc thần.';
      case 3:
        return 'Tuy nhiên, Ngọc thần đang dần cạn kiệt năng lượng và thành phố đang dần khô héo';
      case 4:
        return 'Bạn có muốn khôi phục hòn đảo xinh đẹp này?\nTrong 3 tháng tới, hãy thu thập đủ Đá năng lượng để tinh luyện thành viên Ngọc thần mới cho đảo Flyland.';
      case 5:
        return 'Bạn đã sẵn sàng cho thử thách mới này?';
      default:
        return '';
    }
  }
}
