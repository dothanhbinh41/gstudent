import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';
import 'package:gstudent/api/dtos/Clan/info_user_clan.dart';
import 'package:gstudent/character/model/UserCharacter.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/define_item/avatar_character.dart';
import 'package:gstudent/common/define_item/defind_character.dart';
import 'package:gstudent/common/define_item/teacher_character.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';

class CreateClanSuccessView extends StatefulWidget {
  int clanId;
  int islandId;
  int userId;
  int userClanId;
  String clanName;

  CreateClanSuccessView({this.userId, this.userClanId, this.clanId, this.clanName, this.islandId});

  @override
  State<StatefulWidget> createState() => CreateClanSuccessViewState(userId: this.userId, userClanId: this.userClanId, clanId: this.clanId, clanName: this.clanName, islandId: this.islandId);
}

class CreateClanSuccessViewState extends State<CreateClanSuccessView> {
  int userId;
  int clanId;
  int islandId;
  int userClanId;
  String clanName;

  CreateClanSuccessViewState({this.userId, this.userClanId, this.clanId, this.clanName, this.islandId});

  int position = 0;
  String nameChar;
  UserCharacter char;
  HomeCubit cubit;
  AssetImage bgDialog;

  UserClanInfo user;

  bool isGeneral = false;
  ClanDetail detailClan;

  ApplicationSettings applicationSettings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    applicationSettings = GetIt.instance.get<ApplicationSettings>();
    cubit = BlocProvider.of(context);
    loadImage();
    loadUserDetail();
    loadClan();
  }

  loadClan() async {
    showLoading();
    var res = await cubit.getDetailCLan(clanId);
    var u = await applicationSettings.getCurrentUser();
    hideLoading();
    if (res != null) {
      setState(() {
        detailClan = res;
        isGeneral = detailClan.generalId == u.userInfo.id;
      });
    }
  }

  loadUserDetail() async {
    showLoading();
    var res = await cubit.getInfoUser(userClanId);
    hideLoading();
    if (res != null) {
      setState(() {
        user = res;
        char = CharacterById(user.character.id);
        nameChar = user.nickName;
      });
    }
  }

  Future<bool> loadClanDetail() async {
    var res = await cubit.getDetailCLan(this.clanId);
    return res != null;
  }

  loadImage() {
    // bgDialog = AssetImage('assets/game_bg_dialog_create_long.png');
    bgDialog = AssetImage('assets/bg_create_character.png');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
    return Column(
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
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 4),
                height: MediaQuery.of(context).size.height * 0.1,
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
                                child: Center(child: textpaintingBoldBase('Team ' + clanName, 20, HexColor("#f8e9a5"), HexColor("#681527"), 3)),
                                top: 0,
                                right: 0,
                                bottom: 8,
                                left: 0,
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
                          height: 48,
                          width: 48,
                        ),
                      ),
                      top: 0,
                      left: 8,
                      bottom: 0,
                    ),
                  ],
                ),
              ),
              top: 0,
              right: 0,
              left: 0,
            ),
            Positioned(
              child: Container(
                child: character(),
              ),
              height: MediaQuery.of(context).size.height * 0.6,
              right: 0,
              bottom:  56,
              left: 0,
            ),
            Positioned(
              child: Column(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Positioned(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(48,8,8,8),
                              margin: EdgeInsets.fromLTRB(24, 8, 16, 8),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: HexColor("#EC9C20").withOpacity(0.8)),
                              child: isGeneral
                                  ? RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(text: 'Chúc mừng chủ tướng đã tạo Team thành công, bạn hãy gửi lời mời tới các thành viên của mình bằng', style: ThemeStyles.styleNormal(font: 13)),
                                          TextSpan(text: ' mã mời ', style: ThemeStyles.styleBold(font: 13)),
                                          TextSpan(text: 'được tạo để gây dựng nên 1 team hùng mạnh trong đế chế này nhé!', style: ThemeStyles.styleNormal(font: 13)),
                                        ],
                                      ),
                                    )
                                  : RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(text: 'Chúc mừng bạn đã tham gia Team ', style: ThemeStyles.styleNormal(font: 13)),
                                          TextSpan(text: clanName, style: ThemeStyles.styleBold(font: 13)),
                                          TextSpan(text: '. Hãy cố gắng để gây dựng nên một team hùng mạnh trong đế chế này nhé!', style: ThemeStyles.styleNormal(font: 13)),
                                        ],
                                      ),
                                    ),
                            ),
                            top: 0,
                            right: 0,
                            left: 0,
                            bottom: 0),
                        Positioned(
                          child: Image(
                            image: AssetImage(loadTeacherByIdIsland(islandId)),
                            fit: BoxFit.fitHeight,
                          ),
                          top: 0,
                          left: 0,
                          bottom: 0,
                        ),
                      ],
                    ),
                    height: 100,
                  ),
                  isGeneral
                      ? Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: HexColor("#EC9C20").withOpacity(0.8)),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: 'Code: ', style: ThemeStyles.styleNormal(font: 13)),
                                TextSpan(text: detailClan != null ? detailClan.code.toString() : 0, style: ThemeStyles.styleBold(font: 13)),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              top: MediaQuery.of(context).size.height * 0.1,
              right: 0,
              left: 0,
            ),
            Positioned(
                child: Center(
                  child: GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                      child: ButtonGraySmall("TIẾP TỤC", textColor: HexColor("#d5e7d5"),)),
                ),
                height: 48,
                bottom: 8,
                right: 0,
                left: 0)
          ],
        ))
      ],
    );
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
                  ),
                 height: 200,
                  bottom: 0,
                  right: 0,
                  left: 0,
                ),
                Positioned(
                  child: char != null
                      ? Container(
                          child: Image(
                            image: AssetImage(loadCharacterById(char.characterId)),
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Container(),
                  left: 0,
                  top: 48,
                  right: 0,
                  bottom: 24,
                ),
              ],
            ),
          ),
          top: 0,
          right: 0,
          bottom: 60,
          left: 0,
        ),
        Positioned(
          height: 80,
          child: char != null
              ? Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width*0.15,
                              width: MediaQuery.of(context).size.width*0.15,
                              decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.15/2), color: HexColor("#FFCF38").withOpacity(0.8)),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image(
                                      image: AssetImage('assets/images/game_fight_icon.png'),
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Visibility(
                                    visible: detailClan != null && detailClan.userClans.where((element) => element.characterId == 2 || element.characterId == 1).isEmpty,
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black.withOpacity(0.5)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            detailClan != null && detailClan.userClans.where((element) => element.characterId == 2 || element.characterId == 1).isNotEmpty
                                ? Text(
                                    detailClan.userClans.where((element) => element.characterId == 2 || element.characterId == 1).first.nickname,
                              overflow: TextOverflow.ellipsis,
                                    style: ThemeStyles.styleNormal(font: 14, textColors: Colors.white),
                                  )
                                : Container()
                          ],
                        ),
                        height: 80,
                      )),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        height: 80,
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width*0.15,
                              width: MediaQuery.of(context).size.width*0.15,
                              decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.15/2), color: HexColor("#FFCF38").withOpacity(0.8)),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image(
                                      image: AssetImage('assets/images/icon_steal.png'),
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Visibility(
                                    visible: detailClan != null && detailClan.userClans.where((element) => element.characterId == 5 || element.characterId == 6).isEmpty,
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black.withOpacity(0.5)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            detailClan != null && detailClan.userClans.where((element) => element.characterId == 5 || element.characterId == 6).isNotEmpty
                                ? Text(
                                    detailClan.userClans.where((element) => element.characterId == 5 || element.characterId == 6).first.nickname,
                              overflow: TextOverflow.ellipsis,
                                    style: ThemeStyles.styleNormal(font: 14, textColors: Colors.white),
                                  )
                                : Container()
                          ],
                        ),
                      )),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        height: 80,
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width*0.15,
                              width: MediaQuery.of(context).size.width*0.15,
                              decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.15/2), color: HexColor("#FFCF38").withOpacity(0.8)),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image(
                                      image: AssetImage('assets/images/icon_forge.png'),
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Visibility(
                                    visible: detailClan != null && detailClan.userClans.where((element) => element.characterId == 7 || element.characterId == 8).isEmpty,
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black.withOpacity(0.5)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            detailClan != null && detailClan.userClans.where((element) => element.characterId == 7 || element.characterId == 8).isNotEmpty
                                ? Text(
                                    detailClan.userClans.where((element) => element.characterId == 7 || element.characterId == 8).first.nickname,
                              overflow: TextOverflow.ellipsis,
                                    style: ThemeStyles.styleNormal(font: 14, textColors: Colors.white),
                                  )
                                : Container()
                          ],
                        ),
                      )),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        height: 80,
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width*0.15,
                              width: MediaQuery.of(context).size.width*0.15,
                              decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.15/2), color: HexColor("#FFCF38").withOpacity(0.8)),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image(
                                      image: AssetImage('assets/images/icon_defend.png'),
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Visibility(
                                    visible: detailClan != null && detailClan.userClans.where((element) => element.characterId == 11 || element.characterId == 12).isEmpty,
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black.withOpacity(0.5)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            detailClan != null && detailClan.userClans.where((element) => element.characterId == 11 || element.characterId == 12).isNotEmpty
                                ? Text(
                                    detailClan.userClans.where((element) => element.characterId == 11 || element.characterId == 12).first.nickname,
                              overflow: TextOverflow.ellipsis,
                                    style: ThemeStyles.styleNormal(font: 14, textColors: Colors.white),
                                  )
                                : Container()
                          ],
                        ),
                      )),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        height: 80,
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width*0.15,
                              width: MediaQuery.of(context).size.width*0.15,
                              decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.15/2), color: HexColor("#FFCF38").withOpacity(0.8)),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image(
                                      image: AssetImage('assets/images/icon_knitting_practice.png'),
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Visibility(
                                    visible: detailClan != null && detailClan.userClans.where((element) => element.characterId == 3 || element.characterId == 4).isEmpty,
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black.withOpacity(0.5)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            detailClan != null && detailClan.userClans.where((element) => element.characterId == 3 || element.characterId == 4).isNotEmpty
                                ? Text(
                                    detailClan.userClans.where((element) => element.characterId == 3 || element.characterId == 4).first.nickname,
                              overflow: TextOverflow.ellipsis,
                                    style: ThemeStyles.styleNormal(font: 14, textColors: Colors.white),
                                  )
                                : Container()
                          ],
                        ),
                      )),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        height: 80,
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width*0.15,
                              width: MediaQuery.of(context).size.width*0.15,
                              decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.15/2), color: HexColor("#FFCF38").withOpacity(0.8)),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    right: 0,
                                    left: 0,
                                    child: Center(
                                      child: Image(
                                        image: AssetImage('assets/images/icon_encourage.png'),
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    right: 0,
                                    left: 0,
                                    child: Visibility(
                                      visible: (detailClan != null && detailClan.userClans.where((element) => element.characterId == 9).isEmpty),
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            detailClan != null && detailClan.userClans.where((element) => element.characterId == 9).isNotEmpty
                                ? Text(
                                    detailClan.userClans.where((element) => element.characterId == 9).first.nickname,
                              overflow: TextOverflow.ellipsis,
                                    style: ThemeStyles.styleNormal(font: 14, textColors: Colors.white),
                                  )
                                : Container()
                          ],
                        ),
                      )),
                    ],
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
}
