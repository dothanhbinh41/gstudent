import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter1State();
}

class Chapter1State extends State<Chapter1> with TickerProviderStateMixin {
  int step = 1;
  bool _visible = false;
  bool _visible2 = false;
  bool _isCanNext = true;

  bool _isShowItem = false;

  Animation<double> _fadeInFadeOut;
  AnimationController _animationbgController;
  Animation<double> _fadeInFadeOut2;
  AnimationController _animationbgController2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
    _animationbgController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(_animationbgController);
    _animationbgController2 = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _fadeInFadeOut2 = Tween<double>(begin: 0.0, end: 1.0).animate(_animationbgController2);
  }

  Future _startAnimationbg() async {
    try {
      await _animationbgController.forward().orCancel;
    } on TickerCanceled {
      print(' animation canceled');
    }
  }

  Future _startAnimationbg2() async {
    try {
      await _animationbgController2.forward().orCancel;
    } on TickerCanceled {
      print(' animation canceled');
    }
  }

  step1() {
    setState(() {
      _isCanNext = true;
    });
    // Future.delayed(Duration(milliseconds: 2000)).whenComplete(() => step2());
  }

  step2() {
    setState(() {
    });
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
      setState(() {
        _visible = true;
      });
    });
    Future.delayed(Duration(milliseconds: 2500)).whenComplete(() {
      setState(() {
        _isShowItem = true;
        _isCanNext = true;
      });
      _startAnimationbg();
    });
    // Future.delayed(Duration(milliseconds: 2000)).whenComplete(() => step3());
  }

  step3() {
    setState(() {
      _isCanNext = false;
    });
     Future.delayed(Duration(milliseconds: 500)).whenComplete(() => _startAnimationbg2());
     Future.delayed(Duration(milliseconds: 1000)).whenComplete(() =>  setState(() {
       _visible2 = true;
     }));

    Future.delayed(Duration(milliseconds: 2000)).whenComplete(() =>  setState(() {
      _isCanNext = true;
    }));
  }

  loadImage() {
    bgGameStep1 = imgPreCache('bg_chapter_1.png');
    bgGameStep2 = imgPreCache('bg_chapter_1_step2.png');
    walkthrough_chapter1 = AssetImage('assets/walkthrough_chapter1.png');
  }

  Image bgGameStep1;
  Image bgGameStep2;
  AssetImage walkthrough_chapter1;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1.image, context);
    precacheImage(bgGameStep2.image, context);
    precacheImage(walkthrough_chapter1, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          if (_isCanNext == false) {
            return;
          }
          setState(() {
            step++;
            _isCanNext = false;
          });
          switch (step) {
            case 1:
              step1();
              return;
            case 2:
              step2();
              return;
            case 3:
              step3();
              return;
            case 4:
              setState(() {
                _isCanNext = true;
              });
              return;
            default:
              Navigator.of(context).pop(true);
              return;
          }
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
            step > 2
                ? Positioned(
                    child: AnimatedOpacity(
                      // If the widget is visible, animate to 0.0 (invisible).
                      // If the widget is hidden, animate to 1.0 (fully visible).
                      opacity: _visible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 1000),
                      // The green box must be a child of the AnimatedOpacity widget.
                      child: Image(
                        image: walkthrough_chapter1,
                      ),
                    ),
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: MediaQuery.of(context).size.height * 0.25,
                  )
                : Container(),
            step == 3 && _isShowItem == true
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
                                opacity: _visible ? 1.0 : 0.0,
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
                : Container(),
            step == 4
                ? Positioned(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.9)),
                      child: Stack(
                        children: [
                          Center(
                            child: FadeTransition(
                              child: Image(
                                image: AssetImage('assets/img_result_attack.png'),
                              ),
                              opacity: _fadeInFadeOut2,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: AnimatedOpacity(
                                // If the widget is visible, animate to 0.0 (invisible).
                                // If the widget is hidden, animate to 1.0 (fully visible).
                                opacity: _visible2 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 1500),
                                // The green box must be a child of the AnimatedOpacity widget.
                                child: Image(
                                  image: AssetImage('assets/images/item1_chapter1_large.png'),
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
                                  text(step),
                                  style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400),
                                ),
                                flex: 2,
                              ),
                              step == 2
                                  ? Container(
                                      width: 60,
                                    )
                                  : Container()
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
                image: step < 2 ? AssetImage('assets/images/ohara_teacher.png') : AssetImage('assets/images/ohara_teacher_2.png'),
                fit: BoxFit.fill,
              ),flex: 4,),
                Expanded(child: Container(),flex:5,)
              ],),
              bottom: -16,
              right: 0,
              left: -32  ,
              height:   MediaQuery.of(context).size.height * 0.25,
            ),
            Positioned(
              child: _isCanNext ? Image(
                image: AssetImage('assets/images/arrow_bottom.png'),
              ) : Container(),
              bottom: 8,
              right: 8,
              height: 12,
            ),
            step == 2
                ? Positioned(
                    child: Image(
                      image: AssetImage('assets/images/item1_chapter_1.png'),
                    ),
                    bottom: 40,
                    right: 0,
                    height: MediaQuery.of(context).size.height * 0.25,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  text(int step) {
    switch (step) {
      case 1:
        return 'Chào mừng đến với Athena- nơi được mệnh danh là đảo thông thái.';
      case 2:
        return 'Từ ngàn ngày xưa, Đảo thông thái lưu trữ trí tuệ của nhân loại. Tất cả được đúc kết trong những bộ sách cổ';
      case 3:
        return 'Bạn khao khát được trở nên giỏi hơn chứ? Hãy lần theo bản đồ, thu tập tri thức.';
      case 4:
        return 'Để chứng minh bạn đủ năng lực và vượt qua bài kiểm tra của mình.';
      default:
        return 'Hẹn bạn 3 tháng nữa, để xem những thành tích và vật phẩm bạn thu thập được.\nBạn sẵn sàng cho cuộc thám hiểm này rồi chứ?';
    }
  }

  background() {
    return  step < 3 ? bgGameStep1 : bgGameStep2;
  }
}
