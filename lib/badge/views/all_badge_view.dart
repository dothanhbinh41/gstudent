import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/badge/data_badge.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/define_item/badge_avatar.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';

class AllBadgeView extends StatefulWidget {
  List<Badge> badges;
  AllBadgeView({this.badges});
  @override
  State<StatefulWidget> createState() => AllBadgeViewState(badges:this.badges);
}

class AllBadgeViewState extends State<AllBadgeView> {
  List<Badge> badges;
  AllBadgeViewState({this.badges});
  HomeCubit cubit;
  AssetImage bg;
  List<Badge> data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
    loadAllBadge();
    loadImage();
  }

  loadAllBadge() async {
    var res = await cubit.getAllBadge();
    if (res != null && res.error == false) {
      setState(() {
        data = res.data;
        badges.forEach((element) {

          if(data.where((e) => e.id == element.id).isNotEmpty){
            data.where((e) => e.id == element.id).first.isActive = true;
          }
        });
      });
    }
  }

  loadImage() {
    bg = AssetImage('assets/bg_badge.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bg, context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            child: Image(
              image: bg,
              fit: BoxFit.fill,
            ),
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          Positioned(
            child: Column(
              children: [
                Container(
                  height: 48,
                  margin: EdgeInsets.fromLTRB(8, 16, 8, 16),
                  child: Stack(
                    children: [
                      Positioned(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            child: Image(
                              image: AssetImage('assets/images/game_button_back.png'),
                              height: 48,
                              width: 48,
                            ),
                          ),
                        ),
                        top: 0,
                        left: 0,
                        bottom: 0,
                      ),
                      Positioned(
                        child: Center(
                          child: textpainting('Huy hiệu', 16, HexColor('#F6DCB2'), HexColor('#6D0A0A'), 1),
                        ),
                        top: 0,
                        right: 0,
                        bottom: 0,
                        left: 0,
                      ),
                    ],
                  ),
                ),
                data != null
                    ? Expanded(
                        child: Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: GridView.count(
                          // Create a grid with 2 columns. If you change the scrollDirection to
                          // horizontal, this produces 2 rows.
                          crossAxisCount: 4,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          // Generate 100 widgets that display their index in the List.
                          children: List.generate(data.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    child:  Container(child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Stack(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(color: HexColor("#66242E")),
                                                  child: Image(
                                                    image: AssetImage(defineBadgeById(data[index].id)),
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                ),
                                                Image(
                                                  image: AssetImage('assets/images/border_badge.png'),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ],
                                            ),flex: 2,),
                                        Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(color: HexColor("#66242E"),borderRadius: BorderRadius.circular(4)),
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                data[index].description,
                                                style: TextStyle(color: Colors.white, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w400),
                                              ),
                                            ),flex: 3,),
                                      ],
                                    ),height: 100,),
                                    backgroundColor: Colors.transparent,
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(color: HexColor("#66242E")),
                                    child: Image(
                                      image: AssetImage(defineBadgeById(data[index].id)),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  data[index].isActive ? Container() : Container(
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
                                  ),
                                  Image(
                                    image: AssetImage('assets/images/border_badge.png'),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ))
                    : Container()
              ],
            ),
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
          ),
        ],
      ),
    );
  }

  textpainting(String s, double fontSize, Color colorText, Color colorBorder, double width) {
    return OutlinedText(
      text: Text(s, textAlign: TextAlign.justify, style: TextStyle(fontSize: fontSize, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, color: colorText)),
      strokes: [
        OutlinedTextStroke(color: colorBorder, width: width),
      ],
    );
  }
}
