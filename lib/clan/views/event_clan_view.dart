import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/clan/views/info_event_clan_dialog.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/event_clan/event_clan_view.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';

class ClanEventView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ClanEventViewState();
}

class ClanEventViewState extends State<ClanEventView> {
  HomeCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
    cubit = BlocProvider.of(context);
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
                // Container(
                //   height: 32,
                // ),
                // GestureDetector(
                //   onTap: () async {
                //     // await showDialog(
                //     //   context: context,
                //     //   builder: (context) => InfoEventClanDialog(),
                //     // );
                //     //
                //     // await showDialog(
                //     //   context: context,
                //     //   builder: (context) {
                //     //     return BlocProvider<HomeCubit>.value(
                //     //       value: cubit,
                //     //       child: EventDialog(),
                //     //     );
                //     //   },
                //     // );
                //   },
                //   child: Image(
                //     image: AssetImage('assets/game_event_example1.png'),
                //   ),
                // ),
                // Container(
                //   height: 16,
                // ),
                // Image(
                //   image: AssetImage('assets/game_event_example2.png'),
                // ),
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
                    child: Center(child: textpaintingBoldBase('Sự kiện', 24, HexColor("#f8e9a5"), HexColor("#681527"), 3),),
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
