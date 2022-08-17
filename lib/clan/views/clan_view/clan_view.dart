import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';
import 'package:gstudent/api/dtos/Clan/info_user_clan.dart';
import 'package:gstudent/character/model/UserCharacter.dart';
import 'package:gstudent/clan/views/clan_view.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/hp_progress_bar.dart';
import 'package:gstudent/common/controls/mp_progress_bar.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/define_item/avatar_character.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/home/cubit/home_state.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';

enum enumClanView { info, ranking, event, diary, calendar }

class ClanView extends StatefulWidget {
  int clanId;
  int courseId;
  int userClanId;
  String imageHero;
  String slugMission;

  ClanView({this.clanId, this.courseId, this.userClanId, this.slugMission,this.imageHero});

  @override
  State<StatefulWidget> createState() => ClanViewState(slugMission: this.slugMission, courseId: this.courseId, clanId: this.clanId, userClanId: this.userClanId);
}

class ClanViewState extends State<ClanView> {
  int courseId;
  int clanId;
  int userClanId;
  String slugMission;

  ClanViewState({this.courseId, this.clanId, this.userClanId, this.slugMission});

  enumClanView view;
  HomeCubit cubit;
  ClanDetail clan;
  ApplicationSettings setting;

  int position = 0;
  int idUser;
  String nameChar;
  bool changeStatus = false;
  PageController controller;
  UserClanInfo userClanInfo;
  int level;
  int exp;
  UserCharacter currentCharacter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<HomeCubit>(context);
    setting = GetIt.instance.get<ApplicationSettings>();

    loadImage();
    loadData();
  }

  loadCharInfo() async {
    showLoading();
    UserCharacter c = await setting.getCurrentCharacterUser();
    setState(() {
      currentCharacter = c;
    });
    var res = await cubit.getInfoUser(userClanId);
    hideLoading();
    if (res != null) {
      setState(() {
        userClanInfo = res;
        level = userClanInfo.exp ~/ 500;
        exp = userClanInfo.exp;
        print(exp);
      });
    }

    if (slugMission != null) {
      doMission();
    }
  }

  doMission() {
    switch (slugMission) {
      case "guild_daily_quest":
        showDialogClan(ClanViewenum.ranking);
        return;
      // case "win_arena_2_times":
      //   showDialogClan(ClanViewenum.calendar);
      //   return;
      // case "win_arena_5_times":
      //   showDialogClan(ClanViewenum.calendar);
      //   return;
      // case "win_arena_10_times":
      //   showDialogClan(ClanViewenum.calendar);
      //   return;
      // case "win_arena_10_times_continues":
      //   showDialogClan(ClanViewenum.calendar);
      //   return;
      case "join_arena":
        showDialogClan(ClanViewenum.calendar);
        return;
      case "win_1_giai_dau":
        showDialogClan(ClanViewenum.event);
        return;
      case "top_50_ranking":
        showDialogClan(ClanViewenum.ranking);
        return;
      case "top_30_ranking":
        showDialogClan(ClanViewenum.ranking);
        return;
      case "top_10_ranking":
        showDialogClan(ClanViewenum.ranking);
        return;
      case "gui_loi_moi_thach_dau":
        showDialogClan(ClanViewenum.ranking);
        return;
    }
  }

  loadData() async {
    showLoading();
    var res = await cubit.getDetailCLan(clanId);
    var u = await setting.getCurrentUser();
    hideLoading();
    if (res != null) {
      if (mounted) {
        setState(() {
          clan = res;
          idUser = u.userInfo.id;
          position = clan.userClans.indexWhere((element) => element.studentId == idUser);
        });
      }
      controller = PageController(
        initialPage: position,
        keepPage: false,
        viewportFraction: 0.9,
      );
    } else {
      toast(context, 'Xin hãy chờ để giảng viên duyệt clan');
    }
    loadCharInfo();
  }

  AssetImage bgDialog;

  loadImage() {
    // bgDialog = AssetImage('assets/game_bg_dialog_create_long.png');
    bgDialog = AssetImage('assets/bg_create_character.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgDialog, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: content());
  }

  content() {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {},
      child: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              Positioned(
                child: Image(
                  image: bgDialog,
                  fit: BoxFit.fill,
                ),
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
              ),
              Positioned(
                child: Column(
                  children: [
                    Expanded(
                      child: SafeArea(
                        bottom: false,
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              child: Stack(
                                children: [
                                  Positioned(
                                      child: Container(
                                        child: Stack(
                                          children: [
                                            Positioned(
                                                child: Image(
                                                  image: AssetImage('assets/images/title_result.png'),
                                                  fit: BoxFit.fill,
                                                ),
                                                top: 0,
                                                bottom: 0,
                                                left: 0,
                                                right: 0),
                                            Positioned(
                                              child: clan != null
                                                  ? Center(
                                                      child: textpaintingBoldBase(
                                                          'Team ' + clan.name, clan.name.length > 20 ? 16 : (clan.name.length > 15 ? 18 : 20), HexColor("#f8e9a5"), HexColor("#681527"), 3,
                                                          textAlign: TextAlign.center))
                                                  : Container(),
                                              top: 0,
                                              right: 68,
                                              bottom: 16,
                                              left: 68,
                                            )
                                          ],
                                        ),
                                      ),
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      right: 0),
                                  Positioned(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Image(
                                        image: AssetImage('assets/images/game_button_back.png'),
                                      ),
                                    ),
                                    top: 0,
                                    left: 8,
                                    height: 48,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Stack(
                                    children: [
                                      Positioned(
                                        child: Image(
                                          image: AssetImage('assets/images/horn_win_lose.png'),
                                          height: 40,
                                          width: 40,
                                        ),
                                        bottom: 16,
                                        right: 0,
                                        left: 0,
                                        top: 0,
                                      ),
                                      Positioned(
                                        child: Center(
                                            child: Text(clan != null ? clan.rank.toString() : '0', style: TextStyle(color: Colors.white, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700))),
                                        bottom: 36,
                                        right: 0,
                                        left: 8,
                                        top: 20,
                                      ),
                                      Positioned(
                                        child: Text(
                                          'Rank',
                                          style: TextStyle(color: Colors.white, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700),
                                          textAlign: TextAlign.center,
                                        ),
                                        bottom: 0,
                                        right: 0,
                                        left: 8,
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        AnimatedPositioned(
                                          child: AnimatedOpacity(
                                            opacity: changeStatus ? 1.0 : 0.0,
                                            duration: Duration(milliseconds: 200),
                                            child: GestureDetector(
                                              onTap: () => changeCurrentStatus(),
                                              child: Image(
                                                image: clan != null && clan.attackStatus == 1 ? AssetImage('assets/images/icon_status_shield.png') : AssetImage('assets/images/swords_icon.png'),
                                              ),
                                            ),
                                          ),
                                          bottom: 16,
                                          right: changeStatus ? 0 : 60,
                                          width: 40,
                                          duration: Duration(milliseconds: 1000),
                                          top: 0,
                                        ),
                                        AnimatedPositioned(
                                          child: Center(
                                            child: Image(
                                              image: AssetImage('assets/images/bg_status.png'),
                                            ),
                                          ),
                                          bottom: 16,
                                          right: changeStatus ? 20 : 0,
                                          left: 0,
                                          top: 0,
                                          duration: Duration(milliseconds: 400),
                                        ),
                                        AnimatedPositioned(
                                          child: clan != null
                                              ? GestureDetector(
                                                  onTap: () {
                                                    if (clan.generalId == idUser) {
                                                      setState(() {
                                                        changeStatus = !changeStatus;
                                                      });
                                                    } else {
                                                      toast(context, 'Bạn không phải Chủ tướng');
                                                      return;
                                                    }
                                                  },
                                                  child: Center(
                                                    child: Image(
                                                      height: 40,
                                                      width: 40,
                                                      image: clan.attackStatus == 1 ? AssetImage('assets/images/swords_icon.png') : AssetImage('assets/images/icon_status_shield.png'),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          bottom: 36,
                                          right: changeStatus ? 20 : 0,
                                          left: 0,
                                          top: 20,
                                          duration: Duration(milliseconds: 400),
                                        ),
                                        AnimatedPositioned(
                                          child: Text(
                                            clan != null && clan.attackStatus == 1 ? 'Chiến đấu' : 'Phòng thủ',
                                            style: TextStyle(color: Colors.white, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700),
                                            textAlign: TextAlign.center,
                                          ),
                                          bottom: 0,
                                          right: changeStatus ? 20 : 0,
                                          left: 0,
                                          duration: Duration(milliseconds: 400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Stack(
                                    children: [
                                      Positioned(
                                        child: Image(
                                          image: AssetImage('assets/images/horn_rank.png'),
                                          height: 40,
                                          width: 40,
                                        ),
                                        bottom: 16,
                                        right: 0,
                                        left: 0,
                                        top: 0,
                                      ),
                                      Positioned(
                                        child: Center(
                                            child: Text(clan != null ? clan.win.toString() : '0', style: TextStyle(color: Colors.white, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700))),
                                        bottom: 36,
                                        right: 8,
                                        left: 0,
                                        top: 20,
                                      ),
                                      Positioned(
                                        child: Text(
                                          'Win',
                                          style: TextStyle(color: Colors.white, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700),
                                          textAlign: TextAlign.center,
                                        ),
                                        bottom: 0,
                                        right: 8,
                                        left: 0,
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          clan != null && clan.generalId == idUser
                                              ? Container(
                                                  child: Image(
                                                    image: AssetImage('assets/images/icon_general.png'),
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                  margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                                                )
                                              : Container(),
                                          clan != null
                                              ? textpaintingBase(clan.userClans.where((element) => element.studentId == idUser).first.nickname, 14, Colors.white, Colors.black, 3)
                                              : Container()
                                        ],
                                      ),
                                      Container(
                                        child: Text(userClanInfo != null ? 'HP : ' + userClanInfo.hp.toString() + '/' + currentCharacter.totalHp.toString() : 'HP : 100/100',
                                            style: TextStyle(fontSize: 10, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, color: Colors.white)),
                                      ),
                                      hpbar(),
                                      Container(
                                        child: Text(userClanInfo != null && userClanInfo.level != null ? 'Level : ' + userClanInfo.level.toString() : 'Level : 0',
                                            style: TextStyle(fontSize: 10, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, color: Colors.white)),
                                      ),
                                      mpbar(),
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  )),
                                  GestureDetector(
                                    onTap: () {
                                      showGeneralDialog(
                                        barrierLabel: "Label",
                                        barrierDismissible: true,
                                        barrierColor: Colors.black.withOpacity(0.5),
                                        transitionDuration: Duration(milliseconds: 300),
                                        context: context,
                                        pageBuilder: (context, anim1, anim2) {
                                          return Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              child: ListView.builder(
                                                itemBuilder: (context, index) {
                                                  return index == 0
                                                      ? Container(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Text('Ngày', style: TextStyle(fontSize: 12, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400, color: Colors.black87)),
                                                                  flex: 3),
                                                              Expanded(
                                                                child: Text('Team', style: TextStyle(fontSize: 12, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400, color: Colors.black87)),
                                                                flex: 5,
                                                              ),
                                                              Expanded(
                                                                  child:
                                                                      Text('Kết Quả', style: TextStyle(fontSize: 12, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400, color: Colors.black87)),
                                                                  flex: 3),
                                                              Expanded(
                                                                  child: Text('Thành Tích',
                                                                      style: TextStyle(fontSize: 12, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400, color: Colors.black87)),
                                                                  flex: 3),
                                                            ],
                                                          ),
                                                          decoration: BoxDecoration(border: Border.all(color: Colors.black87, width: 1), color: HexColor("#D8C0A0").withOpacity(0.85)),
                                                          padding: EdgeInsets.all(8),
                                                        )
                                                      : Container(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Text('10/5/2021',
                                                                      style: TextStyle(fontSize: 12, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400, color: Colors.black87)),
                                                                  flex: 3),
                                                              Expanded(
                                                                child: Text('Đấu vương tiếng anh',
                                                                    style: TextStyle(fontSize: 10, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400, color: Colors.black87)),
                                                                flex: 5,
                                                              ),
                                                              Expanded(
                                                                  child: Image(
                                                                    image: AssetImage('assets/images/game_fight_icon.png'),
                                                                    height: 24,
                                                                    width: 24,
                                                                  ),
                                                                  flex: 3),
                                                              Expanded(
                                                                  child:
                                                                      Text('15/20', style: TextStyle(fontSize: 12, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400, color: Colors.black87)),
                                                                  flex: 3),
                                                            ],
                                                          ),
                                                          decoration: BoxDecoration(border: Border.all(color: Colors.black87, width: 1), color: HexColor("#D8C0A0").withOpacity(0.85)),
                                                          padding: EdgeInsets.all(8),
                                                        );
                                                },
                                                shrinkWrap: true,
                                                itemCount: 1,
                                              ),
                                              margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                                            ),
                                          );
                                        },
                                        transitionBuilder: (context, anim1, anim2, child) {
                                          return SlideTransition(
                                            position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
                                            child: child,
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          'Thông tin thêm',
                                          style: TextStyle(color: Colors.white, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, fontSize: 12),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      padding: EdgeInsets.all(8),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Container(
                                  child: character(),
                                  height: MediaQuery.of(context).size.height * 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 90,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Image(
                              image: AssetImage('assets/images/game_bottom_bar_clan.png'),
                              fit: BoxFit.fill,
                            ),
                            bottom: 0,
                            left: 0,
                            right: 0,
                            top: 0,
                          ),
                          Positioned(
                              child: Row(
                            children: [ranking(context), event(), calendar(), diary()],
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
              )
            ],
          ))
        ],
      ),
    );
  }

  ranking(context) {
    print(MediaQuery.of(context).size.width / 4);
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
         FittedBox(child:  Container(
           child: textpaintingBoldBase('Bảng xếp hạng', 12, this.view == enumClanView.ranking ? Colors.blueAccent : Colors.white, Colors.black, 3),
           decoration: BoxDecoration(border: Border(bottom: BorderSide(color: this.view == enumClanView.ranking ? Colors.blueAccent : Colors.transparent, width: 2))),
         ),)
        ],
      ),
    ));
  }

  arenaClicked() async {
    setState(() {
      view = enumClanView.ranking;
    });
    await showDialogClan(ClanViewenum.ranking);
  }

  eventClicked() async {
    setState(() {
      this.view = enumClanView.event;
    });
    await showDialogClan(ClanViewenum.event);
  }

  Future showDialogClan(ClanViewenum v) async {
    if (clan == null) {
      return;
    }
    var result = await showDialog(
        context: context,
        useSafeArea: false,
        builder: (BuildContext context) {
          return BlocProvider<HomeCubit>.value(
            value: cubit,
            child: SafeArea(
              bottom: false,
              child: ClanDialog(
                isGeneral: clan.generalId == idUser,
                statusAttack: clan.attackStatus,
                clanId: clanId,
                courseId: courseId,
                view: v,
                userClanId: this.userClanId,
                userClan: clan.userClans,
              ),
            ),
          );
        });
    setState(() {
      this.view = enumClanView.info;
    });
  }

  event() {
    return Expanded(
        child: GestureDetector(
      onTap: () => eventClicked(),
      child: Column(
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/game_event.png'),
            ),
            height: 60,
          ),
          Container(
            child: textpaintingBoldBase('Sự kiện', 12, this.view == enumClanView.event ? Colors.blueAccent : Colors.white, Colors.black, 3),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: this.view == enumClanView.event ? Colors.blueAccent : Colors.transparent, width: 2))),
          )
        ],
      ),
    ));
  }

  calendar() {
    return Expanded(
        child: GestureDetector(
      onTap: () async {
        setState(() {
          view = enumClanView.calendar;
        });
        await showDialogClan(ClanViewenum.calendar);
      },
      child: Column(
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/game_calendar.png'),
            ),
            height: 60,
          ),
          FittedBox(
            child: Container(
              child: textpaintingBoldBase('Lịch thi đấu', 12, this.view == enumClanView.calendar ? Colors.blueAccent : Colors.white, Colors.black, 3),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: this.view == enumClanView.calendar ? Colors.blueAccent : Colors.transparent, width: 2))),
            ),
          )
        ],
      ),
    ));
  }

  diary() {
    return Expanded(
        child: GestureDetector(
      onTap: () async {
        setState(() {
          view = enumClanView.diary;
        });
        await showDialogClan(ClanViewenum.diary);
      },
      child: Column(
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/game_diary.png'),
            ),
            height: 60,
          ),
          Container(
            child: textpaintingBoldBase('Nhật ký', 12, this.view == enumClanView.diary ? Colors.blueAccent : Colors.white, Colors.black, 3),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: this.view == enumClanView.diary ? Colors.blueAccent : Colors.transparent, width: 2))),
          )
        ],
      ),
    ));
  }

  builder(int index) {
    return Container(
      child: Image(
        image: AssetImage(loadCharacterById(clan.userClans.where((element) => element.characterId != null).toList()[index].characterId)),
        fit: BoxFit.fitHeight,
      ),
    );
  }

  buttonleft() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (position == 0) {
            position = clan.userClans.where((element) => element.characterId != null).toList().length - 1;
          } else {
            position--;
          }
          controller.animateToPage(position, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        });
      },
      child: Container(
        alignment: Alignment.centerLeft,
        child: Visibility(
          visible: position != 0,
          child: Image(
            image: AssetImage('assets/images/game_select_character_left.png'),
            height: 40,
          ),
        ),
      ),
    );
  }

  buttonRight() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (position == clan.userClans.where((element) => element.characterId != null).toList().length - 1) {
            position = 0;
          } else {
            position++;
          }
          controller.animateToPage(position, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        });
      },
      child: Container(
        alignment: Alignment.centerRight,
        child: Visibility(
          visible: position != clan.userClans.where((element) => element.characterId != null).toList().length - 1,
          child: Image(
            image: AssetImage('assets/images/game_select_character_right.png'),
            height: 40,
          ),
        ),
      ),
    );
  }

  hpbar() {
    return Container(
        height: 10,
        width: MediaQuery.of(context).size.width * 0.3,
        child: Stack(
          children: [
            Positioned(
              child: Image(
                image: AssetImage('assets/images/hp_bar.png'),
                fit: BoxFit.fill,
              ),
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
            ),
            Positioned(
                child: HPProgressBar(
                  direction: Axis.horizontal,
                  currentValue: userClanInfo != null ? ((userClanInfo.hp / currentCharacter.totalHp) * 100).toInt() : 1,
                  size: 12,
                ),
                top: 2,
                bottom: 2,
                right: 4,
                left: 2.5),
          ],
        ));
  }

  mpbar() {
    return Container(
        height: 8,
        width: MediaQuery.of(context).size.width * 0.25,
        child: Stack(
          children: [
            Positioned(
              child: Image(
                image: AssetImage('assets/images/mp_bar.png'),
                fit: BoxFit.fill,
              ),
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
            ),
            Positioned(
                child: MPProgressBar(
                  direction: Axis.horizontal,
                  currentValue: userClanInfo != null ? userClanInfo.exp : 1,
                  maxValue: userClanInfo != null ? userClanInfo.nextLevel.nextExp : 1,
                ),
                top: 1.5,
                bottom: 1.5,
                right: 4,
                left: 2),
          ],
        ));
  }

  character() {
    return Stack(
      children: [
        Positioned(
          child: Container(
            child: Stack(
              children: [
                Positioned(
                  child: Image(
                    image: AssetImage('assets/game_bg_create_character.png'),
                    fit: BoxFit.fitHeight,
                  ),
                  top: 80,
                  bottom: 0,
                  right: 0,
                  left: 0,
                ),
                Positioned(
                  child: clan != null
                      ? Container(
                          child: PageView.builder(
                            onPageChanged: (value) {
                              setState(() {
                                position = value;
                              });
                            },
                            controller: controller,
                            itemBuilder: (context, index) => builder(index),
                            itemCount: clan.userClans.where((element) => element.characterId != null).toList().length,
                          ),
                        )
                      : Hero(
                    tag: 'character',
                    child: Container(
                      child: Image(
                        image: AssetImage(widget.imageHero),
                        fit: BoxFit.fitHeight,
                      ),
                    ),),
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 24,
                ),
                Positioned(
                  child: clan != null ? buttonleft() : Container(),
                  top: 0,
                  left: 24,
                  bottom: 0,
                ),
                Positioned(
                  child: clan != null ? buttonRight() : Container(),
                  top: 0,
                  right: 24,
                  bottom: 0,
                ),
              ],
            ),
          ),
          top: 0,
          right: 0,
          bottom: 50,
          left: 0,
        ),
        Positioned(
          child: clan != null
              ? Container(
                  height: 100,
                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () => clickPositionMember(1, 2),
                          child: itemUser(
                              'assets/images/game_fight_icon.png',
                              (clan != null &&
                                  clan.userClans.where((element) => element.characterId == 1 || element.characterId == 2).isNotEmpty &&
                                  clan.userClans.where((element) => element.characterId == 1 || element.characterId == 2).first.studentId == clan.generalId),
                              clan != null && clan.userClans.where((element) => element.characterId == 1 || element.characterId == 2).isEmpty,
                              clan != null && clan.userClans.where((element) => element.characterId == 1 || element.characterId == 2).isNotEmpty
                                  ? clan.userClans.where((element) => element.characterId == 1 || element.characterId == 2).first.nickname
                                  : '',
                              clan.userClans.where((element) => element.characterId == 1 || element.characterId == 2).isNotEmpty
                                  ? clan.userClans.indexOf(clan.userClans.where((element) => element.characterId == 1 || element.characterId == 2).first)
                                  : null),
                        ),
                        GestureDetector(
                          onTap: () => clickPositionMember(5, 6),
                          child: itemUser(
                              'assets/images/icon_steal.png',
                              (clan != null &&
                                  clan.userClans.where((element) => element.characterId == 5 || element.characterId == 6).isNotEmpty &&
                                  clan.userClans.where((element) => element.characterId == 5 || element.characterId == 6).first.studentId == clan.generalId),
                              clan != null && clan.userClans.where((element) => element.characterId == 5 || element.characterId == 6).isEmpty,
                              clan != null && clan.userClans.where((element) => element.characterId == 5 || element.characterId == 6).isNotEmpty
                                  ? clan.userClans.where((element) => element.characterId == 5 || element.characterId == 6).first.nickname
                                  : '',
                              clan.userClans.where((element) => element.characterId == 5 || element.characterId == 6).isNotEmpty
                                  ? clan.userClans.indexOf(clan.userClans.where((element) => element.characterId == 5 || element.characterId == 6).first)
                                  : null),
                        ),
                        GestureDetector(
                            onTap: () => clickPositionMember(7, 8),
                            child: itemUser(
                                'assets/images/icon_forge.png',
                                (clan != null &&
                                    clan.userClans.where((element) => element.characterId == 7 || element.characterId == 8).isNotEmpty &&
                                    clan.userClans.where((element) => element.characterId == 7 || element.characterId == 8).first.studentId == clan.generalId),
                                clan != null && clan.userClans.where((element) => element.characterId == 7 || element.characterId == 8).isEmpty,
                                clan != null && clan.userClans.where((element) => element.characterId == 7 || element.characterId == 8).isNotEmpty
                                    ? clan.userClans.where((element) => element.characterId == 7 || element.characterId == 8).first.nickname
                                    : '',
                                clan.userClans.where((element) => element.characterId == 7 || element.characterId == 8).isNotEmpty
                                    ? clan.userClans.indexOf(clan.userClans.where((element) => element.characterId == 7 || element.characterId == 8).first)
                                    : null)),
                        GestureDetector(
                            onTap: () => clickPositionMember(9, 9),
                            child: itemUser(
                                'assets/images/icon_encourage.png',
                                (clan != null &&
                                    clan.userClans.where((element) => element.characterId == 9).isNotEmpty &&
                                    clan.userClans.where((element) => element.characterId == 9).first.studentId == clan.generalId),
                                clan != null && clan.userClans.where((element) => element.characterId == 9).isEmpty,
                                clan != null && clan.userClans.where((element) => element.characterId == 9).isNotEmpty
                                    ? clan.userClans.where((element) => element.characterId == 9).first.nickname
                                    : '',
                                clan.userClans.where((element) => element.characterId == 9).isNotEmpty
                                    ? clan.userClans.indexOf(clan.userClans.where((element) => element.characterId == 9).first)
                                    : null)),
                        GestureDetector(
                            onTap: () => clickPositionMember(11, 12),
                            child: itemUser(
                                'assets/images/icon_defend.png',
                                (clan != null &&
                                    clan.userClans.where((element) => element.characterId == 11 || element.characterId == 12).isNotEmpty &&
                                    clan.userClans.where((element) => element.characterId == 11 || element.characterId == 12).first.studentId == clan.generalId),
                                clan != null && clan.userClans.where((element) => element.characterId == 11 || element.characterId == 12).isEmpty,
                                (clan != null && clan.userClans.where((element) => element.characterId == 11 || element.characterId == 12).isNotEmpty)
                                    ? clan.userClans.where((element) => element.characterId == 11 || element.characterId == 12).first.nickname
                                    : '',
                                clan.userClans.where((element) => element.characterId == 11 || element.characterId == 12).isNotEmpty
                                    ? clan.userClans.indexOf(clan.userClans.where((element) => element.characterId == 11 || element.characterId == 12).first)
                                    : null)),
                        GestureDetector(
                            onTap: () => clickPositionMember(3, 4),
                            child: itemUser(
                                'assets/images/icon_knitting_practice.png',
                                (clan != null &&
                                    clan.userClans.where((element) => element.characterId == 4 || element.characterId == 3).isNotEmpty &&
                                    clan.userClans.where((element) => element.characterId == 4 || element.characterId == 3).first.studentId == clan.generalId),
                                (clan != null && clan.userClans.where((element) => element.characterId == 4 || element.characterId == 3).isEmpty),
                                (clan != null && clan.userClans.where((element) => element.characterId == 4 || element.characterId == 3).isNotEmpty
                                    ? clan.userClans.where((element) => element.characterId == 4 || element.characterId == 3).first.nickname
                                    : ''),
                                clan.userClans.where((element) => element.characterId == 4 || element.characterId == 3).isNotEmpty
                                    ? clan.userClans.indexOf(clan.userClans.where((element) => element.characterId == 4 || element.characterId == 3).first)
                                    : null))
                      ],
                    ),
                  ),
                )
              : Container(),
          bottom: 0,
          right: 0,
          left: 0,
        ),
      ],
    );
  }

  itemUser(String image, bool dieukien1, bool dieukien2, String name, int indexOf) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: dieukien1
                ? Image(
                    image: AssetImage('assets/images/icon_general.png'),
                    height: 24,
                    width: 24,
                  )
                : Container(),
          ),
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
                border: Border.all(color: indexOf != null && position == indexOf ? Colors.blue : Colors.white, width: 2),
                borderRadius: BorderRadius.circular(28),
                color: HexColor("#FFCF38").withOpacity(0.8)),
            child: Stack(
              children: [
                Center(
                  child: Image(
                    image: AssetImage(image),
                    height: 44,
                    width: 44,
                  ),
                ),
                Visibility(
                  visible: dieukien2,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black.withOpacity(0.5)),
                  ),
                )
              ],
            ),
          ),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro', color: Colors.white),
          )
        ],
      ),
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
    );
  }

  changeCurrentStatus() async {
    if (changeStatus == true) {
      showLoading();
      var res = await cubit.changeStatusClan(clanId, clan.attackStatus == 1 ? 0 : 1);
      hideLoading();
      if (res != null) {
        showPopup(context,   res.message);
        setState(() {
          clan.attackStatus = clan.attackStatus == 1 ? 0 : 1;
          changeStatus = false;
        });
      } else {
        showPopup(context,  res.message);

      }
    }
  }

  clickPositionMember(int i, int j) {
    if (clan.userClans.where((element) => element.characterId == i || element.characterId == j).isNotEmpty) {
      var positionMember = clan.userClans.indexOf(clan.userClans.where((element) => element.characterId == i || element.characterId == j).first);
      controller.jumpToPage(positionMember);
      setState(() {
        position = positionMember;
      });
    }
  }
}
