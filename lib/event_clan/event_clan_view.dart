
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/clan/views/result_event_clan.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/event_clan/calendar_event_view.dart';
import 'package:gstudent/event_clan/ranking_event_view.dart';
import 'package:gstudent/event_clan/rules_event_view.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/home/cubit/home_state.dart';
import 'package:gstudent/main.dart';


enum EventClanView{
  info,result,ranking,rules,calendar
}

class EventDialog extends StatefulWidget {
  // int clanId;
  // int courseId;
  // HomeCubit cubit;
  // EventDialog({this.clanId,this.cubit,this.courseId});

  @override
  State<StatefulWidget> createState() => EventDialogState();
  // State<StatefulWidget> createState() => EventDialogState(clanId: this.clanId,cubit:this.cubit,courseId: this.courseId);
}

class EventDialogState extends State<EventDialog> {
  // int clanId;
  // int courseId;
  // HomeCubit cubit;
  // EventDialogState({this.clanId,this.cubit,this.courseId});

  EventClanView view = EventClanView.calendar;

  @override
  void initState() {
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
                          calender(),
                          result(),
                          ranking(),
                          info(),
                          rules(),

                        ],
                      )
                    ],
                  ))
            ],
          ),
        )
    );
  }



  calender() {
    return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              this.view = EventClanView.calendar;
            });
          },
          child: Column(
            children: [
              Container(
                child: Image(
                  image: AssetImage('assets/images/game_info.png'),
                ),
                height: 60,
              ),
              Container(child:     textpainting(
                  'Lịch thi đấu',
                  12,
                  EventClanView.calendar
              ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color:  this.view == EventClanView.calendar ?Colors.blueAccent : Colors.transparent,
                            width: 2
                        )
                    )
                ),)
            ],
          ),
        ));
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
              Container(child:     textpainting(
                  'Bảng xếp hạng',
                  10,
                  EventClanView.ranking
              ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color:  this.view == EventClanView.ranking ?Colors.blueAccent : Colors.transparent,
                            width: 2
                        )
                    )
                ),)

            ],
          ),
        ));
  }

  arenaClicked() async {
    setState(() {
      view =EventClanView.ranking;
    });
  }

  eventClicked(){
    setState(() {
      this.view = EventClanView.info;
    });
  }


  info() {
    return Expanded(
        child: GestureDetector(
          onTap: ()  => eventClicked(),
          child: Column(
            children: [
              Container(
                child: Image(
                  image: AssetImage('assets/images/icon_file_info.png'),
                ),
                height: 60,
              ),
              Container(child:     textpainting(
                  'Hồ sơ',
                  12,
                  EventClanView.info
              ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color:  this.view == EventClanView.info ?Colors.blueAccent : Colors.transparent,
                            width: 2
                        )
                    )
                ),)

            ],
          ),
        ));
  }

  rules() {
    return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              view = EventClanView.rules;
            });
          },
          child: Column(
            children: [
              Container(
                child: Image(
                  image: AssetImage('assets/images/icon_rules.png'),
                ),
                height: 60,
              ),
              Container(child:     textpainting(
                  'Thể lệ',
                  12,
                  EventClanView.rules
              ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color:  this.view == EventClanView.rules ?Colors.blueAccent : Colors.transparent,
                            width: 2
                        )
                    )
                ),)


            ],
          ),
        ));
  }

  result() {
    return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              view = EventClanView.result;
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
                  'Kết quả',
                  12,
                  EventClanView.result
              ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color:  this.view == EventClanView.result ?Colors.blueAccent : Colors.transparent,
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
      case EventClanView.info:
        return CalendarEventView();
        // return  BlocProvider<HomeCubit>.value(
        //   value: cubit, //
        //   child:   EventClanView(clanId: clanId,cubit: cubit,),
        // );
      case EventClanView.result:
            return ClanResultEventView();
      case EventClanView.ranking :
            return RankingEventView();
      case EventClanView.rules:
        return RulesEventView();
      case EventClanView.calendar:
        return CalendarEventView();
        // return     BlocProvider<HomeCubit>.value(
        //   value: cubit, //
        //   child: CalendarFightView(clanId: clanId,),
        // );

    }
  }

  textpainting(String s, double fontSize, EventClanView v) {
    return textpaintingBoldBase(s, fontSize, this.view == v ?Colors.blueAccent : Colors.white, Colors.black , 3);

  }
}
