import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter5 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter5State();
}

class Chapter5State extends State<Chapter5> with TickerProviderStateMixin {
  int step = 1;
  Image bgGameStep1;
  Image bgGameStep2;
  AssetImage shinobi;
  AssetImage shinobi2;
  AssetImage item_path;
  AssetImage path;
  AssetImage component;
  AssetImage fire;
  bool _visibleFire = false;
  bool _visibleItem = false;
  bool _visibleBackGround = false;
  bool _visiblePath = false;
  bool _visibleItemPath = false;
  Animation<double> _fadeInFadeOut;
  AnimationController _animationbgController;
  AnimationController _animationController;
  bool isCanClick = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    _animationbgController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(_animationbgController);
    loadImage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  loadImage() {
    bgGameStep1 = imgPreCache('bg_chapter5.png');
    bgGameStep2 = imgPreCache('bg_chapter5_2.png');
    item_path = AssetImage('assets/item_path_chapter5.png');
    shinobi = AssetImage('assets/images/shinobi_teacher.png');
    shinobi2 = AssetImage('assets/images/shinobi_teacher_2.png');
    path = AssetImage('assets/images/path_chapter5.png');
    component = AssetImage('assets/component_chapter5.png');
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
          _visibleItem = true;
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
    _startAnimation();
    Future.delayed(Duration(milliseconds: 1500)).whenComplete(() => setState(() {
      _visibleFire = true;
    }));
    Future.delayed(Duration(milliseconds: 2500)).whenComplete(() => setState(() {
      isCanClick = true;
    }));
  }

  step4() {
    setState(() {
      isCanClick = false;
    });
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() => setState(() {
          _visibleBackGround = true;
          _visiblePath = true;
        }));
    Future.delayed(Duration(milliseconds: 1500)).whenComplete(() => setState(() {
      _visibleItemPath = true;
    }));
    Future.delayed(Duration(milliseconds: 3000)).whenComplete(() => setState(() {
      isCanClick = true;
    }));
  }

  step5() {
    setState(() {
      isCanClick = false;
    });
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() => setState(() {
          _visibleBackGround = false;
        }));

    Future.delayed(Duration(milliseconds: 1500)).whenComplete(() => setState(() {
          isCanClick = true;
        }));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1.image, context);
    precacheImage(bgGameStep2.image, context);
    precacheImage(item_path, context);
    precacheImage(shinobi, context);
    precacheImage(shinobi2, context);
    precacheImage(component, context);
    precacheImage(path, context);
    precacheImage(fire, context);
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
            default :
              Navigator.of(context).pop(true);
              return;
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
            //step 2
            step > 1 && step < 3
                ? Positioned(
                    height: 200,
                    top: MediaQuery.of(context).size.height * 0.3,
                    left: 0,
                    right: 0,
                    child: FadeTransition(
                      child: Image(
                        image: AssetImage('assets/img_result_attack.png'),
                      ),
                      opacity: _fadeInFadeOut,
                    ),
                  )
                : Container(),

            //step 3
            step == 3
                ? Container(
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
                  )
                : Container(),
            step == 3 ?  Positioned(
              child: AnimatedOpacity(
                  opacity: _visibleFire ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 1000),
                  // The green box must be a child of the AnimatedOpacity widget.
                  child: Image(
                    image: fire,
                  )),
              top: MediaQuery.of(context).size.height * 0.16,
              height: MediaQuery.of(context).size.width,
              left: 0,
              right: 0,
            ) : Container(),

            step < 4
                ? (step > 1 && step == 2
                    ? Positioned(
                        child: AnimatedOpacity(
                            opacity: _visibleItem ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 1500),
                            // The green box must be a child of the AnimatedOpacity widget.
                            child: Image(
                              image: component,
                            )),
                        top: MediaQuery.of(context).size.height * 0.4,
                        height: 60,
                        left: 0,
                        right: 0,
                      )
                    : AnimationBook(
                        controller: _animationController,
                        startPosition: MediaQuery.of(context).size.height * 0.15,
                        endPosition: MediaQuery.of(context).size.height * 0.1,
                        heightItem: 200,
                      ))
                : Container(),

            step >= 4
                ? Positioned(
                    child: AnimatedOpacity(
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: _visibleBackGround ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 1000),
                        // The green box must be a child of the AnimatedOpacity widget.
                        child: Container(
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
                        )),
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: MediaQuery.of(context).size.height * 0.2,
                  )
                : Container(),
            step >= 4
                ? Positioned(
                    child: AnimatedOpacity(
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: _visiblePath ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 1500),
                        // The green box must be a child of the AnimatedOpacity widget.
                        child: Image(
                          image: path,
                          fit: BoxFit.fill,
                        )),
                    top: MediaQuery.of(context).size.height * 0.22,
                    right: MediaQuery.of(context).size.height * 0,
                    left: MediaQuery.of(context).size.height * 0.15,
                    bottom: MediaQuery.of(context).size.height * 0.4,
                  )
                : Container(),
            step >= 4
                ? Positioned(
                    child: AnimatedOpacity(
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: _visibleItemPath ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 1500),
                        // The green box must be a child of the AnimatedOpacity widget.
                        child: Image(
                          image: item_path,
                          fit: BoxFit.fitHeight,
                        )),
                    top: MediaQuery.of(context).size.height * 0.14,
                    right: MediaQuery.of(context).size.height * 0.08,
                    left: MediaQuery.of(context).size.height * 0.05,
                    bottom: MediaQuery.of(context).size.height * 0.35,
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
                                'Giảng viên Shinobi',
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
                    image: step == 1 ? shinobi : shinobi2,
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
        return 'Chào mừng con tới thành phố Edo - vùng đất của những thám tử lừng danh nhất thế giới.';
      case 2:
        return 'Tuy nhiên gần đây, thành phố bị ám bởi bài thơ của quỷ "Tomino Hell"...rất nhiều người đã chết.';
      case 3:
        return 'Bất cứ ai đọc bài thơ quỷ này, đều sẽ chết. Tuy nhiên, không ai biết tung tích của bài thơ này ở đâu để tiêu huỷ nó.';
      case 4:
        return 'Tương truyền, có một bản đồ thông tin sẽ chỉ nơi ẩn náu của bài thơ quỷ Tomino Hell. ';
      case 5:
        return 'Trong 3 tháng tới, con hãy lần theo hành trình này, tập hợp đủ mảnh bản đồ - tấm bản đồ hoàn chỉnh sẽ giúp con tìm được Thảm thần.\nCon đã sẵn sàng cho hành trình khám phá này?';
      default:
        return '';
    }
  }

  bgByStep() {
    switch (step) {
      case 1:
        return bgGameStep1;

      case 2:
        return bgGameStep1;

      case 3:
        return bgGameStep1;

      default:
        return bgGameStep2;
    }
  }
}

class AnimationBook extends StatelessWidget {
  AnimationBook({Key key, this.controller, this.heightItem, this.startPosition, this.endPosition})
      : opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.2,
              curve: Curves.easeIn,
            ),
          ),
        ),
        movement = EdgeInsetsTween(
          begin: EdgeInsets.only(top: 0, left: 0.0, right: 0, bottom: startPosition),
          end: EdgeInsets.only(top: 0, left: 0.0, right: 0, bottom: endPosition),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.2,
              0.8,
              curve: Curves.easeInSine,
            ),
          ),
        ),
        height = Tween<double>(
          begin: 60,
          end: heightItem,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.6,
              0.9,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        super(key: key);

  final double startPosition;
  final double endPosition;
  final double heightItem;
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> height;
  final Animation<EdgeInsets> movement;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Container(
          padding: movement.value,
          transform: Matrix4.identity(),
          alignment: Alignment.center,
          child: Opacity(
            opacity: opacity.value,
            child: Container(
              height: height.value,
              child: Image(
                image: AssetImage('assets/component_chapter5.png'),
              ),
            ),
          ),
        );
      },
    );
  }
}
