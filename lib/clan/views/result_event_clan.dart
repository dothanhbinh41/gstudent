import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';

class ClanResultEventView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ClanResultEventViewState();
}

class ClanResultEventViewState extends State<ClanResultEventView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            image: AssetImage('assets/game_bg_info_clan.png'),
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: 0,
          right: 24,
          left: 24,
          child: Container(
            child: Stack(
              children: [
                Positioned(
                  child: Image(
                    image: AssetImage('assets/images/title_result.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(child: Center(child: Text('Kết Quả',style: TextStyle(
                    color: HexColor("#f4daa9"),
                    fontFamily:
                    'SourceSerifPro',
                    fontWeight: FontWeight.bold,
                    fontSize: 24))),
                  top: 0,
                  right: 0,
                  bottom: 8,
                  left: 0,)
              ],
            ),
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
                Container(height: 32,),
                Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            children: [
                              Container(
                                  margin:EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: Text('Ngày 14/9', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',
                                      fontSize: 16))),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 90,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: HexColor("#b39858"))),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          child: Opacity(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/game_event_example1.png'),
                                              fit: BoxFit.fitWidth,
                                            ),
                                            opacity: 0.2,
                                          ),
                                          top: 0,
                                          bottom: 0,
                                          right: -8,
                                          left: -8,
                                        ),
                                        Positioned(
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(child: Text(
                                                        'Team 1',
                                                        textAlign: TextAlign.end,
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontFamily:
                                                            'SourceSerifPro',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18),
                                                      ),flex: 2,),
                                                      Expanded(child: Text(
                                                        '2 - 1',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontFamily:
                                                            'SourceSerifPro',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20),
                                                      ),flex: 1,),
                                                      Expanded(child: Text(
                                                        'Team 2',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontFamily:
                                                            'SourceSerifPro',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18),
                                                      ),flex: 2,),
                                                    ],
                                                  )),
                                              Expanded(
                                                  child: Text(
                                                    '15h45 Ngày 14/9/2021',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                        fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro',),
                                                  )),
                                            ],
                                          ),
                                          top: 0,
                                          bottom: 0,
                                          right: 0,
                                          left: 0,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: 2,
                                shrinkWrap: true,
                              ),
                              Visibility(
                                visible: index == 1 ? false : true,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/ellipse.png'),
                                  ),
                                ),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
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
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image(
              image:
              AssetImage('assets/images/game_close_dialog_clan.png'),
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
