import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter3State();
}

class Chapter3State extends State<Chapter3> with TickerProviderStateMixin {
  int step = 1;
  Image bgGameStep1;
  Image bgGameStep4;
  AssetImage component1;
  AssetImage component2;
  AssetImage component3;
  AssetImage component4;
  AssetImage component5;
  AssetImage viking;
  AssetImage path;
  AssetImage item_path;
  AssetImage bear;
  AssetImage bear2;

  bool isCanClick = true;
  bool _visibleBear = false;
  bool _visibleItem = false;
  bool _visibleItem2 = false;
  bool _visibleItem3 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  loadImage() {
    bgGameStep1 = imgPreCache('bg_chapter3_1.png');
    bgGameStep4 = imgPreCache('bg_chapter3_2.png');
    bear = AssetImage('assets/bear.png');
    bear2 = AssetImage('assets/bear2.png');
    item_path = AssetImage('assets/items_path_chapter3.png');
    path = AssetImage('assets/path_chapter3.png');
    component1 = AssetImage('assets/images/item1_chapter3.png');
    component2 = AssetImage('assets/images/item2_chapter3.png');
    component3 = AssetImage('assets/images/item3_chapter3.png');
    component4 = AssetImage('assets/images/item4_chapter3.png');
    component5 = AssetImage('assets/images/item5_chapter3.png');
    viking = AssetImage('assets/images/viking_teacher1.png');
  }

  step2() {
    setState(() {
      isCanClick = false;
    });
    Future.delayed(Duration(milliseconds: 200)).whenComplete(() {
      setState(() {
        _visibleBear = true;
      });
    });

    Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
      setState(() {
        isCanClick = true;
      });
    });
  }

  step3() {
    setState(() {
      isCanClick = false;
    });
    Future.delayed(Duration(milliseconds: 200)).whenComplete(() {
      setState(() {
        _visibleBear = false;
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
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
      setState(() {
        _visibleItem2 = true;
      });
    });

    Future.delayed(Duration(milliseconds: 2000)).whenComplete(() {
      setState(() {
        _visibleItem3 = true;
      });
    });
    Future.delayed(Duration(milliseconds: 3500)).whenComplete(() {
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
    precacheImage(bgGameStep4.image, context);
    precacheImage(component1, context);
    precacheImage(component2, context);
    precacheImage(component3, context);
    precacheImage(component4, context);
    precacheImage(component5, context);
    precacheImage(item_path, context);
    precacheImage(path, context);
    precacheImage(bear, context);
    precacheImage(bear2, context);
    precacheImage(viking, context);
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
              step2();
              return;
            default:
              Navigator.of(context).pop(true);
              return;
          }
        },
        child: Stack(
          children: [
            Positioned(
              child: step == 4 ? bgGameStep4 : bgGameStep1,
              top: 0,
              right: 0,
              left: 0,
              bottom: MediaQuery.of(context).size.height * 0.22,
            ),
            Positioned(
                height: step <= 5 ? 240 : 220,
                child: step == 2 || step == 5
                    ? AnimatedOpacity(
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: _visibleBear ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 1500),
                        // The green box must be a child of the AnimatedOpacity widget.
                        child: Image(
                          image: step == 2 ? bear : bear2,
                        ),
                      )
                    : Container(),
                // child:  step  < 2 ? Container() : Image(image: step == 2 ? human1 : (step ==5 ? human2 : human3),),
                right: 0,
                left: 0,
                bottom: MediaQuery.of(context).size.height * 0.2),
            step == 3
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
                            left: 0,
                            right: 0,
                            height: MediaQuery.of(context).size.height * 0.2),
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
                          top: MediaQuery.of(context).size.height * 0.2,
                          right: 36,
                          height: MediaQuery.of(context).size.height * 0.22,
                        ),
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
                            top: MediaQuery.of(context).size.height * 0.2,
                            left: 24,
                            height: MediaQuery.of(context).size.height * 0.22),
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
                          left: 8,
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        Positioned(
                            child: AnimatedOpacity(
                              // If the widget is visible, animate to 0.0 (invisible).
                              // If the widget is hidden, animate to 1.0 (fully visible).
                              opacity: _visibleItem ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 1500),
                              // The green box must be a child of the AnimatedOpacity widget.
                              child: Image(
                                image: component5,
                              ),
                            ),
                            bottom: 24,
                            right: 8,
                            height: MediaQuery.of(context).size.height * 0.18),
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
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: MediaQuery.of(context).size.height * 0.25,
                    child: Stack(
                      children: [
                        Positioned(
                          child: AnimatedOpacity(
                            // If the widget is visible, animate to 0.0 (invisible).
                            // If the widget is hidden, animate to 1.0 (fully visible).
                            opacity: _visibleItem2 ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 1500),
                            // The green box must be a child of the AnimatedOpacity widget.
                            child: Image(
                              image: path,
                              fit: BoxFit.fill,
                            ),
                          ),
                          top: MediaQuery.of(context).size.height * 0.28,
                          right: MediaQuery.of(context).size.width * 0.2,
                          left: MediaQuery.of(context).size.width * 0.24,
                          bottom: MediaQuery.of(context).size.height * 0.09,
                        ),
                        Positioned(
                          child: AnimatedOpacity(
                            // If the widget is visible, animate to 0.0 (invisible).
                            // If the widget is hidden, animate to 1.0 (fully visible).
                            opacity: _visibleItem3 ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 1500),
                            // The green box must be a child of the AnimatedOpacity widget.
                            child: Image(
                              image: item_path,
                              fit: BoxFit.fill,
                            ),
                          ),
                          top: MediaQuery.of(context).size.height * 0.18,
                          right: MediaQuery.of(context).size.width * 0.1,
                          left: MediaQuery.of(context).size.width * 0.15,
                          bottom: MediaQuery.of(context).size.height * 0.06,
                        ),
                      ],
                    ))
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
                                'Giảng viên Viking',
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
                                  style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400),
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
                  image:viking,
                  fit: BoxFit.fill,
                ),flex: 4,),
                Expanded(child: Container(),flex:5,)
              ],),
              bottom: -16,
              right: 0,
              left: -48,
              height:  MediaQuery.of(context).size.height * 0.25
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

  text(int step) {
    switch (step) {
      case 1:
        return 'Chào mừng bạn tới Thành phố Cực Bắc Arcint.';
      case 2:
        return 'Gấu khổng lồ đang tàn phá thành phố Viking...\nNó cũng chính là nỗi khiếp sợ của dân nơi đây.';
      case 3:
        return 'Người xưa kể lại rằng, thành phố Arcint là nơi cất giữ những vũ khí mạnh nhất thế giới.';
      case 4:
        return 'Bạn muốn tiêu diệt Gấu khổng lồ, giải cứu thành phố chứ?\nHãy lần theo bản đồ, thu thập đủ 5 loại thần khí.';
      case 5:
        return 'Hẹn gặp lại bạn sau 3 tháng nữa, bạn đã sẵn sàng cho cuộc giải cứu này?';
      default:
        return '';
    }
  }
}
