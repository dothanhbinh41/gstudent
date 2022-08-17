

import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:intl/intl.dart';

class CalendarEventView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => CalendarFightViewState( );
}

class CalendarFightViewState extends State<CalendarEventView> {


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
                child:    Column(
                  children: [
                    Container(
                      height: 16,
                    ),
                    Expanded(child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            children: [
                              Container(
                                  margin:EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: Text('Ngày '+DateFormat('dd/MM').format(DateTime.now()), style: ThemeStyles.styleNormal())),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return GestureDetector(
                                    onTap: () async {
                                      // var response =   await showDialog(context: context, builder: (context) => DialogAcceptInvite(clanInvite: data[index].clanInvites[i],),);
                                      // if(response == true){
                                      //   var millisInADay = Duration(hours: data[index].clanInvites[i].dateTimeStart.hour,minutes: data[index].clanInvites[i].dateTimeStart.minute).inMilliseconds;
                                      //   var now = DateTime.now();
                                      //   var millisInANow = Duration(hours: now.hour,minutes: now.minute,seconds: now.second).inMilliseconds;
                                      //   int c = (millisInADay - millisInANow)~/1000;
                                      //   if(c > 5){
                                      //     var response = await showDialog(context: context, builder: (context) => WaitForTheMatchView(time:  data[index].clanInvites[i].dateTimeStart,nameClan: clan.name,nameFromClan: data[index].clanInvites[i].fromClanName,),);
                                      //     if( response != null && response == true ){
                                      //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArenaFightingView(arenaId: data[index].clanInvites[i].arenaId,clanId : clan.id),)) ;
                                      //     }
                                      //   }else{
                                      //     toast(context, 'Hết thời gian vào đấu trường');
                                      //   }
                                      // }
                                    },
                                    child: Container(
                                      height: 90,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: HexColor("#b39858"))),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            child: Opacity(
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/game_event_example1.png'),
                                                fit: BoxFit.fitWidth,
                                              ),
                                              opacity: 0.2,
                                            ),
                                            top: 0,
                                            bottom: 0,
                                            right: -8,
                                            left: -8,
                                          ),
                                          Positioned(
                                            child: Column(
                                              children: [
                                                Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(child: Text(
                                                          'pro neva die',
                                                          textAlign: TextAlign.end,
                                                          style: ThemeStyles.styleBold(textColors: Colors.red,font: 18),
                                                        ),flex: 3,),
                                                        Expanded(child: Container(),flex: 1,),
                                                        Expanded(child: Text(
                                                          'pro neva fake',
                                                          style:ThemeStyles.styleBold(textColors: Colors.red,font: 18),
                                                        ),flex: 3,),
                                                      ],
                                                    )),
                                                Expanded(
                                                    child: Text(
                                                      DateFormat('hh:mm  dd-MM-yyyy ').format(DateTime.now()),
                                                      style: ThemeStyles.styleNormal(),
                                                    )),
                                              ],
                                            ),
                                            top: 0,
                                            bottom: 0,
                                            right: 0,
                                            left: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: 1,
                                shrinkWrap: true,
                              ),
                              Visibility(
                                visible: index == 1 ? false : true,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/ellipse.png'),
                                  ),
                                ),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: 1,
                    ))
                  ],
                )  ,),
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
                    Positioned(child: Center(child: textpaintingBoldBase('Lịch thi đấu',24,HexColor("#f8e9a5"),HexColor("#681527"),3)),
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



}