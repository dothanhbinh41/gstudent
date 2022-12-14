import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter5Middle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter5MiddleState();
}

class Chapter5MiddleState extends State<Chapter5Middle> with TickerProviderStateMixin {
  int step = 1;
  Image bgGameStep1;
  AssetImage shinobi2;
  AssetImage component;
  AssetImage arrow_fire;
  AssetImage end_arrow_fire;
  AssetImage thinking_arrow;
  AssetImage thinking_team;
  AssetImage fire;
  bool _visibleBook = false;
  bool _visibleItem = false;
  bool _visibleArrow = false;
  Animation<double> _fadeInFadeOut;
  Animation<double> _fadeInFadeOutFire;
  AnimationController _animationbgController;
  AnimationController _animationController;
  bool isCanClick = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _animationbgController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(_animationbgController);
    _fadeInFadeOutFire = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    loadImage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  loadImage() {
    bgGameStep1 = imgPreCache('bg_chapter5_3.png');
    shinobi2 = AssetImage('assets/images/shinobi_teacher_2.png');
    thinking_arrow = AssetImage('assets/images/thinking_arrow.png');
    thinking_team = AssetImage('assets/images/thinking_team.png');
    component = AssetImage('assets/component_chapter5.png');
    end_arrow_fire = AssetImage('assets/end_arrow_fire.png');
    arrow_fire = AssetImage('assets/arrow_fire.png');
    fire = AssetImage('assets/fire_chapter5.png');
  }

  Future _startAnimationbg() async {
    try {
      await _animationbgController.forward().orCancel;
    } on TickerCanceled {
      print(' animation canceled');
    }
  }

  Future _startAnimation() async {
    try {
      await _animationController.forward().orCancel;
    } on TickerCanceled {
      print(' animation canceled');
    }
  }

  step2() {
    setState(() {
      isCanClick = false;
    });
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() => setState(() {
          _visibleBook = true;
        }));
    _startAnimationbg();
    Future.delayed(Duration(milliseconds: 1500)).whenComplete(() => setState(() {
          isCanClick = true;
        }));
  }

  step3() {
    setState(() {
      isCanClick = false;
    });
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() => setState(() {
          _visibleItem = true;
        }));

    Future.delayed(Duration(milliseconds: 2500)).whenComplete(() => _startAnimation());
    Future.delayed(Duration(milliseconds: 2500)).whenComplete(() => _startAnimation());

    Future.delayed(Duration(milliseconds: 1500)).whenComplete(() => setState(() {
          _visibleArrow = true;
        }));
    Future.delayed(Duration(milliseconds: 3500)).whenComplete(() => setState(() {
          isCanClick = true;
        }));
  }

  step4() {}

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1.image, context);
    precacheImage(shinobi2, context);
    precacheImage(component, context);
    precacheImage(fire, context);
    precacheImage(end_arrow_fire, context);
    precacheImage(arrow_fire, context);
    precacheImage(thinking_arrow, context);
    precacheImage(thinking_team, context);
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
            default:
              Navigator.of(context).pop(true);
          }
        },
        child: Stack(
          children: [
            Positioned(
              child: bgByStep(),
              top: 0,
              right: 0,
              left: 0,
              bottom: MediaQuery.of(context).size.height * 0.22,
            ),
            step < 3
                ? (step == 2
                    ? Positioned(
                        child: Container(
                          child: Stack(
                            children: [
                              Center(
                                child: FadeTransition(
                                  child: Image(
                                    image: AssetImage('assets/img_result_attack.png'),
                                    height: 300,
                                  ),
                                  opacity: _fadeInFadeOut,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                child: AnimatedOpacity(
                                    // If the widget is visible, animate to 0.0 (invisible).
                                    // If the widget is hidden, animate to 1.0 (fully visible).
                                    opacity: _visibleBook ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 1500),
                                    // The green box must be a child of the AnimatedOpacity widget.
                                    child: Image(
                                      image: AssetImage('assets/images/item_2_chapter1.png'),
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
                      )
                    : Positioned(
                        child: Container(
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Image(
                                  image: AssetImage('assets/img_result_attack.png'),
                                  height: 300,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                child: Image(
                                  image: component,
                                  height: 100,
                                ),
                              )
                            ],
                          ),
                        ),
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: MediaQuery.of(context).size.height * 0.2,
                      ))
                : Container(),
            step == 3
                ? AnimatedPositioned(
                    bottom: _visibleArrow ? MediaQuery.of(context).size.height * 0.35 : -MediaQuery.of(context).size.height / 2,
                    right: 0,
                    left: 0,
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: Image(
                      image: arrow_fire,
                      height: MediaQuery.of(context).size.width,
                    ),
                    duration: Duration(milliseconds: 2000))
                : Container(),
            step == 3
                ? Positioned(
                    height: MediaQuery.of(context).size.width,
                    top: MediaQuery.of(context).size.height * 0.1,
                    left: 0,
                    right: 0,
                    child: Container(
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: FadeTransition(
                              child: Image(
                                image: fire,
                              ),
                              opacity: _fadeInFadeOutFire,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: AnimatedOpacity(
                                // If the widget is visible, animate to 0.0 (invisible).
                                // If the widget is hidden, animate to 1.0 (fully visible).
                                opacity: _visibleItem ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 1000),
                                // The green box must be a child of the AnimatedOpacity widget.
                                child: Image(
                                  image: component,
                                  height: MediaQuery.of(context).size.width / 2,
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
            step == 3
                ? AnimatedPositioned(
                    bottom: _visibleArrow ? MediaQuery.of(context).size.height * 0.35 : -MediaQuery.of(context).size.height / 2,
                    right: 0,
                    left: 0,
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: Image(
                      image: end_arrow_fire,
                      height: MediaQuery.of(context).size.width,
                    ),
                    duration: Duration(milliseconds: 2000))
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
                                'Gi???ng vi??n Shinobi',
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
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.22,
              bottom: 0,
              right: 0,
              left: 0,
            ),
            Positioned(
              child: step < 3
                  ? AnimatedCrossFade(
                      crossFadeState: step == 1 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      firstCurve: Curves.fastOutSlowIn,
                      secondCurve: Curves.fastOutSlowIn,
                      duration: Duration(milliseconds: step == 1 ? 100 : 1500),
                      firstChild: Image(
                        image: thinking_arrow,
                      ),
                      secondChild: Image(
                        image: thinking_team,
                      ),
                    )
                  : Container(),
              left: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.15,
              bottom: MediaQuery.of(context).size.height * 0.26,
            ),
            Positioned(
                child: Row(children: [
                  Expanded(child:   Image(
                    image:shinobi2,
                    fit: BoxFit.fill,
                  ),flex: 4,),
                  Expanded(child: Container(),flex:5,)
                ],),
                bottom: -24,
                right: 0,
                left: -24,
                height:   MediaQuery.of(context).size.height * 0.3
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
        return 'Ng??y c??ng nhi???u ng?????i ch???t...\nT????ng truy???n, ch??? c?? m??i t??n l???a di???t qu??? m???i c?? th??? ti??u hu??? n??';
      case 2:
        return 'C??ch duy nh???t ????? l???y m??i t??n l???a l?? v?????t qua m???t b??i ki???m tra s???c m???nh v?? tr?? th??ng minh v??o 7 ng??y n???a.';
      default:
        return '??n luy???n th???t t???t, ti??u di???t qu??? Tomino v?? tr??? l???i m???t th??nh ph??? Edo y??n b??nh. Ta tin ba??n l??m ???????c!';
    }
  }

  bgByStep() {
    return bgGameStep1;
  }
}
