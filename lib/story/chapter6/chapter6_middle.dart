import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter6Middle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter6MiddleState();
}

class Chapter6MiddleState extends State<Chapter6Middle> with TickerProviderStateMixin {
  int step = 1;
  Image bgGameStep1;
  AssetImage alice;
  AssetImage stone;
  AssetImage thinking_team;
  AssetImage thinking_stone;

  AnimationController controllerMaterial1;
  Animation<double> _fadeInFadeOutMaterial1;
  bool isCanClick = true;
  bool isAnimateMaterial = false;
  Animation base;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controllerMaterial1 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));

    _fadeInFadeOutMaterial1 = Tween<double>(begin: 0.0, end: 1.0).animate(controllerMaterial1);

    loadImage();
  }

  @override
  void dispose() {
    controllerMaterial1.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  loadImage() {
    bgGameStep1 = imgPreCache('bg_chapter6.png');
    stone = AssetImage('assets/images/chapter6_stone.png');
    alice = AssetImage('assets/images/alice.png');
    thinking_team = AssetImage('assets/images/thinking_team.png');
    thinking_stone = AssetImage('assets/images/thinking_stone.png');
  }

  step2() {
    setState(() {
      isCanClick = false;
    });
    try {

      Future.delayed(Duration(milliseconds: 2000)).whenComplete(() => setState(() {
        isCanClick = true;
      }));
    } catch (e) {}
  }

  step3() {
    setState(() {
      isCanClick = false;
    });
    try {
      controllerMaterial1.forward();
      Future.delayed(Duration(milliseconds: 2000)).whenComplete(() => setState(() {
        isCanClick = true;
      }));
    } catch (e) {}
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1.image, context);
    precacheImage(stone, context);
    precacheImage(alice, context);
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
              bottom: MediaQuery.of(context).size.height * 0.1,
            ),
            Positioned(
              child: FadeTransition(
                opacity: _fadeInFadeOutMaterial1,
                child: Image(
                  image: stone,
                ),
              ),
              height: 200,
              top: MediaQuery.of(context).size.height * 0.3,
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
                                'Giảng viên Alice',
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
                                      style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400, fontSize: text(step).length < 150 ? 14 : 12),
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
                    image:alice,
                    fit: BoxFit.fill,
                  ),flex: 4,),
                  Expanded(child: Container(),flex:5,)
                ],),
                bottom: -16,
                right: 0,
                left: -24,
            ),

            Positioned(
              child: step < 3
                  ? AnimatedCrossFade(
                crossFadeState: step == 1 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstCurve: Curves.fastOutSlowIn,
                secondCurve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: step == 1 ? 100 : 1500),
                firstChild: Image(
                  image: thinking_team,
                ),
                secondChild: Image(
                    image: thinking_stone
                ),
              )
                  : Container(),
              left: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.15,
              bottom: MediaQuery.of(context).size.height * 0.26,
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

  String text(int step) {
    switch (step) {
      case 1:
        return 'Chỉ 7 ngày nữa, năng lượng của Ngọc thần sẽ cạn kiệt, thành phố sẽ biến mất...';
      case 2:
        return 'Tiếp tục hoàn thành bài kiểm tra cuối cùng để thu thập đủ đá năng lượng và tốt nghiệp Học viện.';
      case 3:
        return 'Hãy ôn luyện thật tốt, và hoàn thành xuất sắc nhiệm vụ của mình nhé!';
      default:
        return '';
    }
  }
}
