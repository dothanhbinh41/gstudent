import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/Clan/clan_detail_response.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/special/views/dialog_revenge.dart';
import 'package:gstudent/special/views/result_attack_view.dart';

class AttackView extends StatefulWidget {
  int userClanId;
  int quantitySpecial;
  AttackView({this.userClanId,this.quantitySpecial});

  @override
  State<StatefulWidget> createState() => AttackViewState(userClanId: this.userClanId, quantitySpecial : this.quantitySpecial);
}

class AttackViewState extends State<AttackView> with TickerProviderStateMixin {
  int userClanId;
  int quantitySpecial;

  AttackViewState({this.userClanId,this.quantitySpecial});

  bool isHaveRevenge = false;
  HomeCubit cubit;
  List<ClanDetail> data;

  AnimationController controller1;
  AnimationController controller2;
  AnimationController controller3;

  Animation base1;
  Animation base2;
  Animation base3;

  ClanDetail target;
  bool isCanClick = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
    controller1 = AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller2 = AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller3 = AnimationController(vsync: this, duration: Duration(seconds: 1));

    base1 = CurvedAnimation(parent: controller1, curve: Curves.easeOut);
    base2 = CurvedAnimation(parent: controller2, curve: Curves.easeOut);
    base3 = CurvedAnimation(parent: controller3, curve: Curves.easeOut);

    controller1.addStatusListener((status) {
      Future.delayed(Duration(milliseconds: 1100)).whenComplete(() => setState(() {
            isCanClick = true;
          }));
    });
    controller2.addStatusListener((status) {
      Future.delayed(Duration(milliseconds: 1100)).whenComplete(() => setState(() {
            isCanClick = true;
          }));
    });
    controller3.addStatusListener((status) {
      Future.delayed(Duration(milliseconds: 1100)).whenComplete(() => setState(() {
            isCanClick = true;
          }));
    });
    loadData();
    loadImage();
  }

  loadData() async {
    var res = await cubit.getClanCanAttack(userClanId);
    if (res != null && res.data.isNotEmpty) {
      setState(() {
        data = res.data;
      });
    }
    // controller.forward();
  }

  AssetImage bgAttack;
  AssetImage bgRevenge;
  AssetImage component1;
  AssetImage component2;
  AssetImage component3;

  loadImage() {
    bgAttack = AssetImage('assets/bg_attack.png');
    bgRevenge = AssetImage('assets/bg_revenge.png');
    component1 = AssetImage('assets/attack_component_1.png');
    component2 = AssetImage('assets/attack_component_2.png');
    component3 = AssetImage('assets/attack_component_3.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgAttack, context);
    precacheImage(bgRevenge, context);
    precacheImage(component1, context);
    precacheImage(component2, context);
    precacheImage(component3, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned(
              child: Image(
                image: bgAttack,
                fit: BoxFit.fill,
              ),
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
            ),
            Positioned(
              child: GestureDetector(
                onTap: () async {
                  if (data == null || data.isEmpty) {
                    return;
                  }
                  if (isCanClick == false) {
                    return;
                  }
                  setState(() {
                    isCanClick = false;
                    target = data[0];
                  });
                  controller1.forward();
                  controller2.reverse();
                  controller3.reverse();
                },
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      left: 0,
                      child: Image(
                        image: component1,
                      ),
                    ),
                    Positioned(
                      child: data != null && data.isNotEmpty ? textpainting(data[0].name, 20) : textpainting('', 20),
                      top: MediaQuery.of(context).size.height / 24,
                      left: MediaQuery.of(context).size.width / 10,
                    ),
                    Positioned(
                      height: 48,
                      width: 48,
                      child: target != null && target == data[0]
                          ? RotationTransition(
                              turns: base1,
                              child: Image(
                                image: AssetImage('assets/images/icon_target.png'),
                              ),
                            )
                          : Container(),
                      top: MediaQuery.of(context).size.height / 12,
                      left: MediaQuery.of(context).size.width / 8,
                    )
                  ],
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width / 2,
              right: -24,
              bottom: MediaQuery.of(context).size.height * 0.3,
            ),
            Positioned(
              width:  MediaQuery.of(context).size.width / 4 ,
              child: GestureDetector(
                onTap: () {
                  if (data == null || data.length < 2) {
                    return;
                  }
                  if (isCanClick == false) {
                    return;
                  }
                  setState(() {
                    isCanClick = false;
                    target = data[1];
                  });
                  controller2.forward();
                  controller1.reverse();
                  controller3.reverse();
                },
                child: Center(
                  child: Container(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 8,
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Image(
                            image: component2,
                          ),
                        ),
                        Positioned(
                          child: Center(
                            child: data != null && data.isNotEmpty && data.length >= 2 ? textpainting(data[1].name, 16) : textpainting('', 16),
                          ),
                          top: 0,
                          right: 0,
                          left: 0,
                        ),
                        Positioned(
                          child: target != null && target == data[1]
                              ? Container(
                                  margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: RotationTransition(
                                    turns: base2,
                                    child: Image(
                                      image: AssetImage('assets/images/icon_target.png'),
                                    ),
                                  ),
                                  height: 48,
                                  width: 48,
                                  alignment: Alignment.topCenter,
                                )
                              : Container(),
                          top: 0,
                          right: 0,
                          left: 0,
                        )
                      ],
                    ),
                    height: 120,
                  ),
                ),
              ),
              top: 0,
              left: 0,
              bottom: 0,
            ),
            Positioned(
              height: 120,
              child: GestureDetector(
                onTap: () {
                  if (data == null || data.length < 3) {
                    return;
                  }
                  if (isCanClick == false) {
                    return;
                  }
                  setState(() {
                    isCanClick = false;
                    target = data[2];
                  });
                  controller3.forward();
                  controller1.reverse();
                  controller2.reverse();
                },
                child: Center(
                  child: Container(
                    width: 100,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 8,
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: Image(
                            image: component3,
                          ),
                        ),
                        Positioned(
                          child: Center(
                            child: data != null && data.isNotEmpty && data.length >= 3 ? textpainting(data[2].name, 16) : textpainting('', 16),
                          ),
                          top: 0,
                          right: 0,
                          left: 0,
                        ),
                        Positioned(
                          child: target != null && target == data[2]
                              ? Container(
                                  margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: RotationTransition(
                                    turns: base3,
                                    child: Image(
                                      image: AssetImage('assets/images/icon_target.png'),
                                    ),
                                  ),
                                  height: 48,
                                  width: 48,
                                  alignment: Alignment.topCenter,
                                )
                              : Container(),
                          top: 0,
                          right: 0,
                          left: 0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              top: isHaveRevenge ?  MediaQuery.of(context).size.height / 4 : MediaQuery.of(context).size.height / 8,
              right: 0,
              left: 0,
            ),
            Positioned(
              height: 100,
              width: 100,
              child: GestureDetector(
                onTap: () => attackAsync(),
                child: Image(
                  image: AssetImage('assets/images/game_fight_icon.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              bottom: 48,
              left: MediaQuery.of(context).size.width / 2 - 50,
            ),
            Positioned(
              child: Center(
                child: textpainting(target == null ? 'Chọn team để tấn công' : 'Tấn công: ' + target.name, 14),
              ),
              bottom: 16,
              left: 0,
              right: 0,
            ),
            isHaveRevenge ?  Positioned(
              child: Container(
                height: 160,
                child: Stack(
                  children: [
                    Positioned(
                      child: Image(
                        image: bgRevenge,
                        fit: BoxFit.fill,
                      ),
                      top: 0,
                      right: -16,
                      left: -16,
                      bottom: -16,
                    ),
                    Positioned(
                      height: 8,
                      child: Image(
                        image: AssetImage('assets/stick.png'),
                        fit: BoxFit.fitWidth,
                      ),
                      right: 0,
                      left: 0,
                      bottom: 0,
                    ),
                    Positioned(
                      child: SafeArea(child: Wrap(
                        children: [
                          Center(
                            child: Text(
                              'Tấn công',
                              style: TextStyle(fontSize: 20, color: HexColor("#3a230a"), fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height: 16,
                            child: Center(child: Image(
                              image: AssetImage('assets/images/eclipse_login.png'),
                            ),),
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Row(
                            children: [
                              Expanded(child: Container()),
                              Container(
                                child: GestureDetector(
                                  onTap: () async {
                                    await showGeneralDialog(
                                      barrierLabel: "Label",
                                      barrierDismissible: true,
                                      barrierColor: Colors.black.withOpacity(0.5),
                                      transitionDuration: Duration(milliseconds: 700),
                                      context: context,
                                      pageBuilder: (context, anim1, anim2) {
                                        return Align(
                                          alignment: Alignment.center,
                                          child: DialogRevenge(),
                                        );
                                      },
                                      transitionBuilder: (context, anim1, anim2, child) {
                                        return SlideTransition(
                                          position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
                                          child: child,
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Image(
                                          image: AssetImage('assets/images/button_small_green.png'),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        left: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: textpaintingButton(
                                            "TRẢ THÙ",
                                            16,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                height: 56,
                                width: 100,
                              ),
                            ],
                          ),
                        ],
                      ),),
                      top: 4,
                      right: 12,
                      left: 12,
                      bottom: 8,
                    )
                  ],
                ),
              ),
              top: 0,
              right: 0,
              left: 0,
            ) : Container(),
            Positioned(
              child:SafeArea(child:  GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image(
                  image: AssetImage('assets/images/game_button_back.png'),
                  height: 48,
                  width: 48,
                ),
              ),top: false,),
              top:isHaveRevenge ? 168 : 8,
              left: 8,
            ),
          ],
        ));
  }

  textpainting(String s, double fontSize) {
    return OutlinedText(
      text: Text(s, textAlign: TextAlign.justify, style: TextStyle(fontSize: fontSize, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, color: Colors.white)),
      strokes: [
        OutlinedTextStroke(color: Colors.black, width: 3),
      ],
    );
  }

  textpaintingButton(String s, double fontSize) {
    return OutlinedText(
      text: Text(s, textAlign: TextAlign.justify, style: TextStyle(fontSize: fontSize, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, color: HexColor("#d9e9d8"))),
      strokes: [
        OutlinedTextStroke(color: HexColor("#296c23"), width: 3),
      ],
    );
  }

  attackAsync() async {
    if (target == null) {
      toast(context, 'Chưa chọn clan nào làm mục tiêu!!');
      return;
    }
    if(quantitySpecial == 0){
      toast(context, 'Bạn đã hết lượt sử dụng kỹ năng đặc biệt');
      return;
    }
    var res = await cubit.attackClan(userClanId, target.id);
    if (res != null && res.error == false) {
      toast(context, res.message);
      setState(() {
        quantitySpecial = quantitySpecial -1;
      });
     await  showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) => AttackResultView(
          isSuccess: true,
          mess: res.message,
        ),
      );
    } if (res != null && res.error == true)  {
      toast(context, res.message);
      setState(() {
        quantitySpecial = quantitySpecial -1;
      });
      await  showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) => AttackResultView(
          isSuccess: false,
          mess: res.message,
        ),
      );
    }
  }
}
