import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/Reward/item_reward.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/result/views/reward.dart';

class ParamResultVocab{
  ParamResultVocab(this.time,this.total,this.correct);
  int time;
  int total;
  int correct;
}

class ResultTrainingVocabView extends StatefulWidget {
  bool isLast;
  List<ItemReward> rewards;
  ParamResultVocab param;
  ResultTrainingVocabView({this.param,this.isLast,this.rewards});

  @override
  State<StatefulWidget> createState() => ResultTrainingVocabViewState(param : this.param ,isLast:this.isLast,rewards:this.rewards);
}

class ResultTrainingVocabViewState extends State<ResultTrainingVocabView> {
  ParamResultVocab param;
  bool isLast;
  List<ItemReward> rewards;
  ResultTrainingVocabViewState({this.param, this.isLast,this.rewards});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(rewards != null){
      showReward();
    }
  }

  showReward() async {
  await   Future.delayed(Duration(microseconds: 1500)) ;
    await  showDialog(context: context, builder: (context) => RewardView(data: rewards,),);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45.withOpacity(0.8),
      body:  Column(
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
                    'TỔNG KẾT',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SourceSerifPro',
                        fontWeight: FontWeight.w700,
                        fontSize: 24),
                  ),
                  alignment: Alignment.center,
                )
              ],
            ),flex: 2,),
          Expanded(child: Container()),
          Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Container()),
                    Container(
                      child: Stack(
                        children: [
                          Positioned(
                            top: 30,
                            bottom: 0,
                            right: 4,
                            left: 4,
                            child: Container(
                                child: Stack(
                                  children: [
                                    Image(
                                      image:
                                      AssetImage('assets/images/bg_ic_result.png'),
                                    ),
                                    Positioned(
                                      child: Text(
                                        param.time/1000 > 60 ?     _printDuration(Duration(milliseconds: param.time))+'\nphút' :     _printDuration(Duration(milliseconds: param.time))+'\ngiây',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'SourceSerifPro',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      top: 30,
                                      right: 0,
                                      left: 0,
                                      bottom: 0,
                                    )
                                  ],
                                )),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              height: 60,
                              width: 60,
                              child: Stack(
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'assets/images/game_border_avatar_member.png'),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/ic_hourglass.png'),
                                        height: 32,
                                        width: 32,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      width: 60,
                      height: 120,
                    ),
                    Expanded(child: Container()),
                    Container(
                      child: Stack(
                        children: [
                          Positioned(
                            top: 30,
                            bottom: 0,
                            right: 4,
                            left: 4,
                            child: Container(
                                child: Stack(
                                  children: [
                                    Image(
                                      image:
                                      AssetImage('assets/images/bg_ic_result.png'),
                                    ),
                                    Positioned(
                                      child: Text(
                                        'Đúng\n'+ param.correct.toString()+'/'+param.total.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'SourceSerifPro',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      top: 30,
                                      right: 0,
                                      left: 0,
                                      bottom: 0,
                                    )
                                  ],
                                )),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              height: 60,
                              width: 60,
                              child: Stack(
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'assets/images/game_border_avatar_member.png'),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/icon_word_vocab.png'),
                                        height: 36,
                                        width: 36,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      width: 60,
                      height: 120,
                    ),
                    Expanded(child: Container()),
                    Container(
                      child: Stack(
                        children: [
                          Positioned(
                            top: 30,
                            bottom: 0,
                            right: 4,
                            left: 4,
                            child: Container(
                                child: Stack(
                                  children: [
                                    Image(
                                      image:
                                      AssetImage('assets/images/bg_ic_result.png'),
                                    ),
                                    Positioned(
                                      child: Text(
                                        param.correct.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'SourceSerifPro',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      top: 30,
                                      right: 0,
                                      left: 0,
                                      bottom: 0,
                                    )
                                  ],
                                )),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              height: 60,
                              width: 60,
                              child: Stack(
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'assets/images/game_border_avatar_member.png'),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/ic_ranking.png'),
                                        height: 36,
                                        width: 36,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      width: 60,
                      height: 120,
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),flex: 3),

          Container(
            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children:  <TextSpan>[
                  TextSpan(
                      text: 'Thời gian luyện : '+ _printDuration(Duration(milliseconds: param.time))+'phút',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro')),
                  TextSpan(text: '\n', style: TextStyle(color: Colors.white)),
                  TextSpan(
                      text: 'Tỉ lệ đúng: '+param.correct.toString()+'/'+param.total.toString(),
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro')),
                  TextSpan(text: '\n', style: TextStyle(color: Colors.white)),
                  TextSpan(
                      text: 'Số từ thu thập được: '+param.correct.toString(),
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,  fontFamily: 'SourceSerifPro')),
                  TextSpan(text: '\n', style: TextStyle(color: Colors.white)),


                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Image(
              image: AssetImage('assets/images/ellipse.png'),
            ),
          ),
          Expanded(
              child:Row(
                children: [
                  Expanded(child:  Container(
                    margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: ButtonGraySmall('ĐÓNG',textColor: HexColor("#d5e7d5") , ),
                    ),
                  )),
                  isLast ? Container() :  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: ButtonYellowSmall('TIẾP TỤC',textColor: HexColor("#d5e7d5")  ),
                      ),
                    ),
                  )
                ],
              ),flex: 2),
        ],
      )
    );
  }


  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String convertSec(int sec) {
    Duration duration = Duration(milliseconds: sec);
    return ((duration.inMilliseconds / 1000)/param.total).toStringAsFixed(2).replaceFirst('.', ',').padLeft(5, '0') + 's';
  }


}
