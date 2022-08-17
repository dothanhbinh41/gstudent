import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter4 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter4State();
}

class Chapter4State extends State<Chapter4> with TickerProviderStateMixin {
  int step = 1;
  Image bgGameStep1;
  Image bgGameStep2;
  Image bgGameStep3;
  Image bgGameStep4;
  AssetImage ali;
  AssetImage item_path;
  AssetImage component;
  bool _visibleItem = false;
  bool _visibleBackGround= false;
  bool _visiblePath = false;
  Animation<double> _fadeInFadeOut;
  AnimationController _animationbgController;
  bool isCanClick = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    bgGameStep1 = imgPreCache('bg_chapter4.png');
    bgGameStep2 = imgPreCache('bg_chapter4_2.png');
    bgGameStep3 = imgPreCache('bg_chapter4_3.png');
    bgGameStep4 = imgPreCache('bg_chapter4_4.png');
    item_path = AssetImage('assets/path_of_island_chapter4.png');
    ali = AssetImage('assets/images/ali_teacher.png');
    component = AssetImage('assets/images/flying_carpet.png');
  }

  Future _startAnimationbg() async {
    try {
      await _animationbgController.forward().orCancel;
    } on TickerCanceled {
      print(' animation canceled');
    }
  }

  step2() {}

  step3() {}

  step4() {
    setState(() {
      isCanClick = false;
    });
   Future.delayed(Duration(milliseconds: 500)).whenComplete(() =>  setState(() {
     _visibleItem = true;
   }));
    _startAnimationbg();
    Future.delayed(Duration(milliseconds: 2000)).whenComplete(() =>  setState(() {
      isCanClick = true;
    }));
  }

  step5() {
    setState(() {
      isCanClick = false;
    });
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() =>  setState(() {
      _visibleBackGround = true;
    }));
    Future.delayed(Duration(milliseconds: 1500)).whenComplete(() =>  setState(() {
      _visiblePath = true;
    }));
    Future.delayed(Duration(milliseconds: 3000)).whenComplete(() =>  setState(() {
      isCanClick = true;
    }));
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1.image, context);
    precacheImage(bgGameStep2.image, context);
    precacheImage(bgGameStep3.image, context);
    precacheImage(bgGameStep4.image, context);
    precacheImage(item_path, context);
    precacheImage(ali, context);
    precacheImage(component, context);
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
              child: bgByStep(),
              top: 0,
              right: 0,
              left: 0,
              bottom: step == 1 || step == 3  || step == 4? MediaQuery.of(context).size.height * 0.22 : 0,
            ),
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
                  )
                : Container(),
            step == 5
                ? Positioned(
              child: AnimatedOpacity(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                  opacity: _visibleBackGround ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 1000),
                  // The green box must be a child of the AnimatedOpacity widget.
                  child:Container(decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8)
                  ),)),
              top: 0,
              right: 0,
              left: 0,
              bottom: MediaQuery.of(context).size.height * 0.2,
            )
                : Container(),
            step == 5
                ? Positioned(
                    child: AnimatedOpacity(
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: _visiblePath ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 1500),
                        // The green box must be a child of the AnimatedOpacity widget.
                        child: Image(
                          image: item_path,
                          fit: BoxFit.fill,
                        )),
                    top: MediaQuery.of(context).size.height * 0.14,
                    right: MediaQuery.of(context).size.height * 0.015,
                    left: MediaQuery.of(context).size.height * 0.05,
                    bottom: MediaQuery.of(context).size.height * 0.25,
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
                                'Giảng viên Ali',
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
                                  style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400,fontSize: text(step).length < 150 ? 14 : 12),
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
                  image: ali,
                  fit: BoxFit.fill,
                ),flex: 3,),
                Expanded(child: Container(),flex:5,)
              ],),
              bottom: -16,
              right: 0,
              left:  -32  ,
              height:   MediaQuery.of(context).size.height * 0.25
            ),

            Positioned(
              child:  isCanClick ? Image(
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

 String text(int step) {
    switch (step) {
      case 1:
        return 'Chào mừng con tới Vương quốc sa mạc Isukha.';
      case 2:
        return 'Nơi đây có một kim tự tháp đã tồn tại từ thời cổ đại với rất nhiều kho báu.';
      case 3:
        return 'Tuy nhiên, bên trong đó là một mê cung với rất nhiều cạm bẫy, và có đường vào nhưng không có đường ra.';
      case 4:
        return 'Cánh duy nhất ra khỏi đây là tìm kiếm được Thảm bay thần.';
      case 5:
        return 'Trong 3 tháng tới, con hãy lần theo hành trình này, tập hợp đủ mảnh bản đồ - tấm bản đồ hoàn chỉnh sẽ giúp con tìm được Thảm thần.\nCon đã sẵn sàng cho hành trình khám phá này?';
      default :
        return '';
    }
  }

  bgByStep() {
    switch (step) {
      case 1:
        return bgGameStep1  ;
      case 2:
        return bgGameStep2  ;
      case 3:
        return  bgGameStep3 ;
      case 4:
        return bgGameStep3;
      default:
        return bgGameStep4;
    }
  }
}
