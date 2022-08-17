import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/Clan/clan_model.dart';
import 'package:gstudent/clan/views/dialog_send_invite.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/icons/icon_status_clan.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';

class RankingClanView extends StatefulWidget {
  int statusAttack;
  int clanId;
  int courseId;
  bool isGeneral;

  RankingClanView({this.clanId, this.courseId, this.statusAttack, this.isGeneral});

  @override
  State<StatefulWidget> createState() => RankingClanViewState(courseId: this.courseId,  clanId: this.clanId, statusAttack: this.statusAttack, isGeneral: this.isGeneral);
}

class RankingClanViewState extends State<RankingClanView> {
  int clanId;
  int courseId;
  int statusAttack;
  bool isGeneral;

  RankingClanViewState({this.clanId, this.courseId,   this.statusAttack, this.isGeneral});
  HomeCubit cubit;

  List<ClanModel> clans;
  List<ClanModel> all;
  DateTime date;
  Duration hour;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
    loadImage();
    loadData();
  }

  AssetImage bgDialog;

  loadData() async {
    showLoading();
    var res = await cubit.getRanking(courseId);
    hideLoading();
    if (res.error == false) {
      setState(() {
        clans = res.data;
        all = res.data;
      });
    } else {
      toast(context, 'Something wrong, please contact to center');
    }
  }

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
    return Stack(
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
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 16,
                ),
                Container(
                  height: 48,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: HexColor("#9b7e63"),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    style: TextStyle(color: HexColor("#f8e8b0"), fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro'),
                    decoration: new InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        hintText: 'Search',
                        prefixIcon: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Icon(IconStatusClan.search, size: 20, color: HexColor("#f8e8b0")),
                        ),
                        hintStyle: TextStyle(fontFamily: "SourceSerifPro-Bold", color: HexColor("#f8e8b0"))),
                    onChanged: (value) {
                      setState(() {
                        clans = all.where((element) => element.name.contains(value)).toList();
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Image(
                    image: AssetImage('assets/images/ellipse.png'),
                  ),
                ),
                clans != null
                    ? Expanded(
                        child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            child: Stack(
                              children: [
                                Positioned(
                                  child: Image(
                                    image: AssetImage('assets/images/game_bg_member_clan.png'),
                                    fit: BoxFit.fill,
                                  ),
                                  left: 1,
                                  top: 4,
                                  bottom: 4,
                                  right: 1,
                                ),
                                Positioned(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                        height: 48,
                                        width: 48,
                                        child: index == 0
                                            ? Image(
                                                image: AssetImage('assets/images/ranking_top1.png'),
                                                fit: BoxFit.fill,
                                              )
                                            : (index == 1
                                                ? Image(
                                                    image: AssetImage('assets/images/ranking_top2.png'),
                                                    fit: BoxFit.fill,
                                                  )
                                                : (index == 2
                                                    ? Image(
                                                        image: AssetImage('assets/images/ranking_top3.png'),
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Center(
                                                        child: Text(
                                                        (index + 1).toString(),
                                                        style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, color: HexColor("#d08272"), fontSize: 20),
                                                      )))),
                                      ),
                                      // Container(
                                      //   height: 56,
                                      //   width: 56,
                                      //   child: Stack(
                                      //     children: [
                                      //       Positioned(
                                      //         top: 4,
                                      //         right: 4,
                                      //         left: 4,
                                      //         bottom: 4,
                                      //         child: Image(
                                      //           image: AssetImage(
                                      //               'assets/images/ic_training_vocab.png'),
                                      //           fit: BoxFit.fill,
                                      //         ),
                                      //       ),
                                      //       Positioned(
                                      //         top: 0,
                                      //         right: 0,
                                      //         left: 0,
                                      //         bottom: 0,
                                      //         child: Image(
                                      //           image: AssetImage(
                                      //               'assets/images/game_border_avatar_clan.png'),
                                      //           fit: BoxFit.fill,
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      Expanded(
                                          child: Container(
                                        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                        height: 60,
                                        child: Column(
                                          children: [
                                            Text(
                                              clans[index].name,
                                              style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                            clans[index].rank != null
                                                ? RichText(
                                                    text: TextSpan(children: <TextSpan>[
                                                      TextSpan(
                                                        text: "Rank: ",
                                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro'),
                                                      ),
                                                      TextSpan(
                                                          text: clans[index].rank != null ? clans[index].rank.toString() : "0" , style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w700, fontFamily: 'SourceSerifPro')),
                                                    ]),
                                                  )
                                                : Text(' ', style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'SourceSerifPro')),
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        ),
                                      )),
                                      clans[index].id != clanId && clans[index].attackStatus == 1
                                          ? Container(
                                              margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                              decoration: BoxDecoration(border: Border.all(color: HexColor("#AD9958")), borderRadius: BorderRadius.circular(4)),
                                              child: GestureDetector(
                                                  onTap: () => showDialogSendInvite(clans[index].name, clans[index].id),
                                                  child: Center(
                                                    child: Image(
                                                      image: AssetImage('assets/images/ic_swords.png'),
                                                    ),
                                                  )),
                                              height: 36,
                                              width: 36,
                                              padding: EdgeInsets.all(8),
                                            )
                                          : Container()
                                    ],
                                  ),
                                  left: 1,
                                  top: 6,
                                  bottom: 6,
                                  right: 1,
                                ),
                              ],
                            ),
                            height: 80,
                          );
                        },
                        shrinkWrap: true,
                        itemCount: clans.length,
                      ))
                    : Container()
              ],
            ),
          ),
        ),
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
                    child: Center(child: textpaintingBoldBase('Bảng xếp hạng', 24, HexColor("#f8e9a5"), HexColor("#681527"),3),),
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
    );
  }

  showDialogSendInvite(String nameClan, int ClanId) async {
    if (isGeneral == false) {
      toast(context, 'Bạn không phải Chủ tướng');
      return;
    }
    if (statusAttack == 0) {
      toast(context, 'Bạn đang ở chế độ phòng thủ');
      return;
    }
    var response = await showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: BlocProvider<HomeCubit>.value(
            value: cubit, //
            child: DialogSendInvite(
              myClanId: this.clanId,
              toClanId: ClanId,
            ),
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
  }
}
