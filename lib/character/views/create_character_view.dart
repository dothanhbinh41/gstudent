import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/Character/character.dart';
import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';
import 'package:gstudent/character/model/UserCharacter.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/define_item/defind_character.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/home/cubit/home_state.dart';
import 'package:gstudent/main.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';

class CreateCharacterView extends StatefulWidget {
  int userClanId;
  int clanId;
  int userId;
  String nameClan;

  CreateCharacterView(
      {this.userClanId, this.nameClan, this.userId, this.clanId});

  @override
  State<StatefulWidget> createState() => CreateCharacterViewState(
      userClanId: this.userClanId,
      nameClan: this.nameClan,
      clanId: this.clanId,
      userId: this.userId);
}

class CreateCharacterViewState extends State<CreateCharacterView> {
  int userClanId;
  int clanId;
  int userId;
  String nameClan;

  CreateCharacterViewState(
      {this.userClanId, this.nameClan, this.userId, this.clanId});

  HomeCubit cubit;

  List<Character> chars;
  List<UserCharacter> charImgs = [
    CharacterById(1),
    CharacterById(2),
    CharacterById(3),
    CharacterById(4),
    CharacterById(5),
    CharacterById(6),
    CharacterById(7),
    CharacterById(8),
    CharacterById(9),
    CharacterById(11),
    CharacterById(12),
  ];
  int position = 0;
  Character currentChar;
  bool isExpanded = false;
  String nameChar;
  PageController controller;
  bool isFocus = false;
  FocusNode _focus = new FocusNode();
  ClanDetail clan;
  final viewInsets = EdgeInsets.fromWindowPadding(
      WidgetsBinding.instance.window.viewInsets,
      WidgetsBinding.instance.window.devicePixelRatio);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<HomeCubit>(context);
    loadImage();
    loadData();
    CharacterById(1);
    controller = PageController(
      initialPage: position,
      keepPage: false,
      viewportFraction: 0.9,
    );
    _focus.addListener(_onFocusChange);
  }

  loadClan() async {
    var res = await cubit.getDetailCLan(clanId);
    if (res != null) {
      setState(() {
        clan = res;
        clan.userClans
            .where((element) => element.characterId != null)
            .toList()
            .forEach((element) {
          var char = CharacterById(element.characterId);
          var listRemove = charImgs
              .where((c) => c.specialAction == char.specialAction)
              .toList();
          listRemove.forEach((d) {
            charImgs.remove(charImgs
                .where((e) => e.specialAction == d.specialAction)
                .first);
            chars.remove(
                chars.where((e) => e.characterClass == d.classCharacter).first);
          });
        });
        currentChar = chars[position];
      });
    }
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      setState(() {
        isFocus = true;
      });
    } else {
      disableFocus();
    }
  }

  disableFocus() {
    SystemChannels.textInput.invokeListMethod("TextInput.hide");
    _focus.unfocus();
    setState(() {
      isExpanded = false;
      isFocus = false;
    });
  }

  loadData() async {
    showLoading();
    var res = await cubit.getAllCharacter();
    hideLoading();
    if (res != null && res.length > 0) {
      setState(() {
        chars = res;
        loadClan();
      });
    }
  }

  AssetImage bgDialog;

  loadImage() {
    bgDialog = AssetImage('assets/bg_create_character.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgDialog, context);
    precacheImage(AssetImage('assets/alchemist_nam.png'), context);
    precacheImage(AssetImage('assets/warrior_nam.png'), context);
    precacheImage(AssetImage('assets/healer_nam.png'), context);
    precacheImage(AssetImage('assets/thief_nam.png'), context);
    precacheImage(AssetImage('assets/alchemist_nam.png'), context);
    precacheImage(AssetImage('assets/thief_nu.png'), context);
    precacheImage(AssetImage('assets/warrior_nu.png'), context);
    precacheImage(AssetImage('assets/alchemist_nu.png'), context);
    precacheImage(AssetImage('assets/healer_nu.png'), context);
    precacheImage(AssetImage('assets/princess.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
      resizeToAvoidBottomInset: false,
    );
  }

  content() {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {},
      child: Stack(
        children: [
          Positioned(
            child: GestureDetector(
              onTap: () => disableFocus(),
              child: Image(
                image: bgDialog,
                fit: BoxFit.fill,
              ),
            ),
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          Positioned(
            child: GestureDetector(
              onTap: () => disableFocus(),
              child: SafeArea(
                right: false,
                left: false,
                child: Column(
                  children: [
                    Container(
                      height: 48,
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Stack(
                        children: [
                          Positioned(
                              child: Container(
                                child: Stack(
                                  children: [
                                    Positioned(
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/title_result.png'),
                                          fit: BoxFit.fill,
                                        ),
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0),
                                    Positioned(
                                      child: Center(
                                          child: textpainting(
                                              'Team ' + nameClan, 20)),
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
                                image: AssetImage(
                                    'assets/images/game_close_dialog_clan.png'),
                                height: 48,
                                width: 48,
                              ),
                            ),
                            top: 0,
                            left: 16,
                            bottom: 0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                              child:GestureDetector(
                                onTap : () => selectCharacter(clan.userClans
                                    .where((element) =>
                                element.characterId ==
                                   1 ||
                                    element.characterId == 2)
                                    .isEmpty,1 , 2),
                                child:  Container(
                                  margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 52,
                                        width: 52,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            borderRadius: BorderRadius.circular(26),
                                            color:
                                            HexColor("#FFCF38").withOpacity(0.8)),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/game_fight_icon.png'),
                                                height: 40,
                                                width: 40,
                                              ),
                                            ),
                                            Visibility(
                                              visible: !(chars != null &&
                                                  (chars[position].id == 2 ||
                                                      chars[position].id == 1)) ||
                                                  clan != null &&
                                                      clan.userClans
                                                          .where((element) =>
                                                      element.characterId ==
                                                          2 ||
                                                          element.characterId == 1)
                                                          .isNotEmpty,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(30),
                                                    color:
                                                    Colors.black.withOpacity(0.5)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      clan != null &&
                                          clan.userClans
                                              .where((element) =>
                                          element.characterId == 2 ||
                                              element.characterId == 1)
                                              .isNotEmpty
                                          ? Text(
                                        clan.userClans
                                            .where((element) =>
                                        element.characterId == 2 ||
                                            element.characterId == 1)
                                            .first
                                            .nickname,
                                        overflow: TextOverflow.ellipsis,
                                        style: ThemeStyles.styleNormal(
                                            font: 14, textColors: Colors.white),
                                      )
                                          :  Visibility(
                                        visible: currentChar != null &&( currentChar.id == 1 || currentChar.id == 2),
                                        child: Text(
                                          "●",
                                          overflow: TextOverflow.ellipsis,
                                          style: ThemeStyles.styleNormal(
                                              font: 14, textColors: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                  height: 80,
                                ),
                              )),
                          Expanded(
                              child: GestureDetector(
    onTap : () => selectCharacter(clan.userClans
        .where((element) =>
    element.characterId ==
    5 ||
    element.characterId == 6)
        .isEmpty,5 , 6),
    child:
      Container(
                            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                            height: 80,
                            child: Column(
                                children: [
                                  Container(
                                    height: 52,
                                    width: 52,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        borderRadius: BorderRadius.circular(26),
                                        color:
                                            HexColor("#FFCF38").withOpacity(0.8)),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image(
                                            image: AssetImage(
                                                'assets/images/icon_steal.png'),
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                        Visibility(
                                          visible: !(chars != null &&
                                                  (chars[position].id == 5 ||
                                                      chars[position].id == 6)) ||
                                              clan != null &&
                                                  clan.userClans
                                                      .where((element) =>
                                                          element.characterId ==
                                                              5 ||
                                                          element.characterId == 6)
                                                      .isNotEmpty,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color:
                                                    Colors.black.withOpacity(0.5)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  clan != null &&
                                          clan.userClans
                                              .where((element) =>
                                                  element.characterId == 5 ||
                                                  element.characterId == 6)
                                              .isNotEmpty
                                      ? Text(
                                          clan.userClans
                                              .where((element) =>
                                                  element.characterId == 5 ||
                                                  element.characterId == 6)
                                              .first
                                              .nickname,
                                          overflow: TextOverflow.ellipsis,
                                          style: ThemeStyles.styleNormal(
                                              font: 14, textColors: Colors.white),
                                        )
                                      :  Visibility(
                                    visible: currentChar != null &&  (currentChar.id == 5 || currentChar.id == 6),
                                    child: Text(
                                      "●",
                                      overflow: TextOverflow.ellipsis,
                                      style: ThemeStyles.styleNormal(
                                          font: 14, textColors: Colors.white),
                                    ),
                                  )
                                ],
                            ),
                          ),
                              )),
                          Expanded(
                              child: GestureDetector(
                                onTap : () => selectCharacter(clan.userClans
                                    .where((element) =>
                                element.characterId ==
                                    7 ||
                                    element.characterId == 8)
                                    .isEmpty,7, 8),
                                child:  Container(
                            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                            height: 80,
                            child: Column(
                                children: [
                                  Container(
                                    height: 52,
                                    width: 52,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        borderRadius: BorderRadius.circular(26),
                                        color:
                                            HexColor("#FFCF38").withOpacity(0.8)),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image(
                                            image: AssetImage(
                                                'assets/images/icon_forge.png'),
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                        Visibility(
                                          visible: !(chars != null &&
                                                  (chars[position].id == 7 ||
                                                      chars[position].id == 8)) ||
                                              clan != null &&
                                                  clan.userClans
                                                      .where((element) =>
                                                          element.characterId ==
                                                              7 ||
                                                          element.characterId == 8)
                                                      .isNotEmpty,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color:
                                                    Colors.black.withOpacity(0.5)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  clan != null &&
                                          clan.userClans
                                              .where((element) =>
                                                  element.characterId == 7 ||
                                                  element.characterId == 8)
                                              .isNotEmpty
                                      ? Text(
                                          clan.userClans
                                              .where((element) =>
                                                  element.characterId == 7 ||
                                                  element.characterId == 8)
                                              .first
                                              .nickname,
                                          overflow: TextOverflow.ellipsis,
                                          style: ThemeStyles.styleNormal(
                                              font: 14, textColors: Colors.white),
                                        )
                                      :  Visibility(
                                    visible:currentChar != null && ( currentChar.id == 7 || currentChar.id ==8),
                                    child: Text(
                                      "●",
                                      overflow: TextOverflow.ellipsis,
                                      style: ThemeStyles.styleNormal(
                                          font: 14, textColors: Colors.white),
                                    ),
                                  )
                                ],
                            ),
                          ),
                              )),
                          Expanded(
                              child: GestureDetector(
                                onTap : () => selectCharacter(clan.userClans
                                    .where((element) =>
                                element.characterId ==
                                   11 ||
                                    element.characterId == 12)
                                    .isEmpty,11 ,12),
                                child:   Container(
                            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                            height: 80,
                            child: Column(
                                children: [
                                  Container(
                                    height: 52,
                                    width: 52,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        borderRadius: BorderRadius.circular(26),
                                        color:
                                            HexColor("#FFCF38").withOpacity(0.8)),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image(
                                            image: AssetImage(
                                                'assets/images/icon_defend.png'),
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                        Visibility(
                                          visible: !(chars != null &&
                                                  (chars[position].id == 12 ||
                                                      chars[position].id == 11)) ||
                                              clan != null &&
                                                  clan.userClans
                                                      .where((element) =>
                                                          element.characterId ==
                                                              11 ||
                                                          element.characterId == 12)
                                                      .isNotEmpty,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color:
                                                    Colors.black.withOpacity(0.5)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  clan != null &&
                                          clan.userClans
                                              .where((element) =>
                                                  element.characterId == 11 ||
                                                  element.characterId == 12)
                                              .isNotEmpty
                                      ? Text(
                                          clan.userClans
                                              .where((element) =>
                                                  element.characterId == 11 ||
                                                  element.characterId == 12)
                                              .first
                                              .nickname,
                                          overflow: TextOverflow.ellipsis,
                                          style: ThemeStyles.styleNormal(
                                              font: 14, textColors: Colors.white),
                                        )
                                      : Visibility(
                                    visible:currentChar != null &&  ( currentChar.id == 11 || currentChar.id == 12),
                                    child: Text(
                                      "●",
                                      overflow: TextOverflow.ellipsis,
                                      style: ThemeStyles.styleNormal(
                                          font: 14, textColors: Colors.white),
                                    ),
                                  )
                                ],
                            ),
                          ),
                              )),
                          Expanded(
                              child: GestureDetector(
                                onTap : () => selectCharacter(clan.userClans
                                    .where((element) =>
                                element.characterId ==
                                    3 ||
                                    element.characterId == 4)
                                    .isEmpty,3 , 4),
                                child: Container(
                            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                            height: 80,
                            child: Column(
                                children: [
                                  Container(
                                    height: 52,
                                    width: 52,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        borderRadius: BorderRadius.circular(26),
                                        color:
                                            HexColor("#FFCF38").withOpacity(0.8)),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image(
                                            image: AssetImage(
                                                'assets/images/icon_knitting_practice.png'),
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                        Visibility(
                                          visible: !(chars != null &&
                                                  (chars[position].id == 3 ||
                                                      chars[position].id == 4)) ||
                                              clan != null &&
                                                  clan.userClans
                                                      .where((element) =>
                                                          element.characterId ==
                                                              3 ||
                                                          element.characterId == 4)
                                                      .isNotEmpty,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color:
                                                    Colors.black.withOpacity(0.5)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  clan != null &&
                                          clan.userClans
                                              .where((element) =>
                                                  element.characterId == 3 ||
                                                  element.characterId == 4)
                                              .isNotEmpty
                                      ? Text(
                                          clan.userClans
                                              .where((element) =>
                                                  element.characterId == 3 ||
                                                  element.characterId == 4)
                                              .first
                                              .nickname,
                                          overflow: TextOverflow.ellipsis,
                                          style: ThemeStyles.styleNormal(
                                              font: 14, textColors: Colors.white),
                                        )
                                      : Visibility(
                                    visible:currentChar != null && ( currentChar.id == 3 || currentChar.id == 4),
                                    child: Text(
                                      "●",
                                      overflow: TextOverflow.ellipsis,
                                      style: ThemeStyles.styleNormal(
                                          font: 14, textColors: Colors.white),
                                    ),
                                  )
                                ],
                            ),
                          ),
                              )),
                          Expanded(
                              child:GestureDetector(
                                onTap : () => selectCharacter(clan.userClans
                                    .where((element) =>
                                element.characterId ==
                                    9 ||
                                    element.characterId == 9)
                                    .isEmpty,9, 9),
                                child: Container(
                            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                            height: 80,
                            child: Column(
                                children: [
                                  Container(
                                    height: 52,
                                    width: 52,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        borderRadius: BorderRadius.circular(26),
                                        color:
                                            HexColor("#FFCF38").withOpacity(0.8)),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          bottom: 0,
                                          right: 0,
                                          left: 0,
                                          child: Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/icon_encourage.png'),
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
                                            visible: !(chars != null &&
                                                    chars[position].id == 9) ||
                                                (clan != null &&
                                                    clan.userClans
                                                        .where((element) =>
                                                            element.characterId ==
                                                            9)
                                                        .isNotEmpty),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.black
                                                      .withOpacity(0.5)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  clan != null &&
                                          clan.userClans
                                              .where((element) =>
                                                  element.characterId == 9)
                                              .isNotEmpty
                                      ? Text(
                                          clan.userClans
                                              .where((element) =>
                                                  element.characterId == 9)
                                              .first
                                              .nickname,
                                          overflow: TextOverflow.ellipsis,
                                          style: ThemeStyles.styleNormal(
                                              font: 14, textColors: Colors.white),
                                        )
                                      : Visibility(
                                          visible:currentChar != null &&  currentChar.id == 9,
                                          child: Text(
                                            "●",
                                            overflow: TextOverflow.ellipsis,
                                            style: ThemeStyles.styleNormal(
                                                font: 14, textColors: Colors.white),
                                          ),
                                        )
                                ],
                            ),
                          ),
                              )),
                        ],
                      ),
                    ),
                    chars != null && chars.length > 0
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Stack(
                              children: [
                                Positioned(
                                  child: Center(
                                    child: Text(
                                      currentChar != null ? currentChar.name : "",
                                      style: TextStyle(
                                          fontFamily: 'SourceSerifPro',
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                  ),
                                  top: 0,
                                  right: 0,
                                  left: 0,
                                ),
                                Positioned(
                                  child: Image(
                                    image: AssetImage(
                                        'assets/game_bg_create_character.png'),
                                  ),
                                  bottom: 24,
                                  height: 200,
                                  right: 0,
                                  left: 0,
                                ),
                                Positioned(
                                  child: Container(
                                    child: PageView.builder(
                                      onPageChanged: (value) {
                                        setState(() {
                                          print(value);
                                          position = value;
                                          currentChar = chars[position];
                                        });
                                      },
                                      controller: controller,
                                      itemBuilder: (context, index) =>
                                          builder(index),
                                      itemCount: charImgs.length,
                                    ),
                                  ),
                                  left: 0,
                                  top: 48,
                                  right: 0,
                                  bottom:24,
                                ),
                                Positioned(
                                  child: buttonleft(),
                                  top: 0,
                                  left: 24,
                                  bottom: 0,
                                ),
                                Positioned(
                                  child: buttonRight(),
                                  top: 0,
                                  right: 24,
                                  bottom: 0,
                                ),
                                AnimatedPositioned(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isExpanded = true;
                                        });
                                      },
                                      child: Container(
                                        child: Center(
                                          child: Text(
                                            'Thông tin thêm',
                                            style: ThemeStyles.styleNormal(
                                                font: 14,
                                                textColors: Colors.white),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        padding: EdgeInsets.all(8),
                                      ),
                                    ),
                                    height: isExpanded ? 0 : 36,
                                    top: 16,
                                    right: 16,
                                    duration: Duration(milliseconds: 500)),
                                AnimatedPositioned(
                                    child: currentChar != null
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isExpanded = false;
                                              });
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.fromLTRB(
                                                  16, 8, 16, 8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: HexColor("#EC9C20")
                                                      .withOpacity(0.8)),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        8, 8, 8, 8),
                                                    child: Text(
                                                        currentChar.family +
                                                            '\n' +
                                                            'Tính cách : ' +
                                                            currentChar
                                                                .personality +
                                                            '\n' +
                                                            'Năng lực : ' +
                                                            currentChar.ability,
                                                        style: ThemeStyles
                                                            .styleNormal(
                                                                font: 14)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    duration: Duration(milliseconds: 500),
                                    height: isExpanded
                                        ? MediaQuery.of(context).size.height *
                                            0.16
                                        : 0,
                                    top: 0,
                                    right: 0,
                                    left: isExpanded
                                        ? 0
                                        : MediaQuery.of(context).size.width)
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          KeyboardAware(
            builder: (context, configuracaoTeclado) {
              return AnimatedPositioned(
                child: Container(
                  height: 48,
                  margin: EdgeInsets.fromLTRB(24, 8, 24, 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: HexColor("#6e4533") ,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 1), color: HexColor("#FFE1B2").withOpacity(0.4))
                      ]),
                  child: TextField(
                    focusNode: _focus,
                    onChanged: (value) {
                      setState(() {
                        nameChar = value;
                      });
                    },
                    style: ThemeStyles.styleNormal(
                        textColors: HexColor("#FFE1B2")),
                    decoration: new InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        hintText: 'Nhập tên nhân vật ',
                        hintStyle: ThemeStyles.styleNormal(
                            textColors: HexColor("#FFE1B2"))),
                  ),
                ),
                duration: Duration(milliseconds: 50),
                right: 0,
                left: 0,
                bottom: isFocus ? configuracaoTeclado.keyboardHeight + 80 : 64,
              );
            },
          ),
          Positioned(
            child: Container(
              child: Center(
                child: GestureDetector(
                  onTap: () => createChar(),
                  child: Container(
                    width: 120,
                    height: 48,
                    child: ButtonGraySmall("TẠO"),
                  ),
                ),
              ),
            ),
            right: 0,
            left: 0,
            bottom: 8,
          ),
        ],
      ),
    );
  }

  builder(int index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = controller.page - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * 300,
            width: Curves.easeOut.transform(value) * 250,
            child: child,
          ),
        );
      },
      child: Container(
        child: Image(
          image: AssetImage(charImgs[index].imageCharacter),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  buttonleft() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (position == 0) {
            position = chars.length - 1;
          } else {
            position--;
          }
          controller.animateToPage(position,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          currentChar = chars[position];
        });
      },
      child: Container(
        alignment: Alignment.centerLeft,
        child: Image(
          image: AssetImage('assets/images/game_select_character_left.png'),
          height: 40,
        ),
      ),
    );
  }

  buttonRight() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (position == chars.length - 1) {
            position = 0;
          } else {
            position++;
          }
          controller.animateToPage(position,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          currentChar = chars[position];
        });
      },
      child: Container(
        alignment: Alignment.centerRight,
        child: Image(
          image: AssetImage('assets/images/game_select_character_right.png'),
          height: 40,
        ),
      ),
    );
  }

  textpainting(String s, double fontSize) {
    return OutlinedText(
      text: Text(s,
          textAlign: TextAlign.justify,
          style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'SourceSerifPro',
              fontWeight: FontWeight.bold,
              color: HexColor("#f8e9a5"))),
      strokes: [
        OutlinedTextStroke(color: HexColor("#681527"), width: 3),
      ],
    );
  }

  createChar() async {
    if (nameChar == null || nameChar.isEmpty) {
      toast(context, "Tên nhân vật không được bỏ trống");
      return;
    }
    showLoading();
    var characterId = currentChar.id;
    var res = await cubit.createCharacter(userClanId, characterId, nameChar);
    hideLoading();
    if (res == null) {
      toast(context, "Something went wrong please contact with center");
      return;
    }

    if (res.error == true) {
      toast(context, res.message);
      return;
    }
    Navigator.of(context).pop(characterId);
  }

  selectCharacter(bool isEmpty, int i, int j) {
    if(isEmpty){
    var pos =  chars.indexOf( chars.where((element) => element.id==i).first);
      controller.jumpToPage(pos);
      setState(() {
        currentChar = chars[pos];
        position = pos;
      });
    }
  }
}
