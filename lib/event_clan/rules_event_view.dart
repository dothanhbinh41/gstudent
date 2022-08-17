

import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_outline.dart';

class RulesEventView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => RulesEventViewState( );
}

class RulesEventViewState extends State<RulesEventView> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
  }

  AssetImage bgDialog;

  loadImage(){
    bgDialog = AssetImage('assets/game_bg_info_clan.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgDialog, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      children: [
        Expanded(child: Stack(
          children: [
            Positioned(
              top: 16,
              bottom: 0,
              right: 16,
              left: 16,
              child: Image(
                image: bgDialog,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 48,
              bottom: 36,
              right: 48,
              left: 48,
              child:    conten()  ,),
            Positioned(
              top: 0,
              right: 24,
              left: 24,
              child: Container(
                child: Stack(
                  children: [
                    Positioned(
                      child: Image(
                        image: AssetImage('assets/images/title_result.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(child: Center(child: textpainting('Thể lệ',24)),
                      top: 0,
                      right: 0,
                      bottom: 8,
                      left: 0,)
                  ],
                ),
              ),
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image(
                  image:
                  AssetImage(
                      'assets/images/game_close_dialog_clan.png'),
                  height: 48,
                  width: 48,
                ),
              ),
              top: 16,
              right: 16,
            ),
          ],
        ))
      ],
    ),backgroundColor: Colors.transparent,resizeToAvoidBottomInset: false,);
  }

  conten(){
    return
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                "THÔNG TIN SỰ KIỆN",
                style: TextStyle(
                    fontSize: 20,
//   color: HexColor("#f5dda7"),
                    color: Colors.white,
                    fontFamily: 'UTMThanChienTranh'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Image(
                image: AssetImage('assets/images/ellipse.png'),
              ),
            ),
            Image(
              image:
              AssetImage(
                  'assets/game_event_example1.png'),
            ),
            Container(margin: EdgeInsets.fromLTRB(0, 8, 0, 8),child: Text(
              'Hình thức thi đấu',
              style: TextStyle(
                  fontFamily:
                  'SourceSerifPro',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 16),
            ),),
            Text(
              '- Số lượng tuyển thủ tham gia : 32\n- Thể thức thi đấu:\n+ Solo Random\n+ 2vs2 Assy\n+ 3vs3 Shang thuần tiễn\n- Cách thức thi đấu: vòng tròn tính điểm\n+ Vòng bảng: chạm 3\n+Vòng bán kết: chạm 4\n+ Vòng chung kết: chạm 5',
              style: TextStyle(
                  fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                  fontSize: 14),
            ),
            Container(margin: EdgeInsets.fromLTRB(0, 8, 0, 8),child: Text(
              'Giải thưởng',
              style: TextStyle(
                  fontFamily:
                  'SourceSerifPro',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 16),
            ),),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Row(children: [
                Image(
                  image:
                  AssetImage(
                      'assets/images/gold.png'),
                  height: 24,
                  width: 24,
                ),
                Expanded(
                  child: Text('Giải nhất: 15.000.000 VNĐ + Cúp vô địch',  style: TextStyle(
                      fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                      fontSize: 14),overflow: TextOverflow.ellipsis,),
                )
              ],),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Row(children: [
                Image(
                  image:
                  AssetImage(
                      'assets/images/silver.png'),
                  height: 24,
                  width: 24,
                ),
                Expanded(child: Text('Giải nhất: 8.000.000 VNĐ + Cúp vô địch',  style: TextStyle(
                    fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                    fontSize: 14),overflow: TextOverflow.ellipsis,))
              ],),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Row(children: [
                Image(
                  image:
                  AssetImage(
                      'assets/images/copper.png'),
                  height: 24,
                  width: 24,
                ),
                Text('Giải nhất: 4.000.000 VNĐ ',  style: TextStyle(
                    fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                    fontSize: 14),)
              ],),
            ),
            Container(margin: EdgeInsets.fromLTRB(0, 8, 0, 8),child: Text(
              'CÁC ĐỘI ĐÃ ĐĂNG KÝ',
              style: TextStyle(
                  fontFamily:
                  'SourceSerifPro',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 16),
            ),),
            Text('Vô Song\nTiếng Anh là số 1\nTôi là Luận',
              style: TextStyle(
                  fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                  fontSize: 14),
            ),
// Container(
//   margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
//   child: Image(
//     image: AssetImage('assets/images/ellipse.png'),
//   ),
// ),

          ],
        ),
      );
  }

  button(){
    return  Container(
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
            height: 56,
            child: Stack(
              children: [
                Positioned(
                  child: Image(
                    image: AssetImage(
                        'assets/images/button_small_green.png'),
                  ),
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Đăng ký",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SourceSerifPro'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  textpainting(String s, double fontSize) {
    return OutlinedText(
      text: Text(s,
          textAlign: TextAlign.justify,
          style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'SourceSerifPro',
              fontWeight: FontWeight.bold,
              color: HexColor("#f8e9a5"))),
      strokes: [
        OutlinedTextStroke(color: HexColor("#681527"), width: 3),
      ],
    );
  }
}

