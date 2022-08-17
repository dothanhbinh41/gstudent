import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/noti/notification_model.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class NotificationView extends StatefulWidget {
  final List<NotificationModel> notifications;

  NotificationView({Key key, this.notifications}) : super(key: key);

  @override
  _NotificationViewState createState() =>
      _NotificationViewState(notifications: this.notifications);
}

class _NotificationViewState extends State<NotificationView> {
  List<NotificationModel> notifications;

  _NotificationViewState({this.notifications});

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
    return Stack(
      children: [
        Positioned(
          top: 16,
          right: MediaQuery.of(context).size.width > 800 ? 60 : 16,
          left: MediaQuery.of(context).size.width > 800 ? 60 : 16,
          bottom: 60,
          child: Image(
            image: bgDialog,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: 60,
          bottom: 80,
          right: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width * 0.15
              : 48,
          left: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width * 0.15
              : 48,
          child: Container(
            child: SingleChildScrollView(
              child: listNoti(),
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
                    child: Center(child: textpaintingBoldBase('Thông báo', 24, HexColor("#f8e9a5"), HexColor("#681527"), 3),),
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
          right: MediaQuery.of(context).size.width > 800 ? 60 : 16,
        ),
      ],
    );
  }

  listNoti() {
    return ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: HexColor("#fff6d8"),
                  border: Border.all(color: HexColor("#b39858"),width: 1)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    notifications[index].title.replaceAll('ECoach', 'Mentor'),
                    style: ThemeStyles.styleBold(),
                  ),
                  Text(
                    notifications[index].body.replaceAll('ECoach', 'Mentor'),
                    style: ThemeStyles.styleNormal(font: 14),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: notifications != null && notifications.isNotEmpty
            ? notifications.length
            : 0,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true);
  }
}
