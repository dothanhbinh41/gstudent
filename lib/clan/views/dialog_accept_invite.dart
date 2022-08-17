import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/Arena/calendar.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:intl/intl.dart';

class DialogAcceptInvite extends StatefulWidget {
  CalendarArena clanInvite;
  bool isSend;

  DialogAcceptInvite({this.clanInvite, this.isSend});

  @override
  State<StatefulWidget> createState() => DialogAcceptInviteState(clanInvite: this.clanInvite, isSend: this.isSend);
}

class DialogAcceptInviteState extends State<DialogAcceptInvite> {
  CalendarArena clanInvite;
  bool isSend;

  DialogAcceptInviteState({this.clanInvite, this.isSend});

  DateTime date;
  Duration hour;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 320,
        width: MediaQuery.of(context).size.width * 0.9 > 400 ? 400 : MediaQuery.of(context).size.width * 0.9,
        child: Stack(
          children: [
            Positioned(
              child: Image(
                image: AssetImage('assets/images/bg_dialog_send_invite.png'),
                fit: BoxFit.fill,
              ),
              top: 24,
              right: 0,
              left: 0,
              bottom: 60,
            ),
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image(
                      image: AssetImage('assets/images/icon_title_send_invite.png'),
                      height: 48,
                      width: 48,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Thư thách đấu',
                      style: TextStyle(color: HexColor("#792020"), fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Image(
                      image: AssetImage('assets/images/ellipse.png'),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Gửi đến team :' + clanInvite.toClanName,
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro', fontSize: 12),
                    ),
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                  ),
                  Container(
                    child: Text(
                      'Lời nhắn :' + clanInvite.letter,
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro', fontSize: 12),
                    ),
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                  ),
                  Container(
                    child: Text(
                      'Thời gian thách đấu',
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro', fontSize: 12),
                    ),
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                  ),
                  Container(
                    child: Text(
                      DateFormat('HH:mm  dd-MM-yyyy ').format(clanInvite.dateTimeStart),
                      // clanInvite.dateTimeStartFormat,
                      // clanInvite.dateTimeStart.hour.toString()+':'  +clanInvite.dateTimeStart.minute.toString()+' '+   clanInvite.dateTimeStart.day.toString() +'/' + clanInvite.dateTimeStart.month.toString() + '/'+   clanInvite.dateTimeStart.year.toString(),
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro', fontSize: 12),
                    ),
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                  ),
                  Expanded(
                      child: Center(
                    child: Container(
                      child: Text(
                        'Team ' + clanInvite.fromClanName,
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro', fontSize: 12),
                      ),
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                    ),
                  ))
                ],
              ),
              top: 0,
              right: 16,
              left: 16,
              bottom: 60,
            ),
            Positioned(
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    child:isSend ? ButtonGraySmall(
                      'BỎ QUA',
                      textColor: Colors.white,

                    ) : Container(),
                  )),
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(true);
                          },
                          child: ButtonYellowSmall(isSend ? 'ĐỒNG Ý' :'VÀO ĐẤU', textColor: HexColor("#d5e7d5"), ))),
                ],
              ),
              height: 48,
              right: 0,
              left: 0,
              bottom: 0,
            ),
          ],
        ),
      ),
    );
  }
}
