import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Authentication/user_info.dart';
import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';
import 'package:gstudent/api/dtos/Clan/info_user_clan.dart';
import 'package:gstudent/api/dtos/badge/data_badge.dart';
import 'package:gstudent/badge/views/all_badge_view.dart';
import 'package:gstudent/character/model/UserCharacter.dart';
import 'package:gstudent/character/services/character_services.dart';
import 'package:gstudent/clan/services/clan_services.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/LinearPercentIndicator.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/define_item/badge_avatar.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/home/services/home_services.dart';
import 'package:gstudent/mission/services/MissionService.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:gstudent/special/services/special_service.dart';

class CharacterDialog extends StatefulWidget {
  int userClanId;
  int clanId;

  CharacterDialog({this.userClanId, this.clanId});

  @override
  State<StatefulWidget> createState() => CharacterDialogState(userClanId: this.userClanId, clanId: this.clanId);
}

class CharacterDialogState extends State<CharacterDialog> {
  int userClanId;
  int clanId;

  CharacterDialogState({this.userClanId, this.clanId});

  HomeCubit cubit;
  ClanDetail clan;
  List<Badge> badge;
  ApplicationSettings settings;
  UserClanInfo charInfo;
  int level = 0;
  int exp = 0;
  User user;

  UserCharacter character;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
    settings = GetIt.instance.get<ApplicationSettings>();
    loadImage();
    // loadBadge();
    loadUser();
    loadCharInfo();
    loadClanInfo();
  }

  loadUser() async {
    var u = await settings.getCurrentUser();
    setState(() {
      user = u.userInfo;
      print(user.id);
    });
  }

  loadClanInfo() async {
    var res = await cubit.getDetailCLan(clanId);
    if (res != null) {
    if(mounted){
      setState(() {
        clan = res;
      });
    }
    }
  }

  loadCharInfo() async {
    UserCharacter c = await settings.getCurrentCharacterUser();
    var res = await cubit.getInfoUser(userClanId);
    if (res != null) {
      setState(() {
        charInfo = res;
        exp = charInfo.exp;
        character = c;
        badge = res.badges;
      });
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
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              Positioned(
                top: 16,
                right: MediaQuery.of(context).size.width > 800 ? 60 : 16,
                left: MediaQuery.of(context).size.width > 800 ? 60 : 16,
                bottom: 0,
                child: Image(
                  image: bgDialog,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 48,
                bottom: 36,
                right: MediaQuery.of(context).size.width > 800 ? MediaQuery.of(context).size.width * 0.15 : 48,
                left: MediaQuery.of(context).size.width > 800 ? MediaQuery.of(context).size.width * 0.15 : 48,
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 18,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                child: Center(
                                  child: Container(
                                    height: 80,
                                    child: Stack(
                                      children: [
                                        charInfo != null && charInfo.levelAvatar != null && charInfo.levelAvatar.isNotEmpty
                                            ? Container(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(60),
                                                  child: Image.network(charInfo.levelAvatar,fit: BoxFit.fill,),
                                                ),
                                              )
                                            :     Image(image: AssetImage('assets/images/game_bg_rank.png')),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: textpaintingBoldBase(charInfo != null && charInfo.nickName != null ? charInfo.nickName : '', 14, Colors.white, Colors.black, 2),
                                            margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                          ),
                                          Center(
                                            child: Image(
                                              image: AssetImage('assets/images/game_xu.png'),
                                              height: 14,
                                              width: 14,
                                            ),
                                          ),
                                          textpaintingBoldBase(charInfo != null && charInfo.coin != null ? charInfo.coin.toString() : '', 14, Colors.white, Colors.black, 2)
                                        ],
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                      height: 16,
                                      width: 240,
                                      child: Stack(children: [
                                        Positioned(
                                          right: 12,
                                          left: 12,
                                          child: LinearPercentIndicator(
                                            animation: true,
                                            backgroundColor: HexColor("#4c1409"),
                                            lineHeight: 14,
                                            animationDuration: 2000,
                                            percent: charInfo != null && charInfo.hp != null ? charInfo.hp / character.totalHp : 0.1,
                                            center: Row(
                                              children: [
                                                textpaintingBoldBase("HP: ", 10, Colors.white, Colors.black, 3),
                                                textpaintingBoldBase(
                                                    charInfo != null && charInfo.hp != null ? charInfo.hp.toString() + "/" + character.totalHp.toString() : ''
                                                        '', 10, Colors.red, Colors.black, 3),
                                              ],
                                            ),
                                            linearStrokeCap: LinearStrokeCap.roundAll,
                                            progressColor: HexColor("#ef0000"),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          bottom: 0,
                                          left: 0,
                                          child: Image(
                                            image: AssetImage('assets/images/game_border_progress.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ]),
                                    ),
                                    Container(
                                      width: 200,
                                      margin: EdgeInsets.fromLTRB(2, 0, 0, 4),
                                      height: 16,
                                      child: Stack(children: [
                                        Positioned(
                                          right: 12,
                                          left: 12,
                                          child: LinearPercentIndicator(
                                            animation: true,
                                            lineHeight: 14,
                                            backgroundColor: HexColor("#4c1409"),
                                            animationDuration: 2000,
                                            percent: charInfo != null && charInfo.exp > 0 ?  charInfo.exp/charInfo.nextLevel.nextExp : 0.0,
                                            center: Row(
                                              children: [
                                                textpaintingBoldBase("Level: ", 10, HexColor("#978af4"), Colors.black, 3),

                                                charInfo != null  ? textpaintingBoldBase(charInfo.level != null ? charInfo.level.toString() : '0', 10, Colors
                                                    .white, Colors.black, 3) : Container(),
                                              ],
                                            ),
                                            linearStrokeCap: LinearStrokeCap.roundAll,
                                            progressColor: HexColor("#c300ce"),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          bottom: 0,
                                          left: 0,
                                          child: Image(
                                            image: AssetImage('assets/images/game_border_progress.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ]),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          height: 1.0,
                          decoration: BoxDecoration(color: HexColor("#b0a27b")),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Row(
                            children: [
                              badge != null
                                  ? Text(
                                      'Danh hiệu của bạn (' + badge.length.toString() + ')',
                                      style: TextStyle(color: Colors.black, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold),
                                    )
                                  : Container(),
                              Expanded(child: Container()),
                              GestureDetector(
                                onTap: () {
                                  showAllBadge();
                                },
                                child:
                                    Text("Xem chi tiết", style: TextStyle(color: HexColor("#335fa0"), fontWeight: FontWeight.bold, fontFamily: 'SourceSerifPro', decoration: TextDecoration.underline)),
                              ),
                            ],
                          ),
                        ),
                        badge != null && badge.isNotEmpty
                            ? Container(
                                height: badge.length > 4 ? 160 : 80,
                                child: GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  // Create a grid with 2 columns. If you change the scrollDirection to
                                  // horizontal, this produces 2 rows.
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  // Generate 100 widgets that display their index in the List.
                                  children: List.generate(badge.length >8 ? badge.take(8).toList().length : badge.length, (index) {
                                    return Stack(
                                      children: [

                                        Container(
                                          margin: EdgeInsets.all(4),
                                          decoration: BoxDecoration(color: HexColor("#6b5467")),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(4),
                                          child: Image(image: AssetImage(defineBadgeById(badge[index].id)),fit: BoxFit.fitWidth,),
                                        ),

                                        Image(
                                          image: AssetImage('assets/images/game_bg_title_user.png'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              )
                            : Container(),
                        decoration(),
                        Container(
                          child: Row(
                            children: [
                              Center(
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(4),
                                        child: Image(image: AssetImage("assets/images/guild.png"),),
                                      ),
                                      Image(
                                        image: AssetImage('assets/images/game_border_avatar_clan.png'),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 8,
                              ),
                              Expanded(
                                child: clan != null
                                    ? Column(
                                        children: [
                                          Text(
                                            clan.name,
                                            style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "SourceSerifPro", fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Chức danh: ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "SourceSerifPro",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                clan.generalId == user.id ? "General" : 'Member',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Tỉ lệ thắng: ",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily: "SourceSerifPro",
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                             Expanded(child:  Text(
                                               clan != null ? (clan.win != 0 || clan.lose != 0 ? ((clan.win / clan.lose)*100).toStringAsFixed(2) + "%" : '0%') : '0%',
                                               style: TextStyle(color: HexColor("#335fa0"), fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "SourceSerifPro"),
                                             ))
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Số MVP: ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily: "SourceSerifPro",
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                clan != null && clan.userClans.where((element) => element.studentId == user.id).first != null
                                                    ? clan.userClans.where((element) => element.studentId == user.id).first.mvp.toString()
                                                    : "0",
                                                style: TextStyle(color: HexColor("#335fa0"), fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "SourceSerifPro"),
                                              )
                                            ],
                                          ),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      )
                                    : Container(),
                                flex: 2,
                              ),
                            ],
                          ),
                        ),
                        decoration(),
                        // Text("Số liệu tại đảo thông thái", style: TextStyle(color: Colors.black, fontFamily: 'SourceSerifPro', fontSize: 16, fontWeight: FontWeight.bold)),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //         child: Container(
                        //       height: 72,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(4),
                        //         border: Border.all(color: HexColor("#31281b"), width: 3),
                        //       ),
                        //       child: Container(
                        //           margin: EdgeInsets.all(1),
                        //           decoration: BoxDecoration(
                        //               gradient: LinearGradient(
                        //             begin: Alignment.topCenter,
                        //             end: Alignment.bottomCenter,
                        //             colors: [
                        //               HexColor("#33291b"),
                        //               HexColor("#67512f"),
                        //             ],
                        //           )),
                        //           child: Column(
                        //             children: [
                        //               Text("Đi học",
                        //                   style: TextStyle(
                        //                     color: HexColor("#aba079"),
                        //                     fontSize: 14,
                        //                     fontFamily: 'SourceSerifPro',
                        //                     fontWeight: FontWeight.w400,
                        //                   )),
                        //               Text("5/6",
                        //                   style: TextStyle(
                        //                     color: HexColor("#f8e8b0"),
                        //                     fontWeight: FontWeight.bold,
                        //                     fontSize: 16,
                        //                     fontFamily: 'SourceSerifPro',
                        //                   ))
                        //             ],
                        //             crossAxisAlignment: CrossAxisAlignment.center,
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //           )),
                        //     )),
                        //     Container(
                        //       width: 4.0,
                        //     ),
                        //     Expanded(
                        //         child: Container(
                        //       height: 72,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(4),
                        //         border: Border.all(color: HexColor("#31281b"), width: 3),
                        //       ),
                        //       child: Container(
                        //           margin: EdgeInsets.all(1),
                        //           decoration: BoxDecoration(
                        //               gradient: LinearGradient(
                        //             begin: Alignment.topCenter,
                        //             end: Alignment.bottomCenter,
                        //             colors: [
                        //               HexColor("#33291b"),
                        //               HexColor("#67512f"),
                        //             ],
                        //           )),
                        //           child: Column(
                        //             children: [
                        //               Text("Bài tập", style: TextStyle(color: HexColor("#aba079"), fontSize: 14, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400)),
                        //               Text("15/16",
                        //                   style: TextStyle(
                        //                     color: HexColor("#f8e8b0"),
                        //                     fontWeight: FontWeight.bold,
                        //                     fontSize: 16,
                        //                     fontFamily: 'SourceSerifPro',
                        //                   ))
                        //             ],
                        //             crossAxisAlignment: CrossAxisAlignment.center,
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //           )),
                        //     )),
                        //     Container(
                        //       width: 4.0,
                        //     ),
                        //     Expanded(
                        //         child: Container(
                        //       height: 72,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(4),
                        //         border: Border.all(color: HexColor("#31281b"), width: 3),
                        //       ),
                        //       child: Container(
                        //           margin: EdgeInsets.all(1),
                        //           decoration: BoxDecoration(
                        //               gradient: LinearGradient(
                        //             begin: Alignment.topCenter,
                        //             end: Alignment.bottomCenter,
                        //             colors: [
                        //               HexColor("#33291b"),
                        //               HexColor("#67512f"),
                        //             ],
                        //           )),
                        //           child: Column(
                        //             children: [
                        //               Text(
                        //                 "Kết quả bài tập",
                        //                 style: TextStyle(color: HexColor("#aba079"), fontSize: 14, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400),
                        //                 textAlign: TextAlign.center,
                        //               ),
                        //               Text("15/16",
                        //                   style: TextStyle(
                        //                     color: HexColor("#f8e8b0"),
                        //                     fontWeight: FontWeight.bold,
                        //                     fontSize: 16,
                        //                     fontFamily: 'SourceSerifPro',
                        //                   ))
                        //             ],
                        //             crossAxisAlignment: CrossAxisAlignment.center,
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //           )),
                        //     ))
                        //   ],
                        // ),
                        // decoration(),
                        // Text(
                        //   "Luyện từ vựng",
                        //   style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold),
                        // ),
                        // Row(
                        //   children: [
                        //     Text(
                        //       "Tổng số từ thu tập được :",
                        //       style: TextStyle(
                        //         fontFamily: 'SourceSerifPro',
                        //         fontWeight: FontWeight.w400,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //     Text("120",
                        //         style: TextStyle(
                        //           fontFamily: 'SourceSerifPro',
                        //           fontWeight: FontWeight.w400,
                        //           color: HexColor("#335fa0"),
                        //         )),
                        //   ],
                        // ),
                        Container(
                          height: 20,
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ),
              ),
              Positioned(
                  child: Container(
                    child: Stack(
                      children: [
                        Positioned(   top: 0,
                          right: MediaQuery.of(context).size.width > 800 ? 60 : 0,
                          bottom: 8,
                          left:  MediaQuery.of(context).size.width > 800 ? 60 : 0,
                          child: Image(
                            image: AssetImage('assets/images/title_result.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          child: Center(
                            child: textpainting('Nhân Vật', 24),
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
                right:MediaQuery.of(context).size.width > 800 ? 60 : 16,
              ),
            ],
          )),
        ],
      ),
    );
  }

  decoration() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
      height: 1.0,
      decoration: BoxDecoration(color: HexColor("#b0a27b")),
    );
  }

  showAllBadge() async {
    var charService = GetIt.instance.get<CharacterService>();
    var clanService = GetIt.instance.get<ClanService>();
    var missionService = GetIt.instance.get<MissionService>();
    var applicationSetting = GetIt.instance.get<ApplicationSettings>();
    var homeService = GetIt.instance.get<HomeService>();
    var specialService = GetIt.instance.get<SpecialService>();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value:
            HomeCubit(characterService: charService, settings: applicationSetting, homeService: homeService, missionService: missionService, specialService: specialService, clanService: clanService),
        child: AllBadgeView(badges : charInfo.badges),
      ),
    ));
  }

  textpainting(String s, double fontSize) {
    return OutlinedText(
      text: Text(s, textAlign: TextAlign.justify, style: TextStyle(fontSize: fontSize, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, color: HexColor("#f8e9a5"))),
      strokes: [
        OutlinedTextStroke(color: HexColor("#681527"), width: 3),
      ],
    );
  }
}
