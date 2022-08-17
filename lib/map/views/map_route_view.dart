import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Course/course.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/home/cubit/route_cubit.dart';
import 'package:gstudent/home/services/route_services.dart';
import 'package:gstudent/home/views/route_view.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/map/cubit/map_cubit.dart';
import 'package:gstudent/map/cubit/map_state.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';

class MapRouteView extends StatefulWidget {
  int idIslandCurrent;
  List<CourseModel> course;
  String slug;

  MapRouteView({this.course, this.slug,this.idIslandCurrent});

  @override
  State<StatefulWidget> createState() =>
      MapRouteViewState(course: this.course, slug: this.slug,idIslandCurrent:this.idIslandCurrent);
}

class MapRouteViewState extends State<MapRouteView>
    with TickerProviderStateMixin {
  List<CourseModel> course;
  String slug;
  int idIslandCurrent;
  MapRouteViewState({this.course, this.slug,this.idIslandCurrent});

  MapCubit myBloc;
  bool isAthenaLock = false;
  bool isLockAmazonica = false;
  bool isLockIshukhan = false;
  bool isLockArcint = false;
  bool isLockEdo = false;
  bool isLockFly = false;
  bool isMoaLock = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showLoading();
    loadImage();
    loadIsland();
    myBloc = BlocProvider.of<MapCubit>(context);
    hideLoading();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  loadIsland() async {

    setState(() {
      isMoaLock = course
          .where((element) =>
      element.course != null &&
          element.course.islandId != null &&
          element.course.islandId == 7 &&
          element.isLearning == true)
          .toList()
          .length >
          0;
      isAthenaLock = course
          .where((element) =>
      element.course != null &&
          element.course.islandId != null &&
          element.course.islandId == 1 &&
          element.isLearning == true)
          .toList()
          .length >
          0;
      isLockAmazonica = course
          .where((element) =>
      element.course != null &&
          element.course.islandId != null &&
          element.course.islandId == 2 &&
          element.isLearning == true)
          .toList()
          .length >
          0;
      isLockIshukhan = course
          .where((element) =>
      element.course != null &&
          element.course.islandId != null &&
          element.course.islandId == 3 &&
          element.isLearning == true)
          .toList()
          .length >
          0;
      isLockArcint = course
          .where((element) =>
      element.course != null &&
          element.course.islandId != null &&
          element.course.islandId == 4 &&
          element.isLearning == true)
          .toList()
          .length >
          0;
      isLockEdo = course
          .where((element) =>
      element.course != null &&
          element.course.islandId != null &&
          element.course.islandId == 5 &&
          element.isLearning == true)
          .toList()
          .length >
          0;
      isLockFly = course
          .where((element) =>
      element.course != null &&
          element.course.islandId != null &&
          element.course.islandId == 6 &&
          element.isLearning == true)
          .toList()
          .length >
          0;
    });


    await Future.delayed(const Duration(milliseconds: 100));
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent / 2,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn);
    });

    if (course
        .where((element) =>
            (element.course.islandId == 1 || element.course.islandId == 2) &&
            element.isLearning == true)
        .isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn);
      });

      if (slug != null) {
        var id =
            course.where((element) => element.isLearning).first.course.islandId;
        BlocProvider.of<MapCubit>(context).islandRouteClicked(id);
      }
    } else if (course
        .where((element) =>
            (element.course.islandId == 3 || element.course.islandId == 4) &&
            element.isLearning == true)
        .isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent / 2,
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn);
      });
      if (slug != null) {
        var id =
            course.where((element) => element.isLearning).first.course.islandId;
        BlocProvider.of<MapCubit>(context).islandRouteClicked(id);
      }
    }
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<MapCubit, MapState>(
          listener: (context, state) {
            if (state is ErrorNoClass) {
              toast(context, "You not join some class yet");
            }

            if (state is LoadRouteIsland) {
              navigateToRoute(state.classroomId, state.idIsland,state.isLongRoute);
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
                child: ListView(
                  controller: _scrollController,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: GestureDetector(
                            onTap: () => islandClicked(6, isLockFly),
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
                                            alignment: Alignment.centerRight,
                                            child: imageRightChange(
                                                isLockFly,
                                                'assets/fly_land.png',
                                                'assets/fly_land_lock.png'),
                                          ),
                                          Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  32, 0, 0, 32),
                                              alignment: Alignment.bottomCenter,
                                              child: textpaintingBoldBase(
                                                  "Đảo Flyland",
                                                  18,
                                                  Colors.white,
                                                  Colors.black,
                                                  5,
                                                  textAlign: TextAlign.center))
                                        ],
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0,
                              MediaQuery.of(context).size.height * 0.2, 0, 0),
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
                                      onTap: () => islandClicked(5, isLockEdo),
                                      child: Stack(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: imageLeftChange(
                                                isLockEdo,
                                                'assets/edo_land.png',
                                                'assets/edo_land_lock.png'),
                                          ),
                                          Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  32, 0, 0, 32),
                                              alignment: Alignment.bottomCenter,
                                              child: textpaintingBoldBase(
                                                  "Thành phố Edo",
                                                  18,
                                                  Colors.white,
                                                  Colors.black,
                                                  5,
                                                  textAlign: TextAlign.center))
                                        ],
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0,
                              (MediaQuery.of(context).size.height * 0.4), 0, 0),
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
                                          islandClicked(4, isLockArcint),
                                      child: Stack(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: imageRightChange(
                                                isLockArcint,
                                                'assets/arcint_land.png',
                                                'assets/arcint_land_lock.png'),
                                          ),
                                          Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 68, 32),
                                              alignment: Alignment.bottomCenter,
                                              child: textpaintingBoldBase(
                                                  "Thành phố cực bắc \n Arcint",
                                                  18,
                                                  Colors.white,
                                                  Colors.black,
                                                  5,
                                                  textAlign: TextAlign.center))
                                        ],
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0,
                              (MediaQuery.of(context).size.height * 0.6), 0, 0),
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Stack(
                            children: [
                              Positioned(
                                left: -10,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: GestureDetector(
                                      onTap: () =>
                                          islandClicked(3, isLockIshukhan),
                                      child: Stack(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: imageLeftChange(
                                                isLockIshukhan,
                                                'assets/isukha_land.png',
                                                'assets/isukha_land_lock.png'),
                                          ),
                                          Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 60, 32),
                                              alignment: Alignment.bottomCenter,
                                              child: textpaintingBoldBase(
                                                  "Vương quốc sa mạc \n Isukha",
                                                  18,
                                                  Colors.white,
                                                  Colors.black,
                                                  5,
                                                  textAlign: TextAlign.center))
                                        ],
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0,
                              (MediaQuery.of(context).size.height * 0.8), 0, 0),
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
                                          islandClicked(2, isLockAmazonica),
                                      child: Stack(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: imageRightChange(
                                                isLockAmazonica,
                                                'assets/amazonica_land.png',
                                                'assets/amazonica_land_lock.png'),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 48, 32),
                                            alignment: Alignment.bottomCenter,
                                            child: textpaintingBoldBase(
                                                "Rừng nhiệt đới \n Amazonica",
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
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0,
                              (MediaQuery.of(context).size.height * 1), 0, 0),
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Stack(
                            children: [
                              Positioned(
                                left: -10,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: GestureDetector(
                                    onTap: () => islandClicked(1, isAthenaLock),
                                    child: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: imageLeftChange(
                                              isAthenaLock,
                                              'assets/athena_land.png',
                                              'assets/athena_land_lock.png'),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 0, 32),
                                          alignment: Alignment.bottomCenter,
                                          child: textpaintingBoldBase(
                                              'Đảo thông thái \n Athena',
                                              18,
                                              Colors.white,
                                              Colors.black,
                                              5,
                                              textAlign: TextAlign.center),
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
                                          islandClicked(7,isMoaLock),
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
                ),
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
              ),
              Positioned(
                child: SafeArea(
                  top: true,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      BlocProvider.of<MapCubit>(context)
                          .emit(MapStateInitial());
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Image(
                        image: AssetImage('assets/images/game_button_back.png'),
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ),
                ),
                top: 0,
                left: 8,
              ),
            ],
          ),
        ));
  }

  islandClicked(int idIsland, bool isLock) async {
    if (isLock == false) {
      return;
    }
    if(idIsland == this.idIslandCurrent){
      BlocProvider.of<MapCubit>(context).islandRouteClicked(idIsland);
    }
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

  void navigateToRoute(int classroomid, int idIsland, int length) async {
    var service = GetIt.instance.get<RouteService>();
    var res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: RouteCubit(service: service,
          settings: GetIt.instance.get<ApplicationSettings>()),
          child: RouteView(
            classroomId: classroomid,
            length: length,
          ),
        ),
      ),
    );
    if (res != null) {
      Navigator.of(context).pop(res);
    } else {
      Navigator.of(context).pop();
    }

    // BlocProvider.of<MapCubit>(context).emit(MapStateInitial());
    // await showDialog(context: context, builder: (context) => UnlockIsLandDialog(islandImage: localImageByIdIsland(idIsland),),);
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
        return 'assets/athena_land.png';
    }
  }
}
