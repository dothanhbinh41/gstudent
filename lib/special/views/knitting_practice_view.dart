import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/special/views/knitting_practice_success_view.dart';

class KnittingPracticeView extends StatefulWidget {
  int ClanId;
  int userClanId;
  int quantitySpecial;
  KnittingPracticeView({this.ClanId,this.userClanId,this.quantitySpecial});

  @override
  State<StatefulWidget> createState() => KnittingPracticeViewState(ClanId: this.ClanId,userClanId:this.userClanId, quantitySpecial : this.quantitySpecial);
}

class KnittingPracticeViewState extends State<KnittingPracticeView> {
  int ClanId;
  int userClanId;
  int quantitySpecial;
  KnittingPracticeViewState({this.ClanId,this.userClanId,this.quantitySpecial});
  bool isAnimate = false;
  HomeCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
    loadImage();
    Future.delayed(Duration(milliseconds: 1000)).whenComplete(() => animationStart());
    Future.delayed(Duration(milliseconds: 2000)).whenComplete(() => navigationToResult());

  }

  navigationToResult()async {
   await  Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: HomeCubit(settings: cubit.settings, characterService: cubit.characterService, specialService: cubit.specialService, missionService: cubit.missionService, clanService: cubit.clanService, homeService: cubit.homeService),
          child:KnittingPracticeSuccessView(ClanId: this.ClanId,userClanId: this.userClanId,quantitySpecial: this.quantitySpecial,),
        )));
   Navigator.of(context).pop();
  }

  animationStart(){
    setState(() {
      isAnimate = true;
    });
  }


  AssetImage bg;
  AssetImage loluyendan;
  AssetImage component1;
  AssetImage component2;
  AssetImage component3;

  loadImage() {
    bg = AssetImage('assets/bg_luyendan.png');
    loluyendan = AssetImage('assets/lo_luyendan.png');
    component1 = AssetImage('assets/images/item_luyendan1.png');
    component2 = AssetImage('assets/images/item_luyendan2.png');
    component3 = AssetImage('assets/images/item_luyendan3.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bg, context);
    precacheImage(loluyendan, context);
    precacheImage(component1, context);
    precacheImage(component2, context);
    precacheImage(component3, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Image(
              image: loluyendan,
            ),
            right: MediaQuery.of(context).size.width*0.2,
            left: MediaQuery.of(context).size.width*0.2,
            bottom: MediaQuery.of(context).size.height*0.1,
          ),
          AnimatedPositioned(
            height: 80,
            top: isAnimate ? MediaQuery.of(context).size.height*0.6 : MediaQuery.of(context).size.height*0.3,
            right:  0  ,
            left: 0,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            child: GestureDetector(
              onTap: () {

                setState(() {
                  isAnimate = true;
                });
              },
              child: Image(
                image: component1,
              ),
            ),
          ),
          AnimatedPositioned(
            width: 80,
            top: isAnimate ? MediaQuery.of(context).size.height*0.6 : MediaQuery.of(context).size.height*0.4,
            left: isAnimate ? MediaQuery.of(context).size.width*0.4 : 24,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            child: GestureDetector(
              onTap: () {

                setState(() {
                  isAnimate = true;
                });
              },
              child: Image(
                image: component2,
              ),
            ),
          ),
          AnimatedPositioned(
            width: 80,
            top: isAnimate ? MediaQuery.of(context).size.height*0.6 : MediaQuery.of(context).size.height*0.4,
            right: isAnimate ? MediaQuery.of(context).size.width*0.4 : 24,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            child: GestureDetector(
              onTap: () {

                setState(() {
                  isAnimate = true;
                });
              },
              child: Image(
                image: component3,
              ),
            ),
          ),

        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
