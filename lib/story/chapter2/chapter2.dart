import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter2State();
}

class Chapter2State extends State<Chapter2> with TickerProviderStateMixin {
  int step = 1;
  Image bgGameStep1;
  AssetImage component1;
  AssetImage component2;
  AssetImage component3;
  AssetImage component4;
  AssetImage human1;
  AssetImage human2;
  AssetImage human3;

  bool isCanClick = true;
  bool _visibleItem = false;
  bool _visibleItem2 = false;

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
    component1 = AssetImage('assets/images/item_luyendan1.png');
    component2 = AssetImage('assets/images/item_luyendan2.png');
    component3 = AssetImage('assets/images/item_luyendan3.png');
    component4 = AssetImage('assets/images/item_luyendan4.png');
    human1 = AssetImage('assets/human_chapter2_1.png');
    human2 = AssetImage('assets/human_chapter2_2.png');
    human3 = AssetImage('assets/human_chapter2_3.png');
  }


  step3() {
    setState(() {
      isCanClick = false;

    });

    Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
      setState(() {
        _visibleItem = true;
      });
    });
    Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
      setState(() {
        isCanClick = true;
      });
    });
  }

  step4() {
    setState(() {
      isCanClick = false;
    });
    Future.delayed(Duration(milliseconds: 1000)).whenComplete(() {
      setState(() {
        _visibleItem2 = true;
      });
    });

    Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
      _startAnimationbg();
    });
      Future.delayed(Duration(milliseconds: 2500)).whenComplete(() {
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
    precacheImage(component1, context);
    precacheImage(component2, context);
    precacheImage(component3, context);
    precacheImage(component4, context);
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
            case 2 :

              return;
            case 3:
              step3();
              return;
            case 4:
              step4();
              return;
            case 5 :
              return;
              case 6 :
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
              height: step <= 5 ? 240 : 220,
              child: step < 2
                  ? Container()
                  : Image(
                      image: imageByStep(step),
                    ),
              // child:  step  < 2 ? Container() : Image(image: step == 2 ? human1 : (step ==5 ? human2 : human3),),
              right: 0,
              left: 0,
              bottom: step <= 5 ? MediaQuery.of(context).size.height * 0.2 : MediaQuery.of(context).size.height * 0.25,
            ),
            step < 4
                ? Positioned(
                    child: Stack(
                      children: [
                        Positioned(
                            child: AnimatedOpacity(
                              // If the widget is visible, animate to 0.0 (invisible).
                              // If the widget is hidden, animate to 1.0 (fully visible).
                              opacity: _visibleItem ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 1500),
                              // The green box must be a child of the AnimatedOpacity widget.
                              child: Image(
                                image: component1,
                              ),
                            ),
                            top: 4,
                            left: 4,
                            height: 80),
                        Positioned(
                          child: AnimatedOpacity(
                            // If the widget is visible, animate to 0.0 (invisible).
                            // If the widget is hidden, animate to 1.0 (fully visible).
                            opacity: _visibleItem ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 1500),
                            // The green box must be a child of the AnimatedOpacity widget.
                            child: Image(
                              image: component2,
                            ),
                          ),
                          top: 4,
                          right: 4,
                          height: 80,
                        ),
                        Positioned(
                            child: AnimatedOpacity(
                              // If the widget is visible, animate to 0.0 (invisible).
                              // If the widget is hidden, animate to 1.0 (fully visible).
                              opacity: _visibleItem ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 1500),
                              // The green box must be a child of the AnimatedOpacity widget.
                              child: Image(
                                image: component3,
                              ),
                            ),
                            bottom: 24,
                            right: 4,
                            height: 80),
                        Positioned(
                            child: AnimatedOpacity(
                              // If the widget is visible, animate to 0.0 (invisible).
                              // If the widget is hidden, animate to 1.0 (fully visible).
                              opacity: _visibleItem ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 1500),
                              // The green box must be a child of the AnimatedOpacity widget.
                              child: Image(
                                image: component4,
                              ),
                            ),
                            bottom: 24,
                            left: 4,
                            height: 80),
                      ],
                    ),
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: MediaQuery.of(context).size.height * 0.25,
                  )
                : Container(),
            step == 4
                ? Positioned(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
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
                                opacity: _visibleItem2 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 1500),
                                // The green box must be a child of the AnimatedOpacity widget.
                                child: Image(
                                  image: AssetImage('assets/images/item_chapter2.png'),
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
                  image: step < 2 ? AssetImage('assets/images/kogi_1.png') : AssetImage('assets/images/kogi_2.png'),
                  fit: BoxFit.fill,
                ),flex: 4,),
                Expanded(child: Container(),flex:5,)
              ],),
              bottom: -16,
              right: 0,
              left:  -48 ,
              height: step < 2 ?  MediaQuery.of(context).size.height * 0.3 :  MediaQuery.of(context).size.height * 0.25,
            ),

            Positioned(
              child:  isCanClick ? Image(
                image:AssetImage('assets/images/arrow_bottom.png') ,
              ): Container(),
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
        return 'Chào các bạn đến với rừng nhiệt đới Amazonica.';
      case 2:
        return 'Vị trưởng tộc của hòn đảo đã nhiễm một loại độc tố bí ẩn.';
      case 3:
        return 'Từ ngàn xưa, rừng nhiệt đới Amazonica được mệnh danh là nơi ẩn náu tất cả các loại dược liệu cổ của nhân loại.';
      case 4:
        return 'Người xưa truyền dạy, chỉ có Đan dược thần - được luyện từ các loại dược liệu cổ mới có thể cứu sống Trưởng tộc';
      case 5:
        return 'Bạn có thể cứu sống Trưởng tộc chứ?';
      default:
        return 'Hẹn gặp bạn 3 tháng nữa, hãy tìm kiếm dược liệu cổ và luyện Đan dược thành công. Bạn đã sẵn sàng với cuộc chinh phục này?';
    }
  }

  AssetImage imageByStep(int step) {
    switch (step) {
      case 5:
        return human2;
      case 6:
        return human3;
      case 7:
        return human3;
      default:
        return human1;
    }
  }
}
