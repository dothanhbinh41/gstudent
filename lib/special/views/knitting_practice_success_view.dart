import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/define_item/avatar_character.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/special/views/knitting_practice_view_result.dart';

class KnittingPracticeSuccessView extends StatefulWidget {
  int ClanId;
  int userClanId;
  int quantitySpecial;

  KnittingPracticeSuccessView(
      {this.ClanId, this.userClanId, this.quantitySpecial});

  @override
  State<StatefulWidget> createState() => KnittingPracticeSuccessViewState(
      ClanId: this.ClanId,
      userClanId: this.userClanId,
      quantitySpecial: this.quantitySpecial);
}

class KnittingPracticeSuccessViewState
    extends State<KnittingPracticeSuccessView> {
  int ClanId;
  int userClanId;
  int quantitySpecial;

  KnittingPracticeSuccessViewState(
      {this.ClanId, this.userClanId, this.quantitySpecial});

  List<UserClan> userClans;
  bool isAnimate = false;
  HomeCubit cubit;
  UserClan userChoose;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
    loadImage();
    loadMember();
  }

  loadMember() async {
    var res = await cubit.getMemberUserClan(this.ClanId);
    if (res != null) {
      setState(() {
        userClans = res.userClans
                .where((element) => element.id != userClanId)
                .toList()
                .isNotEmpty
            ? res.userClans
                .where((element) => element.id != userClanId)
                .toList()
            : res.userClans;
      });
    }
  }

  AssetImage bgRevenge;
  AssetImage bg;

  void showDialogSuccess(String mess) async {
    await showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => ResultKnittingPracticeView(
        mess: mess,
      ),
    );
    Navigator.of(context).pop();
  }

  loadImage() {
    bg = AssetImage('assets/bg_luyendan.png');
    bgRevenge = AssetImage('assets/bg_revenge.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bg, context);
    precacheImage(bgRevenge, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Image(
              image: bg,
              fit: BoxFit.fill,
            ),
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          Column(
            children: [
              Container(
                height: 161,
                child: Stack(
                  children: [
                    Positioned(
                      child: Image(
                        image: bgRevenge,
                        fit: BoxFit.fill,
                      ),
                      top: 0,
                      right: -16,
                      left: -16,
                      bottom: -16,
                    ),
                    Positioned(
                      child: Image(
                        image: AssetImage('assets/stick.png'),
                        fit: BoxFit.fitWidth,
                      ),
                      right: 0,
                      left: 0,
                      bottom: 0,
                    ),
                    Positioned(
                      child: Column(
                        children: [
                          Text(
                            'Luyện đan',
                            style: TextStyle(
                                fontSize: 24,
                                color: HexColor("#3a230a"),
                                fontFamily: 'SourceSerifPro',
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 24,
                            child: Image(
                              image:
                                  AssetImage('assets/images/eclipse_login.png'),
                            ),
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 60,
                            alignment: Alignment.center,
                            child: Text(
                              'Bạn đã luyện đan thành công \nBạn muốn tặng cho ai',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'SourceSerifPro'),
                            ),
                          ),
                          Container(
                            height: 24,
                            child: Image(
                              image: AssetImage('assets/images/ellipse.png'),
                            ),
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                        ],
                      ),
                      top: 4,
                      right: 12,
                      left: 12,
                      bottom: 16,
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image(
                          image:
                              AssetImage('assets/images/game_button_back.png'),
                          height: 48,
                          width: 48,
                        ),
                      ),
                      top: 8,
                      left: 8,
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      child: Stack(
                        children: [
                          Center(
                            child: Image(
                              image: AssetImage('assets/img_result_attack.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Center(
                            child: Image(
                              image:
                                  AssetImage('assets/images/item_chapter2.png'),
                              height: MediaQuery.of(context).size.width / 2,
                            ),
                          )
                        ],
                      ),
                    ),
                    right: 0,
                    top: 0,
                    left: 0,
                    bottom: 0,
                  ),
                  Positioned(
                    height: 80,
                    child: userClans != null && userClans.isNotEmpty
                        ? GestureDetector(
                            onTap: () => luyendan(0),
                            child: Column(
                              children: [
                                Container(
                                  child: Stack(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/images/game_border_avatar_member.png'),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        left: 8,
                                        bottom: 8,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: Image(
                                              image: AssetImage(
                                                  loadAvatarCharacterById(
                                                      userClans[0]
                                                          .characterId))),
                                        ),
                                      )
                                    ],
                                  ),
                                  height: 60,
                                ),
                                Text(
                                  userClans[0].nickname,
                                  style: ThemeStyles.styleBold(
                                      font: 12, textColors: Colors.white),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    left: 0,
                    right: 0,
                    top: 48,
                  ),
                  Positioned(
                    width: 80,
                    child: userClans != null && userClans.length > 1
                        ? GestureDetector(
                            onTap: () => luyendan(1),
                            child: Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      child: Stack(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/images/game_border_avatar_member.png'),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            left: 8,
                                            bottom: 8,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: Image(
                                                  image: AssetImage(
                                                      loadAvatarCharacterById(
                                                          userClans[1]
                                                              .characterId))),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      userClans[1].nickname,
                                      style: ThemeStyles.styleBold(
                                          font: 12, textColors: Colors.white),
                                    )
                                  ],
                                ),
                                height: 80,
                              ),
                            ),
                          )
                        : Container(),
                    left: 12,
                    top: 0,
                    bottom: 0,
                  ),
                  Positioned(
                    width: 80,
                    child: userClans != null && userClans.length > 2
                        ? GestureDetector(
                            onTap: () => luyendan(2),
                            child: Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      child: Stack(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/images/game_border_avatar_member.png'),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            left: 8,
                                            bottom: 8,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: Image(
                                                  image: AssetImage(
                                                      loadAvatarCharacterById(
                                                          userClans[2]
                                                              .characterId))),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      userClans[2].nickname,
                                      style: ThemeStyles.styleBold(
                                          font: 12, textColors: Colors.white),
                                    )
                                  ],
                                ),
                                height: 80,
                              ),
                            ),
                          )
                        : Container(),
                    right: 12,
                    top: 0,
                    bottom: 0,
                  ),
                  Positioned(
                    width: 80,
                    height: 80,
                    child: userClans != null && userClans.length > 3
                        ? GestureDetector(
                            onTap: () => luyendan(3),
                            child: Column(
                              children: [
                                Container(
                                  child: Stack(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/images/game_border_avatar_member.png'),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        left: 8,
                                        bottom: 8,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: Image(
                                              image: AssetImage(
                                                  loadAvatarCharacterById(
                                                      userClans[3]
                                                          .characterId))),
                                        ),
                                      )
                                    ],
                                  ),
                                  width: 60,
                                ),
                                Text(
                                  userClans[2].nickname,
                                  style: ThemeStyles.styleBold(
                                      font: 12, textColors: Colors.white),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    right: 48,
                    bottom: 24,
                  ),
                  Positioned(
                    height: 80,
                    width: 60,
                    child: userClans != null && userClans.length > 4
                        ? GestureDetector(
                            onTap: () => luyendan(4),
                            child: Column(
                              children: [
                                Container(
                                  child: Stack(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/images/game_border_avatar_member.png'),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        left: 8,
                                        bottom: 8,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: Image(
                                              image: AssetImage(
                                                  loadAvatarCharacterById(
                                                      userClans[4]
                                                          .characterId))),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Text(
                                  userClans[4].nickname,
                                  style: ThemeStyles.styleBold(
                                      font: 12, textColors: Colors.white),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    left: 48,
                    bottom: 24,
                  ),
                ],
              ))
            ],
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  luyendan(int position) async {
    if (quantitySpecial == 0) {
      toast(context, 'Bạn đã hết lượt luyện đan!');
      return;
    }
    showLoading();
    var res = await cubit.knitting(this.userClanId, userClans[position].id);
    hideLoading();
    if (res != null) {
      showDialogSuccess(res.message);
    }
  }
}
