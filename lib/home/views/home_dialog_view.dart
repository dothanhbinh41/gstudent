import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/character/views/character_view.dart';
import 'package:gstudent/clan/views/clan_view.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/home/views/inventory_view.dart';
import 'package:gstudent/mission/views/mission_view.dart';
import 'package:gstudent/settings/views/settings_view.dart';

enum ViewDialogHome { character, mission, clan, settings, inventory }

class HomeDialogView extends StatefulWidget {
  int classroomId;
  int userClanId;
  int clanId;
  ViewDialogHome view;
  HomeCubit cubit;

  HomeDialogView({this.view, this.cubit,this.classroomId,this.userClanId,this.clanId});

  @override
  State<HomeDialogView> createState() =>
      HomeDialogViewState(view: this.view, cubit: this.cubit,classroomId: this.classroomId,userClanId:this.userClanId,clanId: this.clanId);
}

class HomeDialogViewState extends State<HomeDialogView> {
  ViewDialogHome view;
  HomeCubit cubit;
  int classroomId;
  int userClanId;
  int clanId;
  HomeDialogViewState({this.view, this.cubit,this.classroomId,this.userClanId,this.clanId});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: view != ViewDialogHome.inventory ? true : false,
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: contentView(),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Stack(
                  children: [
                    Positioned(
                        top: 20,
                        bottom: 0,
                        right: -20,
                        left: -20,
                        child: Container(
                          child: Image(
                            image: AssetImage('assets/images/game_bg_bottom.png'),
                            fit: BoxFit.fill,
                          ),
                        )),
                    Row(
                      children: [
                        inven(),
                        character(),
                        mission(),
                        clan(),
                        setting()
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  contentView() {
    switch (this.view) {
      case ViewDialogHome.character:
        return CharacterDialog(userClanId: userClanId, clanId: this.clanId,);
      case ViewDialogHome.mission:
        return MissionDialog(classroomId:this.classroomId ,);
      case ViewDialogHome.settings:
        return SettingDialog(
          classroomId: this.classroomId,
            userClanId: this.userClanId
        );
      case ViewDialogHome.inventory:
        return InventoryDialog(
          cubit: cubit,
          userClanId: this.userClanId,
        );
      case ViewDialogHome.clan:
        Navigator.of(context).pop(ViewDialogHome.clan);
        return Container();
    }
  }

  text(String s, double fontSize, ViewDialogHome v) {
    return Container(
      child: textpaintingBoldBase(s, fontSize, this.view == v ? Colors.blueAccent : Colors.white,Colors.black,3),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color:
                      this.view == v ? Colors.blueAccent : Colors.transparent,
                  width: 2))),
    );
  }

  inven() {
    return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              this.view = ViewDialogHome.inventory;
            });
          },
          child: Column(
      children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/game_inventory_icon.png'),
            ),
            height: 60,
          ),
          text('Túi Đồ', 14, ViewDialogHome.inventory),
      ],
    ),
        ));
  }

  character() {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        setState(() {
          this.view = ViewDialogHome.character;
        });
      },
      child: Column(
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/game_character_icon.png'),
            ),
            height: 60,
          ),
          text('Nhân vật', 14, ViewDialogHome.character),
        ],
      ),
    ));
  }

  mission() {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        setState(() {
          this.view = ViewDialogHome.mission;
        });
      },
      child: Column(
        children: [
          Container(
            child: iconMission(),
            height: 60,
            width: 80,
          ),
          text('Nhiệm Vụ', 14, ViewDialogHome.mission),
        ],
      ),
    ));
  }

  clan() {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        setState(() {
          this.view = ViewDialogHome.clan;
        });
      },
      child: Column(
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/game_clan_icon.png'),
            ),
            height: 60,
          ),
          text('Team', 14, ViewDialogHome.clan),

        ],
      ),
    ));
  }

  setting() {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        setState(() {
          this.view = ViewDialogHome.settings;
        });
      },
      child: Column(
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/game_setting_icon.png'),
            ),
            height: 60,
          ),
          text('Cài Đặt', 14, ViewDialogHome.settings),
        ],
      ),
    ));
  }

  iconMission() {
    return Stack(
      children: [
        Container(
          child: Image(
            image: AssetImage('assets/images/game_mission.png'),
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: Image(
            image: AssetImage('assets/images/game_noti_icon.png'),
            height: 32,
            width: 32,
          ),
        )
      ],
    );
  }

  void showDialogAsync() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ClanDialog();
        });
  }

  decoration() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
      height: 1.0,
      decoration: BoxDecoration(color: HexColor("#b0a27b")),
    );
  }
}
