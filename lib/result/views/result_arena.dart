import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/Arena/result_arena.dart';
import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/define_item/avatar_character.dart';

class ResultArenaView extends StatefulWidget {
  DataResultArena result;
  List<UserClan> userClan;
  int generalId;
  ResultArenaView({this.result,this.userClan,this.generalId});

  @override
  State<StatefulWidget> createState() => ResultArenaViewState(result: this.result,userClan:this.userClan,generalId:this.generalId);
}

class ResultArenaViewState extends State<ResultArenaView> {
  DataResultArena result;
  List<UserClan> userClan;
  int generalId;
  ResultArenaViewState({this.result,this.userClan,this.generalId});

  bool isWin = false;

  @override
  void initState() {
    super.initState();
    var fakeData = result;
    fakeData.users.sort((a, b) => b.totalNumberTrue.compareTo(a.totalNumberTrue));
    result.users.where((element) => element.id == fakeData.users.first.id).first.isMvp = true;
    setState(() {
      isWin = result.resultClan > result.resultClanEnemy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black45,
      body: Column(
        children: [
          Expanded(child: Container()),
          Expanded(
              child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: isWin
                    ? Image(
                        image: AssetImage('assets/bg_result_homework.png'),
                      )
                    : Image(
                        image: AssetImage('assets/bg_title_lose.png'),
                      ),
              ),
              Container(
                child: Text(
                  isWin ? 'CHIẾN THẮNG' : 'THUA CUỘC',
                  style: TextStyle(color: Colors.white, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, fontSize: 40),
                ),
                alignment: Alignment.center,
              ),
            ],
          ),flex: 2,),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Tỷ số: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'SourceSerifPro', color: Colors.white)),
                TextSpan(text: result.resultClan.toString()+'-'+result.resultClanEnemy.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'SourceSerifPro', color: HexColor("#f5d756"))),
                TextSpan(text: '\nDanh sách thành viên trả lời đúng nhất:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'SourceSerifPro', color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: ListView.builder(
                itemBuilder: (context, index) => itemMember(index),
                shrinkWrap: true,
                itemCount: result.users.length,
              ),
            ),
            flex: 5,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Image(
              image: AssetImage('assets/images/ellipse.png'),
            ),
          ),
          Container(
            height: 48,
            margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: ButtonYellowSmall('THOÁT'),
              ),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  itemMember(int index) {
    if(index == 0){
      return Container(
        height: 60,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
        child: Stack(
          children: [
            Positioned(
              child: Image(
                image: AssetImage('assets/images/game_bg_member_clan.png'),
                fit: BoxFit.fill,
              ),
              left: 40,
              top: 6,
              bottom: 6,
              right: 1,
            ),
            Positioned(
              child: Container(
                width: 60,
                child: Stack(
                  children: [
                    Image(
                      image: AssetImage('assets/images/game_border_avatar_member.png'),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      bottom: 8,
                      left: 8,
                      child: result.users.where((element) => element.id == generalId).isNotEmpty ?  ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image(image: AssetImage(loadAvatarCharacterById(result.users.where((element) => element.id == generalId).first.characterId))),
                      ) : Container(),
                    )
                  ],
                ),
              ),
              left: 1,
            ),
            Positioned(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
    result.users.where((element) => element.id == generalId).isNotEmpty &&  userClan.where((element) => element.studentId == result.users.where((element) => element.id == generalId).first.id).isNotEmpty ?   userClan.where((element) => element.studentId == result.users.where((element) => element.id == generalId).first.id).first.nickname : '',
                          style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Điểm: ', style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro')),
                              TextSpan(
                                  text:  result.users.where((element) => element.id == generalId).isNotEmpty ? result.users.where((element) => element.id == generalId).first.totalNumberTrue.toString()  : '',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'SourceSerifPro', fontSize: 14, color: Colors.red)),
                            ],
                          ),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ],
              ),
              left: 68,
              right: 56,
              top: 8,
              bottom: 8,
            ),
            Positioned(
              width: 96,
              child: index == 0
                  ? Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          child: Image(
                            image: AssetImage('assets/images/icon_general.png'),
                            height: 40,
                          ),
                        ),
                        textpainting('General'),
                      ],
                    ),
                    width: 48,
                  ),
                  result.users.where((element) => element.id == generalId).isNotEmpty &&     result.users.where((element) => element.id == generalId).first.isMvp != null && result.users.where((element) => element.id == generalId).first.isMvp == true &&  result.users.where((element) => element.id == generalId).first.totalNumberTrue > 0
                      ? Container(
                    child: Column(
                      children: [
                        Container(
                          child: Image(
                            image: AssetImage('assets/images/icon_mvp.png'),
                            height: 40,
                          ),
                        ),
                        textpainting('MVP'),
                      ],
                    ),
                    width: 48,
                  )
                      : Container()
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              )
                  : (result.users[index].isMvp != null && result.users[index].isMvp && result.users[index].totalNumberTrue > 0
                  ? Row(children: [
                Expanded(child: Container()),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Image(
                          image: AssetImage('assets/images/icon_mvp.png'),
                          height: 40,
                        ),
                      ),
                      textpainting('MVP'),
                    ],
                  ),
                  width: 48,
                )],)
                  : Row(children: [
                Expanded(child: Container()),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Image(
                          image: AssetImage('assets/images/icon_member.png'),
                          height: 40,
                        ),
                      ),
                      textpainting('Member'),
                    ],
                  ),
                  width: 48,
                )
              ],)),
              top: 0,
              right: 8,
              bottom: 0,
            )
          ],
        ),
      );
    }else{
      return Container(
        height: 60,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
        child: Stack(
          children: [
            Positioned(
              child: Image(
                image: AssetImage('assets/images/game_bg_member_clan.png'),
                fit: BoxFit.fill,
              ),
              left: 40,
              top: 6,
              bottom: 6,
              right: 1,
            ),
            Positioned(
              child: Container(
                width: 60,
                child: Stack(
                  children: [
                    Image(
                      image: AssetImage('assets/images/game_border_avatar_member.png'),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      bottom: 8,
                      left: 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image(image: AssetImage(loadAvatarCharacterById(result.users.where((element) => element.id != generalId).toList()[index-1].characterId))),
                      ),
                    )
                  ],
                ),
              ),
              left: 1,
            ),
            Positioned(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          userClan.where((element) => element.studentId == result.users.where((element) => element.id != generalId).toList()[index-1].id).isNotEmpty ?   userClan.where((element) => element.studentId == result.users.where((element) => element.id != generalId).toList()[index-1].id).first.nickname : '',
                          style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Điểm: ', style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro')),
                              TextSpan(
                                  text: result.users.where((element) => element.id != generalId).toList()[index-1].totalNumberTrue< 0 ?'0' :  result.users.where((element) => element.id != generalId).toList()[index-1].totalNumberTrue.toString() ,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'SourceSerifPro', fontSize: 14, color: Colors.red)),
                            ],
                          ),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ],
              ),
              left: 68,
              right: 56,
              top: 8,
              bottom: 8,
            ),
            Positioned(
              width: 96,
              child: index == 0
                  ? Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          child: Image(
                            image: AssetImage('assets/images/icon_general.png'),
                            height: 40,
                          ),
                        ),
                        textpainting('General'),
                      ],
                    ),
                    width: 48,
                  ),
                  result.users.where((element) => element.id != generalId).toList()[index-1].isMvp != null && result.users.where((element) => element.id != generalId).toList()[index-1].isMvp == true &&  result.users.where((element) => element.id != generalId).toList()[index-1].totalNumberTrue > 0
                      ? Container(
                    child: Column(
                      children: [
                        Container(
                          child: Image(
                            image: AssetImage('assets/images/icon_mvp.png'),
                            height: 40,
                          ),
                        ),
                        textpainting('MVP'),
                      ],
                    ),
                    width: 48,
                  )
                      : Container()
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              )
                  : (result.users.where((element) => element.id != generalId).toList()[index-1].isMvp != null && result.users.where((element) => element.id != generalId).toList()[index-1].isMvp && result.users.where((element) => element.id != generalId).toList()[index-1].totalNumberTrue > 0
                  ? Row(children: [
                Expanded(child: Container()),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Image(
                          image: AssetImage('assets/images/icon_mvp.png'),
                          height: 40,
                        ),
                      ),
                      textpainting('MVP'),
                    ],
                  ),
                  width: 48,
                )],)
                  : Row(children: [
                Expanded(child: Container()),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Image(
                          image: AssetImage('assets/images/icon_member.png'),
                          height: 40,
                        ),
                      ),
                      textpainting('Member'),
                    ],
                  ),
                  width: 48,
                )
              ],)),
              top: 0,
              right: 8,
              bottom: 0,
            )
          ],
        ),
      );
    }

  }

  textpainting(String s) {
    return OutlinedText(
      text: Text(s, textAlign: TextAlign.justify, style: TextStyle(fontSize: 12, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, color: Colors.white)),
      strokes: [
        OutlinedTextStroke(color: Colors.black87, width: 2),
      ],
    );
  }
}
