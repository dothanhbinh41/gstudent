import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class NotificationDialogView extends StatefulWidget {
  String title;
  String message;

  NotificationDialogView({this.message, this.title = 'THÔNG BÁO'});

  @override
  State<StatefulWidget> createState() =>
      NotificationDialogViewState(message: this.message, title: this.title);
}

class NotificationDialogViewState extends State<NotificationDialogView> {
  String title;
  String message;

  NotificationDialogViewState({this.message, this.title});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            child: Image(
              image: AssetImage('assets/bg_notification.png'),
            ),
          ),
          Positioned(
              top: 16,
              bottom: 12,
              right: 28,
              left: 28,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                          color: HexColor("#2e2e2e"),
                          fontWeight: FontWeight.w700,
                          fontFamily: 'SourceSerifPro',
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    child: Image(
                      image: AssetImage('assets/images/eclipse_login.png'),
                      fit: BoxFit.fill,
                    ),
                    margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                            color: HexColor("#fcd19a")),
                        child: Text(message,
                            style: ThemeStyles.styleNormal(font: 14)),
                      ),
                    ),
                  ),
                  Container(
                    child: Image(
                      image: AssetImage('assets/images/ellipse.png'),
                      fit: BoxFit.fill,
                    ),
                    margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Container(
                      height: 48,
                      child: ButtonGraySmall('Đóng',
                          fontSize: 16, textColor: HexColor('#e3effa')),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
