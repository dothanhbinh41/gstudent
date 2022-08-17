import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter3End extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter3EndState();
}

class Chapter3EndState extends State<Chapter3End> with TickerProviderStateMixin {
  int step = 1;
  Image bgGameStep1;
  AssetImage viking;
  AssetImage bear_end;
  AssetImage bear2;
  AssetImage gate;

  bool _isWin = true;

  Animation base;
  AnimationController controllerGate;

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

  @override
  void dispose() {
    controllerGate.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  loadImage() {
    bgGameStep1 = imgPreCache('bg_chapter3_1.png');
    bear_end = AssetImage('assets/bear_end.png');
    bear2 = AssetImage('assets/bear2.png');
    viking = AssetImage('assets/images/viking_teacher1.png');
    gate = AssetImage('assets/images/gate.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1.image, context);
    precacheImage(bear_end, context);
    precacheImage(bear2, context);
    precacheImage(viking, context);
    precacheImage(gate, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop(true);
        },
        child: Stack(
          children: [
            Positioned(
              child: bgGameStep1,
              top: 0,
              right: 0,
              left: 0,
              bottom: MediaQuery.of(context).size.height * 0.22,
            ),
            Positioned(
              height: _isWin ? MediaQuery.of(context).size.height * 0.3 : 60,
              child: RotationTransition(
                  turns: base,
                  child: Image(
                    image: AssetImage('assets/images/gate.png'),
                  )),
              top: _isWin ? MediaQuery.of(context).size.height * 0.2 : MediaQuery.of(context).size.height * 0.3,
              right: 0,
              left: 0,
            ),
            Positioned(
                height: 240,
                child: step < 3
                    ? Image(
                        image: _isWin ? bear_end : bear2,
                      )
                    : Container(),
                // child:  step  < 2 ? Container() : Image(image: step == 2 ? human1 : (step ==5 ? human2 : human3),),
                right: 0,
                left: 0,
                bottom: MediaQuery.of(context).size.height * 0.25),
            Positioned(
              child: _isWin
                  ? Container()
                  : Container(
                      color: Colors.black.withOpacity(0.6),
                    ),
              top: 0,
              right: 0,
              left: 0,
              bottom: MediaQuery.of(context).size.height * 0.22,
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
                                  text(),
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
              child: Image(
                image: AssetImage('assets/images/arrow_bottom.png'),
              ),
              bottom: 8,
              right: 8,
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  text() {
    return _isWin ? 'Chúc mừng con đã tốt nghiệp học viện Arcint!' : 'Nhiệm vụ của con đã thất bại, con chưa thể ra khỏi thành phố này!';
  }
}
