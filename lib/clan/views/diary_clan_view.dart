import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/Clan/diary_clan_dtos.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';

class DiaryClanView extends StatefulWidget {
  int clanId;

  DiaryClanView({this.clanId});

  @override
  State<StatefulWidget> createState() => DiaryClanViewState(clanId: this.clanId);
}

class DiaryClanViewState extends State<DiaryClanView> {
  int clanId;

  DiaryClanViewState({this.clanId});

  HomeCubit cubit;
  List<Diary> data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
    loadImage();
    loadData();
  }

  loadData() async {
    var res = await cubit.getDiaryClan(clanId);
    if (res != null) {
      setState(() {
        data = res.data;
      });
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
                Expanded(
                    child: data != null
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(color: HexColor("#fff6d8"), border: Border.all(color: HexColor("#b39858"), width: 1)),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      child: Stack(
                                        children: [
                                          Image(
                                            image: AssetImage('assets/images/game_fight_icon.png'),
                                            height: 56,
                                            width: 56,
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                      children: [
                                        Text(
                                          data[index].title,
                                          style: ThemeStyles.styleBold(textColors: HexColor("#c64339")),
                                        ),
                                        Text(
                                          data[index].message,
                                          style: ThemeStyles.styleNormal(),
                                        ),
                                        // RichText(
                                        //   text: new TextSpan(
                                        //     // Note: Styles for TextSpans must be explicitly defined.
                                        //     // Child text spans will inherit styles from parent
                                        //     style: TextStyle(fontSize: 12),
                                        //     children: <TextSpan>[
                                        //       new TextSpan(text: 'Clan ',style:ThemeStyles.styleNormal(font: 14)),
                                        //       new TextSpan(text: 'Thích thì nhích ',style:ThemeStyles.styleBold(font: 14)),
                                        //       new TextSpan(text: 'đã tấn công clan bạn, mỗi thành viên bị trừ ', style: ThemeStyles.styleNormal(font: 14)),
                                        //       new TextSpan(text: '200 máu', style:ThemeStyles.styleBold(textColors: Colors.redAccent,font: 14)),
                                        //     ],
                                        //   ),
                                        // )
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    )),
                                  ],
                                ),
                              );
                            },
                            shrinkWrap: true,
                            itemCount: data.length,
                          )
                        : Container())
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
                    child: Center(
                      child: textpaintingBoldBase('Nhật ký', 24, HexColor("#f8e9a5"), HexColor("#681527"), 3),
                    ),
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
          right: 16,
        ),
      ],
    );
  }
}
