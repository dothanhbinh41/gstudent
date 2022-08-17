import 'package:flutter/material.dart';

class Chapter0 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Chapter0State();
}

class Chapter0State extends State<Chapter0> {
  int step = 1;
  AssetImage bgGameStep1;
  AssetImage bgGameStep2;
  AssetImage bgGameStep3;
  AssetImage bgGameStep4;
  AssetImage bgGameStep5;
  AssetImage component1;
  AssetImage book1;

  bool isCanClick = true;

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
    bgGameStep1 = AssetImage('assets/moa1.jpg');
    bgGameStep2 = AssetImage('assets/moa2.jpg');
    bgGameStep3 = AssetImage('assets/moa3.jpg');
    bgGameStep4 = AssetImage('assets/moa4.jpg');
    bgGameStep5 = AssetImage('assets/moa5.jpg');
    book1 = AssetImage('assets/images/book_testinput2.png');
    component1 = AssetImage('assets/images/item_2_chapter1.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGameStep1, context);
    precacheImage(bgGameStep2, context);
    precacheImage(bgGameStep3, context);
    precacheImage(bgGameStep4, context);
    precacheImage(bgGameStep5, context);
    precacheImage(component1, context);
    precacheImage(book1, context);
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

          setState(() {
            isCanClick = false;
          });
          if(step == 6){
            Navigator.of(context).pop(true);
          }
         else{
            Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
              setState(() {
                isCanClick = true;
              });
            });
          }
        },
        child: Stack(
          children: [
            Positioned(
              child: AnimatedOpacity(
                  child: Image(
                    image: bgGameStep1,
                    fit: BoxFit.fill,
                  ),
                  duration: Duration(milliseconds: 1000),
                  opacity: step > 1 && step < 6 ? 0.0 : 1.0),
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
            ),
            Positioned(
              child: AnimatedOpacity(
                  child: Image(
                    image: book1,
                  ),
                  duration: Duration(milliseconds: 1000),
                  opacity: step > 1  ? 0.0 : 1.0),
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
            ),
            Positioned(
              child: AnimatedOpacity(
                  child: Image(
                    image: bgGameStep2,
                    fit: BoxFit.fill,
                  ),
                  duration: Duration(milliseconds: 1000),
                  opacity: step == 2 ? 1.0 : 0.0),
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
            ),
            Positioned(
              child: AnimatedOpacity(
                  child: Image(
                    image: bgGameStep3,
                    fit: BoxFit.fill,
                  ),
                  duration: Duration(milliseconds: 1000),
                  opacity: step == 3 ? 1.0 : 0.0),
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
            ),
            Positioned(
              child: AnimatedOpacity(
                  child: Image(
                    image: bgGameStep4,
                    fit: BoxFit.fill,
                  ),
                  duration: Duration(milliseconds: 1000),
                  opacity: step == 4 ? 1.0 : 0.0),
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
            ),
            Positioned(
              child: AnimatedOpacity(
                  child: Image(
                    image: bgGameStep5,
                    fit: BoxFit.fill,
                  ),
                  duration: Duration(milliseconds: 1000),
                  opacity: step == 5 ? 1.0 : 0.0),
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
                      Center(
                        child: AnimatedOpacity(
                          child: Image(
                            image: AssetImage('assets/img_result_attack.png'),
                            height: 300,
                          ),
                          duration: Duration(milliseconds: 2000),
                          opacity: step == 6 ? 1.0 : 0.0,
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                          child: AnimatedOpacity(
                            child: Image(
                              image: component1,
                              height: 100,
                            ),
                            duration: Duration(milliseconds: 2000),
                            opacity: step == 6 ? 1.0 : 0.0,
                          ))
                    ],
                  ),
                ),
                duration: Duration(milliseconds: 1000),
                opacity: step == 6 ? 1.0: 0.0,
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
                                'Giảng viên Kogi',
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
                                  text(step),
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
              left: -60,
              height:  MediaQuery.of(context).size.height * 0.3
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
        return 'Chào các bạn đến với học viện ECoach - ngôi trường danh giá nhất thế giới với những nhân vật xuất chúng!';
      case 2:
        return 'Để chính thức được gia nhập học viên ECoach, bạn cần phải vượt qua một thử thách nho nhỏ của trường.';
      case 3:
        return 'Bạn đang trên một chuyến tham quan hòn đảo Moa xinh đẹp và yên bình!';
      case 4:
        return 'Hòn đảo nằm dưới đáy đại dương, rất khó khăn trong giao thương với người dân hòn đảo khác.';
      case 5:
        return 'Trong một tháng tới, nâng cao trình độ ngoại ngữ của mình, tìm kiếm những thương nhân để giúp hòn đảo giao thương.';
      default:
        return '';
    }
  }

}
