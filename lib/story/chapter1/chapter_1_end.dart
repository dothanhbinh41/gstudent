import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter1End extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter1EndState();
}

class Chapter1EndState extends State<Chapter1End> with TickerProviderStateMixin {
  int step = 0;
  bool _visible = false;

  bool _isWin = false;

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
    loadImage();

    controllerGate = AnimationController(vsync: this, duration: Duration(milliseconds: 10000));
    base = CurvedAnimation(parent: controllerGate, curve: Curves.easeOut);
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
    bgGameStep1 = imgPreCache('bg_chapter_1.png');
  }

  Image bgGameStep1;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _isWin ? win() :lose() ,
    );
  }

  text() {
    return _isWin ? 'Chúc mừng con đã tốt nghiệp học viện Athena' : 'Cánh cửa đã đóng, con không thể ra khỏi hòn đảo này.';
  }

  background() {
    return bgGameStep1;
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
              child:RotationTransition(
                  turns: base,
                  child: Image(
                    image: AssetImage('assets/images/gate.png'),
                  )),
              top: MediaQuery.of(context).size.height * 0.15,
              right: 0),
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
            child: Image(
              image: step < 4 ? AssetImage('assets/images/ohara_teacher_2.png') : AssetImage('assets/images/ohara_teacher.png'),
              fit: BoxFit.fitHeight,
            ),
            bottom: 0,
            left: step < 3 ? -40 : -32,
            height: step < 4 ? MediaQuery.of(context).size.height * 0.3 : MediaQuery.of(context).size.height * 0.36,
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
                    top: MediaQuery.of(context).size.height * 0.3,
                    right: MediaQuery.of(context).size.width * 0.2,
                    height: 60,
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
                image: step < 4 ? AssetImage('assets/images/ohara_teacher_2.png') : AssetImage('assets/images/ohara_teacher.png'),
                fit: BoxFit.fill,
              ),flex: 4,),
              Expanded(child: Container(),flex:5,)
            ],),
            bottom: -16,
            right: 0,
            left:  -32  ,
            height:   MediaQuery.of(context).size.height * 0.25,
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
