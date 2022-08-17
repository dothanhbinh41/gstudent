import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/mission/mission_data.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/result/views/reward.dart';

class DailyMission extends StatefulWidget {
  Function(bool) success;

  int idUser;
  List<GroupMission> data;

  DailyMission({this.data, this.idUser, this.success});

  @override
  State<StatefulWidget> createState() => DailyMissionState(data: this.data, idUser: this.idUser);
}

class DailyMissionState extends State<DailyMission> {
  int idUser;
  List<GroupMission> data;
  HomeCubit cubit;

  DailyMissionState({this.data, this.idUser});

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) {
            return itemMission(index);
          },
          itemCount: data.length,
          shrinkWrap: true,
        ))
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  receivReward(Mission data) async {
      var res = await cubit.receiveRewardMission(data.missionUsers.first.id);
      hideLoading();
      if (res != null) {
        if (res.error == false) {
         await  showDialog(context: context, builder: (context) => RewardView(data: res.data,),);
          widget.success(true);
        }
        else{
          toast(context, res.message);

        }
      }
  }

  selecMission(String slug) {
    print(slug);
    Navigator.of(context).pop(slug);
  }

  Widget itemMission(int index) {
    if(data[index].missions.where((element) => element.missionUsers.isEmpty).isEmpty){
      var mission = data[index].missions.where((element) => element.missionUsers.isNotEmpty && element.missionUsers.first.dateClaim == null).isNotEmpty ? data[index].missions.where((element) => element.missionUsers.isNotEmpty && element.missionUsers.first.dateClaim == null).first : data[index].missions.last;
      if(mission.missionUsers.first.dateClaim != null){
        return Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(color: HexColor("#fff6d8"), border: Border.all(color: HexColor("#efd9a1"), width: 2), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                        child: Text(
                            mission.name,
                            style: ThemeStyles.styleNormal(font: 12)),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text(
                            mission.reward.name,
                            style:ThemeStyles.styleBold(font: 12,textColors: HexColor("#415497"))),
                      ),
                    ],
                  )),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        );
      }else{
        return Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(color: HexColor("#fff6d8"), border: Border.all(color: HexColor("#efd9a1"), width: 2), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                        child: Text(
                            mission.name,
                            style: ThemeStyles.styleNormal(font: 12)),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text(
                            mission.reward.name,
                            style:ThemeStyles.styleBold(font: 12,textColors: HexColor("#415497"))),
                      ),
                    ],
                  )),
              GestureDetector(
                  onTap: () => receivReward(mission),
                  child: Container(
                      width: 108,
                      height: 48,
                      child: Stack(
                        children: [
                          Positioned(
                              top: 4,
                              bottom: 4,
                              right: 0,
                              left: 0,
                              child: Image(
                                image: AssetImage('assets/images/button_small_blue.png'),
                              )),
                          Center(
                            child: textpaintingBoldBase("Nhận thưởng", 14, HexColor("#e4e8df"), HexColor("#296e21"), 3),
                          )
                        ],
                      )))
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        );
      }
    }
    else{
      if (data[index].missions.where((element) => element.missionUsers.isNotEmpty).isNotEmpty) {
        var mission = data[index].missions.where((element) => element.missionUsers.isNotEmpty && element.missionUsers.first.dateClaim == null).isNotEmpty ?
        data[index].missions.where((element) => element.missionUsers.isNotEmpty && element.missionUsers.first.dateClaim == null).first :
        data[index].missions.where((element) => element.missionUsers.isEmpty ).first
        ;

        if(mission.missionUsers.isEmpty){
          return Container(
            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(color: HexColor("#fff6d8"), border: Border.all(color: HexColor("#efd9a1"), width: 2), borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                          child: Text(
                              mission.name,
                              style: ThemeStyles.styleNormal(font: 12)),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(
                              mission.reward.name,
                              style:ThemeStyles.styleBold(font: 12,textColors: HexColor("#415497"))),
                        ),
                      ],
                    )),
                GestureDetector(
                    onTap: () => selecMission(mission.slug),
                    child: Container(
                        height: 48,
                        width: 100,
                        child: ButtonYellowSmall(
                          'Thực hiện',
                        )))
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          );
        }else{
          return Container(
            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(color: HexColor("#fff6d8"), border: Border.all(color: HexColor("#efd9a1"), width: 2), borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                Expanded(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                          child: Text(
                              mission.name,
                              style: ThemeStyles.styleNormal(font: 12)),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(
                              mission.reward.name,
                              style:ThemeStyles.styleBold(font: 12,textColors: HexColor("#415497"))),
                        ),
                      ],
                    )),
                GestureDetector(
                    onTap: () => receivReward(mission),
                    child: Container(
                        width: 108,
                        height: 48,
                        child: Stack(
                          children: [
                            Positioned(
                                top: 4,
                                bottom: 4,
                                right: 0,
                                left: 0,
                                child: Image(
                                  image: AssetImage('assets/images/button_small_blue.png'),
                                )),
                            Center(
                              child: FittedBox(child: textpaintingBoldBase("Nhận thưởng", 14, HexColor("#e4e8df"), HexColor("#296e21"), 3),fit: BoxFit.contain),
                            )
                          ],
                        )))
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          );
        }
      }
      else{
        return Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(color: HexColor("#fff6d8"), border: Border.all(color: HexColor("#efd9a1"), width: 2), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 0, 8),
                        child: Text(
                            data[index].missions.first.name,
                            style: ThemeStyles.styleNormal(font: 12)),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 0, 8),
                        child: Text(
                            data[index].missions.first.reward.name,
                            style: ThemeStyles.styleBold(font: 12,textColors: HexColor("#415497"))),
                      ),
                    ],
                  )),
              GestureDetector(
                  onTap: () => selecMission(data[index].missions.first.slug),
                  child: Container(
                      height: 48,
                      width: 100,
                      child: ButtonYellowSmall(
                        'Thực hiện',
                      )))
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        );
      }
    }

  }
}
