import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/base/HeaderProvider.dart';
import 'package:gstudent/api/dtos/Authentication/user_info.dart';
import 'package:gstudent/api/dtos/Clan/clan.dart';
import 'package:gstudent/api/dtos/Course/course.dart';
import 'package:gstudent/authentication/cubit/login_cubit.dart';
import 'package:gstudent/authentication/services/authentication_services.dart';
import 'package:gstudent/authentication/views/login_view.dart';
import 'package:gstudent/character/services/character_services.dart';
import 'package:gstudent/character/views/create_character_view.dart';
import 'package:gstudent/clan/services/clan_services.dart';
import 'package:gstudent/clan/views/create_clan/create_clan_success.dart';
import 'package:gstudent/clan/views/create_clan/create_clan_view.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/home/services/home_services.dart';
import 'package:gstudent/home/views/home_view.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/map/cubit/map_cubit.dart';
import 'package:gstudent/map/cubit/map_state.dart';
import 'package:gstudent/mission/services/MissionService.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:gstudent/special/services/special_service.dart';
import 'package:gstudent/story/chapter0/chapter0.dart';
import 'package:gstudent/story/chapter0/chapter0_end.dart';
import 'package:gstudent/story/chapter1/chapter_1.dart';
import 'package:gstudent/story/chapter1/chapter_1_end.dart';
import 'package:gstudent/story/chapter1/chapter_1_middle.dart';
import 'package:gstudent/story/chapter2/chapter2.dart';
import 'package:gstudent/story/chapter2/chapter2_end.dart';
import 'package:gstudent/story/chapter2/chapter2_middle.dart';
import 'package:gstudent/story/chapter3/chapter3.dart';
import 'package:gstudent/story/chapter3/chapter3_end.dart';
import 'package:gstudent/story/chapter3/chapter3_middle.dart';
import 'package:gstudent/story/chapter4/chapter4.dart';
import 'package:gstudent/story/chapter4/chapter4_end.dart';
import 'package:gstudent/story/chapter4/chapter4_middle.dart';
import 'package:gstudent/story/chapter5/chapter5.dart';
import 'package:gstudent/story/chapter5/chapter5_end.dart';
import 'package:gstudent/story/chapter5/chapter5_middle.dart';
import 'package:gstudent/story/chapter6/chapter6.dart';
import 'package:gstudent/story/chapter6/chapter6_end.dart';
import 'package:gstudent/story/chapter6/chapter6_middle.dart';
import 'package:gstudent/story/chapter_tutorial/chapter_tutorial.dart';

class MapGameView extends StatefulWidget {
  List<CourseModel> course;

  MapGameView({this.course});

  @override
  State<StatefulWidget> createState() => MapGameViewState(course: this.course);
}

class MapGameViewState extends State<MapGameView> with TickerProviderStateMixin {
  List<CourseModel> course;

  MapGameViewState({this.course});

  final ScrollController _scrollController = ScrollController();
  MapCubit myBloc;
  bool isAthenaLock = false;
  bool isLockAmazonica = false;
  bool isLockIshukhan = false;
  bool isLockArcint = false;
  bool isLockEdo = false;
  bool isLockFly = false;
  bool isMoaLock = false;

  final charService = GetIt.instance.get<CharacterService>();
  final clanService = GetIt.instance.get<ClanService>();
  final applicationSetting = GetIt.instance.get<ApplicationSettings>();
  final homeService = GetIt.instance.get<HomeService>();
  final missionService = GetIt.instance.get<MissionService>();
  final specialService = GetIt.instance.get<SpecialService>();

  User user;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
    loadIsland();
    loadUser();
    myBloc = BlocProvider.of<MapCubit>(context);
  }

  loadUser() async {
    var data = await applicationSetting.getCurrentUser();
    setState(() {
      user = data.userInfo;
    });
    myBloc.navigateStoryWorld();
  }

  loadIsland() async {
    setState(() {
      isMoaLock = course.where((element) => element.course != null && element.course.islandId != null && element.course.islandId == 7 && element.isLearning == true).toList().length > 0;
      isAthenaLock = course.where((element) => element.course != null && element.course.islandId != null && element.course.islandId == 1 && element.isLearning == true).toList().length > 0;
      isLockAmazonica = course.where((element) => element.course != null && element.course.islandId != null && element.course.islandId == 2 && element.isLearning == true).toList().length > 0;
      isLockIshukhan = course.where((element) => element.course != null && element.course.islandId != null && element.course.islandId == 3 && element.isLearning == true).toList().length > 0;
      isLockArcint = course.where((element) => element.course != null && element.course.islandId != null && element.course.islandId == 4 && element.isLearning == true).toList().length > 0;
      isLockEdo = course.where((element) => element.course != null && element.course.islandId != null && element.course.islandId == 5 && element.isLearning == true).toList().length > 0;
      isLockFly = course.where((element) => element.course != null && element.course.islandId != null && element.course.islandId == 6 && element.isLearning == true).toList().length > 0;
    });
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
    });
  }

  AssetImage bgGame;

  AssetImage imgFlyland;
  AssetImage imgEdo;
  AssetImage imgArcint;
  AssetImage imgIsukha;
  AssetImage imgAmazonica;
  AssetImage imgAthena;

  loadImage() {
    bgGame = AssetImage('assets/game_bg_map.png');
    imgFlyland = AssetImage('assets/fly_land_lock.png');
    imgEdo = AssetImage('assets/edo_land_lock.png');
    imgArcint = AssetImage('assets/arcint_land_lock.png');
    imgIsukha = AssetImage('assets/isukha_land_lock.png');
    imgAmazonica = AssetImage('assets/amazonica_land_lock.png');
    imgAthena = AssetImage('assets/athena_land_lock.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgGame, context);
    precacheImage(imgFlyland, context);
    precacheImage(imgEdo, context);
    precacheImage(imgArcint, context);
    precacheImage(imgIsukha, context);
    precacheImage(imgAmazonica, context);
    precacheImage(imgAthena, context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: BlocListener<MapCubit, MapState>(
                listener: (context, state) {
                  if (state is ErrorNoClass) {
                    toast(context, "You not join some class yet");
                  }
                  if (state is CreateCharacter) {
                    navigateToCreateCharacter(state.classroomId, state.idIsland);
                  }

                  if (state is CreateClan) {
                    navigateToCreateClan(state.classroomId, state.idIsland);
                  }
                  if (state is NavigateToHome) {
                    navigateToHome(state.data);
                  }
                  if(state is NavigateStoryWorld){
                    navigateToStoryWorld();
                  }
                  if (state is NavigateStory) {
                    navigateStory(state.islandId, state.id,state.classroomId);
                  }
                  if (state is NavigateStoryMiddle) {
                    navigateStoryMiddle(state.islandId, state.id,state.classroomId);
                  }
                  if (state is NavigateStoryEnd) {
                    navigateStoryEnd(state.islandId, state.id,state.classroomId);
                  }
                  if (state is NavigateToZoom) {
                    navigateToZoom(state.zoomId, state.zoomPass);
                  }
                  if(state is MapErrorState){
                    errorMessage(state.message);
                  }
                },
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: Container(
                        child: Image(
                          image: bgGame,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: ListView(
                          controller: _scrollController,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  child: GestureDetector(
                                    onTap: () => islandClicked(isLockFly, 6),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: -20,
                                          top: 0,
                                          bottom: 0,
                                          child: Container(
                                              width: MediaQuery.of(context).size.width *
                                                  0.7,
                                              height:
                                              MediaQuery.of(context).size.height *
                                                  0.25,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    child: imageRightChange(isLockFly, 'assets/fly_land.png', 'assets/fly_land_lock.png'),
                                                    alignment: Alignment.centerRight,
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.fromLTRB(32, 0, 0, 32),
                                                      alignment: Alignment.bottomCenter,
                                                      child: textpaintingBoldBase("Đảo Flyland", 18, Colors.white, Colors.black, 5, textAlign: TextAlign.center))
                                                ],
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.2, 0, 0),
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: -40,
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                            width:
                                            MediaQuery.of(context).size.width * 0.8,
                                            height: MediaQuery.of(context).size.height *
                                                0.25,
                                            child: GestureDetector(
                                              onTap: () => islandClicked(isLockEdo, 5),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    child: imageLeftChange(isLockEdo, 'assets/edo_land.png', 'assets/edo_land_lock.png'),
                                                    alignment: Alignment.centerLeft,
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.fromLTRB(32, 0, 0, 32),
                                                      alignment: Alignment.bottomCenter,
                                                      child: textpaintingBoldBase("Thành phố Edo", 18, Colors.white, Colors.black, 5, textAlign: TextAlign.center))
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, (MediaQuery.of(context).size.height * 0.4), 0, 0),
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        right: -40,
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                            width: MediaQuery.of(context).size.width * 0.8,
                                            height: MediaQuery.of(context).size.height * 0.3,
                                            child: GestureDetector(
                                              onTap: () => islandClicked(isLockArcint, 4),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    child: imageRightChange(isLockArcint, 'assets/arcint_land.png', 'assets/arcint_land_lock.png'),
                                                    alignment: Alignment.centerRight,
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.fromLTRB(0, 0, 68, 32),
                                                      alignment: Alignment.bottomCenter,
                                                      child: textpaintingBoldBase("Thành phố cực bắc \n Arcint", 18, Colors.white, Colors.black, 5, textAlign: TextAlign.center))
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, (MediaQuery.of(context).size.height * 0.6), 0, 0),
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: -10,
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                            width: MediaQuery.of(context).size.width * 0.8,
                                            height: MediaQuery.of(context).size.height * 0.3,
                                            child: GestureDetector(
                                              onTap: () => islandClicked(isLockIshukhan, 3),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    child: imageLeftChange(isLockIshukhan, 'assets/isukha_land.png', 'assets/isukha_land_lock.png'),
                                                    alignment: Alignment.centerLeft,
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.fromLTRB(0, 0, 60, 32),
                                                      alignment: Alignment.bottomCenter,
                                                      child: textpaintingBoldBase("Vương quốc sa mạc \n Isukha", 18, Colors.white, Colors.black, 5, textAlign: TextAlign.center))
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, (MediaQuery.of(context).size.height * 0.8), 0, 0),
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        right: -40,
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                            width: MediaQuery.of(context).size.width * 0.7,
                                            height: MediaQuery.of(context).size.height * 0.3,
                                            child: GestureDetector(
                                              onTap: () => islandClicked(isLockAmazonica, 2),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    child: imageRightChange(isLockAmazonica, 'assets/amazonica_land.png', 'assets/amazonica_land_lock.png'),
                                                    alignment: Alignment.centerRight,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0, 0, 48, 32),
                                                    alignment: Alignment.bottomCenter,
                                                    child: textpaintingBoldBase("Rừng nhiệt đới \n Amazonica", 18, Colors.white, Colors.black, 5, textAlign: TextAlign.center),
                                                  )
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, (MediaQuery.of(context).size.height * 1), 0, 0),
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: -10,
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.8,
                                          height: MediaQuery.of(context).size.height * 0.3,
                                          child: GestureDetector(
                                            onTap: () => islandClicked(isAthenaLock, 1),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  child: imageLeftChange(isAthenaLock, 'assets/athena_land.png', 'assets/athena_land_lock.png'),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 32),
                                                  alignment: Alignment.bottomCenter,
                                                  child: textpaintingBoldBase('Đảo thông thái \n Athena', 18, Colors.white, Colors.black, 5, textAlign: TextAlign.center),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                isMoaLock ?     Container(
                                  margin: EdgeInsets.fromLTRB(0, (MediaQuery.of(context).size.height * 1.2), 0, 0),
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        right: -40,
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                            width:
                                            MediaQuery.of(context).size.width * 0.7,
                                            height: MediaQuery.of(context).size.height *
                                                0.25,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  islandClicked(isMoaLock,7),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.centerRight,
                                                    child: imageRightChange(
                                                        isMoaLock,
                                                        'assets/moa_land.png',
                                                        'assets/moa_land.png'),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 48, 32),
                                                    alignment: Alignment.bottomCenter,
                                                    child: textpaintingBoldBase(
                                                        "Đảo Moa",
                                                        18,
                                                        Colors.white,
                                                        Colors.black,
                                                        5,
                                                        textAlign: TextAlign.center),
                                                  )
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ) :
                                Container(
                                  margin: EdgeInsets.fromLTRB(0,
                                      (MediaQuery.of(context).size.height * 1.4), 0, 0),
                                )
                              ],
                            )
                          ],
                        )),
                    Positioned(
                      child: SafeArea(
                        top: false,
                        child: GestureDetector(
                          onTap: () {
                            var service = GetIt.instance.get<AuthenticationService>();
                            var setting = GetIt.instance.get<ApplicationSettings>();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: AuthenticationCubit(service: service,headerProvider:null ,applicationSettings: setting),
                                child: LoginView(),
                              ),
                            ));
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(16, 8, 0, 0),
                            child: Image(
                              image: AssetImage('assets/images/game_button_back.png'),
                              height: 48,
                              width: 48,
                            ),
                          ),
                        ),
                      ),
                      top: 8,
                      left: 8,
                    )
                  ],
                ))),
        onWillPop: () async => false);
  }

  islandClicked(bool clanClick, int idIsland) async {
    if (clanClick == false) {
      return;
    }
    myBloc.islandClick(idIsland);
  }

  imageRightChange(t, unlock, lock) {
    return Stack(
      children: [
        AnimatedOpacity(
            opacity: t ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 3500),
            // The green box must be a child of the AnimatedOpacity widget.
            child: Image(
              image: AssetImage(unlock),
              fit: BoxFit.fill,
            )),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 20,
          child: AnimatedOpacity(
              opacity: t ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 3000),
              // The green box must be a child of the AnimatedOpacity widget.
              child: Image(
                image: AssetImage(lock),
                fit: BoxFit.fill,
              )),
        )
      ],
    );
  }

  imageLeftChange(t, unlock, lock) {
    return Stack(
      children: [
        AnimatedOpacity(
            opacity: t ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 3500),
            // The green box must be a child of the AnimatedOpacity widget.
            child: Image(
              image: AssetImage(unlock),
              fit: BoxFit.fill,
            )),
        Positioned(
          top: 0,
          right: 20,
          bottom: 0,
          left: 0,
          child: AnimatedOpacity(
              opacity: t ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 3000),
              // The green box must be a child of the AnimatedOpacity widget.
              child: Image(
                image: AssetImage(lock),
                fit: BoxFit.fill,
              )),
        )
      ],
    );
  }

  navigateToCreateCharacter(int classroomid, int idIsland) async {
    var currentCourse = course.where((element) => element.classroomId == classroomid).first;
    int response = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: HomeCubit(
              characterService: charService, settings: applicationSetting, homeService: homeService, specialService: specialService, missionService: missionService, clanService: clanService),
          child: CreateCharacterView(
            userId: user.id,
            nameClan: currentCourse.clan.name,
            userClanId: currentCourse.clan.userClanId,
            clanId: currentCourse.clan.id,
          ),
        ),
      ),
    );
    if (response != null) {
      setState(() {
        currentCourse.clan.characterId = response;
        // course.where((element) => element.classroomId == classroomid).first.clan.characterId = response;
      });

      reloadCurrentCourseInList(currentCourse);
      var wait = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: HomeCubit(
              characterService: charService, settings: applicationSetting,
              homeService: homeService, specialService: specialService,
              missionService: missionService, clanService: clanService),
          child: CreateClanSuccessView(
            islandId: idIsland,
            clanName: currentCourse.clan.name,
            clanId: currentCourse.clan.id,
            userClanId: currentCourse.clan.userClanId,
            userId: user.id,
          ),
        ),
      ));

      if (currentCourse.clan != null && currentCourse.clan.characterId != null) {
        myBloc.loadStory(currentCourse.classroomId, idIsland);
      }
    }
  }

  void navigateToCreateClan(int classroomid, int idIsland) async {
    var currentCourse = course.where((element) => element.classroomId == classroomid).first;
    if (currentCourse.clan == null || (currentCourse.clan != null && (currentCourse.clan.isApprove == null || currentCourse.clan.isApprove == false))) {
      Clan respone = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: HomeCubit(
                characterService: charService, settings: applicationSetting, homeService: homeService, missionService: missionService, specialService: specialService, clanService: clanService),
            child: CreateClanView(
              userName: user.name,
              clanId: currentCourse.clan != null ? currentCourse.clan.id : 0,
              idIsland: idIsland,
              classroomId: classroomid,
              userClanId: currentCourse.clan != null ? currentCourse.clan.userClanId : 0,
              nameCLan: currentCourse.clan != null ? currentCourse.clan.name : null,
            ),
          ),
        ),
      );
      if (respone != null) {
        setState(() {
          currentCourse.clan = respone;
          // course.where((element) => element.classroomId == classroomid).first.clan = respone;
        });
        reloadCurrentCourseInList(currentCourse);
      }
    }

    if (currentCourse.clan != null && currentCourse.clan.isApprove == true) {
      if (currentCourse.clan.characterId == null) {
        int response = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: HomeCubit(
                  characterService: charService, settings: applicationSetting, homeService: homeService, specialService: specialService, missionService: missionService, clanService: clanService),
              child: CreateCharacterView(
                userId: user.id,
                nameClan: currentCourse.clan.name,
                userClanId: currentCourse.clan.userClanId,
                clanId: currentCourse.clan.id,
              ),
            ),
          ),
        );
        if (response != null) {

          setState(() {
            currentCourse.clan.characterId = response;
            // course.where((element) => element.classroomId == classroomid).first.clan.characterId = response;
          });
          reloadCurrentCourseInList(currentCourse);

          bool res = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: HomeCubit(
                  characterService: charService, settings: applicationSetting, homeService: homeService, specialService: specialService, missionService: missionService, clanService: clanService),
              child: CreateClanSuccessView(
                islandId: idIsland,
                clanName: currentCourse.clan.name,
                clanId: currentCourse.clan.id,
                userClanId: currentCourse.clan.userClanId,
                userId: user.id,
              ),
            ),
          ));

          if (res == false) {
            return;
          }

          if (currentCourse.clan != null && currentCourse.clan.characterId != null) {
            myBloc.loadStory(currentCourse.classroomId, idIsland);
          }
        }
      }
    }
  }

  reloadCurrentCourseInList(CourseModel currentCourse) {
    course.forEach((element) {
      if (element.id == currentCourse.id) {
          element = currentCourse;
      }
    });
    applicationSetting.saveRoute(course);
  }

  void navigateToHome(CourseModel courses) async {

    await Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value:
            HomeCubit(settings: applicationSetting, characterService: charService,
                clanService: clanService, specialService: specialService, missionService: missionService, homeService: homeService),
        child: HomeGamePage(
          courses: courses,
        ),
      ),
    ));
    myBloc.emit(MapStateInitial());
  }

  String localImageByIdIsland(int idIsland) {
    switch (idIsland) {
      case 1:
        return 'assets/amazonica_land.png';
      case 2:
        return 'assets/isukha_land.png';
      case 3:
        return 'assets/arcint_land.png';
      case 4:
        return 'assets/edo_land.png';
      case 5:
        return 'assets/fly_land.png';
      default:
        return '';
    }
  }



  navigateStory(int islandId, int id, int classroomId) async {
    Widget chapter;
    switch (islandId) {
      case 1:
        chapter = Chapter1();
        break;
      case 2:
        chapter = Chapter2();
        break;
      case 3:
        chapter = Chapter3();
        break;
      case 4:
        chapter = Chapter4();
        break;
      case 5:
        chapter = Chapter5();
        break;
      case 6:
        chapter = Chapter6();
        break;
      case 7 :
        chapter = Chapter0();
        break;
    }
    var res = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => chapter,
    ));
    if (res != null) {
      await applicationSetting.saveIsland(islandId, id.toString());
      var c =  course.where((element) => element.course.islandId == islandId && element.classroomId == classroomId).first;
      myBloc.emit(NavigateToHome(data: course.where((element) => element.course.islandId == islandId && element.classroomId == classroomId).first));
    }
  }

  navigateStoryMiddle(int islandId, int id, int classroomId) async {
    Widget chapter;
    switch (islandId) {
      case 1:
        chapter = Chapter1Middle();
        break;
      case 2:
        chapter = Chapter2Middle();
        break;
      case 3:
        chapter = Chapter3Middle();
        break;
      case 4:
        chapter = Chapter4Middle();
        break;
      case 5:
        chapter = Chapter5Middle();
        break;
      case 6:
        chapter = Chapter6Middle();
        break;
    }
    var res = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => chapter,
    ));
    if (res != null) {
      await applicationSetting.saveIslandMiddle(islandId, id.toString());
      myBloc.emit(NavigateToHome(data: course.where((element) => element.course.islandId == islandId && element.classroomId == classroomId).first));
    }
  }

  navigateStoryEnd(int islandId, int id, int classroomId) async {
    Widget chapter;
    switch (islandId) {
      case 1:
        chapter = Chapter1End();
        break;
      case 2:
        chapter = Chapter2End();
        break;
      case 3:
        chapter = Chapter3End();
        break;
      case 4:
        chapter = Chapter4End();
        break;
      case 5:
        chapter = Chapter5End();
        break;
      case 6:
        chapter = Chapter6End();
        break;
      case 7:
        chapter = Chapter0End();
        break;
    }
    var res = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => chapter,
    ));
    if (res != null) {
      await applicationSetting.saveIslandEnd(islandId, id.toString());
      myBloc.emit(NavigateToHome(data: course.where((element) => element.course.islandId == islandId && element.classroomId == classroomId).first));
    }
  }

  void navigateToZoom(String zoomId, String zoomPass) async {
    if (zoomId != null && zoomPass != null) {
      myBloc.initZoomOptions(zoomId.replaceAll(' ', ''), zoomPass.replaceAll(' ', ''));
      // await Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => BlocProvider.value(
      //       value: ZoomCubit(this.applicationSetting, this.user.id),
      //       child: ZoomView(
      //         idZoom: zoomId.split(' ').join(''),
      //         passZoom: zoomPass.split(' ').join(''),
      //       ),
      //     ),
      //   ),
      // );
    }else{
      toast(context, 'Zoom id và mật khẩu không hợp lệ');
    }
  }

  void navigateToStoryWorld() async {
  var check =  await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChapterTutorial(),));
  if(check != null && check == true){
    await applicationSetting.saveStoryWorld();
  }
  }

  void errorMessage(String message) {
    toast(context, message);
    return;
  }
}
