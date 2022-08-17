
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';
import 'package:gstudent/clan/views/calendar_fight_view.dart';
import 'package:gstudent/clan/views/diary_clan_view.dart';
import 'package:gstudent/clan/views/event_clan_view.dart';
import 'package:gstudent/clan/views/ranking_clan_view.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/home/cubit/home_state.dart';
import 'package:gstudent/main.dart';

enum ClanViewenum{
  ranking,event,diary,calendar
}

class ClanDialog extends StatefulWidget {
  int statusAttack;
  int clanId;
  int courseId;
  int userClanId;
  int generalId;
  bool isGeneral;
  ClanViewenum view;
  List<UserClan> userClan;
  ClanDialog({this.clanId,this.courseId,this.view,this.userClanId,this.statusAttack,this.isGeneral,this.userClan,this.generalId});

  @override
  State<StatefulWidget> createState() => ClanDialogState(generalId:this.generalId,isGeneral:this.isGeneral,clanId: this.clanId,courseId: this.courseId,view: this.view,userClanId: this.userClanId,statusAttack:this.statusAttack,userClan:this.userClan);
}

class ClanDialogState extends State<ClanDialog> {
  int clanId;
  int courseId;
  int userClanId;
  int statusAttack;
  int generalId;
  ClanViewenum view;
  bool isGeneral;
  List<UserClan> userClan;
  ClanDialogState({this.isGeneral,this.clanId,this.courseId,this.view,this.userClanId,this.statusAttack,this.userClan,this.generalId});
  HomeCubit cubit;

  @override
  void initState() {
    cubit = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body:BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is LoadingData) {
       showLoading();
          } else if(state is LoadDataSuccess) {
            hideLoading();
          }else if(state is LoadDataError){
            hideLoading();
            toast(context, 'Something went wrong please contact to center');
          }
        },
        child:  Column(
          children: [
            Expanded(
                child: contentView()),
            Container(
              margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                height: 90,
                child: Stack(
                  children: [
                    Positioned(
                      child: Image(
                        image:
                        AssetImage('assets/images/game_bottom_bar_clan.png'),
                      ),
                      bottom: 0,
                      left: 0,
                      right: 0,
                    ),
                    Row(
                      children: [
                        ranking(),
                        event(),
                        calendar(),
                        diary()
                      ],
                    )
                  ],
                ))
          ],
        ),
      )
    );
  }




  ranking() {
    return Expanded(
        child: GestureDetector(
          onTap: () => arenaClicked(),
          child: Column(
            children: [
              Container(
                child: Image(
                  image: AssetImage('assets/images/game_ranking.png'),
                ),
                height: 60,
              ),
             FittedBox(child:  Container(child:     textpainting(
                 'Bảng xếp hạng',
                 12,
                 ClanViewenum.ranking
             ),
               decoration: BoxDecoration(
                   border: Border(
                       bottom: BorderSide(
                           color:  this.view == ClanViewenum.ranking ?Colors.blueAccent : Colors.transparent,
                           width: 2
                       )
                   )
               ),),)

            ],
          ),
        ));
  }

  arenaClicked() async {
  setState(() {
    view =ClanViewenum.ranking;
  });
  }

  eventClicked(){
    setState(() {
      this.view = ClanViewenum.event;
    });
  }


  event() {
    return Expanded(
        child: GestureDetector(
          onTap: ()  => eventClicked(),
          child: Column(
            children: [
              Container(
                child: Image(
                  image: AssetImage('assets/images/game_event.png'),
                ),
                height: 60,
              ),
              Container(child:     textpainting(
                  'Sự kiện',
                  12,
                  ClanViewenum.event
              ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color:  this.view == ClanViewenum.event ?Colors.blueAccent : Colors.transparent,
                            width: 2
                        )
                    )
                ),)

            ],
          ),
        ));
  }

  calendar() {
    return Expanded(
        child: GestureDetector(
          onTap: () {
          setState(() {
            view = ClanViewenum.calendar;
          });
          },
          child: Column(
            children: [
              Container(
                child: Image(
                  image: AssetImage('assets/images/game_calendar.png'),
                ),
                height: 60,
              ),
             FittedBox(child:  Container(child:     textpainting(
                 'Lịch thi đấu',
                 12,
                 ClanViewenum.calendar
             ),
               decoration: BoxDecoration(
                   border: Border(
                       bottom: BorderSide(
                           color:  this.view == ClanViewenum.calendar ?Colors.blueAccent : Colors.transparent,
                           width: 2
                       )
                   )
               ),),)
            ],
          ),
        ));
  }

  diary() {
    return Expanded(
        child: GestureDetector(
           onTap: () {
             setState(() {
               view = ClanViewenum.diary;
             });
           },
          child: Column(
            children: [
              Container(
                child: Image(
                  image: AssetImage('assets/images/game_diary.png'),
                ),
                height: 60,
              ),
              Container(child:     textpainting(
                  'Nhật ký',
                  12,
                  ClanViewenum.diary
              ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color:  this.view == ClanViewenum.diary ?Colors.blueAccent : Colors.transparent,
                          width: 2
                        )
                    )
                ),)

            ],
          ),
        ));
  }

  contentView() {
    switch(this.view){
      case ClanViewenum.event:
        return  BlocProvider<HomeCubit>.value(
            value: cubit, //
            child:   ClanEventView()
        );
      case ClanViewenum.ranking :
        return   BlocProvider<HomeCubit>.value(
          value: cubit, //
          child:  RankingClanView(clanId: clanId,courseId:courseId,statusAttack:this.statusAttack,isGeneral: this.isGeneral,))  ;
      case ClanViewenum.diary:
        return
          BlocProvider<HomeCubit>.value(
              value: cubit, //
              child:  DiaryClanView(clanId: clanId,) );
      case ClanViewenum.calendar:
        return     BlocProvider<HomeCubit>.value(
          value: cubit, //
          child: CalendarFightView(clanId: clanId,userClanId: this.userClanId,userClan:this.userClan ),
        );

    }
  }

  textpainting(String s, double fontSize, ClanViewenum v) {
    return OutlinedText(
      text: Text(s,
          textAlign: TextAlign.justify,
          style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'SourceSerifPro',
              fontWeight: FontWeight.bold,
              color:   this.view == v ?Colors.blueAccent : Colors.white)),
      strokes: [
        OutlinedTextStroke(color: Colors.black, width: 3),
      ],
    );

}
  }
