import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';

class DialogCheckClanView extends StatefulWidget {
  int clanId;
  String message;

  DialogCheckClanView({this.message, this.clanId});

  @override
  State<StatefulWidget> createState() => DialogCheckClanViewState(message: this.message, clanId: this.clanId);
}

class DialogCheckClanViewState extends State<DialogCheckClanView> {
  String message;
  int clanId;

  DialogCheckClanViewState({this.message, this.clanId});

  HomeCubit cubit;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
  }

  loadClan() async {
    setState(() {
      isLoading = true;
    });
    var res = await cubit.getDetailCLan(clanId);
   await  Future.delayed(Duration(milliseconds: 2000));
    setState(() {
      isLoading = false;
    });
    if (res != null) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Image(
            image: AssetImage('assets/bg_notification.png'),
          ),
          Positioned(
              top: 12,
              bottom: 12,
              right: 24,
              left: 24,
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
                    margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(border: Border.all(color: Colors.transparent), color: HexColor("#fcd19a")),
                      child: Text(message, style: ThemeStyles.styleNormal(font: 14)),
                    ),
                  ),
                  Container(
                    child: Image(
                      image: AssetImage('assets/images/ellipse.png'),
                      fit: BoxFit.fill,
                    ),
                    margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                  ),
                  GestureDetector(
                    onTap: () => loadClan(),
                    child: isLoading ? SpinKitFadingCircle(
                      color: Colors.white,
                      size: 48.0,
                    ):  Container(
                      height: 48,
                      child: ButtonGraySmall("KIỂM TRA"),
                    ),
                  )
                ],
              )),
          Positioned(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(false);
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
}
