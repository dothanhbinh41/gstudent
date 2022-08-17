import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter4Middle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter4MiddleState();
}

class Chapter4MiddleState extends State<Chapter4Middle> with TickerProviderStateMixin {
  int step = 1;
  Image bgGameStep1;
  AssetImage ali;
  AssetImage component;
  bool _visibleItem = false;
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
    bgGameStep1 = imgPreCache('assets/bg_chapter4_3.png');
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

  step2() {
    setState(() {
      isCanClick = false;
    });
    _startAnimationbg();
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
      setState(() {
        _visibleItem = true;
      });
    });
    Future.delayed(Duration(milliseconds: 2000)).whenComplete(() {
      setState(() {
        isCanClick = true;
      });
    });
  }

  step3() {}



  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1.image, context);
    precacheImage(component, context);
    precacheImage(ali, context);
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
            default:
              Navigator.of(context).pop(true);
          }
        },
        child: Stack(
          children: [
            Positioned(
              child:bgGameStep1  ,
              top: 0,
              right: 0,
              left: 0,
              bottom:   MediaQuery.of(context).size.height * 0.22  ,
            ),
            step == 2
                ? Positioned(
              child: Container(
                child: Stack(
                  children: [
                    Center(
                      child: FadeTransition(
                        child: Image(
                          image: AssetImage('assets/img_result_attack.png'),
                          height:  300 ,
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
                            fit: BoxFit.fitHeight,
                            height: _visibleItem ?  100 : 0,
                          )),
                    )
                  ],
                ),
              ),
              top: 0,
              right: 0,
              left: 0,
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
                left:  -32,
                height:   MediaQuery.of(context).size.height * 0.25
            ),

            Positioned(
              child: isCanClick ? Image(
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
        return 'Chỉ 3 ngày nữa, Thảm thần sẽ xuất hiện.';
      default:
        return 'Chỉ có Thảm thần, con mới có thể ra khỏi mê cung này... Hãy ôn luyện thật tốt, chinh phục Thảm thần. Con sắp làm được rồi!';
        }
  }

}
