import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/network_image.dart';

class Chapter4End extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter4EndState();
}

class Chapter4EndState extends State<Chapter4End> with TickerProviderStateMixin {
  int step = 1;
  Image bgGameWin;
  Image bgGameLose;
  AssetImage ali;
  AssetImage component;
  bool isWin = true;
  Animation<double> _fadeInFadeOut;
  AnimationController _animationbgController;
  bool isCanClick = false;
  bool _visibleItem = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationbgController = AnimationController(vsync: this, duration: Duration(milliseconds: isWin ? 1500 : 3000));
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(_animationbgController);
    loadImage();
    _startAnimationbg();
    Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
      setState(() {
        isCanClick = true;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  loadImage() {
    bgGameLose = imgPreCache('bg_chapter4_3.png');
    bgGameWin = imgPreCache('bg_chapter4.png');
    ali = AssetImage('assets/images/ali_teacher.png');
    component = AssetImage('assets/images/flying_carpet.png');
  }

  Future _startAnimationbg() async {
    try {
      await _animationbgController.forward().orCancel;
      setState(() {
         _visibleItem = true;
      });
    } on TickerCanceled {
      print(' animation canceled');
    }
  }




  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameWin.image, context);
    precacheImage(bgGameLose.image, context);
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

          Navigator.of(context).pop(true);

        },
        child: Stack(
          children: [
            Positioned(
              child: isWin ? bgGameWin : bgGameLose  ,
              top: 0,
              right: 0,
              left: 0,
              bottom:   MediaQuery.of(context).size.height * 0.22  ,
            ),
         isWin ?   Positioned(
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: FadeTransition(
                        child: Image(
                          image: AssetImage('assets/img_result_attack.png'),
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
                            height: 80,
                          )),
                    )
                  ],
                ),
              ),
              top:  MediaQuery.of(context).size.height * 0.01,
              height: 260,
              right: 0,
              left: 0,

            ) :   Positioned(child: Container(decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8)
            ),),   top: 0,
                right: 0,
                left: 0,
                bottom:   MediaQuery.of(context).size.height * 0.2),
            isWin ? Container() : Positioned(child: Chapter4Failed(controller: _animationbgController,endPosition: MediaQuery.of(context).size.height*0.1,startPosition: MediaQuery.of(context).size.height*0.3,heightItem:60 ,),top: 0,right: 0,left: 0,) ,
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
                left: step < 2 ? -32 : -48,
                height: MediaQuery.of(context).size.height * 0.25
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
   return isWin ? 'Chúc mừng con đã tốt nghiệp học viện Isukha!' : 'Không có thảm bay, con đã bị mắc kẹt trong mê cung này!' ;
  }

}


class Chapter4Failed extends StatelessWidget {
  Chapter4Failed(
      {Key key,
        this.controller,
        this.heightItem,
        this.startPosition,
        this.endPosition})
      : opacity = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Interval(
        0.0,
        0.2,
        curve: Curves.easeIn,
      ),
    ),
  ),
        movement = EdgeInsetsTween(
          begin: EdgeInsets.only(top: startPosition, left: 0.0,right: 0),
          end: EdgeInsets.only(top: endPosition, left: 0.0,right: 0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.2,
              0.8,
              curve: Curves.slowMiddle,
            ),
          ),
        ),
        height = Tween<double>(
          begin: 100.0,
          end: heightItem,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.6,
              0.9,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        super(key: key);

  final double startPosition;
  final double endPosition;
  final double heightItem;
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> height;
  final Animation<EdgeInsets> movement;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Container(
          padding: movement.value,
          transform: Matrix4.identity(),
          alignment: Alignment.center,
          child: Opacity(
            opacity: opacity.value,
            child: Container(
              height: height.value,
              child: Image(
                image:  AssetImage('assets/images/flying_carpet.png'),
                fit: BoxFit.fitHeight,
                height:   100  ,
              ),
            ),
          ),
        );
      },
    );
  }
}