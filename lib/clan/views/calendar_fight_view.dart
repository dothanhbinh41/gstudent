import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Arena/calendar.dart';
import 'package:gstudent/api/dtos/Arena/result_arena.dart';
import 'package:gstudent/api/dtos/Authentication/user_info.dart';
import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';
import 'package:gstudent/api/dtos/Clan/clan_invite_arena.dart';
import 'package:gstudent/character/services/character_services.dart';
import 'package:gstudent/clan/services/clan_services.dart';
import 'package:gstudent/clan/views/arena_fighting_view.dart';
import 'package:gstudent/clan/views/arena_waiting_view.dart';
import 'package:gstudent/clan/views/dialog_accept_invite.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/controls/time_ago.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/home/services/home_services.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/result/views/result_arena.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:intl/intl.dart';

class MapClanInvite {
  DateTime time;

  List<CalendarArena> clanInvites;

  MapClanInvite({this.time, this.clanInvites});
}

class CalendarFightView extends StatefulWidget {
  int clanId;
  int userClanId;
  List<UserClan> userClan;

  CalendarFightView({
    this.clanId,
    this.userClanId,
    this.userClan,
  });

  @override
  State<StatefulWidget> createState() => CalendarFightViewState(clanId: this.clanId, userClanId: this.userClanId, userClan: this.userClan);
}

class CalendarFightViewState extends State<CalendarFightView> {
  int clanId;
  int userClanId;
  List<UserClan> userClan;

  CalendarFightViewState({this.clanId, this.userClanId, this.userClan});

  User user;
  HomeCubit cubit;
  ApplicationSettings settings;
  ClanDetail clan;
  List<MapClanInvite> data = [];
  List<CalendarArena> dataCalendar = [];
  List<ClanInvite> invites = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<HomeCubit>(context);
    settings = GetIt.instance.get<ApplicationSettings>();
    loadImage();
    showLoading();
    hideLoading();
    loadData();
  }

  loadDetailClan() async {
    var res = await cubit.getDetailCLan(clanId);
    if (res != null) {
      if (mounted) {
        setState(() {
          clan = res;
        });
      }
    }
    checkInvite();
  }

  loadData() async {
    showLoading();
    var listCalendar = await cubit.calendarArena(clanId);
    hideLoading();
    if (listCalendar != null) {
      setState(() {
        data.clear();
        dataCalendar = listCalendar.data.where((element) => element.dateTimeStart.add(Duration(minutes: 5)).isAfter(DateTime.now())).toList();
      });
      Map<DateTime, List<CalendarArena>> list = groupBy(dataCalendar, (CalendarArena obj) => obj.dateTimeStart);
      setState(() {
        list.forEach((key, value) {
          data.add(MapClanInvite(time: key, clanInvites: value));
        });
      });
      loadDetailClan();
    } else {
      toast(context, 'error something');
    }
  }

  checkInvite() async {
    var user = await settings.getCurrentUser();
    if (user.userInfo.id == clan.generalId) {
      var res = await cubit.getListInviteArena(clanId);
      if (res.error == false && res.data.isNotEmpty) {
        if (mounted) {
          setState(() {
            this.user = user.userInfo;
            invites = res.data.where((element) => element.dateTimeStart.isAfter(DateTime.now())).toList();
          });
        }
      }
    }
  }

  AssetImage bgDialog;

  loadImage() {
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
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Stack(
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 16,
                        ),
                        invites.length > 0 || data.isNotEmpty
                            ? Container(
                                margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Image(
                                  image: AssetImage('assets/images/ellipse.png'),
                                ),
                              )
                            : Container(),
                        invites.length > 0
                            ? Text('Thư thách đấu', style: TextStyle(color: Colors.black, fontFamily: 'SourceSerifPro', fontSize: 16))
                            : Container(),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                              height: 60,
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: HexColor("#ad9958"), width: 1),
                                          color: HexColor("#fff6d8")),
                                      child: Row(
                                        children: [
                                          Image(
                                            image: AssetImage('assets/images/ic_letter.png'),
                                            height: 32,
                                            width: 32,
                                          ),
                                          Container(
                                            width: 8,
                                          ),
                                          Expanded(
                                              child: Column(
                                            children: [
                                              Text(invites[index].fromClanName,
                                                  style: TextStyle(color: Colors.black, fontFamily: 'SourceSerifPro', fontSize: 16)),
                                              Text(TimeAgo.timeAgoSinceDate(DateFormat("dd-MM-yyyy HH:mma").format(invites[index].createdAt)),
                                                  style: TextStyle(fontSize: 14)),
                                            ],
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                          ))
                                        ],
                                      ),
                                    ),
                                    top: 0,
                                    right: 12,
                                    left: 0,
                                    bottom: 0,
                                  ),
                                  Positioned(
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (user.id != clan.generalId) {
                                          toast(context, 'Bạn không phải là chủ tướng');
                                          return;
                                        }
                                        var response = await showDialog(
                                          context: context,
                                          builder: (context) => DialogAcceptInvite(
                                              clanInvite: CalendarArena(
                                                  arenaId: invites[index].arenaId,
                                                  dateTimeStart: invites[index].dateTimeStart,
                                                  fromClanId: invites[index].fromClanId,
                                                  fromClanName: invites[index].fromClanName,
                                                  toClanId: invites[index].toClanId,
                                                  letter: invites[index].letter,
                                                  toClanName: invites[index].toClanName),
                                              isSend: true),
                                        );
                                        if (response == true) {
                                          showLoading();
                                          var r = await cubit.acceptInviteArena(invites[index].arenaId);
                                          hideLoading();
                                          if (r != null && r.error == false) {
                                            setState(() {
                                              invites.remove(invites[index]);
                                            });
                                            toast(context, r.message);
                                            loadData();
                                          } else {
                                            toast(context, r.message);
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: 48,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: HexColor("#1ba931"), borderRadius: BorderRadius.circular(2)),
                                        child: Center(
                                          child: Text('Mở', style: ThemeStyles.styleNormal(textColors: Colors.white, font: 12)),
                                        ),
                                      ),
                                    ),
                                    top: 16,
                                    right: 0,
                                    bottom: 16,
                                  )
                                ],
                              ),
                            );
                          },
                          shrinkWrap: true,
                          itemCount: invites.length,
                        ),
                        invites.length > 0
                            ? Container(
                                margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Image(
                                  image: AssetImage('assets/images/ellipse.png'),
                                ),
                              )
                            : Container(),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                      child: Text('Ngày ' + DateFormat('dd/MM').format(data[index].time),
                                          style: TextStyle(color: Colors.black, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400, fontSize: 16))),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      return GestureDetector(
                                        onTap: () async {
                                          var response = await showGeneralDialog(
                                            barrierLabel: "Label",
                                            barrierDismissible: true,
                                            barrierColor: Colors.black.withOpacity(0.5),
                                            transitionDuration: Duration(milliseconds: 700),
                                            context: context,
                                            pageBuilder: (context, anim1, anim2) {
                                              return Align(
                                                alignment: Alignment.center,
                                                child: DialogAcceptInvite(
                                                  clanInvite: data[index].clanInvites[i],
                                                  isSend: false,
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

                                          if (response == true) {
                                            var now = DateTime.now();

                                            if (isSameDate(now, data[index].clanInvites[i].dateTimeStart) == false) {
                                              toast(context, 'Chưa đến ngày bắt đầu');
                                              return;
                                            }

                                            var charService = GetIt.instance.get<CharacterService>();
                                            var clanService = GetIt.instance.get<ClanService>();
                                            var homeService = GetIt.instance.get<HomeService>();
                                            showLoading();
                                            var dataArena = await clanService.getInfoArena(data[index].clanInvites[i].arenaId);

                                            hideLoading();
                                            var millisInADay = Duration(
                                                    hours: data[index].clanInvites[i].dateTimeStart.hour,
                                                    minutes: data[index].clanInvites[i].dateTimeStart.minute)
                                                .inMilliseconds;
                                            var millisInANow = Duration(hours: now.hour, minutes: now.minute, seconds: now.second).inMilliseconds;
                                            int c = (millisInADay - millisInANow) ~/ 1000;
                                            var response = await showDialog(
                                              context: context,
                                              useSafeArea: false,
                                              builder: (context) => WaitForTheMatchView(
                                                time: data[index].clanInvites[i].dateTimeStart,
                                                nameClan: dataArena.data.clan.name == clan.name ? dataArena.data.clan.name : dataArena.data.anotherClan.name,
                                                nameFromClan:
                                                    dataArena.data.clan.name == clan.name ? dataArena.data.anotherClan.name : dataArena.data.clan.name,
                                                rankClan: dataArena.data.clan.name == clan.name ? dataArena.data.clan.rank : dataArena.data.anotherClan.rank,
                                                rankOtherClan:
                                                    dataArena.data.clan.name == clan.name ? dataArena.data.anotherClan.rank : dataArena.data.clan.rank,
                                                winRateClan:
                                                    dataArena.data.clan.name == clan.name ? dataArena.data.clan.winRate : dataArena.data.anotherClan.winRate,
                                                winRateOtherClan:
                                                    dataArena.data.clan.name == clan.name ? dataArena.data.anotherClan.winRate : dataArena.data.clan.winRate,
                                                generalClan: dataArena.data.clan.name == clan.name
                                                    ? dataArena.data.clan.student.where((element) => element.position == "General").first
                                                    : dataArena.data.anotherClan.student.where((element) => element.position == "General").first,
                                                generalOtherClan: dataArena.data.clan.name == clan.name
                                                    ? dataArena.data.anotherClan.student.where((element) => element.position == "General").first
                                                    : dataArena.data.clan.student.where((element) => element.position == "General").first,
                                                mvpClan: dataArena.data.clan.name == clan.name
                                                    ? (dataArena.data.clan.student.where((element) => element.position.toLowerCase() == "mvp").isNotEmpty
                                                        ? dataArena.data.clan.student.where((element) => element.position.toLowerCase() == "mvp").first
                                                        : dataArena.data.clan.student.where((element) => element.position == "General").first)
                                                    : (dataArena.data.anotherClan.student.where((element) => element.position.toLowerCase() == "mvp").isNotEmpty
                                                        ? dataArena.data.anotherClan.student.where((element) => element.position.toLowerCase() == "mvp").first
                                                        : dataArena.data.anotherClan.student.where((element) => element.position == "General").first),
                                                mvpOtherClan: dataArena.data.clan.name == clan.name
                                                    ? (dataArena.data.anotherClan.student.where((element) => element.position.toLowerCase() == "mvp").isNotEmpty
                                                        ? dataArena.data.anotherClan.student.where((element) => element.position.toLowerCase() == "mvp").first
                                                        : dataArena.data.anotherClan.student.where((element) => element.position == "General").first)
                                                    : (dataArena.data.clan.student.where((element) => element.position.toLowerCase() == "mvp").isNotEmpty
                                                        ? dataArena.data.clan.student.where((element) => element.position.toLowerCase() == "mvp").first
                                                        : dataArena.data.clan.student.where((element) => element.position == "General").first),
                                              ),
                                            );
                                            if (response != null && response == true) {
                                              DataResultArena result = await Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => BlocProvider.value(
                                                  value: HomeCubit(
                                                      settings: settings, characterService: charService, clanService: clanService, homeService: homeService),
                                                  child: ArenaFightingView(
                                                    startTime: data[index].clanInvites[i].dateTimeStart,
                                                    data: dataArena.data,
                                                    arenaId: data[index].clanInvites[i].arenaId,
                                                    clanId: clan.id,
                                                    userClanId: userClanId,
                                                  ),
                                                ),
                                              ));
                                              loadData();

                                              if (result != null) {
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) => ResultArenaView(
                                                    result: result,
                                                    userClan: this.userClan,
                                                    generalId: clan.generalId,
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 72,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(4),
                                                      border: Border.all(color: HexColor("#ad9958"), width: 1),
                                                      color: HexColor("#fff6d8")),
                                                  child: Row(
                                                    children: [
                                                      Image(
                                                        image: AssetImage('assets/images/swords_icon.png'),
                                                        height: 32,
                                                        width: 32,
                                                      ),
                                                      Container(
                                                        width: 8,
                                                      ),
                                                      Expanded(
                                                          child: Column(
                                                        children: [
                                                          Text(data[index].clanInvites[i].fromClanName,
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: 'SourceSerifPro',
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 16)),
                                                          Text(DateFormat('dd/MM').format(data[index].clanInvites[i].dateTimeStart),
                                                              style: TextStyle(fontSize: 14, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400)),
                                                        ],
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                      ))
                                                    ],
                                                  ),
                                                ),
                                                top: 12,
                                                right: 12,
                                                left: 0,
                                                bottom: 0,
                                              ),
                                              Positioned(
                                                child: Visibility(
                                                  visible: index == 0 && i == 0,
                                                  child: Container(
                                                    width: 100,
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(color: HexColor("#2C4482"), borderRadius: BorderRadius.circular(2)),
                                                    child: Center(
                                                      child: Text('Sắp thi đấu',
                                                          style: TextStyle(
                                                              color: Colors.white, fontSize: 12, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400)),
                                                    ),
                                                  ),
                                                ),
                                                top: 0,
                                                right: 24,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: data[index].clanInvites.length,
                                    shrinkWrap: true,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                    child: Image(
                                      image: AssetImage('assets/images/ellipse.png'),
                                    ),
                                  )
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            );
                          },
                          shrinkWrap: true,
                          itemCount: data.length,
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  )),
              Positioned(
                  child: Container(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: MediaQuery.of(context).size.width > 800 ? 60 : 0,
                          bottom: 8,
                          left: MediaQuery.of(context).size.width > 800 ? 60 : 0,
                          child: Image(
                            image: AssetImage('assets/images/title_result.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          child: Center(
                            child: textpaintingBoldBase('Lịch thi đấu', 24, HexColor("#f8e9a5"), HexColor("#681527"), 3),
                          ),
                          top: 0,
                          right: 0,
                          bottom: 16,
                          left: 0,
                        )
                      ],
                    ),
                  ),
                  top: 0,
                  height: MediaQuery.of(context).size.width > 800 ? 90 : 60,
                  left: 24,
                  right: 24),
              Positioned(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image(
                    image: AssetImage('assets/images/game_close_dialog_clan.png'),
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
      ),
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
    );
  }

  bool isSameDate(DateTime now, DateTime other) {
    return now.year == other.year && now.month == other.month && now.day == other.day;
  }
}
