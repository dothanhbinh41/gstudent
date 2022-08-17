import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter5End extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter5EndState();
}

class Chapter5EndState extends State<Chapter5End> with TickerProviderStateMixin {
  int step = 0;
  bool _isWin = true;
  Animation base;
  AnimationController controllerGate;

  @override
  void dispose() {
    controllerGate.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerGate = AnimationController(vsync: this, duration: Duration(milliseconds: 10000));
    base = CurvedAnimation(parent: controllerGate, curve: Curves.easeOut);
    loadImage();
    _startAnimationbg();
  }

  Future _startAnimationbg() async {
    try {
      await controllerGate.forward().orCancel;
    } on TickerCanceled {
      print(' animation canceled');
    }
  }

  loadImage() {
    bgGameWin = imgPreCache('bg_chapter1_middle.png');
    bgGameLose = imgPreCache('bg_chapter5.png');
    shinobi2 = AssetImage('assets/images/shinobi_teacher_2.png');
  }

  Image bgGameWin;
  Image bgGameLose;
  AssetImage shinobi2;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameWin.image, context);
    precacheImage(bgGameLose.image, context);
    precacheImage(shinobi2, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _isWin ? win() : lose(),
    );
  }

  text() {
    return _isWin
        ? 'Thành phố Edo đã yên bình trở lại. Đây là cánh cửa không gian - cánh cửa đưa bạn sang hòn đảo tiếp theo.\nChúc mừng bạn đã tốt nghiệp học viện Edo!'
        : 'Nhiệm vụ thất bại...cánh cửa không gian sang hòn đảo tiếp theo đã đóng...bạn chưa thể ra khỏi thành phố này!';
  }

  background() {
    return _isWin
        ? bgGameWin
        : bgGameLose;
  }

  win() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(true);
      },
      child: Stack(
        children: [
          Positioned(
            child: background(),
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: MediaQuery.of(context).size.height * 0.2,
            child: RotationTransition(
                turns: base,
                child: Image(
                  image: AssetImage('assets/images/gate.png'),
                )),
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
                                text(),
                                style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400),
                              ),
                              flex: 2,
                            ),
                            Container(
                              width: 8,
                            )
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
            child: Image(
              image: AssetImage('assets/images/arrow_bottom.png'),
            ),
            bottom: 8,
            right: 8,
            height: 12,
          ),
        ],
      ),
    );
  }

  lose() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Stack(
        children: [
          Positioned(
            child: background(),
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          Positioned(
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
              child: Stack(
                children: [
                  Positioned(
                    child: RotationTransition(
                        turns: base,
                        child: Image(
                          image: AssetImage('assets/images/gate.png'),
                        )),
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                  )
                ],
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
                              flex: 1,
                            ),
                            Expanded(
                              child: Text(
                                text(),
                                style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400),
                              ),
                              flex: 2,
                            ),
                            Container(
                              width: 8,
                            )
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
            child: Image(
              image: shinobi2,
            ),
            bottom: -24,
            left: -24,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Positioned(
            child: Image(
              image: AssetImage('assets/images/arrow_bottom.png'),
            ),
            bottom: 8,
            right: 8,
            height: 12,
          ),
        ],
      ),
    );
  }
}
