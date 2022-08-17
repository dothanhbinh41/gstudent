import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/icons/icon_status_clan.dart';

class RankingEventView extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => RankingEventViewState( );
}

class RankingEventViewState extends State<RankingEventView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
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
                Container(
                  height: 56,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: HexColor("#9b7e63"),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        hintText: 'Search',
                        prefixIcon: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Icon(IconStatusClan.search,
                              size: 20, color: HexColor("#f8e8b0")),
                        ),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                            color: HexColor("#f8e8b0"))),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Image(
                    image: AssetImage('assets/images/ellipse.png'),
                  ),
                ),
                 Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          child: Stack(
                            children: [
                              Positioned(
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/game_bg_member_clan.png'),
                                  fit: BoxFit.fill,
                                ),
                                left: 1,
                                top: 4,
                                bottom: 4,
                                right: 1,
                              ),
                              Positioned(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      height: 48,
                                      width: 48,
                                      child: index == 0
                                          ? Image(
                                        image: AssetImage(
                                            'assets/images/ranking_top1.png'),
                                        fit: BoxFit.fill,
                                      )
                                          : (index == 1
                                          ? Image(
                                        image: AssetImage(
                                            'assets/images/ranking_top2.png'),
                                        fit: BoxFit.fill,
                                      )
                                          : (index == 2
                                          ? Image(
                                        image: AssetImage(
                                            'assets/images/ranking_top3.png'),
                                        fit: BoxFit.fill,
                                      )
                                          : Center(
                                          child: Text(
                                            (index + 1).toString(),
                                            style: TextStyle(
                                                fontFamily:
                                                'SourceSerifPro',
                                                fontWeight:
                                                FontWeight.bold,
                                                color: HexColor(
                                                    "#d08272"),
                                                fontSize: 20),
                                          )))),
                                    ),
                                    Container(
                                      height: 56,
                                      width: 56,
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
                                    Expanded(
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                          height: 60,
                                          child: Column(
                                            children: [
                                              Text(
                                                'alo 1234',
                                                style: TextStyle(
                                                    fontFamily: 'SourceSerifPro',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                              RichText(
                                                text: TextSpan(children: <
                                                    TextSpan>[
                                                  TextSpan(
                                                    text: "Rank: ",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),
                                                  ),
                                                  TextSpan(
                                                      text: (index + 1)
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: Colors.red,
                                                          fontFamily:
                                                          'SourceSerifPro')),
                                                ]),
                                              )
                                            ],
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          ),
                                        )),
                                     Container(
                                      margin: EdgeInsets.fromLTRB(
                                          8, 8, 8, 8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                              HexColor("#AD9958")),
                                          borderRadius:
                                          BorderRadius.circular(4)),
                                      child: GestureDetector(

                                          child: Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/ic_swords.png'),
                                            ),
                                          )),
                                      height: 36,
                                      width: 36,
                                      padding: EdgeInsets.all(8),
                                    )

                                  ],
                                ),
                                left: 1,
                                top: 6,
                                bottom: 6,
                                right: 1,
                              ),
                            ],
                          ),
                          height: 80,
                        );
                      },
                      shrinkWrap: true,
                      itemCount: 2,
                    ))

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
                    child: Center(child: textpainting('Bảng xếp hạng', 24)),
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

