import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class SupportView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SupportViewState();
}

class SupportViewState extends State<SupportView> {
  AssetImage bgDialog;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
  }

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
                child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      right: 16,
                      left: 16,
                      bottom: 0,
                      child: Image(
                        image: bgDialog,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 48,
                      right: 48,
                      left: 48,
                      bottom: 16,
                      child: content(),
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
                                child: Center(child: textpainting('Hỗ trợ', 24)),
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
                          image: AssetImage('assets/images/game_button_back.png'),
                          height: 48,
                          width: 48,
                        ),
                      ),
                      top: 16,
                      right: 16,
                    ),
                  ],
                ),
                bottom: 0,
                top: 0,
                left: 0,
                right: 0,
              ),
            ],
          )),
          Container(
            height: 90,
          ),
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

  content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
        ),
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {

              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1), color: HexColor("fff6d8")),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      child: Column(
                        children: [
                          Text(
                            'Vấn đề lớp học',
                            style: ThemeStyles.styleBold(font: 14),
                          ),
                          Text(
                            '28/12/2021',
                            style: ThemeStyles.styleNormal(font: 12),
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    )),
                    Container(
                      child: Text(
                        'Có xử lý mới',
                        style: ThemeStyles.styleNormal(font: 12),
                      ),
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    )
                  ],
                ),
              ),
            );
          },
          shrinkWrap: true,
          itemCount: 1,
        )),
        GestureDetector(
          onTap: () async {},
          child: Container(
            height: 48,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: ButtonYellowSmall(
              'TẠO MỚI',
              textColor: HexColor("#d5e7d5"),
            ),
          ),
        )
      ],
    );
  }
}
