import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';

class InfoMemberClanView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InfoMemberClanViewState();
}

class InfoMemberClanViewState extends State<InfoMemberClanView>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  bool expanded = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      reverseDuration: Duration(milliseconds: 1000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        child: Column(
          children: [
            Expanded(child: Stack(
              children: [
                Positioned(
                  child: Image(
                    image: AssetImage('assets/bg_notification_large.png'),
                    fit: BoxFit.fill,
                  ),
                  top: 0,
                  right: 24,
                  left: 24,
                  bottom: 0,
                ),
                Positioned(
                  top: 24,
                  right: 48,
                  left: 48,
                  bottom: 24,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            "Chi tiết thành viên",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSerifPro'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Image(
                            image:
                            AssetImage('assets/images/eclipse_login.png'),
                            fit: BoxFit.fill,
                          ),
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height / 2.5,
                          child: Image(
                            image: AssetImage(
                                'assets/images/game_character.png'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              color: HexColor("#fcd19a")),
                          child: RichText(
                            text: TextSpan(
                              children: const <TextSpan>[
                                TextSpan(
                                    text: 'Shinobi Cap\n',
                                    style: TextStyle(
                                        fontFamily: 'SourceSerifPro',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 18)),
                                TextSpan(
                                  text: 'Tộc người phố Edo' +
                                      '\n' +
                                      '• Cấp độ :1' +
                                      '\n' +
                                      '• Số MVP : 4' +
                                      '\n' +
                                      '• Phong độ gần đây:\n' +
                                      '10/5 - Thách đấu - UAE - Thắng - 15/20\n' +
                                      '8/5 - Thách đấu - UAE - Thắng - 15/20\n' +
                                      '10/5 - Thách đấu - UAE - Thắng - 15/20\n' +
                                      '8/5 - Thách đấu - UAE - Thắng - 15/20\n' +
                                      '10/5 - Thách đấu - UAE - Thắng - 15/20',
                                  style: TextStyle(
                                      color: Colors.black,
                                    fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                          child: Text(
                            "Đồng ý",
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
            )
          ],
        ),
      ),
    );
  }
}
