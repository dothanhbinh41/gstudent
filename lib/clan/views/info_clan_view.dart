import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';
import 'package:gstudent/api/dtos/Clan/list_request_join.dart';
import 'package:gstudent/clan/views/info_member_clan.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';

import '../../main.dart';

class InfoClanView extends StatefulWidget {
  int clanId;
  HomeCubit cubit;

  InfoClanView({this.clanId, this.cubit});

  @override
  State<StatefulWidget> createState() =>
      InfoClanViewState(clanId: this.clanId, cubit: this.cubit);
}

class InfoClanViewState extends State<InfoClanView>
    with SingleTickerProviderStateMixin {
  int clanId;
  HomeCubit cubit;

  InfoClanViewState({this.clanId, this.cubit});

  AnimationController animationController;
  String dropdownValue;

  GlobalKey _dropdownButtonKey = GlobalKey();
  int current = 0;

  ClanDetail clan;

  final setting = GetIt.instance.get<ApplicationSettings>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
    loadData();
    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1500),
        reverseDuration: Duration(milliseconds: 1500));
  }

  loadData() async {
    showLoading();
    var res = await cubit.getDetailCLan(clanId);
    hideLoading();
    if (res != null) {
      setState(() {
        clan = res;
        dropdownValue = clan.attackStatus == 1 ? 'Thách đấu' : 'Phòng thủ';
      });
    } else {
      toast(context, 'Xin hãy chờ để giảng viên duyệt clan');
    }
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
    if (clan != null) {
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
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    left: 4,
                                    bottom: 4,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/ic_training_vocab.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    left: 0,
                                    bottom: 0,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/game_border_avatar_clan.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                clan.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SourceSerifPro',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Rank: ",
                                    style: TextStyle(
                                      fontFamily: 'SourceSerifPro',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "16",
                                    style: TextStyle(
                                      fontFamily: 'SourceSerifPro',
                                      color: HexColor("#ff0000"),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Code: ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SourceSerifPro',
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    clan.code.toString(),
                                    style: TextStyle(
                                      fontFamily: 'SourceSerifPro',
                                      fontWeight: FontWeight.bold,
                                      color: HexColor("#335fa0"),
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 100,
                                    padding: EdgeInsets.fromLTRB(8, 4, 0, 0),
                                    decoration: BoxDecoration(
                                        color: HexColor("#ffc288"),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            bottomLeft: Radius.circular(4)),
                                        border: Border.all(
                                            color: HexColor("#3f2208"),
                                            width: 2)),
                                    child: DropdownButton<String>(
                                      key: _dropdownButtonKey,
                                      value: dropdownValue,
                                      icon: Visibility(
                                          visible: false,
                                          child: Icon(Icons.arrow_downward)),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      underline:
                                          Container(color: Colors.transparent),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          dropdownValue = newValue;
                                          int status =
                                              newValue == 'Thách đấu' ? 1 : 0;
                                          changeStatus(status);
                                        });
                                      },
                                      onTap: () {
                                        setState(() {});
                                      },
                                      items: <String>[
                                        'Thách đấu',
                                        'Phòng thủ',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                            value: value,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    value,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'SourceSerifPro',
                                                        fontWeight:
                                                            FontWeight.w700),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  // Divider(
                                                  //   color: Colors
                                                  //       .black,
                                                  //   thickness: 0.5,
                                                  // )
                                                ],
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                            ));
                                      }).toList(),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => openDropdown(),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: HexColor("#3f2208"),
                                              width: 2),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(4),
                                              bottomRight: Radius.circular(4))),
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/button_drop_down.png'),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          flex: 4,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Image(
                      image: AssetImage('assets/images/ellipse.png'),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Danh sách thành viên: 16",
                                    style: TextStyle(
                                        fontFamily: 'SourceSerifPro',
                                        fontWeight: FontWeight.w700),
                                  ),
                                  flex: 3,
                                ),
                                // Expanded(
                                //   child: GestureDetector(
                                //     child: Container(
                                //       height: 36,
                                //       decoration: BoxDecoration(
                                //           border: Border.all(
                                //               width: 2,
                                //               color: HexColor("#3f2208")),
                                //           borderRadius: BorderRadius.all(
                                //               Radius.circular(4))),
                                //       child: Row(
                                //         children: [
                                //           Container(
                                //             margin:
                                //                 EdgeInsets.fromLTRB(4, 0, 4, 0),
                                //             child: Image(
                                //               image: AssetImage(
                                //                   'assets/images/icon_add.png'),
                                //               height: 16,
                                //               width: 16,
                                //             ),
                                //           ),
                                //           Text(
                                //             "Mời thêm",
                                //             style: TextStyle(
                                //                 color: Colors.black,
                                //                 fontFamily: 'SourceSerifPro',
                                //                 fontWeight: FontWeight.bold),
                                //           )
                                //         ],
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.center,
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.center,
                                //       ),
                                //     ),
                                //     onTap: () => requestJoin(),
                                //   ),
                                //   flex: 2,
                                // )
                              ],
                            ),
                            height: 64,
                          ),
                          Expanded(
                              child: Stack(
                            children: [
                              ListView.builder(
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            InfoMemberClanView(),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/game_bg_member_clan.png'),
                                              fit: BoxFit.fill,
                                            ),
                                            left: 40,
                                            top: 6,
                                            bottom: 6,
                                            right: 1,
                                          ),
                                          Positioned(
                                            child: Container(
                                              height: 80,
                                              width: 80,
                                              child: Stack(
                                                children: [
                                                  Image(
                                                    image: AssetImage(
                                                        'assets/images/game_border_avatar_member.png'),
                                                    height: 80,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      child: Image.network(
                                                          "https://www.1999.co.jp/itbig17/10170417a.jpg"),
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
                                                        clan.userClans[index]
                                                                    .nickname !=
                                                                null
                                                            ? clan
                                                                .userClans[
                                                                    index]
                                                                .nickname
                                                            : "",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'SourceSerifPro',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                        overflow:
                                                            TextOverflow.fade,
                                                        maxLines: 1,
                                                        softWrap: false,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "HP: ",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'SourceSerifPro',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Text("300/300",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'SourceSerifPro',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .red)),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("Lv: ",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'SourceSerifPro',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                          Text("30",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'SourceSerifPro',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .blueAccent)),
                                                        ],
                                                      )
                                                    ],
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                  ),
                                                ),
                                                Container(
                                                  height: 76,
                                                  width: 80,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        top: 12,
                                                        bottom: 20,
                                                        right: 0,
                                                        left: 0,
                                                        child: Image(
                                                          image: AssetImage(
                                                              'assets/images/ic_king.png'),
                                                          height: 40,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 2,
                                                        right: 0,
                                                        left: 0,
                                                        child: Center(
                                                          child: Text(
                                                            "Rank",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'SourceSerifPro',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            left: 88,
                                            right: 1,
                                          ),
                                        ],
                                      ),
                                      height: 80,
                                    ),
                                  );
                                },
                                itemCount: clan.userClans.length,
                                shrinkWrap: true,
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
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
                      child: Image(
                        image: AssetImage('assets/images/title_result.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      child: Center(child: textpainting('Thông tin clan', 24)),
                      top: 0,
                      right: 0,
                      bottom: 8,
                      left: 0,
                    )
                  ],
                ),
              ),
              top: 0,
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
    } else {
      return Container();
    }
  }

  void openDropdown() {
    GestureDetector detector;
    void searchForGestureDetector(BuildContext element) {
      element.visitChildElements((element) {
        if (element.widget != null && element.widget is GestureDetector) {
          detector = element.widget;
          return false;
        } else {
          searchForGestureDetector(element);
        }

        return true;
      });
    }

    searchForGestureDetector(_dropdownButtonKey.currentContext);
    assert(detector != null);

    detector.onTap();
  }

  changeStatus(int status) async {
    showLoading();
    var res = await cubit.changeStatusClan(clanId, status);
    hideLoading();
    if (res.error == false) {
      toast(context, 'Đổi trạng thái thành công');
      setState(() {
        if (clan.attackStatus == 0) {
          clan.attackStatus = 1;
        } else {
          clan.attackStatus = 0;
        }
      });
    }
  }

  listRequest(List<UserRequestJoin> data) {
    return Dialog(
      child: Wrap(
        children: [
          data != null && data.length > 0
              ? Container(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(child: Text(data[index].name)),
                          Expanded(
                            child: Container(),
                          ),
                          GestureDetector(
                            onTap: () => sendRequest(1, data[index].id),
                            child: Text("Duyệt"),
                          ),
                          Container(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              sendRequest(0, data[index].id);
                            },
                            child: Text("Gạch"),
                          ),
                        ],
                      );
                    },
                    shrinkWrap: true,
                    itemCount: data.length,
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  requestJoin() async {
    var idCurrentUser = await setting.getCurrentUser();
    if (idCurrentUser.userInfo.id == clan.generalId) {
      ListRequestJoinData res = await cubit.getListRequestJoin(clanId);
      if (res.error == false) {
        if (res.data.isEmpty) {
          toast(context, 'Chưa có người xin gia nhập');
          return;
        }
        await showDialog(
          context: context,
          builder: (context) {
            return BlocProvider<HomeCubit>.value(
              value: cubit, //
              child: listRequest(res.data),
            );
          },
        );
      } else {
        toast(context, 'Lỗi');
      }
    } else {
      toast(context, 'u arre not leader');
    }
  }

  sendRequest(int status, int studentId) async {
    showLoading();
    var res = await cubit.approveUser(clanId, studentId, status);
    hideLoading();
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
}
