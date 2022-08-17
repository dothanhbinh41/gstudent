import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter3Middle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter3MiddleState();
}

class Chapter3MiddleState extends State<Chapter3Middle> with TickerProviderStateMixin {
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
  AssetImage bear3;
  AssetImage gate;

  bool isCanClick = true;
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
    bear3 = AssetImage('assets/bear_chapter3.png');
    item_path = AssetImage('assets/items_path_chapter3.png');
    path = AssetImage('assets/path_chapter3.png');
    component1 = AssetImage('assets/images/item1_chapter3.png');
    component2 = AssetImage('assets/images/item2_chapter3.png');
    component3 = AssetImage('assets/images/item3_chapter3.png');
    component4 = AssetImage('assets/images/item4_chapter3.png');
    component5 = AssetImage('assets/images/item5_chapter3.png');
    viking = AssetImage('assets/images/viking_teacher1.png');
    gate = AssetImage('assets/images/gate.png');
  }

  step2() {
    setState(() {
      isCanClick = false;
    });
    Future.delayed(Duration(milliseconds: 200)).whenComplete(() {
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

  step3() {
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
    precacheImage(gate, context);
    precacheImage(bear3, context);
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
              ;
              return;
          }
        },
        child: Stack(
          children: [
            Positioned(
              child: step == 3 ? bgGameStep4 : bgGameStep1,
              top: 0,
              right: 0,
              left: 0,
              bottom: MediaQuery.of(context).size.height * 0.22,
            ),
            Positioned(
              height: MediaQuery.of(context).size.height * 0.3,
              child: step < 3
                  ? Image(
                      image: gate,
                    )
                  : Container(),
              top: MediaQuery.of(context).size.height * 0.2,
              right: 0,
              left: 0,
            ),
            step < 3
                ? AnimatedPositioned(
                    right: step == 2 ? MediaQuery.of(context).size.width * 0.3 : 0,
                    left: 0,
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 2000),
                    top: step == 2 ? MediaQuery.of(context).size.height * 0.42 : MediaQuery.of(context).size.height * 0.45,
                    child: Image(
                      image: step == 2 ? bear : bear2,
                    ),
                    height: step == 2 ? 140 : 200,
                  )
                : Container(),
            Positioned(
                height: MediaQuery.of(context).size.height * 0.15,
                child: step == 2
                    ? AnimatedOpacity(
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: _visibleItem ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 1500),
                        // The green box must be a child of the AnimatedOpacity widget.
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Image(
                                image: component1,
                              ),
                            ),
                            Expanded(
                              child: Image(
                                image: component2,
                              ),
                            ),
                            Expanded(
                              child: Image(
                                image: component3,
                              ),
                            ),
                            Expanded(
                              child: Image(
                                image: component4,
                              ),
                            ),
                            Expanded(
                              child: Image(
                                image: component5,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                // child:  step  < 2 ? Container() : Image(image: step == 2 ? human1 : (step ==5 ? human2 : human3),),
                right: 0,
                left: 0,
                bottom: MediaQuery.of(context).size.height * 0.25),
            step == 3
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
                              image: bear3,
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.2,
                          top: 24,
                          left: 16,
                        ),
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
        return 'Gấu khổng lồ chặn cánh cửa không gian, ngăn cản bất kỳ ai muốn ra khỏi thành phố.';
      case 2:
        return '3 ngày nữa, cánh cửa sẽ mở ra - cơ hội duy nhất để con ra khỏi thành phố này. Con đã thu thập đủ thần khí chưa nhỉ?';
      case 3:
        return 'Thời gian không còn nhiều, con hãy ôn tập thật tốt, chinh phục đủ thần khí và tiêu diệt Gấu khổng lồ nhé!';
      default:
        return '';
    }
  }
}
