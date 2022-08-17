import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/mission/mission_data.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/draw_progress_tripped.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/result/views/reward.dart';

class ProgressMission extends StatefulWidget {
  int idUser;
  List<GroupMission> data;
  final Function(bool) onRecived;
  final Function() clickMissionDaily;

  ProgressMission(
      {this.data, this.idUser, this.onRecived, this.clickMissionDaily});

  @override
  State<StatefulWidget> createState() => ProgressMissionState(
      clickMissionDaily: this.clickMissionDaily,
      data: this.data,
      idUser: this.idUser,
      onRecived: this.onRecived);
}

class ProgressMissionState extends State<ProgressMission> {
  int idUser;
  List<GroupMission> data;
  final Function(bool) onRecived;
  final Function() clickMissionDaily;

  ProgressMissionState(
      {this.data, this.idUser, this.onRecived, this.clickMissionDaily});

  HomeCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return data != null && data.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              return itemMission(index);
            },
            itemCount: data.length,
            shrinkWrap: true,
          )
        : Container();
  }

  Widget itemMission(int index) {
    if (data[index]
        .missions
        .where((element) => element.missionUsers.isEmpty)
        .isEmpty) {
      var mission = data[index]
              .missions
              .where((element) =>
                  element.missionUsers.isNotEmpty &&
                  element.missionUsers.first.dateClaim == null)
              .isNotEmpty
          ? data[index]
              .missions
              .where((element) =>
                  element.missionUsers.isNotEmpty &&
                  element.missionUsers.first.dateClaim == null)
              .first
          : data[index].missions.last;
      if (mission.missionUsers.first.dateClaim == null) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: HexColor("#fff6d8"),
              border: Border.all(color: HexColor("#efd9a1"), width: 1),
              borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                    border: Border.all(color: HexColor("#31281b"), width: 2),
                    gradient: LinearGradient(
                        colors: [
                          HexColor("#120B04"),
                          HexColor("#55422A"),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp)),
                child: Image(
                  image: NetworkImage(mission.image),
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: Text(
                      mission.name,
                      style: ThemeStyles.styleBold(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: Text(
                      mission.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: HexColor("#6a6a6a"),
                    ),
                    child: Stack(
                      children: [
                        CustomPaint(
                          painter: StripePainter(
                              height: 16,
                              progress: data[index]
                                      .missions
                                      .where((element) =>
                                          element.missionUsers.isNotEmpty)
                                      .length /
                                  data[index].missions.length,
                              distance:
                                  (MediaQuery.of(context).size.width * 0.1)),
                          size: Size.infinite,
                        ),
                        Container(
                          child: Row(
                            children: [
                              for (var i = 0;
                                  i < data[index].missions.length;
                                  i++)
                                Expanded(
                                    child: Stack(
                                  children: [
                                    Positioned(
                                        child: Visibility(
                                      visible: i == 0 ? false : true,
                                      child: Container(
                                        width: 2,
                                        decoration: BoxDecoration(
                                            color: HexColor("#404040")),
                                      ),
                                    ))
                                  ],
                                ))
                            ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.transparent,
                              border: Border.all(
                                  color: HexColor("#272727"), width: 1)),
                        ),
                        Positioned(
                          child:Center(child: FittedBox(child:  textpaintingBase(
                              data[index]
                                  .missions
                                  .where((element) =>
                              element.missionUsers.isNotEmpty)
                                  .length
                                  .toString() +
                                  "/" +
                                  data[index].missions.length.toString(),
                              14,
                              Colors.white,
                              Colors.black,
                              2),),),
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => receivReward(mission),
                    child: Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                        height: 48,
                        child: Stack(
                          children: [
                            Positioned(
                                top: 4,
                                bottom: 4,
                                right: 0,
                                left: 0,
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/button_small_blue.png'),
                                )),
                            Center(
                              child: textpaintingBoldBase("Nhận thưởng", 14,
                                  HexColor("#e4e8df"), HexColor("#296e21"), 3),
                            )
                          ],
                        )),
                  ),
                ],
              )),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: HexColor("#fff6d8"),
              border: Border.all(color: HexColor("#efd9a1"), width: 1),
              borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                    border: Border.all(color: HexColor("#31281b"), width: 2),
                    gradient: LinearGradient(
                        colors: [
                          HexColor("#120B04"),
                          HexColor("#55422A"),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp)),
                child: Image(
                  image: NetworkImage(mission.image),
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: Text(
                      mission.name,
                      style: ThemeStyles.styleBold(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: Text(
                      mission.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: HexColor("#6a6a6a"),
                    ),
                    child: Stack(
                      children: [
                        CustomPaint(
                          painter: StripePainter(
                              height: 16,
                              progress: data[index]
                                      .missions
                                      .where((element) =>
                                          element.missionUsers.isNotEmpty)
                                      .length /
                                  data[index].missions.length,
                              distance:
                                  (MediaQuery.of(context).size.width * 0.1)),
                          size: Size.infinite,
                        ),
                        Container(
                          child: Row(
                            children: [
                              for (var i = 0;
                                  i < data[index].missions.length;
                                  i++)
                                Expanded(
                                    child: Stack(
                                  children: [
                                    Positioned(
                                        child: Visibility(
                                      visible: i == 0 ? false : true,
                                      child: Container(
                                        width: 2,
                                        decoration: BoxDecoration(
                                            color: HexColor("#404040")),
                                      ),
                                    ))
                                  ],
                                ))
                            ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.transparent,
                              border: Border.all(
                                  color: HexColor("#272727"), width: 2)),
                        ),
                        Positioned(
                          child:Center(child: FittedBox(child:  textpaintingBase(
                              data[index]
                                  .missions
                                  .where((element) =>
                              element.missionUsers.isNotEmpty)
                                  .length
                                  .toString() +
                                  "/" +
                                  data[index].missions.length.toString(),
                              14,
                              Colors.white,
                              Colors.black,
                              2),),),
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                        )
                      ],
                    ),
                  ),
                ],
              )),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        );
      }
    } else {
      if (data[index]
          .missions
          .where((element) => element.missionUsers.isNotEmpty)
          .isNotEmpty) {
        var mission = data[index]
                .missions
                .where((element) =>
                    element.missionUsers.isNotEmpty &&
                    element.missionUsers.first.dateClaim == null)
                .isNotEmpty
            ? data[index]
                .missions
                .where((element) =>
                    element.missionUsers.isNotEmpty &&
                    element.missionUsers.first.dateClaim == null)
                .first
            : data[index]
                .missions
                .where((element) => element.missionUsers.isEmpty)
                .first;

        if (mission.missionUsers.isEmpty) {
          return Container(
            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: HexColor("#fff6d8"),
                border: Border.all(color: HexColor("#efd9a1"), width: 2),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    border: Border.all(color: HexColor("#31281b"), width: 2),
                    gradient: LinearGradient(
                        colors: [
                          HexColor("#120B04"),
                          HexColor("#55422A"),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Image(
                    image: NetworkImage(mission.image),
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                      child: Text(
                        mission.name,
                        style: ThemeStyles.styleBold(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                      child: Text(
                        mission.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'SourceSerifPro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                      height: 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: HexColor("#6a6a6a"),
                      ),
                      child: Stack(
                        children: [
                          CustomPaint(
                            painter: StripePainter(
                                height: 16,
                                progress: data[index]
                                        .missions
                                        .where((element) =>
                                            element.missionUsers.isNotEmpty)
                                        .length /
                                    data[index].missions.length,
                                distance:
                                    (MediaQuery.of(context).size.width * 0.1)),
                            size: Size.infinite,
                          ),
                          Container(
                            child: Row(
                              children: [
                                for (var i = 0;
                                    i < data[index].missions.length;
                                    i++)
                                  Expanded(
                                      child: Stack(
                                    children: [
                                      Positioned(
                                          child: Visibility(
                                        visible: i == 0 ? false : true,
                                        child: Container(
                                          width: 2,
                                          decoration: BoxDecoration(
                                              color: HexColor("#404040")),
                                        ),
                                      ))
                                    ],
                                  ))
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.transparent,
                                border: Border.all(
                                    color: HexColor("#404040"), width: 2)),
                          ),
                          Positioned(
                            child:Center(child: FittedBox(child:  textpaintingBase(
                                data[index]
                                    .missions
                                    .where((element) =>
                                element.missionUsers.isNotEmpty)
                                    .length
                                    .toString() +
                                    "/" +
                                    data[index].missions.length.toString(),
                                14,
                                Colors.white,
                                Colors.black,
                                2),),),
                            top: 0,
                            right: 0,
                            left: 0,
                            bottom: 0,
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () => selecMission(mission.slug),
                        child: Container(
                            margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                            height: 48,
                            child: ButtonYellowSmall(
                              'Thực hiện',
                            ))),
                  ],
                )),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          );
        } else {
          return Container(
            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: HexColor("#fff6d8"),
                border: Border.all(color: HexColor("#efd9a1"), width: 2),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                      border: Border.all(color: HexColor("#31281b"), width: 2),
                      gradient: LinearGradient(
                          colors: [
                            HexColor("#120B04"),
                            HexColor("#55422A"),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp)),
                  child: Image(
                    image: NetworkImage(mission.image),
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                      child: Text(
                        mission.name,
                        style: ThemeStyles.styleBold(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                      child: Text(
                        mission.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'SourceSerifPro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                      height: 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: HexColor("#6a6a6a"),
                      ),
                      child: Stack(
                        children: [
                          CustomPaint(
                            painter: StripePainter(
                                height: 16,
                                progress: data[index]
                                        .missions
                                        .where((element) =>
                                            element.missionUsers.isNotEmpty)
                                        .length /
                                    data[index].missions.length,
                                distance:
                                    (MediaQuery.of(context).size.width * 0.1)),
                            size: Size.infinite,
                          ),
                          Container(
                            child: Row(
                              children: [
                                for (var i = 0;
                                    i < data[index].missions.length;
                                    i++)
                                  Expanded(
                                      child: Stack(
                                    children: [
                                      Positioned(
                                          child: Visibility(
                                        visible: i == 0 ? false : true,
                                        child: Container(
                                          width: 2,
                                          decoration: BoxDecoration(
                                              color: HexColor("#404040")),
                                        ),
                                      ))
                                    ],
                                  ))
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.transparent,
                                border: Border.all(
                                    color: HexColor("#272727"), width: 1)),
                          ),
                          Positioned(
                            child:Center(child: FittedBox(child:  textpaintingBase(
                                data[index]
                                    .missions
                                    .where((element) =>
                                element.missionUsers.isNotEmpty)
                                    .length
                                    .toString() +
                                    "/" +
                                    data[index].missions.length.toString(),
                                14,
                                Colors.white,
                                Colors.black,
                                2),),),
                            top: 0,
                            right: 0,
                            left: 0,
                            bottom: 0,
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => receivReward(mission),
                      child: Container(
                          margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                          height: 48,
                          child: Stack(
                            children: [
                              Positioned(
                                  top: 4,
                                  bottom: 4,
                                  right: 0,
                                  left: 0,
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/button_small_blue.png'),
                                  )),
                              Center(
                                child: textpaintingBoldBase(
                                    "Nhận thưởng",
                                    14,
                                    HexColor("#e4e8df"),
                                    HexColor("#296e21"),
                                    3),
                              )
                            ],
                          )),
                    ),
                  ],
                )),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          );
        }
      } else {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: HexColor("#fff6d8"),
              border: Border.all(color: HexColor("#efd9a1"), width: 1),
              borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(4),
                width: 72,
                height: 72,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: HexColor("#31281b"), width: 2),
                      gradient: LinearGradient(
                          colors: [
                            HexColor("#120B04"),
                            HexColor("#55422A"),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    padding: EdgeInsets.all(2),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          left: 0,
                          child: Image(
                            image:
                                NetworkImage(data[index].missions.first.image),
                            fit: BoxFit.fill,
                          ),
                        ),
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
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: Text(
                      data[index].missions.first.name,
                      style: ThemeStyles.styleBold(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: Text(
                      data[index].missions.first.name,
                      style: ThemeStyles.styleNormal(font: 14),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: HexColor("#6a6a6a"),
                    ),
                    child: Stack(
                      children: [
                        CustomPaint(
                          painter: StripePainter(
                              height: 16,
                              progress: data[index]
                                      .missions
                                      .where((element) =>
                                          element.missionUsers.isNotEmpty)
                                      .length /
                                  data[index].missions.length,
                              distance:
                                  (MediaQuery.of(context).size.width * 0.08)),
                          size: Size.infinite,
                        ),
                        Container(
                          child: Row(
                            children: [
                              for (var i = 0;
                                  i < data[index].missions.length;
                                  i++)
                                Expanded(
                                    child: Stack(
                                  children: [
                                    Positioned(
                                        child: Visibility(
                                      visible: i == 0 ? false : true,
                                      child: Container(
                                        width: 2,
                                        decoration: BoxDecoration(
                                            color: HexColor("#404040")),
                                      ),
                                    ))
                                  ],
                                ))
                            ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.transparent,
                              border: Border.all(
                                  color: HexColor("#272727"), width: 1)),
                        ),
                        Positioned(
                          child:Center(child: FittedBox(child:  textpaintingBase(
                              data[index]
                                  .missions
                                  .where((element) =>
                              element.missionUsers.isNotEmpty)
                                  .length
                                  .toString() +
                                  "/" +
                                  data[index].missions.length.toString(),
                              14,
                              Colors.white,
                              Colors.black,
                              2),),),
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                      onTap: () =>
                          selecMission(data[index].missions.first.slug),
                      child: Container(
                        height: 48,
                        child: ButtonYellowSmall(
                          'Thực hiện',
                        ),
                      ))
                ],
              )),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        );
      }
    }
  }

  double convertDouble(double c) {
    var lastNumber = c.toString().substring(c.toString().length - 1);
    var number = int.parse(lastNumber) > 5 ? c - 0.05 : c - 0;
    return number;
  }

  receivReward(Mission data) async {
    var res = await cubit.receiveRewardMission(data.missionUsers.first.id);
    if (res != null) {
      if (res.error == false) {
        await showDialog(
          context: context,
          builder: (context) => RewardView(
            data: res.data,
          ),
        );
        onRecived(true);
      }
      else{
        toast(context, res.message);
      }
    }
  }

  selecMission(String slug) {
    switch (slug) {
      case "15_mission_in_2_week":
        clickMissionDaily();
        return;
      case "60_mission_in_2_months":
        clickMissionDaily();
        return;
      case "90_mission_in_3_months":
        clickMissionDaily();
        return;
      default:
        Navigator.of(context).pop(slug);
        return;
    }
  }
}
