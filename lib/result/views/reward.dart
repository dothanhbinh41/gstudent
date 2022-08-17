import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/Reward/item_reward.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';


class RewardView extends StatefulWidget {
  List<ItemReward> data;

  RewardView({this.data});

  @override
  State<StatefulWidget> createState() => RewardViewState(data: this.data);
}

class RewardViewState extends State<RewardView> {
  List<ItemReward> data;

  RewardViewState({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45.withOpacity(0.8),
      body: SafeArea(
        right: false,
        left: false,
        bottom: false,
        top: false,
        child: Column(
          children: [
            Expanded(child: Container()),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Image(
                      image: AssetImage('assets/bg_result_homework.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    child: Text(
                      'PHẦN THƯỞNG',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SourceSerifPro',
                          fontWeight: FontWeight.w700,
                          fontSize: 24),
                    ),
                    alignment: Alignment.center,
                  )
                ],
              ),
              flex: 2,
            ),
            Expanded(
                child: Stack(
                  children: [
                    Positioned(
                        top: -(MediaQuery.of(context).size.height * 0.15),
                        right: 0,
                        left: 0,
                        child: Image(
                          image: AssetImage('assets/images/light_fare.png'),
                          fit: BoxFit.fitWidth,
                        )),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.05,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        children: [
                          Expanded(child: Container()),
                          data.length >= 4
                              ? Container(
                                  child: GridView.count(
                                    physics: NeverScrollableScrollPhysics(),
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    children:
                                        List.generate(data.length, (index) {
                                      print(MediaQuery.of(context).size.width /
                                          4);
                                      return Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                                color: HexColor("#6b5467")),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            child: Image(
                                              image: NetworkImage(
                                                  data[index].avatar),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Image(
                                            image: AssetImage(
                                                'assets/images/game_border_avatar_clan.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                )
                              : Row(
                                  children: [
                                    for (var i = 0; i < data.length; i++)
                                      Expanded(
                                          child: Center(
                                        child: Container(
                                          child: Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    color: HexColor("#6b5467")),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(4),
                                                child: Image(
                                                  image: NetworkImage(
                                                      data[i].avatar),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/game_border_avatar_clan.png'),
                                                fit: BoxFit.fill,
                                              ),
                                            ],
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                        ),
                                      ))
                                  ],
                                ),
                          Expanded(child: Container()),
                          Container(
                            child: Stack(
                            children: [

                              Positioned(
                                top: 0,
                                right: 0,left: 0,
                                bottom: 0,
                                child: Image(
                                    image: AssetImage('assets/images/bg_content_reward.png'),fit: BoxFit.fitHeight,),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                left: 0,
                                bottom: 0,
                                child: Center(child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      for (var i = 0; i < data.length; i++)
                                        TextSpan(
                                            text: data[i].name +
                                                " : " +
                                                data[i].quantity.toString()+'\n',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'SourceSerifPro')),
                                    ],
                                  ),
                                ),),
                              ),
                            ],
                          ),height: 100,),
                          Expanded(child: Container()),
                        ],
                      ),
                    )
                  ],
                ),
                flex: 5),
            Container(
              margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Image(
                image: AssetImage('assets/images/ellipse.png'),
              ),
            ),
            Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: ButtonGraySmall(
                          'ĐÓNG',
                        ),
                      ),
                    )),
                  ],
                ),
                flex: 1),
          ],
        ),
      ),
    );
  }
}
