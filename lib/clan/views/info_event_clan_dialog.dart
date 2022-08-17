import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class InfoEventClanDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InfoEventClanDialogState();
}

class InfoEventClanDialogState extends State<InfoEventClanDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body:  Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height-90,
              child: Stack(
                children: [
                  Positioned(
                    child: Image(
                      image: AssetImage(
                          'assets/game_bg_dialog_create_long.png'),
                      fit: BoxFit.fill,
                    ),
                    top: 0,
                    right: 16,
                    left: 16,
                    bottom: 0,
                  ),
                  Positioned(
                    top: 40,
                    right: 64,
                    left: 64,
                    bottom: 40,
                    child: SingleChildScrollView(
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
                            style: ThemeStyles.styleBold(),
                          ),),
                          Text(
                            '- Số lượng tuyển thủ tham gia : 32\n- Thể thức thi đấu:\n+ Solo Random\n+ 2vs2 Assy\n+ 3vs3 Shang thuần tiễn\n- Cách thức thi đấu: vòng tròn tính điểm\n+ Vòng bảng: chạm 3\n+Vòng bán kết: chạm 4\n+ Vòng chung kết: chạm 5',
                            style:ThemeStyles.styleNormal(font: 14),
                          ),
                          Container(margin: EdgeInsets.fromLTRB(0, 8, 0, 8),child: Text(
                            'Giải thưởng',
                            style: ThemeStyles.styleBold(),
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
                                child: Text('Giải nhất: 15.000.000 VNĐ + Cúp vô địch',  style:ThemeStyles.styleNormal(font: 14),overflow: TextOverflow.ellipsis,),
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
                              Expanded(child: Text('Giải nhất: 8.000.000 VNĐ + Cúp vô địch',  style:ThemeStyles.styleNormal(font: 14),overflow: TextOverflow.ellipsis,))
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
                              Text('Giải nhất: 4.000.000 VNĐ ',  style:ThemeStyles.styleNormal(font: 14),)
                            ],),
                          ),
                          Container(margin: EdgeInsets.fromLTRB(0, 8, 0, 8),child: Text(
                            'CÁC ĐỘI ĐÃ ĐĂNG KÝ',
                            style: ThemeStyles.styleBold(),
                          ),),
                          Text('Vô Song\nTiếng Anh là số 1\nTôi là Luận',
                            style: ThemeStyles.styleNormal(font: 14),
                          ),
                          // Container(
                          //   margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          //   child: Image(
                          //     image: AssetImage('assets/images/ellipse.png'),
                          //   ),
                          // ),

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                    height: 48,
                    child: ButtonYellowSmall('ĐĂNG KÝ'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
