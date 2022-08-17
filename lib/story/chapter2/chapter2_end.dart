import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter2End extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter2EndState();
}

class Chapter2EndState extends State<Chapter2End> with TickerProviderStateMixin {

  bool isSuccess = true;
  Image bgGameStep1;
  AssetImage human1;
  AssetImage human2;
  AssetImage human3;

  Animation base;
  AnimationController controllerGate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
    controllerGate = AnimationController(vsync: this, duration: Duration(milliseconds: 10000));
    base = CurvedAnimation(parent: controllerGate, curve: Curves.easeOut);
    _startAnimationbg();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controllerGate.dispose();
    super.dispose();
  }

  Future _startAnimationbg() async {
    try {
      await controllerGate.forward().orCancel;
    } on TickerCanceled {
      print(' animation canceled');
    }
  }



  loadImage() {
    bgGameStep1 = imgPreCache('bg_chapter2.png');
    human1 = AssetImage('assets/human_chapter2_1.png');
    human2 = AssetImage('assets/human_chapter2_2.png');
    human3 = AssetImage('assets/human_chapter2_3.png');
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1.image, context);
    precacheImage(human1, context);
    precacheImage(human2, context);
    precacheImage(human3, context);
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
              bottom: 0,
            ),
            Positioned(
              height:  220,
              child:  Image(image: imageByStep()),
              right: 0,
              left: 0,
              bottom: MediaQuery.of(context).size.height * 0.25,
            ),
           Positioned(
              width: isSuccess ?  MediaQuery.of(context).size.width/2:48,
              height: isSuccess ? MediaQuery.of(context).size.width/2:48.0,
              top: isSuccess ? 24 : MediaQuery.of(context).size.height*0.2 ,
              left: isSuccess ? 24 : MediaQuery.of(context).size.width*0.2 ,
              child: Container(
                child:  Center(child:  RotationTransition(
                    turns: base,
                    child: Image(
                      image: AssetImage('assets/images/gate.png'),
                    )),),
              ),
            ) ,
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
                                'Giảng viên Kogi',
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
                  image: AssetImage('assets/images/kogi_2.png'),
                  fit: BoxFit.fill,
                ),flex: 4,),
                Expanded(child: Container(),flex:5,)
              ],),
              bottom: -16,
              right: 0,
              left: -48,
              height: MediaQuery.of(context).size.height * 0.25
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
  return   isSuccess == false? 'Rất tiếc , trưởng trộc đã không qua khỏi, con không thể bước qua cánh cửa không gian để rời khỏi đảo.' : 'Cảm ơn con đã cứu vị trưởng tộc của hòn đảo, và chúc mừng con đã tốt nghiệp học viện Amazonica.';
  }

  AssetImage imageByStep() {
  return   isSuccess ?human3 : human1  ;
  }
}
