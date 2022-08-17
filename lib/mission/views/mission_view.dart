import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/mission/mission_data.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/mission/views/daily_mission.dart';
import 'package:gstudent/mission/views/progress_mission.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';

class MissionDialog extends StatefulWidget {
  int classroomId;

  MissionDialog({this.classroomId});

  @override
  State<StatefulWidget> createState() => MissionDialogState(classroomId: this.classroomId);
}

class MissionDialogState extends State<MissionDialog> with TickerProviderStateMixin {
  int classroomId;

  MissionDialogState({this.classroomId});

  TabController _tabController;
  int test = 0;
  int idUser;
  int tab = 0;
  HomeCubit cubit;
  List<GroupMission> missionDaily;
  List<GroupMission> missionProgress;
  ApplicationSettings settings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings = GetIt.instance.get<ApplicationSettings>();
    loadImage();
    _tabController = TabController(length: 3, vsync: this);
    cubit = BlocProvider.of(context);
    loadMission();
  }

  loadProgress() async {
    showLoading();
    var progress = await cubit.getMissionProgress(classroomId);
    hideLoading();
    if (progress != null) {
      if (mounted) {
        setState(() {
          this.missionProgress = null;
          this.missionProgress = progress.data;
        });
      }
    }
  }

  loadDaily() async {
    showLoading();
    var daily = await cubit.getMissionDaily(classroomId);
    hideLoading();
    if (daily != null) {
      if (mounted) {
        setState(() {
          this.missionDaily = null;
          this.missionDaily = daily.data;
        });
      }
    }
  }

  loadMission() async {
    var user = await settings.getCurrentUser();
    idUser = user.userInfo.id;
    loadDaily();
    loadProgress();
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
      resizeToAvoidBottomInset: false,
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
                top: MediaQuery.of(context).size.height > 1000 ? MediaQuery.of(context).size.height * 0.05 : 48,
                bottom: 36,
                right: MediaQuery.of(context).size.width > 800 ? MediaQuery.of(context).size.width * 0.15 : 48,
                left: MediaQuery.of(context).size.width > 800 ? MediaQuery.of(context).size.width * 0.15 : 48,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 16,
                      ),
                      Container(
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              height: 40,
                              decoration: tab == 0
                                  ? BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            HexColor("#fecd45"),
                                            HexColor("#fba416"),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp),
                                      border: Border.all(width: 0.5))
                                  : BoxDecoration(color: HexColor("f9ce95"), border: Border.all(width: 0.5)),
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      tab = 0;
                                    });
                                  },
                                  child: Center(
                                    child: textpaintingBoldBase('Hằng ngày', 14, tab == 0 ? Colors.white : Colors.black, tab == 0 ? Colors.black : Colors.transparent, 2),
                                  )),
                            )),
                            Expanded(
                                child: Container(
                              height: 40,
                              decoration: tab == 1
                                  ? BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            HexColor("#fecd45"),
                                            HexColor("#fba416"),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp),
                                      border: Border.all(width: 0.5))
                                  : BoxDecoration(color: HexColor("f9ce95"), border: Border.all(width: 0.5)),
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      tab = 1;
                                    });
                                  },
                                  child: Center(
                                    child: textpaintingBoldBase('Progress', 14, tab == 1 ? Colors.white : Colors.black, tab == 1 ? Colors.black : Colors.transparent, 2),
                                  )),
                            )),
                            Expanded(
                                child: Container(
                              height: 40,
                              decoration: tab == 2
                                  ? BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            HexColor("#fecd45"),
                                            HexColor("#fba416"),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp),
                                      border: Border.all(width: 0.5))
                                  : BoxDecoration(color: HexColor("f9ce95"), border: Border.all(width: 0.5)),
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      tab = 2;
                                    });
                                  },
                                  child: Center(
                                    child: textpaintingBoldBase('Sự kiện', 14, tab == 2 ? Colors.white : Colors.black, tab == 2 ? Colors.black : Colors.transparent, 2),
                                  )),
                            )),
                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: HexColor("#ffcd93"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Image(
                          image: AssetImage('assets/images/ellipse.png'),
                        ),
                      ),
                      Expanded(
                        child: missionDaily != null || missionProgress != null ? contentMission() : Container(),
                      )
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
                          child: Center(child: textpainting('Nhiệm vụ', 24)),
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
                right: MediaQuery.of(context).size.width > 800 ? 60 : 16,
              ),
            ],
          )),
        ],
      ),
    );
  }

  textpainting(String s, double fontSize) {
    return OutlinedText(
      text: Text(s, textAlign: TextAlign.justify, style: TextStyle(fontSize: fontSize, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, color: HexColor("#f8e9a5"))),
      strokes: [
        OutlinedTextStroke(color: HexColor("#681527"), width: 3),
      ],
    );
  }

  contentMission() {
    switch (tab) {
      case 0:
        return DailyMission(
          success: (p0) {
            setState(() {
              missionDaily = null;
            });
            if (p0 == true) {
              loadDaily();
            }
          },
          idUser: this.idUser,
          data: this.missionDaily != null ? this.missionDaily : [],
        );
      case 1:
        return ProgressMission(
          idUser: this.idUser,
          data: this.missionProgress != null ? this.missionProgress : [],
          onRecived: (p0) {
            if (p0 == true) {
              setState(() {
                missionProgress = null;
              });
              loadProgress();
            }
          },
          clickMissionDaily: () {
            setState(() {
              tab = 0;
            });
          },
        );
      case 2:
        return Container();
    }
  }

// tabbar(){
//  return Stack(
//     children: [
//       TabBar(
//         controller: _tabController,
//         indicator: BoxDecoration(color: HexColor("#febd27"), border: Border.all(color: Colors.black,width: 0.5)),
//         labelColor: Colors.white,
//         labelPadding: EdgeInsets.zero,
//         unselectedLabelColor: Colors.black,
//         labelStyle: TextStyle(fontSize: 14, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400),
//         unselectedLabelStyle: TextStyle(fontSize: 14, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400),
//         onTap: (value) {
//           setState(() {
//             tab = value;
//           });
//         },
//         tabs: [
//           // first tab [you can add an icon using the icon property]
//           Tab(
//             child: textpaintingBoldBase('Hằng ngày', 14, tab == 0?  Colors.white : Colors.black,tab == 0?  Colors.black :  Colors.transparent, 2),
//           ),
//
//           // second tab [you can add an icon using the icon property]
//           Tab(
//             child: textpaintingBoldBase('Progress', 14, tab == 1?  Colors.white : Colors.black,tab == 1?  Colors.black :  Colors.transparent, 2,),
//           ),
//           Tab(
//             child: textpaintingBoldBase('Sự kiện', 14, tab == 2?  Colors.white : Colors.black,tab == 2?  Colors.black :  Colors.transparent, 2),
//           ),
//         ],
//       ),
//       Positioned(
//         top: 0,
//         bottom: 0,
//         right: 0,
//         left: 0,
//         child: Row(
//           children: [
//             Expanded(child: Container()),
//             Container(
//               width: 1,
//               color: Colors.black,
//             ),
//             Expanded(child: Container()),
//             Container(
//               width: 1,
//               color: Colors.black,
//             ),
//             Expanded(child: Container()),
//           ],
//         ),
//       )
//     ],
//   );
// }

// tabcontent(){
//     return TabBarView(
//       controller: _tabController,
//       children: [
//         DailyMission(
//           success: (p0) {
//             setState(() {
//               missionDaily = null;
//             });
//             if (p0 == true) {
//               loadDaily();
//             }
//           },
//           idUser: this.idUser,
//           data: this.missionDaily,
//         ),
//         ProgressMission(
//           idUser: this.idUser,
//           data: this.missionProgress,
//           onRecived: (p0) {
//             if (p0 == true) {
//               setState(() {
//                 missionProgress = null;
//               });
//               loadProgress();
//             }
//           },
//           clickMissionDaily: () {
//             _tabController.animateTo(0);
//             setState(() {
//               tab = 0;
//             });
//           },
//         ),
//         Center(
//           child: Text(''),
//         ),
//       ],
//     );
// }
}
