import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Authentication/user_info.dart';
import 'package:gstudent/api/dtos/Clan/create_clan_reponse.dart';
import 'package:gstudent/api/dtos/Clan/info_user_clan.dart';
import 'package:gstudent/api/dtos/Course/course.dart';
import 'package:gstudent/api/dtos/homework/submit_response.dart';
import 'package:gstudent/api/dtos/noti/notification_model.dart';
import 'package:gstudent/character/services/character_services.dart';
import 'package:gstudent/clan/services/clan_services.dart';
import 'package:gstudent/clan/views/clan_view/clan_view.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/hp_progress_bar.dart';
import 'package:gstudent/common/controls/mp_progress_bar.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/define_item/defind_character.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/home/cubit/home_state.dart';
import 'package:gstudent/home/model/result_data_homework.dart';
import 'package:gstudent/home/services/home_services.dart';
import 'package:gstudent/home/services/route_services.dart';
import 'package:gstudent/homework/cubit/homework_cubit.dart';
import 'package:gstudent/homework/views/homework_view.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/map/cubit/map_cubit.dart';
import 'package:gstudent/mission/services/MissionService.dart';
import 'package:gstudent/result/views/result_homework.dart';
import 'package:gstudent/result/views/result_homework_advance.dart';
import 'package:gstudent/result/views/result_test_route.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:gstudent/settings/views/notification_dialog.dart';
import 'package:gstudent/settings/views/notification_view.dart';
import 'package:gstudent/special/services/special_service.dart';
import 'package:gstudent/special/views/attack_view.dart';
import 'package:gstudent/special/views/knitting_practice_view.dart';
import 'package:gstudent/training/cubit/vocab_cubit.dart';
import 'package:gstudent/training/services/vocab_services.dart';
import 'package:gstudent/training/views/training_dialog.dart';
import 'package:gstudent/training/views/vocab/vocabulary_practice.dart';
import 'package:gstudent/waiting/views/waiting_training_vocab.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../map/views/map_route_view.dart';
import '../../special/views/steal_view.dart';
import 'home_dialog_view.dart';

class HomeGamePage extends StatefulWidget {
  CourseModel courses;

  HomeGamePage({this.courses});

  @override
  State<StatefulWidget> createState() =>
      HomeGamePageState(currentCourse: this.courses);
}

class HomeGamePageState extends State<HomeGamePage> {
  // List<CourseModel> courses;

  HomeGamePageState({this.currentCourse});

  ApplicationSettings settings;
  int clanId;
  int characterId;
  HomeCubit cubit;
  int userClanId;
  User user;
  CourseModel currentCourse;
  DataCreateClanReponse dataClan;
  UserClanInfo characterInfo;
  int quantitySpecial = 0;
  List<NotificationModel> notifications;

  @override
  void initState() {
    super.initState();
    settings = GetIt.instance.get<ApplicationSettings>();
    cubit = BlocProvider.of<HomeCubit>(context);
    loadData();
    setupSocket();
    loadImage();
  }

  void setupSocket() async {
    Socket socket = io(
        'ws://socket.edutalk.edu.vn',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());
    socket.connect();
    socket.onConnect((data) {
      print("socket connect : " + socket.connected.toString());
      socket.on('noti-clan-join-arena-' + clanId.toString(), (data) async {

      });
    });
  }

  loadData() async {
    if (currentCourse != null && currentCourse.clan != null) {
      clanId = currentCourse.clan.id;
      characterId = currentCourse.clan.characterId;
      var loginRes = await settings.getCurrentUser();
      user = loginRes.userInfo;
      if (user.character == null) {
        user.character = CharacterById(characterId);
        loginRes.userInfo = user;
        await settings.saveLocalCharacterUser(user.character);
      }
      char = AssetImage(user.character.imageCharacter);
      userClanId = currentCourse.clan.userClanId != null
          ? currentCourse.clan.userClanId
          : null;
    }
    Future.wait([getAllNoti(), getInfoUserClan(), getQualitySpecial()]);
  }

  Future getInfoUserClan() async {
    var res = await cubit.getInfoUser(userClanId);
    if (res != null) {
      setState(() {
        characterInfo = null;
        Future.delayed(Duration(milliseconds: 200)).whenComplete(() {
          setState(() {
            characterInfo = res;
          });
        });
      });
    }
  }

  Future getQualitySpecial() async {
    var q = await cubit.getQuantitySpecial(currentCourse.clan.userClanId);
    if (q != null) {
      setState(() {
        quantitySpecial = q.data;
      });
    }
  }

  Future getAllNoti() async {
  try{
    var notis = await cubit.getAllNotification();
    if (notis != null && notis.isNotEmpty) {
      setState(() {
        notifications = notis;
      });
    }
  }catch(e){

  }
  }

  AssetImage bgGame;
  AssetImage bgHeader;
  AssetImage char;

  loadImage() {
    bgGame = AssetImage('assets/bg_login_view.png');
    bgHeader = AssetImage('assets/images/game_bg_header.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGame, context);
    precacheImage(bgHeader, context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {},
          child: Stack(
            children: [
              Positioned(
                top: 90,
                bottom: 40,
                right: 0,
                left: 0,
                child: characterUnit(),
              ),
              Positioned(
                child: inventory(),
                bottom: 120,
                left: 16,
              ),
              Positioned(
                child: fight(),
                bottom: 120,
                right: 16,
              ),
              // Positioned(
              //   child: notify(),
              //   top: 120,
              //   left: 16,
              //   height: 60,
              // ),
              header(),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                    child: Stack(
                  children: [
                    backgroundBottom(),
                    Row(
                      children: [
                        map(),
                        trainingRoom(),
                        mission(),
                        clan(),
                        setting()
                      ],
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  characterUnit() {
    return Container(
        child: Stack(
      children: [
        Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Image(
              image: bgGame,
              fit: BoxFit.fill,
            )),
        Positioned(
          child: (characterInfo != null ||
                      (currentCourse.clan != null &&
                          currentCourse.clan.characterId != null)) &&
                  char != null
              ? Hero(
            tag: 'character',
                child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Image(
                      image: char ?? 'assets/ninja_nam.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
              )
              : Container(),
          left: 1,
          right: 1,
          bottom: 48,
        ),
      ],
    ));
  }

  inventory() {
    return GestureDetector(
      onTap: () => showDialogAsync(ViewDialogHome.inventory, useTop: false),
      child: Column(
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/game_inventory_icon.png'),
            ),
            height: 60,
          ),
          textpaintingBoldBase('Túi đồ', 14, Colors.white, Colors.black, 3)
        ],
      ),
    );
  }

  fight() {
    return GestureDetector(
      onTap: () => specialClick(),
      child: user != null && user.character != null
          ? Column(
              children: [
                Container(
                  child: Stack(
                    children: [
                      Image(
                        image: AssetImage(user.character.specialAction),
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        child: Container(
                          height: 16,
                          width: 16,
                          child: Center(
                            child: textpaintingBase(quantitySpecial.toString(),
                                14, Colors.white, Colors.black, 2),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white70),
                        ),
                        top: 0,
                        left: 0,
                        height: 16,
                        width: 16,
                      )
                    ],
                  ),
                  height: 60,
                ),
                textpaintingBoldBase(user.character.specialTitle, 14,
                    Colors.white, Colors.black, 3)
              ],
            )
          : Container(),
    );
  }

  map() {
    return Expanded(
        child: GestureDetector(
      onTap: () => navigateToRoute(),
      child: Column(
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/game_map_icon.png'),
            ),
            height: 60,
          ),
          textpaintingBoldBase('Bản đồ', 12, Colors.white, Colors.black, 3)
        ],
      ),
    ));
  }

  trainingRoom() {
    return Expanded(
        child: GestureDetector(
      onTap: () => showDialogTrainingRoom(),
      child: Column(
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/icon_trainning.png'),
              fit: BoxFit.fitWidth,
            ),
            height: 60,
          ),
         FittedBox(child:  textpaintingBoldBase(
             'Phòng luyện', 12, Colors.white, Colors.black, 3),),
        ],
      ),
    ));
  }

  mission() {
    return Expanded(
        child: GestureDetector(
      onTap: () => showDialogAsync(ViewDialogHome.mission),
      child: Column(
        children: [
          Container(
            child: iconMission(),
            height: 60,
            width: 80,
          ),
          textpaintingBoldBase('Nhiệm vụ', 12, Colors.white, Colors.black, 3)
        ],
      ),
    ));
  }

  clan() {
    return Expanded(
        child: GestureDetector(
      child: Column(
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/game_clan_icon.png'),
            ),
            height: 60,
          ),
          textpaintingBoldBase('Team', 12, Colors.white, Colors.black, 3)
        ],
      ),
      onTap: () => showDialogClan(),
    ));
  }

  setting() {
    return Expanded(
        child: GestureDetector(
      onTap: () => showDialogAsync(ViewDialogHome.settings),
      child: Column(
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/game_setting_icon.png'),
            ),
            height: 60,
          ),
          textpaintingBoldBase('Cài đặt', 12, Colors.white, Colors.black, 3)
        ],
      ),
    ));
  }

  showDialogClan({String slugTitle}) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BlocProvider.value(
          value: HomeCubit(
              clanService: cubit.clanService,
              homeService: cubit.homeService,
              settings: cubit.settings,
              characterService: cubit.characterService),
          child: ClanView(
            imageHero: char.assetName,
            slugMission: slugTitle,
            clanId: clanId,
            courseId: currentCourse.courseId,
            userClanId: this.userClanId,
          )),
    ));
    loadData();
    cubit.emit(HomeStateInitial());
  }

  void showDialogAsync(ViewDialogHome viewHome, {bool useTop = true}) async {
    var result = await showDialog(
        context: context,
        useSafeArea: false,
        builder: (BuildContext context) {
          return BlocProvider<HomeCubit>.value(
            value: cubit, //
            child: HomeDialogView(
              view: viewHome,
              classroomId: currentCourse.classroomId,
              cubit: cubit,
              userClanId: userClanId,
              clanId: this.clanId,
            ),
          );
        });
    loadData();

    cubit.emit(HomeStateInitial());

    if (result is String) {
      print(result);
      doMissionAsync(result);
    } else {
      if (result == ViewDialogHome.clan) {
        showDialogClan();
      }
    }
  }

  header() {
    return Container(
      child: Stack(
        children: [
          Positioned(
            top: -10,
            right: -10,
            left: -10,
            child: Container(
                child: Image(
              image: bgHeader,
              fit: BoxFit.fill,
            )),
          ),
          Positioned(
              width: 56,
              top: 16,
              right: MediaQuery.of(context).size.width * 0.05,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: iconNotification(),
              )),
          characterInfo != null ||
                  (currentCourse.clan != null &&
                      currentCourse.clan.characterId != null)
              ? Positioned(
                  left: MediaQuery.of(context).size.width * 0.05,
                  top: 20,
                  width: MediaQuery.of(context).size.width > 600
                      ? (MediaQuery.of(context).size.width * 0.4)
                      : 240,
                  child: SafeArea(
                    top: false,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 24,
                          width: MediaQuery.of(context).size.width > 600
                              ? (MediaQuery.of(context).size.width * 0.4) - 80
                              : 160,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: textpaintingBoldBase(
                                              characterInfo != null &&
                                                      characterInfo.nickName !=
                                                          null
                                                  ? characterInfo.nickName
                                                  : "",
                                              14,
                                              Colors.white,
                                              Colors.black,
                                              3),
                                          margin:
                                              EdgeInsets.fromLTRB(4, 0, 4, 0),
                                        ),
                                      ),
                                      characterInfo != null &&
                                              characterInfo.coin != null &&
                                              characterInfo.coin != null
                                          ? Center(
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/game_xu.png'),
                                                height: 16,
                                                width: 16,
                                              ),
                                            )
                                          : Container(),
                                      textpaintingBoldBase(
                                          characterInfo != null &&
                                                  characterInfo.coin != null &&
                                                  characterInfo.coin != null
                                              ? characterInfo.coin.toString()
                                              : "0",
                                          14,
                                          Colors.white,
                                          Colors.black,
                                          3)
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                  ),
                                  margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                ),
                                characterInfo != null
                                    ? HpProgressbar(
                                        current: characterInfo.hp,
                                        total: user.character.totalHp,
                                      )
                                    : Container(),
                                characterInfo != null
                                    ? Container(
                                        child: MpProgressbar(
                                          nextLevel:
                                              characterInfo.nextLevel.nextExp,
                                          exp: characterInfo.exp,
                                        ),
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 40, 0),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              showDialogAsync(ViewDialogHome.character);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  height: 100,
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/game_bg_rank.png'),
                                  ),
                                ),
                                Positioned(
                                  bottom: 04,
                                  top: 04,
                                  right: 04,
                                  left: 04,
                                  child: characterInfo != null &&
                                          characterInfo.levelAvatar != null &&
                                          characterInfo.levelAvatar.isNotEmpty
                                      ? Image.network(
                                          characterInfo.levelAvatar,
                                          fit: BoxFit.fill,
                                        )
                                      : Container(),
                                )
                              ],
                            ),
                          ),
                          height: 100,
                        ),
                        Positioned(
                          child: Stack(
                            children: [
                              Image(
                                image: AssetImage(
                                    'assets/images/background_level.png'),
                              ),
                              Center(child:  textpaintingBoldBase(characterInfo != null && characterInfo.level != null ? characterInfo.level.toString() : '0', 16, Colors.white  , HexColor('#813e8a'), 2))
                            ],
                          ),
                          bottom: 32,
                          left: 72,
                          height: 32,
                          width: 32,
                        ),
                      ],
                    ),
                  ))
              : Container(),
        ],
      ),
    );
  }

  iconNotification() {
    return GestureDetector(
      onTap: () async {
        if (notifications == null || notifications.isEmpty) {
          toast(context, 'Không có thông báo.');
          return;
        }
        await showDialog(
            context: context,
            builder: (buildContext) {
              return NotificationView(notifications: notifications,);
            });


      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: HexColor("#B3471a11"), offset: Offset(1, 1))
              ],
            ),
            child: Image(
              image: AssetImage('assets/images/game_loa_icon.png'),
            ),
          ),
          Positioned(
            child: Container(
              child: Image(
                image: AssetImage('assets/images/game_noti_icon.png'),
                height: 28,
                width: 28,
              ),
            ),
            right: 0,
          )
        ],
      ),
    );
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

  backgroundBottom() {
    return Positioned(
        top: 20,
        right: -20,
        left: -20,
        bottom: 0,
        child: Container(
          child: Image(
            image: AssetImage('assets/images/game_bg_bottom.png'),
            fit: BoxFit.fill,
          ),
        ));
  }

  // notify() {
  //   return Stack(
  //     children: [
  //       Container(
  //         width: MediaQuery.of(context).size.width * 0.8,
  //         decoration: BoxDecoration(
  //           color: HexColor("#66000000"),
  //         ),
  //         child: Center(
  //           child: RunningText(
  //             text: "helo helo lo lo lo ",
  //             marqueeDirection: RunningTextDirection.rtl,
  //             speed: 20,
  //             style: TextStyle(
  //                 color: Colors.white, fontFamily: 'SourceSerifPro-Bold'),
  //             alwaysScroll: true,
  //             onEnd: (value) {},
  //           ),
  //         ),
  //         margin: EdgeInsets.fromLTRB(40, 8, 16, 8),
  //       ),
  //       Container(
  //         child: Stack(
  //           children: [
  //             Container(
  //               height: 60,
  //               width: 60,
  //               child: Stack(
  //                 children: [
  //                   Image(
  //                     image:
  //                         AssetImage('assets/images/game_bg_notification.png'),
  //                   ),
  //                   Center(
  //                     child: Image(
  //                       image: AssetImage('assets/images/game_loa_icon.png'),
  //                       height: 48,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             Positioned(
  //               child: Image(
  //                 image: AssetImage('assets/images/game_noti_icon.png'),
  //                 height: 24,
  //                 width: 24,
  //               ),
  //               top: 0,
  //               right: 0,
  //             )
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  specialClick() async {
    if (quantitySpecial == 0) {
      toast(context, 'Bạn đã hết lượt sử dụng kỹ năng đặc biệt');
      return;
    }
    var charService = GetIt.instance.get<CharacterService>();
    var clanService = GetIt.instance.get<ClanService>();
    var homeService = GetIt.instance.get<HomeService>();
    var missionService = GetIt.instance.get<MissionService>();
    var specialService = GetIt.instance.get<SpecialService>();

    switch (user.character.characterId) {
      case 1:
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: HomeCubit(
                      settings: settings,
                      characterService: charService,
                      specialService: specialService,
                      missionService: missionService,
                      clanService: clanService,
                      homeService: homeService),
                  child: AttackView(
                    userClanId: currentCourse.clan.userClanId,
                    quantitySpecial: quantitySpecial,
                  ),
                )));
        getQualitySpecial();
        return;
      case 2:
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: HomeCubit(
                      settings: settings,
                      characterService: charService,
                      specialService: specialService,
                      missionService: missionService,
                      clanService: clanService,
                      homeService: homeService),
                  child: AttackView(
                    userClanId: currentCourse.clan.userClanId,
                    quantitySpecial: quantitySpecial,
                  ),
                )));
        getQualitySpecial();
        return;
      case 3:
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: HomeCubit(
                      settings: settings,
                      characterService: charService,
                      specialService: specialService,
                      missionService: missionService,
                      clanService: clanService,
                      homeService: homeService),
                  child: KnittingPracticeView(
                      ClanId: currentCourse.clan.id,
                      userClanId: currentCourse.clan.userClanId,
                      quantitySpecial: this.quantitySpecial),
                )));
        getQualitySpecial();
        return;
      case 4:
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: HomeCubit(
                      settings: settings,
                      characterService: charService,
                      specialService: specialService,
                      missionService: missionService,
                      clanService: clanService,
                      homeService: homeService),
                  child: KnittingPracticeView(
                      ClanId: currentCourse.clan.id,
                      userClanId: currentCourse.clan.userClanId,
                      quantitySpecial: this.quantitySpecial),
                )));
        getQualitySpecial();
        return;
      case 5:
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: HomeCubit(
                      settings: settings,
                      characterService: charService,
                      specialService: specialService,
                      missionService: missionService,
                      clanService: clanService,
                      homeService: homeService),
                  child: StealView(
                      userClanId: currentCourse.clan.userClanId,
                      quantitySpecial: this.quantitySpecial),
                )));
        getQualitySpecial();
        return;
      case 6:
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: HomeCubit(
                      settings: settings,
                      characterService: charService,
                      specialService: specialService,
                      missionService: missionService,
                      clanService: clanService,
                      homeService: homeService),
                  child: StealView(
                      userClanId: currentCourse.clan.userClanId,
                      quantitySpecial: this.quantitySpecial),
                )));
        getQualitySpecial();
        return;
      default:
        passiveSpecial();
        return;
    }
  }

  passiveSpecial() async {
    var res = await cubit.passiveSpecial(currentCourse.clan.userClanId);
    if (res != null) {
      toast(context, res.message);
      getQualitySpecial();
    }
  }

  doMissionAsync(String slug) {
    switch (slug) {
      //route
      case "diem_danh":
        navigateToRoute(slugTitle: slug);
        return;
      case "individual":
        navigateToRoute(slugTitle: slug);
        return;
      case "do_homework":
        navigateToRoute(slugTitle: slug);
        return;
      case "homework_advance":
        navigateToRoute(slugTitle: slug);
        return;
      case "pass_mid_term_test":
        navigateToRoute(slugTitle: slug);
        return;
      case "join_class_one_week":
        navigateToRoute(slugTitle: slug);
        return;

      //training speed
      case "speed_practice":
        showDialogTrainingRoom(slugTitle: "speed");
        return;
      case "speed_room_5_question":
        showDialogTrainingRoom(slugTitle: "speed");
        return;
      case "speed_room_10_question":
        showDialogTrainingRoom(slugTitle: "speed");
        return;
      case "speed_room_20_question":
        showDialogTrainingRoom(slugTitle: "speed");
        return;
      case "speed_room_30_question":
        showDialogTrainingRoom(slugTitle: "speed");
        return;
      case "10_speed_time_lt_5s":
        showDialogTrainingRoom(slugTitle: "speed");
        return;
      case "20_speed_time_lt_5s":
        showDialogTrainingRoom(slugTitle: "speed");
        return;
      case "100_times_quickest":
        showDialogTrainingRoom(slugTitle: "speed");
        return;
      case "10_speed_time_lt_5s":
        showDialogTrainingRoom(slugTitle: "speed");
        return;

//clan
      case "guild_daily_quest":
        showDialogClan(slugTitle: slug);
        return;
      case "gui_loi_moi_thach_dau":
        showDialogClan(slugTitle: slug);
        return;
      case "win_arena_2_times":
        showDialogClan(slugTitle: slug);
        return;
      case "win_arena_5_times":
        showDialogClan(slugTitle: slug);
        return;
      case "win_arena_10_times":
        showDialogClan(slugTitle: slug);
        return;
      case "win_arena_10_times_continues":
        showDialogClan(slugTitle: slug);
        return;
      case "join_arena":
        showDialogClan(slugTitle: slug);
        return;
      case "win_1_giai_dau":
        showDialogClan(slugTitle: slug);
        return;
      case "top_50_ranking":
        showDialogClan(slugTitle: slug);
        return;
      case "top_30_ranking":
        showDialogClan(slugTitle: slug);
        return;
      case "top_10_ranking":
        showDialogClan(slugTitle: slug);
        return;

      //vocab
      case "collect_300_vocab_words":
        showDialogTrainingRoom(slugTitle: "vocab");
        return;
      case "collect_500_vocab_words":
        showDialogTrainingRoom(slugTitle: "vocab");
        return;

      case "collect_20_items":
        showDialogAsync(ViewDialogHome.inventory, useTop: false);
        return;
      case "collect_40_items":
        showDialogAsync(ViewDialogHome.inventory, useTop: false);
        return;

      case "up_level_2":
        showDialogAsync(ViewDialogHome.character);
        return;
      case "up_level_4":
        showDialogAsync(ViewDialogHome.character);
        return;
      case "up_level_8":
        showDialogAsync(ViewDialogHome.character);
        return;
      case "up_level_12":
        showDialogAsync(ViewDialogHome.character);
        return;
      case "5_mvp":
        showDialogAsync(ViewDialogHome.character);
        return;
      case "10_mvp":
        showDialogAsync(ViewDialogHome.character);
        return;
    }
  }

  showDialogTrainingRoom({String slugTitle}) async {
    await showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: TrainningDialog(
              slug: slugTitle,
              courseStudentId: this.currentCourse.id,
              classroomId: this.currentCourse.classroom.id,
              userClanId: this.userClanId,
              exp: characterInfo.exp),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  navigateToRoute({String slugTitle}) async {
    var settings = GetIt.instance.get<ApplicationSettings>();
    var service = GetIt.instance.get<HomeService>();
    var routeService = GetIt.instance.get<RouteService>();
    var clanService = GetIt.instance.get<ClanService>();
    var c = await settings.getRoute();
    ResultDataHomeWork res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: MapCubit(
              course: c,
              settings: settings,
              service: service,
              routeService: routeService,
              clanService: clanService),
          child: MapRouteView(
            course: c,
            slug: slugTitle,
            idIslandCurrent: this.currentCourse.course.islandId,
          ),
        ),
      ),
    );
    loadData();
    if (res != null) {
        var isAdvance = await showDialog(
          context: context,
          useSafeArea: false,
          builder: (context) => ResultHomeworkView(
            isTest: res.isTest,
            duration: res.result.duration,
            isMark: res.result.statusMark == 0,
            total: int.parse(res.result.process.split('/').last),
            score: res.result.score,
            avgTime: res.result.avgDuration,
          ),
        );
        if (isAdvance == null) {
          return;
        }
        if (isAdvance == false) {
          var wait = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TrainingVocabWaiting(),
          ));
          if (wait == true) {
            var vocabServices = GetIt.instance.get<VocabService>();
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: VocabCubit(services: vocabServices),
                child: VocabularyPracticeView(
                  classroomId: currentCourse.classroomId,
                  lesson: res.result.lesson,
                  userClanId: this.userClanId,
                ),
              ),
            ));
          }
        }
        else {
          var routeService = GetIt.instance.get<RouteService>();
          var doHomeworkAdvance =
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                value: HomeworkCubit(service: routeService),
                child: HomeworkPage(
                  isAdvance: true,
                  classroomId: res.result.classroomId,
                  lesson: res.result.lesson,
                )),
          ));
          if (doHomeworkAdvance != null) {
            await showDialog(
              useSafeArea: false,
              context: context,
              builder: (context) => ResultHomeworkAdvanceView(
                duration: doHomeworkAdvance.duration,
                isMark: doHomeworkAdvance.statusMark == 0,
                total: int.parse(doHomeworkAdvance.process.split('/').last),
                score: doHomeworkAdvance.score,
                avgTime: doHomeworkAdvance.avgDuration,
              ),
            );
          }
        }
      }


    }
  }
