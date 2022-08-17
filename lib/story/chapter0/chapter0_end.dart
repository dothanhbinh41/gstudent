import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/TestInput/image.dart';

class Chapter0End extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter0EndState();
}

class Chapter0EndState extends State<Chapter0End> with TickerProviderStateMixin {
  int step = 0;
  bool _isWin = true;
  AssetImage human2;
  AssetImage bgWin;
  AssetImage bgLose;
  AssetImage component1;
  bool showBackground = false;
  bool showComponent = false;
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
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      setState(() {
        showBackground = true;
      });
    });
    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      setState(() {
        showComponent = true;
      });
    });
  }

  Future _startAnimationbg() async {
    try {
      await controllerGate.forward().orCancel;
    } on TickerCanceled {
      print(' animation canceled');
    }
  }

  loadImage() {
    bgLose = AssetImage('assets/moa1.jpg');
    bgWin = AssetImage('assets/moa6.jpg');
    component1 = AssetImage('assets/images/item_2_chapter1.png');
    human2 = AssetImage('assets/human_chapter2_2.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgWin, context);
    precacheImage(human2, context);
    precacheImage(bgLose, context);
    precacheImage(component1, context);
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
        ? 'Chúc mừng bạn đã chính thức được nhận vào học viện ECoach. Cánh cửa không gian này sẽ đưa bạn quay về học viện để cùng bắt đầu hành trình khám phá năng lực không giới hạn của mình.'
        : 'Với điểm ngoại ngữ kém, bạn chưa thực sự đủ thuyết phục học viên ECoach. Học viện sẽ chỉ mở 1 cơ hội cuối cùng - bạn cần phải vượt qua bài kiểm tra năng lực nữa do chính học viện Biên soạn';
  }

  lose() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(true);
      },
      child: Stack(
        children: [
          Positioned(
            child: Image(
              image: bgLose,
              fit: BoxFit.fill,
            ),
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          Positioned(
            child: AnimatedOpacity(
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
                child: Stack(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                        child: AnimatedOpacity(
                          child: Image(
                            image: component1,
                            height: 160,
                          ),
                          duration: Duration(milliseconds: 2000),
                          opacity: showComponent ? 1.0 : 0.0,
                        ))
                  ],
                ),
              ),
              duration: Duration(milliseconds: 1000),
              opacity: showBackground ? 1.0 : 0.0,
            ),
            top: 0,
            right: 0,
            left: 0,
            bottom: MediaQuery.of(context).size.height * 0.2,
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
                              style: TextStyle(
                                  fontFamily: 'SourceSerifPro',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
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
                                style: TextStyle(
                                    fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400),
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
            child: Row(
              children: [
                Expanded(
                  child: Image(
                    image:AssetImage('assets/images/kogi_2.png') ,
                    fit: BoxFit.fill,
                  ),
                  flex: 4,
                ),
                Expanded(
                  child: Container(),
                  flex: 5,
                )
              ],
            ),
            bottom: -16,
            right: 0,
            left: -60,
            height: step < 2
                ? MediaQuery.of(context).size.height * 0.3
                : MediaQuery.of(context).size.height * 0.25,
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

  win() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Stack(
        children: [
          Positioned(
            child: Image(image: bgWin, fit: BoxFit.fill),
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          Positioned(
            child: RotationTransition(
                turns: base,
                child: Image(
                  image: AssetImage('assets/images/gate.png'),
                )),
            top: MediaQuery.of(context).size.height * 0.15,
            right: 0,
            left: 0,
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
                              style: TextStyle(
                                  fontFamily: 'SourceSerifPro',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
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
                                style: TextStyle(
                                    fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400),
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
            child: Row(
              children: [
                Expanded(
                  child: Image(
                    image:AssetImage('assets/images/kogi_2.png'),
                    fit: BoxFit.fill,
                  ),
                  flex: 4,
                ),
                Expanded(
                  child: Container(),
                  flex: 5,
                )
              ],
            ),
            bottom: -16,
            right: 0,
            left: -32,
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
