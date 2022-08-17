import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/define_item/avatar_character.dart';

class DialogRevenge extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DialogRevengeState();
}

class DialogRevengeState extends State<DialogRevenge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: MediaQuery.of(context).size.width * 0.9 > 400 ? 400 : MediaQuery.of(context).size.width * 0.9,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Image(
              image: AssetImage('assets/bg_notification.png'),
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
              top: 8,
              right: 16,
              left: 16,
              bottom: 16,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'THÔNG BÁO',
                      style: TextStyle(color: HexColor("#2e2e2e"), fontWeight: FontWeight.w700, fontFamily: 'SourceSerifPro', fontSize: 24),
                    ),
                  ),
                  Container(
                    child: Image(
                      image: AssetImage('assets/images/eclipse_login.png'),
                      fit: BoxFit.fill,
                    ),
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  ),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        height: 68,
                        child: Row(
                          children: [
                            Container(
                              child: Center(
                                child: Stack(
                                  children: [
                                    Image(
                                      image: AssetImage('assets/images/game_border_avatar_member.png'),
                                      height: 60,
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      left: 8,
                                      bottom: 8,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Image(image: AssetImage(loadAvatarCharacterById(6))),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              height: 60,
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Comander',
                                      style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, fontSize: 18),
                                    ),
                                    Text(
                                      'Comander',
                                      style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                              ),
                            ),
                            Container(
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
                                        14,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              height: 48,
                              width: 100,
                            )
                          ],
                        ),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: HexColor("#f4d9a2"), width: 1))),
                      );
                    },
                    shrinkWrap: true,
                    itemCount: 2,
                  ),
                ],
              )),
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
            top: 8,
            right: 8,
          ),
        ],
      ),
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
}
